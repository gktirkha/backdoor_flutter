import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../constants/storage_service_keys.dart';
import '../model/payment_status_model.dart';

/// A service class for managing persistent storage using [SharedPreferences].
///
/// This class provides static methods to interact with shared preferences, including
/// initializing preferences, setting and retrieving version numbers, handling payment
/// models, and managing launch counts.
abstract class StorageService {
  /// The instance of [SharedPreferences] used for storing and retrieving data.
  static late SharedPreferences _instance;

  /// Initializes the [SharedPreferences] instance.
  ///
  /// This method must be called before using any other methods in this class to ensure
  /// that the [SharedPreferences] instance is properly initialized.
  static Future<void> init() async {
    _instance = await SharedPreferences.getInstance();
  }

  /// Clears all data stored in [SharedPreferences].
  ///
  /// This method removes all key-value pairs from the shared preferences storage.
  static Future<void> _clear() async {
    await _instance.clear();
  }

  /// Sets the Backdoor Rules version in [SharedPreferences].
  ///
  /// [version] The version number to be stored.
  static Future<void> _setVersion(double version) async {
    await _instance.setDouble(StorageServiceKeys.version, version);
  }

  /// Retrieves the Backdoor Rules version from [SharedPreferences].
  ///
  /// Returns the stored version number as a [double], or null if no version is stored.
  static Future<double?> _getVersion() async {
    return _instance.getDouble(StorageServiceKeys.version);
  }

  /// Sets the Backdoor Rules version and clears stored data if the new version is different.
  ///
  /// If the new [version] is different from the currently stored version, or if no version is
  /// currently stored, this method clears all stored data and updates the stored version.
  ///
  /// [version] The version number to be set.
  static Future<void> setVersion(double version) async {
    final storedVersion = await _getVersion();
    if (version == storedVersion) return;

    if (storedVersion == null) {
      await _clear();
      return await _setVersion(version);
    }

    if (version > storedVersion) {
      await _clear();
      await _setVersion(version);
    }
  }

  /// Stores a [BackdoorPaymentModel] instance in [SharedPreferences].
  ///
  /// [paymentModel] The payment model to be encoded as a JSON string and stored.
  static Future<void> setPaymentModel(BackdoorPaymentModel paymentModel) async {
    await _instance.setString(StorageServiceKeys.paymentModel, jsonEncode(paymentModel));
  }

  /// Removes the stored payment model from [SharedPreferences].
  ///
  /// This method deletes the key-value pair associated with the payment model.
  static Future<void> clearPaymentModel() async {
    await _instance.remove(StorageServiceKeys.paymentModel);
  }

  /// Retrieves the stored payment model from [SharedPreferences].
  ///
  /// Returns a [BackdoorPaymentModel] instance if a payment model is stored; otherwise, returns null.
  static Future<BackdoorPaymentModel?> getPaymentModel() async {
    final String? paymentString = _instance.getString(StorageServiceKeys.paymentModel);
    if (paymentString == null) return null;
    return BackdoorPaymentModel.fromJson(jsonDecode(paymentString));
  }

  /// Stores or updates the launch count in [SharedPreferences].
  ///
  /// If [launchCount] is null, this method does nothing. Otherwise, it stores the launch count,
  /// converting negative values to a positive multiplier (e.g., -5 becomes 500).
  ///
  /// [launchCount] The number of launches to be stored.
  static Future<void> setLaunchCount(int? launchCount) async {
    if (launchCount == null) return;
    final launchToBeSet = launchCount < 0 ? launchCount * -1 * 100 : launchCount;
    await _instance.setInt(StorageServiceKeys.launchCount, launchToBeSet);
  }

  /// Retrieves the stored launch count from [SharedPreferences].
  ///
  /// Returns the stored launch count as an [int], or null if no launch count is stored.
  static Future<int?> getLaunchCount() async {
    return _instance.getInt(StorageServiceKeys.launchCount);
  }

  /// Removes the stored launch count from [SharedPreferences].
  ///
  /// This method deletes the key-value pair associated with the launch count.
  static Future<void> clearLaunchCount() async {
    await _instance.remove(StorageServiceKeys.launchCount);
  }

  /// Decrements the launch count by one.
  ///
  /// This method retrieves the current launch count, decrements it by one if it is greater than zero,
  /// and then stores the updated count. If the count is zero or null, no action is taken.
  static Future<void> decrementCount() async {
    final currentCount = await getLaunchCount();
    if (currentCount == null) return;
    if (currentCount == 0) return;
    await setLaunchCount(currentCount - 1);
  }
}
