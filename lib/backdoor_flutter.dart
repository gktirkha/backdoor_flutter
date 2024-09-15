/// The Backdoor Flutter library.
///
/// This library provides a set of tools for managing application payment status and controlling launch behaviors
/// using configuration from a remote JSON source. It includes functionalities for initialization, checking app
/// status, and handling various payment states.

library backdoor_flutter;

// Export the core class responsible for managing payment status and launch control.
export './src/backdoor_flutter.dart';
// Export the exception class used for handling errors in the BackdoorFlutter operations.
export './src/backdoor_flutter_exception.dart';
// Export type definitions used throughout the BackdoorFlutter library.
export './src/backdoor_type_definitions.dart';
// Export the data model representing the payment status and related information.
export './src/models/backdoor_payment_status_model.dart';
// Export the enumeration defining various payment statuses.
export './src/payment_status_enum.dart';
