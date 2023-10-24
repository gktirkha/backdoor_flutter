// ignore_for_file: constant_identifier_names, non_constant_identifier_names

class Strings {
  static void initialize(String appName) {
    BOX_NAME = '${appName.toUpperCase()}_BACKDOOR_BOX';
  }

  static late String BOX_NAME;
  static const String VERSION = 'BACKDOOR_VERSION';
  static const String PAYMENT_STATUS = 'BACKDOOR_PAYMENT_STATUS';
  static const String COUNTER = 'BACKDOOR_COUNTER';
  static const String EXPIRY_DATE = 'BACKDOOR_EXPIRY_DATE';
  static const String API_RESPONSE = 'BACKDOOR_API_RESPONSE';

  static const int PAID = 1;
  static const int UNPAID = 0;
  static const String LOG_STRING = 'Backdoor';
}
