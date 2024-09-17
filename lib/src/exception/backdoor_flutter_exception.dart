import '../model/payment_status_model.dart';

/// A custom exception class for handling specific errors in the Backdoor Flutter application.
///
/// This class implements the [Exception] interface and provides additional context for the error
/// through properties like [message], [type], [apiResponse], [stackTrace], and [operationConfiguration].
class BackdoorFlutterException implements Exception {
  /// Creates an instance of [BackdoorFlutterException].
  ///
  /// [message] is the error message describing the exception.
  /// [type] specifies the type of exception.
  /// [apiResponse] is an optional response from an API if applicable.
  /// [stackTrace] is an optional stack trace for debugging purposes.
  /// [operationConfiguration] contains optional configuration related to the operation that caused the exception.
  BackdoorFlutterException({
    required this.message,
    required this.type,
    this.apiResponse,
    this.stackTrace,
    this.operationConfiguration,
  });

  /// The error message describing the exception.
  final String message;

  /// The type of exception, which provides context about the error.
  final BackdoorFlutterExceptionType type;

  /// An optional response from an API that might provide more details about the error.
  final String? apiResponse;

  /// An optional stack trace for debugging purposes.
  final StackTrace? stackTrace;

  /// Optional configuration related to the operation that caused the exception.
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

/// Enum representing different types of exceptions in the Backdoor Flutter application.
///
/// This enum categorizes exceptions to provide more context about the nature of the error.
enum BackdoorFlutterExceptionType {
  /// Indicates that a required value was not found.
  VALUE_NOT_FOUND,

  /// Indicates that there was a network-related exception.
  NETWORK_EXCEPTION,

  /// Indicates an unknown error that does not fit into other categories.
  UNKNOWN,

  /// Indicates a configuration-related exception.
  CONFIGURATION_EXCEPTION,
}
