import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../constants/storage_service_keys.dart';
import '../model/payment_status_model.dart';

abstract class StorageService {
  static late SharedPreferences _instance;

  static Future<void> init() async {
    _instance = await SharedPreferences.getInstance();
  }

  static Future<void> _clear() async {
    await _instance.clear();
  }

  static Future<void> _setVersion(double version) async {
    await _instance.setDouble(StorageServiceKeys.version, version);
  }

  static Future<double?> _getVersion() async {
    return _instance.getDouble(StorageServiceKeys.version);
  }

  static Future<void> _setAppName(String appName) async {
    await _instance.setString(StorageServiceKeys.appName, appName);
  }

  static Future<String?> _getAppName() async {
    return _instance.getString(StorageServiceKeys.appName);
  }

  static Future<void> setConfig(double version, String appName) async {
    final storedVersion = await _getVersion();
    final storedAppName = await _getAppName();

    if ((version == storedVersion) && (appName == storedAppName)) return;

    if (storedAppName != appName) {
      await _clear();
    }

    if (storedVersion == null || storedAppName == null) {
      await _clear();
      await _setVersion(version);
      await _setAppName(appName);
      return;
    }

    if (version > storedVersion) {
      await _clear();
      await _setVersion(version);
    }
  }

  static Future<void> setPaymentModel(BackdoorPaymentModel paymentModel) async {
    await _instance.setString(StorageServiceKeys.paymentModel, jsonEncode(paymentModel));
  }

  static Future<void> clearPaymentModel() async {
    await _instance.remove(StorageServiceKeys.paymentModel);
  }

  static Future<BackdoorPaymentModel?> getPaymentModel() async {
    final String? paymentString = _instance.getString(StorageServiceKeys.paymentModel);
    if (paymentString == null) return null;
    return BackdoorPaymentModel.fromJson(jsonDecode(paymentString));
  }

  static Future<void> setLaunchCount(int launchCount) async {
    final launchToBeSet = launchCount < 0 ? launchCount * -1 * 100 : launchCount;
    await _instance.setInt(StorageServiceKeys.launchCount, launchToBeSet);
  }

  static Future<int?> getLaunchCount() async {
    return _instance.getInt(StorageServiceKeys.launchCount);
  }

  static Future<void> clearLaunchCount() async {
    await _instance.remove(StorageServiceKeys.launchCount);
  }

  static Future<void> decrementCount() async {
    final currentCount = await getLaunchCount();
    if (currentCount == null) return;
    if (currentCount <= 0) return;
    await _instance.setInt(StorageServiceKeys.launchCount, currentCount - 1);
  }
}
