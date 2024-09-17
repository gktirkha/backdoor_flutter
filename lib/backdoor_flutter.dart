/// A Dart library for managing and interacting with the backdoor payment system.
///
/// This library provides core functionalities for handling payments, including:
/// - Configuration and initialization of the backdoor system.
/// - Checking payment statuses and handling different scenarios such as paid, unpaid, trial, and limited launches.
/// - Handling exceptions related to payment and configuration.
///
/// Components exported by this library include:
/// - `BackdoorFlutter`: The main class for interacting with the backdoor payment system.
/// - `BackdoorFlutterTypeDefinitions`: Type definitions used throughout the library.
/// - `OnUnhandledReasonEnum`: Enum representing various reasons for unhandled cases.
/// - `PaymentStatusEnum`: Enum representing different payment statuses.
/// - `BackdoorFlutterException`: Custom exception class for handling errors in the backdoor system.
/// - `PaymentStatusModel`: Model class representing the payment status.
library backdoor_flutter;

// Export the core class for managing payments.
export './src/backdoor_flutter.dart';
// Export type definitions used throughout the library.
export './src/constants/backdoor_flutter_type_definitions.dart';
// Export payment status enumeration.
export './src/constants/payment_status_enum.dart';
// Export custom exception class for error handling.
export './src/exception/backdoor_flutter_exception.dart';
// Export the payment status model class.
export './src/model/payment_status_model.dart';
// Export reasons for unhandled cases.
export 'src/constants/on_unhandled_reason_enum.dart';
