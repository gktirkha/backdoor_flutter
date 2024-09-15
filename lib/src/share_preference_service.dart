import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'models/backdoor_payment_status_model.dart';

/// A service class for managing shared preferences related to the BackdoorFlutter configuration.
///
/// This class provides static methods to interact with shared preferences,
/// including storing and retrieving payment models, version numbers, and launch counts.
abstract class SharePreferenceService {
  static late SharedPreferences sharedPreferences;
  static const String _ref = 'backdoor_flutter';
  static const String _paymentModelKey = '${_ref}PAYMENT_MODEL';
  static const String _launchCountKey = '${_ref}LAUNCH_COUNT';

  /// Initializes the SharedPreferences instance.
  ///
  /// This method must be called before using other methods of this class to ensure
  /// that the SharedPreferences instance is properly initialized.
  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  /// Retrieves the stored [BackdoorPaymentModel] from shared preferences.
  ///
  /// Returns the [BackdoorPaymentModel] if it exists, or `null` if it does not.
  ///
  /// Throws a [FormatException] if the stored data is not valid JSON or does not match the expected format.
  static Future<BackdoorPaymentModel?> getPaymentModel() async {
    final model = sharedPreferences.getString(_paymentModelKey);
    if (model == null) return null;
    return BackdoorPaymentModel.fromJson(jsonDecode(model));
  }

  /// Stores a [BackdoorPaymentModel] in shared preferences.
  ///
  /// If [paymentStatusModel] is `null`, this method will remove the existing payment model.
  ///
  /// [paymentStatusModel] - The payment model to store.
  static Future<void> setPaymentModel(
    BackdoorPaymentModel? paymentStatusModel,
  ) async {
    if (paymentStatusModel == null) {
      await sharedPreferences.remove(_paymentModelKey);
    } else {
      await sharedPreferences.setString(
        _paymentModelKey,
        jsonEncode(paymentStatusModel),
      );
    }
  }

  /// Retrieves the stored launch count from shared preferences.
  ///
  /// Returns the launch count as an [int] if it exists, or `null` if it does not.
  static Future<int?> getLaunchCount() async {
    return sharedPreferences.getInt(_launchCountKey);
  }

  /// Stores the launch count in shared preferences.
  ///
  /// If [count] is `null`, this method will remove the existing launch count.
  /// If [count] is less than or equal to 0, it will store a modified count to ensure proper handling.
  ///
  /// [count] - The launch count to store.
  static Future<void> setLaunchCount(
    int? count,
  ) async {
    if (count == null) {
      await sharedPreferences.remove(_launchCountKey);
    } else {
      final countToBeStored = count > 0 ? count : count * -1 * 100;
      await sharedPreferences.setInt(
        _launchCountKey,
        countToBeStored,
      );
    }
  }

  /// Removes the stored launch count from shared preferences.
  ///
  /// This method resets the launch count, effectively removing it from shared preferences.
  static Future<void> resetCount() async {
    await sharedPreferences.remove(_launchCountKey);
  }

  /// Decreases the stored launch count by one.
  ///
  /// If the current launch count is `null` or `0`, no changes will be made.
  static Future<void> decrease() async {
    final currentCount = (await getLaunchCount());
    if (currentCount == null || currentCount == 0) return;
    await sharedPreferences.setInt(_launchCountKey, currentCount - 1);
  }
}
