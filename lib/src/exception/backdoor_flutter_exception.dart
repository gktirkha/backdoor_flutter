// ignore_for_file: constant_identifier_names
import '../model/payment_status_model.dart';

/// Custom exception class for handling errors in the Backdoor application.
///
/// This class encapsulates details about an error, including a message, type,
/// optional API response, stack trace, and operation configuration.
class BackdoorFlutterException implements Exception {
  /// Creates an instance of [BackdoorFlutterException].
  ///
  /// [message] - A descriptive message about the error.
  /// [type] - The type of the exception.
  /// [apiResponse] - Optional response from the API, if applicable.
  /// [stackTrace] - Optional stack trace of the error for debugging.
  /// [operationConfiguration] - Optional configuration associated with the operation that caused the error.
  BackdoorFlutterException({
    required this.message,
    required this.type,
    this.apiResponse,
    this.stackTrace,
    this.operationConfiguration,
  });

  /// A descriptive message about the error.
  final String message;

  /// The type of the exception.
  final BackdoorFlutterExceptionType type;

  /// Optional API response for additional context.
  final String? apiResponse;

  /// Optional stack trace for debugging purposes.
  final StackTrace? stackTrace;

  /// Optional operation configuration related to the error.
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

/// Enumeration representing various types of exceptions that can occur in the Backdoor application.
enum BackdoorFlutterExceptionType {
  /// Indicates that a required value was not found.
  VALUE_NOT_FOUND,

  /// Indicates that a network-related exception occurred.
  NETWORK_EXCEPTION,

  /// Indicates an unknown exception that does not fit other categories.
  UNKNOWN,

  /// Indicates a configuration-related exception.
  CONFIGURATION_EXCEPTION,

  /// Indicates an unknown payment status.
  UNKNOWN_PAYMENT_STATUS,
}
