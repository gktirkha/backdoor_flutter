import 'package:hive_flutter/adapters.dart';

import 'api_response.dart';
import 'strings.dart';

abstract class HiveService {
  static final Box _backdoorBox = Hive.box(Strings.BOX_NAME);

  // For Version
  static num? get version => _backdoorBox.get(Strings.VERSION);
  static Future<void> setVersion(num value) async => await _backdoorBox.put(Strings.VERSION, value);

  // For PaymentStatus
  static num get paymentStatus => _backdoorBox.get(Strings.PAYMENT_STATUS) ?? 0;
  static Future<void> setPaymentStatus(num value) async => _backdoorBox.put(Strings.PAYMENT_STATUS, value);

  // To Clear Hive Box
  static Future<void> clear() async => await _backdoorBox.clear();

  // For Counter
  static num? get counter => _backdoorBox.get(Strings.COUNTER);
  static Future<void> setCounter(num? value) async => _backdoorBox.put(
        Strings.COUNTER,
        (value == null)
            ? value
            : (value >= 0)
                ? value
                : value * -100,
      );
  static Future<void>? decrementCounter() => (counter == null)
      ? null
      : (counter! > 0)
          ? setCounter(counter! - 1)
          : null;

  // For Expiry Date
  static String? get expiryDate => _backdoorBox.get(Strings.EXPIRY_DATE);
  static Future<void> setExpiryDate(String? value) async => _backdoorBox.put(Strings.EXPIRY_DATE, value);

  // For API response
  static ApiResponse? get storedResponse => _backdoorBox.get(Strings.API_RESPONSE);
  static Future<void> setApiResponse(ApiResponse? value) async => _backdoorBox.put(Strings.API_RESPONSE, value);
}
