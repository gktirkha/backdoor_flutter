import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/payment_status_model.dart';

part '../constants/storage_service_keys.dart';

/// Abstract class for managing application data storage using SharedPreferences.
abstract class StorageService {
  static late SharedPreferences _instance;

  /// Initializes the SharedPreferences instance.
  ///
  /// This method must be called before any other methods in this class to ensure
  /// the SharedPreferences instance is available.
  static Future<void> init() async {
    _instance = await SharedPreferences.getInstance();
  }

  /// Clears all stored data in SharedPreferences.
  static Future<void> _clear() async {
    await _instance.clear();
  }

  /// Sets the application version in SharedPreferences.
  ///
  /// [version] - The version number to be stored.
  static Future<void> _setVersion(double version) async {
    await _instance.setDouble(_StorageServiceKeys.version, version);
  }

  /// Retrieves the stored application version from SharedPreferences.
  ///
  /// Returns:
  /// - A [double] representing the stored version, or null if not set.
  static Future<double?> _getVersion() async {
    return _instance.getDouble(_StorageServiceKeys.version);
  }

  /// Sets the application name in SharedPreferences.
  ///
  /// [appName] - The name of the application to be stored.
  static Future<void> _setAppName(String appName) async {
    await _instance.setString(_StorageServiceKeys.appName, appName);
  }

  /// Retrieves the stored application name from SharedPreferences.
  ///
  /// Returns:
  /// - A [String] representing the stored app name, or null if not set.
  static Future<String?> _getAppName() async {
    return _instance.getString(_StorageServiceKeys.appName);
  }

  /// Sets the application configuration in SharedPreferences.
  ///
  /// [version] - The version of the application.
  /// [appName] - The name of the application.
  ///
  /// This method clears the stored data if the app name or version does not match the provided values.
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

  /// Sets the payment model in SharedPreferences.
  ///
  /// [paymentModel] - The [BackdoorPaymentModel] to be stored.
  static Future<void> setPaymentModel(BackdoorPaymentModel paymentModel) async {
    await _instance.setString(
        _StorageServiceKeys.paymentModel, jsonEncode(paymentModel));
  }

  /// Clears the stored payment model in SharedPreferences.
  static Future<void> clearPaymentModel() async {
    await _instance.remove(_StorageServiceKeys.paymentModel);
  }

  /// Retrieves the stored payment model from SharedPreferences.
  ///
  /// Returns:
  /// - A [BackdoorPaymentModel] if found, or null if not set.
  static Future<BackdoorPaymentModel?> getPaymentModel() async {
    final String? paymentString =
        _instance.getString(_StorageServiceKeys.paymentModel);
    if (paymentString == null) return null;
    return BackdoorPaymentModel.fromJson(jsonDecode(paymentString));
  }

  /// Sets the launch count in SharedPreferences.
  ///
  /// [launchCount] - The count of launches to be stored.
  /// Negative counts will be converted to a positive value multiplied by 100.
  static Future<void> setLaunchCount(int launchCount) async {
    final launchToBeSet =
        launchCount < 0 ? launchCount * -1 * 100 : launchCount;
    await _instance.setInt(_StorageServiceKeys.launchCount, launchToBeSet);
  }

  /// Retrieves the stored launch count from SharedPreferences.
  ///
  /// Returns:
  /// - An [int] representing the stored launch count, or null if not set.
  static Future<int?> getLaunchCount() async {
    return _instance.getInt(_StorageServiceKeys.launchCount);
  }

  /// Clears the stored launch count in SharedPreferences.
  static Future<void> clearLaunchCount() async {
    await _instance.remove(_StorageServiceKeys.launchCount);
  }

  /// Decrements the launch count in SharedPreferences by one.
  ///
  /// This method will not decrement if the current count is null or less than or equal to zero.
  static Future<void> decrementCount() async {
    final currentCount = await getLaunchCount();
    if (currentCount == null) return;
    if (currentCount <= 0) return;
    await _instance.setInt(_StorageServiceKeys.launchCount, currentCount - 1);
  }
}
