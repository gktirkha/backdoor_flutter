/// Exception class for handling errors specific to the BackdoorFlutter functionality.
class BackdoorFlutterException implements Exception {
  /// Creates a new instance of [BackdoorFlutterException].
  ///
  /// [message] - An optional error message to describe the exception.
  BackdoorFlutterException({this.message});

  /// An optional error message that provides details about the exception.
  final String? message;

  /// Returns a string representation of the exception.
  ///
  /// If a [message] is provided, it is returned. Otherwise, the default
  /// exception string representation is returned.
  @override
  String toString() {
    return message != null ? message! : super.toString();
  }
}
