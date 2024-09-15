import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'backdoor_flutter_exception.dart';
import 'backdoor_type_definitions.dart';
import 'init_service.dart';
import 'models/backdoor_payment_status_model.dart';
import 'payment_status_enum.dart';
import 'share_preference_service.dart';

/// A class responsible for managing application payment status and launch control.
abstract class BackdoorFlutter {
  /// The URL used to fetch the JSON configuration.
  static late String jsonUrl;

  /// The name of the application.
  static late String appName;

  /// A flag to determine if the launch counter should be auto-decremented.
  static late bool autoDecrement;

  /// Initializes the BackdoorFlutter configuration.
  ///
  /// [jsonUrl] The URL where the JSON configuration can be found.
  /// [appName] The name of the application.
  /// [autoDecrementLaunchCounter] A flag indicating if the launch counter should be auto-decremented.
  static Future<void> initialize({
    String? jsonUrl,
    String? appName,
    bool? autoDecrementLaunchCounter,
  }) async {
    BackdoorFlutter.jsonUrl = InitService.initializeUrl(jsonUrl);
    BackdoorFlutter.appName = InitService.initializeAppName(appName);
    BackdoorFlutter.autoDecrement =
        InitService.initializeAutoDecrement(autoDecrementLaunchCounter);

    await SharePreferenceService.init();
  }

  /// Decrements the launch counter if auto-decrement is enabled.
  static Future<void> _decrementCounter() async {
    if (!autoDecrement) return;
    await decrementLaunchCounter();
  }

  /// Decrements the launch counter in shared preferences.
  static Future<void> decrementLaunchCounter() async {
    await SharePreferenceService.decrease();
  }

  /// Checks if the app status should be verified against the model.
  ///
  /// [model] The [BackdoorPaymentModel] to check.
  /// Returns true if the app status requires verification.
  static Future<bool> _checkFromModel(
    BackdoorPaymentModel model,
  ) async {
    switch (model.status) {
      case PaymentStatusEnum.PAID:
        return model.shouldCheckAfterPaid;

      case PaymentStatusEnum.UNPAID:
        return true;

      case PaymentStatusEnum.ALLOW_LIMITED_LAUNCHES:
        final launchCount = await SharePreferenceService.getLaunchCount();
        return launchCount == null || launchCount == 0;

      case PaymentStatusEnum.ON_TRIAL:
        final expiryDate =
            (await SharePreferenceService.getPaymentModel())?.expiryDate;
        return expiryDate != null && expiryDate.isBefore(DateTime.now());

      default:
        return true;
    }
  }

  /// Determines if the app status should be checked online.
  ///
  /// Returns true if the status should be checked online, otherwise false.
  static Future<bool> _shouldCheckOnline() async {
    final BackdoorPaymentModel? model =
        await SharePreferenceService.getPaymentModel();
    if (model == null) return true;

    final res = await _checkFromModel(model);
    return res;
  }

  /// Fetches the payment model from the online JSON configuration.
  ///
  /// [httpHeaders] HTTP headers for the request.
  /// [httpQueryParameters] Query parameters for the request.
  /// [httpRequestBody] Body of the HTTP request.
  /// [httpMethod] HTTP method to use for the request (GET, POST, etc.).
  /// [onAppNotFoundInJson] Callback for when the app is not found in the JSON response.
  /// [showApiLogs] Flag indicating if API logs should be shown.
  ///
  /// Returns the BackdoorPaymentModel fetched from the JSON response.
  static Future<BackdoorPaymentModel> _onlineModel({
    required Map<String, dynamic> httpHeaders,
    required Map<String, dynamic> httpQueryParameters,
    required Map<String, dynamic> httpRequestBody,
    required String httpMethod,
    required OnAppNotFoundINJson? onAppNotFoundInJson,
    required bool showApiLogs,
  }) async {
    try {
      final dio = Dio(
        BaseOptions(
          sendTimeout: const Duration(minutes: 5),
          connectTimeout: const Duration(minutes: 5),
          receiveTimeout: const Duration(minutes: 5),
        ),
      );

      if (showApiLogs) {
        dio.interceptors.addAll(
          [
            LogInterceptor(
              logPrint: (object) => _logger(object, name: 'BACKDOOR_API_LOGS'),
            ),
          ],
        );
      }

      final response = await dio.request(
        jsonUrl,
        options: Options(
          headers: httpHeaders,
          method: httpMethod,
        ),
        queryParameters: httpQueryParameters,
        data: httpRequestBody,
      );

      final responseData = response.data;
      final Map<String, dynamic> jsonData = responseData is String
          ? jsonDecode(responseData)
          : responseData as Map<String, dynamic>;

      final paymentStatusModel =
          BackdoorPaymentApiResponseModel.fromJson(jsonData);

      if (showApiLogs) {
        _logger(
          'Json From $jsonUrl:\n${paymentStatusModel.toJson()}',
          name: 'BACKDOOR_API_LOGS',
        );
      }

      final selectedApp = paymentStatusModel.apps?[appName];
      if (selectedApp == null) {
        onAppNotFoundInJson?.call(paymentStatusModel);
        throw BackdoorFlutterException(
          message: 'App $appName not found in JSON.',
        );
      }

      return selectedApp;
    } catch (e) {
      _logger('Error fetching or parsing JSON: ${e.toString()}');
      rethrow;
    }
  }

  /// Checks the application status and triggers the appropriate callback based on the status.
  ///
  /// [onPaid] Callback for when the status is PAID.
  /// [onLimitedLaunches] Callback for when the status allows limited launches.
  /// [onUnpaid] Callback for when the status is UNPAID.
  /// [onException] Callback for handling exceptions.
  /// [onLimitedLaunchesExceeded] Callback for when the limited launches have been exceeded.
  /// [onTrial] Callback for when the status is ON_TRIAL and trial is active.
  /// [onTrialExpire] Callback for when the status is ON_TRIAL and trial has expired.
  /// [httpHeaders] HTTP headers for the request.
  /// [httpQueryParameters] Query parameters for the request.
  /// [httpRequestBody] Body of the HTTP request.
  /// [httpMethod] HTTP method to use for the request (GET, POST, etc.).
  /// [onAppNotFoundInNJson] Callback for when the app is not found in the JSON response.
  /// [showAPILogs] Flag indicating if API logs should be shown.
  static Future<void> checkAppStatus({
    OnPaid? onPaid,
    OnLimitedLaunches? onLimitedLaunches,
    OnUnpaid? onUnpaid,
    OnException? onException,
    OnLimitedLaunchesExceeded? onLimitedLaunchesExceeded,
    OnTrial? onTrial,
    OnTrialExpire? onTrialExpire,
    Map<String, dynamic>? httpHeaders,
    Map<String, dynamic>? httpQueryParameters,
    Map<String, dynamic>? httpRequestBody,
    String httpMethod = 'GET',
    OnAppNotFoundINJson? onAppNotFoundInNJson,
    bool showAPILogs = kDebugMode,
  }) async {
    try {
      final checkOnline = await _shouldCheckOnline();

      BackdoorPaymentModel? prefModel =
          await SharePreferenceService.getPaymentModel();

      BackdoorPaymentModel? operationModel;

      if (checkOnline) {
        operationModel = await _onlineModel(
          httpHeaders: httpHeaders ?? {},
          httpMethod: httpMethod,
          httpQueryParameters: httpQueryParameters ?? {},
          httpRequestBody: httpRequestBody ?? {},
          onAppNotFoundInJson: onAppNotFoundInNJson,
          showApiLogs: showAPILogs,
        );
      } else {
        operationModel = prefModel;
      }

      if (operationModel == null && prefModel != null && checkOnline) {
        operationModel = prefModel;
      }

      if (operationModel == null) {
        if (checkOnline) return;
        throw BackdoorFlutterException(message: 'Something Went Wrong');
      }

      if (checkOnline) {
        prefModel = operationModel;
        await SharePreferenceService.setPaymentModel(prefModel);

        if (!operationModel.strictMaxLaunch &&
            operationModel.status == PaymentStatusEnum.ALLOW_LIMITED_LAUNCHES) {
          await SharePreferenceService.setLaunchCount(operationModel.maxLaunch);
        }
      }

      handelModel(
        operationModel,
        onPaid,
        onLimitedLaunches,
        onUnpaid,
        onException,
        onLimitedLaunchesExceeded,
        onTrial,
        onTrialExpire,
      );
    } catch (e) {
      BackdoorPaymentModel? prefModel =
          await SharePreferenceService.getPaymentModel();

      if (prefModel != null) {
        return handelModel(
          prefModel,
          onPaid,
          onLimitedLaunches,
          onUnpaid,
          onException,
          onLimitedLaunchesExceeded,
          onTrial,
          onTrialExpire,
        );
      }
      _logger(e);
      if (e is Exception) onException?.call(e, null);
    }
  }

  /// Logs messages or errors to the console.
  ///
  /// [data] The data to log.
  /// [name] The name of the log.
  static void _logger(dynamic data, {String name = 'BACKDOOR_FLUTTER'}) {
    log(data.toString(), name: name);
  }

  /// Handles the BackdoorPaymentModel based on its status and triggers appropriate callbacks.
  ///
  /// [operationModel] The BackdoorPaymentModel to handle.
  /// [onPaid] Callback for when the status is PAID.
  /// [onLimitedLaunches] Callback for when the status allows limited launches.
  /// [onUnpaid] Callback for when the status is UNPAID.
  /// [onException] Callback for handling exceptions.
  /// [onLimitedLaunchesExceeded] Callback for when the limited launches have been exceeded.
  /// [onTrial] Callback for when the status is ON_TRIAL and trial is active.
  /// [onTrialExpire] Callback for when the status is ON_TRIAL and trial has expired.
  static Future<void> handelModel(
    BackdoorPaymentModel operationModel,
    OnPaid? onPaid,
    OnLimitedLaunches? onLimitedLaunches,
    OnUnpaid? onUnpaid,
    OnException? onException,
    OnLimitedLaunchesExceeded? onLimitedLaunchesExceeded,
    OnTrial? onTrial,
    OnTrialExpire? onTrialExpire,
  ) async {
    switch (operationModel.status) {
      case PaymentStatusEnum.PAID:
        onPaid?.call(operationModel);
        break;

      case PaymentStatusEnum.UNPAID:
        onUnpaid?.call(operationModel);
        break;

      case PaymentStatusEnum.ALLOW_LIMITED_LAUNCHES:
        final launchCount = await SharePreferenceService.getLaunchCount();
        if (launchCount != null && launchCount > 0) {
          onLimitedLaunches?.call(operationModel, launchCount);
        } else {
          onLimitedLaunchesExceeded?.call(operationModel);
        }
        await _decrementCounter();
        break;

      case PaymentStatusEnum.ON_TRIAL:
        final expiryDate =
            (await SharePreferenceService.getPaymentModel())?.expiryDate;
        if (expiryDate != null && expiryDate.isAfter(DateTime.now())) {
          onTrial?.call(operationModel);
        } else {
          onTrialExpire?.call(operationModel);
        }
        break;

      default:
        throw BackdoorFlutterException(
          message: 'Unknown Status ${operationModel.status}',
        );
    }
  }
}
