import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import 'constants/backdoor_flutter_type_definitions.dart';
import 'constants/on_unhandled_reason_enum.dart';
import 'constants/payment_status_enum.dart';
import 'exception/backdoor_flutter_exception.dart';
import 'model/payment_status_model.dart';
import 'services/init_service.dart';
import 'services/storage_service.dart';

/// A class for managing and interacting with the backdoor payment system.
///
/// This class provides methods to initialize configurations, check the payment status,
/// and handle different payment scenarios, including paid, unpaid, trial, and limited launches.
abstract class BackdoorFlutter {
  /// The URL for the JSON configuration.
  static late final String jsonUrl;

  /// The application name used in the configuration.
  static late final String appName;

  /// Flag indicating whether the launch count should be automatically decremented.
  static late final bool autoDecrementLaunchCount;

  /// The current application version.
  static late final double version;

  /// Tag used for logging API requests and responses.
  static const String _apiLogTag = 'BACKDOOR_FLUTTER_API_LOG';

  /// Initializes the `BackdoorFlutter` configuration.
  ///
  /// This method sets up the `jsonUrl`, `appName`, `autoDecrementLaunchCount`, and `version` using
  /// the provided values or environment variables. It also initializes the `StorageService` and sets
  /// the application version in storage.
  ///
  /// [jsonUrl] The URL for the JSON configuration (optional).
  /// [appName] The application name used in the configuration (optional).
  /// [autoDecrementLaunchCount] Flag indicating whether to auto-decrement the launch count (optional).
  /// [version] The current application version (optional).
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

  /// Logs messages to the console with a specific name.
  ///
  /// [data] The data to be logged.
  /// [name] The name of the logger (default is 'BACKDOOR_FLUTTER').
  static void _logger(dynamic data, {String name = 'BACKDOOR_FLUTTER'}) {
    log(data.toString(), name: name);
  }

  /// Determines whether the application should check the online status.
  ///
  /// Checks if the payment model requires online validation based on the version and payment status.
  ///
  /// Returns `true` if an online check is required, otherwise `false`.
  static Future<bool> _shouldCheckOnline() async {
    final BackdoorPaymentModel? backdoorPaymentModel = await StorageService.getPaymentModel();
    if (backdoorPaymentModel == null) return true;
    if (backdoorPaymentModel.targetVersion != version) return true;
    switch (backdoorPaymentModel.status) {
      case PaymentStatusEnum.PAID:
        return backdoorPaymentModel.shouldCheckAfterPaid;

      case PaymentStatusEnum.UNPAID:
        return true;

      case PaymentStatusEnum.ALLOW_LIMITED_LAUNCHES:
        final currentCount = await StorageService.getLaunchCount();
        return (currentCount != null && currentCount > 0);

      case PaymentStatusEnum.ON_TRIAL:
        final now = DateTime.now();
        final warningDate = backdoorPaymentModel.warningDate;
        final expiryDate = backdoorPaymentModel.expireDateTime;
        if (expiryDate == null) return true;
        if (warningDate != null && now.isBefore(warningDate)) {
          return true;
        } else {
          return now.isBefore(expiryDate);
        }
    }
  }

  /// Fetches the payment model from the online service.
  ///
  /// This method performs an HTTP request to retrieve the payment model from the remote server.
  ///
  /// [httpHeaders] The headers to include in the HTTP request.
  /// [httpQueryParameters] The query parameters to include in the HTTP request.
  /// [httpRequestBody] The body of the HTTP request.
  /// [httpMethod] The HTTP method to use (default is 'GET').
  /// [showApiLogs] Whether to log API requests and responses (default is `true`).
  ///
  /// Returns the payment model if found; otherwise, throws an exception.
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

  /// Checks the payment status and executes appropriate callbacks based on the status.
  ///
  /// This method determines whether to check online or use cached data, fetches the payment model,
  /// and calls appropriate callbacks based on the payment status. It also handles exceptions and
  /// provides a mechanism to use cached configuration on network exceptions.
  ///
  /// [httpHeaders] The headers to include in the HTTP request (optional).
  /// [httpQueryParameters] The query parameters to include in the HTTP request (optional).
  /// [httpRequestBody] The body of the HTTP request (optional).
  /// [httpMethod] The HTTP method to use (default is 'GET').
  /// [showApiLogs] Whether to log API requests and responses (default is `true`).
  /// [onException] Callback to handle exceptions.
  /// [onUnhandled] Callback to handle unhandled reasons.
  /// [onAppNotFound] Callback for when the application is not found in the response (optional).
  /// [onPaid] Callback for when the payment status is paid (optional).
  /// [onUnPaid] Callback for when the payment status is unpaid (optional).
  /// [onLimitedLaunch] Callback for when the limited launch status is applicable (optional).
  /// [onLimitedLaunchExceeded] Callback for when the limited launch count is exceeded (optional).
  /// [onTrial] Callback for when the payment status is on trial (optional).
  /// [onTrialWarning] Callback for trial warning (optional).
  /// [onTrialEnded] Callback for when the trial period has ended (optional).
  /// [onTargetVersionMisMatch] Callback for when there is a target version mismatch (optional).
  /// [useCachedConfigOnNetworkCException] Whether to use cached configuration on network exceptions (default is `true`).
  ///
  /// Throws a [BackdoorFlutterException] if an error occurs and is not handled.
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
    bool useCachedConfigOnNetworkCException = true,
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
          onUnhandled(OnUnhandledReasonEnum.APP_NOT_FOUND_IN_JSON, operationModel);
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
          onUnhandled(OnUnhandledReasonEnum.TARGET_VERSION_MISMATCH, operationModel);
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
        shouldCheckOnline: shouldCheckOnline,
        onLimitedLaunchExceeded: onLimitedLaunchExceeded,
        onTargetVersionMisMatch: onTargetVersionMisMatch,
      );
    } catch (e) {
      try {
        if (e is BackdoorFlutterException && e.type == BackdoorFlutterExceptionType.NETWORK_EXCEPTION) {
          final BackdoorPaymentModel? operationModel = await StorageService.getPaymentModel();
          if (operationModel != null && useCachedConfigOnNetworkCException) {
            bool shouldCheckOnline = false;
            return _handleExecution(
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
              shouldCheckOnline: shouldCheckOnline,
              onLimitedLaunchExceeded: onLimitedLaunchExceeded,
              onTargetVersionMisMatch: onTargetVersionMisMatch,
            );
          }
        }
      } catch (e) {
        _logger(e);
        onException(_convertException(e));
      }
      _logger(e);
      onException(_convertException(e));
    }
  }

  /// Handles execution based on the payment model's status.
  ///
  /// Executes the appropriate callback based on the payment status, including handling paid,
  /// unpaid, trial, and limited launch scenarios.
  ///
  /// [onException] Callback to handle exceptions.
  /// [onUnhandled] Callback to handle unhandled reasons.
  /// [onAppNotFound] Callback for when the application is not found in the response (optional).
  /// [onPaid] Callback for when the payment status is paid (optional).
  /// [onUnPaid] Callback for when the payment status is unpaid (optional).
  /// [onLimitedLaunch] Callback for when the limited launch status is applicable (optional).
  /// [onLimitedLaunchExceeded] Callback for when the limited launch count is exceeded (optional).
  /// [onTrial] Callback for when the payment status is on trial (optional).
  /// [onTrialWarning] Callback for trial warning (optional).
  /// [onTrialEnded] Callback for when the trial period has ended (optional).
  /// [onTargetVersionMisMatch] Callback for when there is a target version mismatch (optional).
  /// [operationModel] The payment model to be processed.
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
    required bool shouldCheckOnline,
  }) async {
    switch (operationModel.status) {
      case PaymentStatusEnum.PAID:
        if (onPaid != null) {
          onPaid(operationModel);
        } else {
          onUnhandled(OnUnhandledReasonEnum.PAID, operationModel);
        }
        break;

      case PaymentStatusEnum.UNPAID:
        if (onUnPaid != null) {
          onUnPaid(operationModel);
        } else {
          onUnhandled(OnUnhandledReasonEnum.UNPAID, operationModel);
        }
        break;

      case PaymentStatusEnum.ALLOW_LIMITED_LAUNCHES:
        final allowedLaunches = operationModel.maxLaunch;
        if (allowedLaunches == null) {
          throw BackdoorFlutterException(
            message: 'max_launch not set for ALLOW_LIMITED_LAUNCHES mechanism in remote json file',
            type: BackdoorFlutterExceptionType.CONFIGURATION_EXCEPTION,
            operationConfiguration: operationModel,
          );
        }
        if (shouldCheckOnline) {
          if (!operationModel.strictMaxLaunch) {
            StorageService.setLaunchCount(allowedLaunches);
          }
        }
        final launchCount = await StorageService.getLaunchCount();
        if (launchCount == null || launchCount == 0) {
          if (onLimitedLaunchExceeded != null) {
            onLimitedLaunchExceeded(operationModel);
          } else {
            onUnhandled(OnUnhandledReasonEnum.LIMITED_LAUNCH_EXCEEDED, operationModel);
          }
        } else {
          if (onLimitedLaunch != null) {
            onLimitedLaunch(operationModel, launchCount);
          } else {
            onUnhandled(OnUnhandledReasonEnum.LIMITED_LAUNCH, operationModel);
          }
        }

        if (autoDecrementLaunchCount) await StorageService.decrementCount();
        break;

      case PaymentStatusEnum.ON_TRIAL:
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
          onUnhandled(OnUnhandledReasonEnum.TRAIL_WARNING, operationModel);
        } else if (now.isAfter(expiryDate)) {
          if (onTrialEnded != null) {
            onTrialEnded(operationModel, expiryDate);
          }
          onUnhandled(OnUnhandledReasonEnum.TRIAL_ENDED, operationModel);
        } else if (now.isBefore(expiryDate)) {
          if (onTrial != null) {
            onTrial(operationModel, expiryDate, warningDate);
          }
          onUnhandled(OnUnhandledReasonEnum.TRIAL, operationModel);
        }
        break;

      default:
        throw BackdoorFlutterException(
          message: 'An Unknown Error occurred',
          type: BackdoorFlutterExceptionType.UNKNOWN,
          operationConfiguration: operationModel,
        );
    }
  }

  /// Converts an exception into a [BackdoorFlutterException].
  ///
  /// This method wraps the provided exception into a [BackdoorFlutterException]
  /// with an appropriate message and type based on the exception's nature.
  ///
  /// [exception] The exception to be converted.
  ///
  /// Returns a [BackdoorFlutterException] representing the provided exception.
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
