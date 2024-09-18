import '../model/payment_status_model.dart';

class BackdoorFlutterException implements Exception {
  BackdoorFlutterException({
    required this.message,
    required this.type,
    this.apiResponse,
    this.stackTrace,
    this.operationConfiguration,
  });

  final String message;

  final BackdoorFlutterExceptionType type;

  final String? apiResponse;

  final StackTrace? stackTrace;

  final BackdoorPaymentModel? operationConfiguration;

  @override
  String toString() {
    String returnMessage = message;
    if (apiResponse != null) {
      returnMessage += '\nAPI_RESPONSE:\n $apiResponse';
    }
    return returnMessage;
  }
}

enum BackdoorFlutterExceptionType {
  VALUE_NOT_FOUND,

  NETWORK_EXCEPTION,

  UNKNOWN,

  CONFIGURATION_EXCEPTION,

  UNKNOWN_PAYMENT_STATUS,
}
