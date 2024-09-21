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

/// [BackdoorFlutter] Class Provides provides method to check payment status and act accordingly
///
/// it provides 2 methods
/// 1. [init] to initialize configuration
/// 2. [checkStatus] to check the status
abstract class BackdoorFlutter {
  static late final String _jsonUrl;

  static late final String _appName;

  static late final bool _autoDecrementLaunchCount;

  static late final double _version;

  static const String _apiLogTag = 'BACKDOOR_FLUTTER_API_LOG';

  static late bool _showApiLogs;

  /// Initializes the application configuration.
  ///
  /// This method sets up the necessary parameters for the application using either
  /// provided arguments or environment variables. All parameters must be supplied either
  /// directly in this method or through their respective environment variables.
  ///
  /// Parameters:
  /// - [jsonUrl] : The URL where the JSON configuration file is hosted.
  ///   Corresponding environment variable: `BACKDOOR_JSON_URL`.
  /// - [appName] : The name of the app to be looked up in the JSON file.
  ///   Corresponding environment variable: `BACKDOOR_APP_NAME`.
  /// - [version] : The version of the backdoor rules, which must be greater than 0.
  ///   Corresponding environment variable: `BACKDOOR_VERSION`.
  /// - [autoDecrementLaunchCount] : If set to `true`, the launch count will be automatically managed.
  ///   If `false`, you must manually decrement the launch count using the [decrementCount] method.
  ///   Corresponding environment variable: `BACKDOOR_AUTO_DECREMENT`.
  ///
  /// Throws:
  /// - An exception if any required parameters are missing or invalid.
  ///
  /// Returns:
  /// - A [Future] that completes when the configuration has been successfully initialized.
  /// [showApiLogs] to show api logs, default true
  static Future<void> init({
    String? jsonUrl,
    String? appName,
    double? version,
    bool showApiLogs = true,
    bool autoDecrementLaunchCount = true,
  }) async {
    _showApiLogs = showApiLogs;
    _jsonUrl = InitService.initializeUrl(jsonUrl);
    _appName = InitService.initializeAppName(appName);
    _autoDecrementLaunchCount = InitService.initializeAutoDecrement(autoDecrementLaunchCount);
    _version = InitService.initializeVersion(version);
    await StorageService.init();
    await StorageService.setConfig(_version, _appName);
  }

  static void _logger(dynamic data, {String name = 'BACKDOOR_FLUTTER'}) {
    log(data.toString(), name: name);
  }

  /// Decrements the launch count for the application.
  ///
  /// This method reduces the recorded launch count by one. It can be used to manually
  /// adjust the count, particularly when [autoDecrementLaunchCount] is set to `false`.
  ///
  /// Returns:
  /// - A [Future] that completes when the launch count has been successfully decremented.
  static Future<void> decrementCount() => StorageService.decrementCount();

  static Future<bool> _shouldCheckOnline() async {
    final BackdoorPaymentModel? backdoorPaymentModel = await StorageService.getPaymentModel();
    if (backdoorPaymentModel == null) return true;
    if (backdoorPaymentModel.targetVersion != _version) return true;
    switch (backdoorPaymentModel.status) {
      case PaymentStatus.PAID:
        return backdoorPaymentModel.shouldCheckAfterPaid;

      case PaymentStatus.UNPAID:
        return true;

      case PaymentStatus.ALLOW_LIMITED_LAUNCHES:
        final currentCount = await StorageService.getLaunchCount();
        return (currentCount == null || currentCount <= 0);

      case PaymentStatus.ON_TRIAL:
        if (backdoorPaymentModel.checkDuringTrial == true) return true;
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
  }) async {
    try {
      final Dio dioClient = Dio(
        BaseOptions(
          sendTimeout: const Duration(minutes: 10),
          connectTimeout: const Duration(minutes: 10),
          receiveTimeout: const Duration(minutes: 10),
        ),
      );
      if (_showApiLogs) {
        dioClient.interceptors.add(
          LogInterceptor(
            logPrint: (object) => _logger(object, name: _apiLogTag),
          ),
        );
      }

      final res = (await dioClient.request(
        _jsonUrl,
        options: Options(
          headers: httpHeaders,
          method: httpMethod,
        ),
        queryParameters: httpQueryParameters,
        data: httpRequestBody,
      ))
          .data;

      final BackdoorPaymentApiResponseModel apiResponseModel = BackdoorPaymentApiResponseModel.fromJson(res is Map ? res : jsonDecode(res));
      return apiResponseModel.apps?[_appName];
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

  /// Checks the status of the application by retrieving and validating payment model data.
  ///
  /// This method performs an online check for the payment model unless specified otherwise.
  /// It handles various callbacks for different states of the application and potential exceptions.
  /// The function can be customized with HTTP headers, query parameters, request body, and method type.
  ///
  /// Parameters:
  /// - [httpHeaders] : Optional map of HTTP headers to send with the request.
  /// - [httpQueryParameters] : Optional map of query parameters to include in the request.
  /// - [httpRequestBody] : Optional map for the body of the request (for POST or PUT requests).
  /// - [httpMethod] : The HTTP method to use for the request. Defaults to 'GET'.
  /// - [onException] : Callback invoked when an exception occurs during the operation.
  /// - [onUnhandled] : Callback invoked for unhandled cases or unexpected results.
  /// - [onAppNotFound] : Optional callback for when the application is not found.
  /// - [onPaid] : Callback invoked when the application is in a paid state.
  /// - [onUnPaid] : Callback invoked when the application is in an unpaid state.
  /// - [onLimitedLaunch] : Callback for handling limited launch scenarios.
  /// - [onLimitedLaunchExceeded] : Callback for when limited launch is exceeded.
  /// - [onTrial] : Callback for when the application is in a trial period.
  /// - [onTrialWarning] : Callback for trial warning scenarios.
  /// - [onTrialEnded] : Callback for when the trial period has ended.
  /// - [onTargetVersionMisMatch] : Callback for when the target version does not match.
  /// - [useCachedConfigOnNetworkException] : Flag indicating whether to use cached configuration in case of a network exception. Defaults to true.
  ///
  /// Throws:
  /// - [BackdoorFlutterException] if there is an issue with the target version or configuration.
  ///
  /// Returns:
  /// - A [Future] that completes when the status check is done.
  static Future<void> checkStatus({
    Map<String, dynamic>? httpHeaders,
    Map<String, dynamic>? httpQueryParameters,
    Map<String, dynamic>? httpRequestBody,
    String httpMethod = 'GET',
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

      if (targetVersion != _version) {
        if (onTargetVersionMisMatch != null) {
          onTargetVersionMisMatch(operationModel, targetVersion, _version);
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

  static Future<void> _handleExecution({
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
          int? currentLaunchCount = await StorageService.getLaunchCount();

          if (allowedLaunches == null) {
            throw BackdoorFlutterException(
              message: 'max_launch not set for ALLOW_LIMITED_LAUNCHES mechanism in remote json file',
              type: BackdoorFlutterExceptionType.CONFIGURATION_EXCEPTION,
              operationConfiguration: operationModel,
            );
          }

          if (isOnlineModel) {
            if (!operationModel.strictMaxLaunch || (currentLaunchCount == null)) {
              StorageService.setLaunchCount(allowedLaunches);
            }
          }

          currentLaunchCount = await StorageService.getLaunchCount();

          if (currentLaunchCount == null || currentLaunchCount <= 0) {
            if (onLimitedLaunchExceeded != null) {
              onLimitedLaunchExceeded(operationModel);
            } else {
              onUnhandled(OnUnhandledReason.LIMITED_LAUNCH_EXCEEDED, operationModel);
            }
          } else {
            if (onLimitedLaunch != null) {
              onLimitedLaunch(operationModel, currentLaunchCount);
            } else {
              onUnhandled(OnUnhandledReason.LIMITED_LAUNCH, operationModel);
            }
          }
          if (_autoDecrementLaunchCount) await StorageService.decrementCount();

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
            } else {
              onUnhandled(OnUnhandledReason.TRIAL_WARNING, operationModel);
            }
          } else if (now.isAfter(expiryDate)) {
            if (onTrialEnded != null) {
              onTrialEnded(operationModel, expiryDate);
            } else {
              onUnhandled(OnUnhandledReason.TRIAL_ENDED, operationModel);
            }
          } else if (now.isBefore(expiryDate)) {
            if (onTrial != null) {
              onTrial(operationModel, expiryDate, warningDate);
            } else {
              onUnhandled(OnUnhandledReason.TRIAL, operationModel);
            }
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

  static BackdoorFlutterException _convertException(dynamic exception) {
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
