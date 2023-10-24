import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'api_response.dart';
import 'api_response_adapter.dart';
import 'date_helper.dart';
import 'dio_singleton.dart';
import 'hive_service.dart';
import 'strings.dart';
import 'type_definitions.dart';

abstract class Backdoor {
  static late OnNetworkException _onNetworkException;
  static late OnException _onException;
  static late OnCounter _onCounter;
  static late int _currentVersion;
  static late OnUnpaid _onUnpaid;
  static late String _appName;
  static late bool _showLogs;
  static late OnPaid _onPaid;
  static late String _url;

  static void initialize({
    required String appName,
    required String url,
    required int version,
    required String hiveBoxName,
    bool showLogs = false,
  }) async {
    _showLogs = showLogs;
    Strings.initialize(hiveBoxName);
    await Hive.initFlutter();
    Hive.registerAdapter(ApiResponseAdapter());
    await Hive.openBox(Strings.BOX_NAME);
    _currentVersion = version;
    _appName = appName;
    _url = url;
  }

  static void _checkVersion() async {
    // clear the Hive Box if current version changes
    if (HiveService.version == null || HiveService.version! < _currentVersion) {
      await HiveService.clear();
      await HiveService.setVersion(_currentVersion);
    }
  }

  // Check if we need to check server
  static bool get _shouldCheckServer {
    _logger('Expiry Date: ${HiveService.expiryDate}, Countdown ${HiveService.counter}');
    if (HiveService.counter == null && HiveService.expiryDate == null) return true;
    if (HiveService.expiryDate != null && HiveService.expiryDate.isExpired()) return true;
    if (!HiveService.expiryDate.isExpired()) return (HiveService.counter == null || HiveService.counter == 0);
    return (HiveService.counter == null || HiveService.counter == 0);
  }

  static Future<void> _checkServer() async {
    try {
      final Response response = await DioSingleton.instance.dioClient.get(_url);
      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          message: 'Received status code is not 200',
        );
      }
      final Map<String, dynamic> data = (response.data is String) ? jsonDecode(response.data) : response.data;
      final ApiResponse apiResponse = ApiResponse.fromMap(data['apps'][_appName]);
      _logger(apiResponse.toString());
      await _updateStoredData(apiResponse: apiResponse);
      _execute();
    } on DioException catch (exception) {
      _onNetworkException(exception);
      exception.toString();
    } catch (exception) {
      _onException(exception);
    }
  }

  static Future<void> _updateStoredData({required ApiResponse apiResponse}) async {
    _logger('Updating Hive Database');
    await HiveService.setPaymentStatus(apiResponse.status);
    if (apiResponse.status == Strings.PAID) return;

    await HiveService.setApiResponse(apiResponse);
    await HiveService.setExpiryDate(apiResponse.expiryDate);

    if (apiResponse.expiryDate == null) {
      await HiveService.setCounter(apiResponse.maxLaunch);
      return;
    }
    await HiveService.setCounter(apiResponse.expiryDate.isExpired() ? null : apiResponse.maxLaunch);
  }

  static void _execute() async {
    _logger('Payment Status received form server is ${HiveService.paymentStatus}');
    if (HiveService.paymentStatus == Strings.PAID) {
      _onPaid();
      return;
    }
    await HiveService.decrementCounter();
    (HiveService.counter == null)
        ? _onUnpaid(HiveService.storedResponse)
        : _onCounter(expiryDate: HiveService.expiryDate, remainingCounter: HiveService.counter, storedResponse: HiveService.storedResponse);
  }

  static Future<void> checkPayment({
    required OnPaid onPaid,
    required OnUnpaid onUnpaid,
    required OnCounter onCounter,
    required OnException onException,
    required OnNetworkException onNetworkException,
  }) async {
    _onPaid = onPaid;
    _onUnpaid = onUnpaid;
    _onCounter = onCounter;
    _onException = onException;
    _onNetworkException = onNetworkException;

    // Check the stored version and compare it with current version
    _checkVersion();

    // No Server Call If Payment Status is Paid
    if (HiveService.paymentStatus == Strings.PAID) {
      _logger('Payment Status is Paid in local storage');
      _onPaid();
      return;
    }

    // Check if we need to check server
    if (_shouldCheckServer) {
      _logger('Checking Payment Status Online');
      await _checkServer();
      return;
    }

    // Run and decrement the counter if we don't need to check server
    _logger('Payment Status is unPaid, but date is not expired and counter is not 0 in local storage');
    await HiveService.decrementCounter();
    _onCounter(expiryDate: HiveService.expiryDate, remainingCounter: HiveService.counter, storedResponse: HiveService.storedResponse);
  }

  static void _logger(String? message) => (_showLogs) ? log(message.toString(), name: Strings.LOG_STRING) : null;
}
