import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import 'constants/backdoor_flutter_type_definitions.dart';
import 'constants/on_unhandled_reason.dart';
import 'constants/payment_status.dart';
import 'exception/backdoor_flutter_exception.dart';
import 'model/payment_status_model.dart';
import 'services/init_service.dart';
import 'services/storage_service.dart';

abstract class BackdoorFlutter {
  static late final String jsonUrl;

  static late final String appName;

  static late final bool autoDecrementLaunchCount;

  static late final double version;

  static const String _apiLogTag = 'BACKDOOR_FLUTTER_API_LOG';

  static Future<void> init({
    String? jsonUrl,
    String? appName,
    bool? autoDecrementLaunchCount,
    double? version,
  }) async {
    BackdoorFlutter.jsonUrl = InitService.initializeUrl(jsonUrl);
    BackdoorFlutter.appName = InitService.initializeAppName(appName);
    BackdoorFlutter.autoDecrementLaunchCount = InitService.initializeAutoDecrement(autoDecrementLaunchCount);
    BackdoorFlutter.version = InitService.initializeVersion(version);
    await StorageService.init();
    await StorageService.setVersion(BackdoorFlutter.version);
  }

  static void _logger(dynamic data, {String name = 'BACKDOOR_FLUTTER'}) {
    log(data.toString(), name: name);
  }

  static Future<bool> _shouldCheckOnline() async {
    final BackdoorPaymentModel? backdoorPaymentModel = await StorageService.getPaymentModel();
    if (backdoorPaymentModel == null) return true;
    if (backdoorPaymentModel.targetVersion != version) return true;
    switch (backdoorPaymentModel.status) {
      case PaymentStatus.PAID:
        return backdoorPaymentModel.shouldCheckAfterPaid;

      case PaymentStatus.UNPAID:
        return true;

      case PaymentStatus.ALLOW_LIMITED_LAUNCHES:
        final currentCount = await StorageService.getLaunchCount();
        return (currentCount != null && currentCount > 0);

      case PaymentStatus.ON_TRIAL:
        final now = DateTime.now();
        final warningDate = backdoorPaymentModel.warningDate;
        final expiryDate = backdoorPaymentModel.expireDateTime;
        if (expiryDate == null) return true;
        if (warningDate != null && now.isAfter(warningDate) && now.isBefore(expiryDate)) {
          return true;
        } else {
          return now.isAfter(expiryDate);
        }

      case null:
        return true;
    }
  }

  static Future<BackdoorPaymentModel?> _onlineModel({
    required Map<String, dynamic> httpHeaders,
    required Map<String, dynamic> httpQueryParameters,
    required Map<String, dynamic> httpRequestBody,
    required String httpMethod,
    required bool showApiLogs,
  }) async {
    try {
      final Dio dioClient = Dio(
        BaseOptions(
          sendTimeout: const Duration(minutes: 10),
          connectTimeout: const Duration(minutes: 10),
          receiveTimeout: const Duration(minutes: 10),
        ),
      );
      if (showApiLogs) {
        dioClient.interceptors.add(
          LogInterceptor(
            logPrint: (object) => _logger(object, name: _apiLogTag),
          ),
        );
      }

      final res = (await dioClient.request(
        jsonUrl,
        options: Options(
          headers: httpHeaders,
          method: httpMethod,
        ),
        queryParameters: httpQueryParameters,
        data: httpRequestBody,
      ))
          .data;

      final BackdoorPaymentApiResponseModel apiResponseModel = BackdoorPaymentApiResponseModel.fromJson(res is Map ? res : jsonDecode(res));
      return apiResponseModel.apps?[appName];
    } catch (e) {
      if (e is DioException) {
        final String message = switch (e.type) {
          DioExceptionType.connectionTimeout => 'CONNECTION TIME_OUT',
          DioExceptionType.sendTimeout => 'SEND TIME_OUT',
          DioExceptionType.receiveTimeout => 'RECEIVE TIME_OUT',
          DioExceptionType.badCertificate => 'BAD_CERTIFICATE',
          DioExceptionType.badResponse => 'BAD_RESPONSE',
          DioExceptionType.cancel => 'CANCEL',
          DioExceptionType.connectionError => 'CONNECTION_ERROR',
          DioExceptionType.unknown => 'UNKNOWN',
        };

        throw BackdoorFlutterException(
          message: message,
          type: BackdoorFlutterExceptionType.NETWORK_EXCEPTION,
          apiResponse: e.response?.toString(),
          stackTrace: e.stackTrace,
          operationConfiguration: await StorageService.getPaymentModel(),
        );
      } else {
        rethrow;
      }
    }
  }

  Future<void> checkStatus({
    Map<String, dynamic>? httpHeaders,
    Map<String, dynamic>? httpQueryParameters,
    Map<String, dynamic>? httpRequestBody,
    String httpMethod = 'GET',
    bool showApiLogs = true,
    required OnException onException,
    required OnUnhandled onUnhandled,
    OnAppNotFound? onAppNotFound,
    OnPaid? onPaid,
    OnUnPaid? onUnPaid,
    OnLimitedLaunch? onLimitedLaunch,
    OnLimitedLaunchExceeded? onLimitedLaunchExceeded,
    OnTrial? onTrial,
    OnTrialWarning? onTrialWarning,
    OnTrialEnded? onTrialEnded,
    OnTargetVersionMisMatch? onTargetVersionMisMatch,
    bool useCachedConfigOnNetworkException = true,
  }) async {
    try {
      final bool shouldCheckOnline = await _shouldCheckOnline();
      BackdoorPaymentModel? storedModel = await StorageService.getPaymentModel();
      final BackdoorPaymentModel? operationModel = shouldCheckOnline
          ? await _onlineModel(
              httpHeaders: httpHeaders ?? {},
              httpQueryParameters: httpQueryParameters ?? {},
              httpRequestBody: httpRequestBody ?? {},
              httpMethod: httpMethod,
              showApiLogs: showApiLogs,
            )
          : storedModel;

      if (operationModel == null) {
        if (onAppNotFound != null) {
          onAppNotFound();
        } else {
          onUnhandled(OnUnhandledReason.APP_NOT_FOUND_IN_JSON, operationModel);
        }
        return;
      }

      if (shouldCheckOnline) {
        storedModel = operationModel;
        await StorageService.setPaymentModel(storedModel);
      }

      final targetVersion = operationModel.targetVersion;
      if (targetVersion == null) {
        throw BackdoorFlutterException(
          message: 'target_version not set in remote json',
          type: BackdoorFlutterExceptionType.CONFIGURATION_EXCEPTION,
          operationConfiguration: operationModel,
        );
      }

      if (targetVersion != version) {
        if (onTargetVersionMisMatch != null) {
          onTargetVersionMisMatch(operationModel, targetVersion, version);
        } else {
          onUnhandled(OnUnhandledReason.TARGET_VERSION_MISMATCH, operationModel);
        }
        return;
      }
      _handleExecution(
        onPaid: onPaid,
        onTrial: onTrial,
        onUnPaid: onUnPaid,
        onException: onException,
        onUnhandled: onUnhandled,
        onTrialEnded: onTrialEnded,
        onAppNotFound: onAppNotFound,
        operationModel: operationModel,
        onTrialWarning: onTrialWarning,
        onLimitedLaunch: onLimitedLaunch,
        isOnlineModel: shouldCheckOnline,
        onLimitedLaunchExceeded: onLimitedLaunchExceeded,
        onTargetVersionMisMatch: onTargetVersionMisMatch,
      );
    } catch (e) {
      final BackdoorPaymentModel? operationModel = await StorageService.getPaymentModel();
      if (useCachedConfigOnNetworkException && operationModel != null && e is BackdoorFlutterException && e.type == BackdoorFlutterExceptionType.NETWORK_EXCEPTION) {
        _handleExecution(
          onPaid: onPaid,
          onTrial: onTrial,
          onUnPaid: onUnPaid,
          isOnlineModel: false,
          onException: onException,
          onUnhandled: onUnhandled,
          onTrialEnded: onTrialEnded,
          onAppNotFound: onAppNotFound,
          operationModel: operationModel,
          onTrialWarning: onTrialWarning,
          onLimitedLaunch: onLimitedLaunch,
          onLimitedLaunchExceeded: onLimitedLaunchExceeded,
          onTargetVersionMisMatch: onTargetVersionMisMatch,
        );
      }

      _logger(e);
      onException(_convertException(e));
    }
  }

  Future<void> _handleExecution({
    required OnException onException,
    required OnUnhandled onUnhandled,
    OnAppNotFound? onAppNotFound,
    OnPaid? onPaid,
    OnUnPaid? onUnPaid,
    OnLimitedLaunch? onLimitedLaunch,
    OnLimitedLaunchExceeded? onLimitedLaunchExceeded,
    OnTrial? onTrial,
    OnTrialWarning? onTrialWarning,
    OnTrialEnded? onTrialEnded,
    OnTargetVersionMisMatch? onTargetVersionMisMatch,
    required BackdoorPaymentModel operationModel,
    required bool isOnlineModel,
  }) async {
    try {
      switch (operationModel.status) {
        case PaymentStatus.PAID:
          if (onPaid != null) {
            onPaid(operationModel);
          } else {
            onUnhandled(OnUnhandledReason.PAID, operationModel);
          }
          break;

        case PaymentStatus.UNPAID:
          if (onUnPaid != null) {
            onUnPaid(operationModel);
          } else {
            onUnhandled(OnUnhandledReason.UNPAID, operationModel);
          }
          break;

        case PaymentStatus.ALLOW_LIMITED_LAUNCHES:
          final allowedLaunches = operationModel.maxLaunch;

          if (allowedLaunches == null) {
            throw BackdoorFlutterException(
              message: 'max_launch not set for ALLOW_LIMITED_LAUNCHES mechanism in remote json file',
              type: BackdoorFlutterExceptionType.CONFIGURATION_EXCEPTION,
              operationConfiguration: operationModel,
            );
          }

          if (isOnlineModel) {
            if (!operationModel.strictMaxLaunch) {
              StorageService.setLaunchCount(allowedLaunches);
            }
          }

          final launchCount = await StorageService.getLaunchCount();
          if (launchCount == null || launchCount == 0) {
            if (onLimitedLaunchExceeded != null) {
              onLimitedLaunchExceeded(operationModel);
            } else {
              onUnhandled(OnUnhandledReason.LIMITED_LAUNCH_EXCEEDED, operationModel);
            }
          } else {
            if (autoDecrementLaunchCount) await StorageService.decrementCount();
            if (onLimitedLaunch != null) {
              onLimitedLaunch(operationModel, launchCount);
            } else {
              onUnhandled(OnUnhandledReason.LIMITED_LAUNCH, operationModel);
            }
          }

          break;

        case PaymentStatus.ON_TRIAL:
          final now = DateTime.now();
          final warningDate = operationModel.warningDate;
          final expiryDate = operationModel.expireDateTime;
          if (expiryDate == null) {
            throw BackdoorFlutterException(
              message: 'expire_date not set for ON_TRIAL mechanism in remote json file',
              type: BackdoorFlutterExceptionType.CONFIGURATION_EXCEPTION,
            );
          }
          if (warningDate != null && now.isAfter(warningDate) && now.isBefore(expiryDate)) {
            if (onTrialWarning != null) {
              onTrialWarning(operationModel, expiryDate, warningDate);
            }
            onUnhandled(OnUnhandledReason.TRAIL_WARNING, operationModel);
          } else if (now.isAfter(expiryDate)) {
            if (onTrialEnded != null) {
              onTrialEnded(operationModel, expiryDate);
            }
            onUnhandled(OnUnhandledReason.TRIAL_ENDED, operationModel);
          } else if (now.isBefore(expiryDate)) {
            if (onTrial != null) {
              onTrial(operationModel, expiryDate, warningDate);
            }
            onUnhandled(OnUnhandledReason.TRIAL, operationModel);
          }
          break;

        case null:
          BackdoorFlutterException(
            message: 'UNKNOWN_PAYMENT_STATUS, Please Make Sure that Payment status in json is one of following\nPAID\nUNPAID\nALLOW_LIMITED_LAUNCHES\nON_TRIAL,',
            type: BackdoorFlutterExceptionType.UNKNOWN_PAYMENT_STATUS,
            operationConfiguration: operationModel,
          );
          break;
      }
    } catch (e) {
      _logger(e);
      onException(_convertException(e));
    }
  }

  BackdoorFlutterException _convertException(dynamic exception) {
    if (exception is BackdoorFlutterException) {
      return exception;
    } else if (exception is Error) {
      return BackdoorFlutterException(
        message: exception.toString(),
        type: BackdoorFlutterExceptionType.UNKNOWN,
        stackTrace: exception.stackTrace,
      );
    } else {
      return BackdoorFlutterException(
        message: exception.toString(),
        type: BackdoorFlutterExceptionType.UNKNOWN,
      );
    }
  }
}
