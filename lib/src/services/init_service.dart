import '../exception/backdoor_flutter_exception.dart';

/// A service for initializing application configuration settings from environment variables.
///
/// This class provides static methods to retrieve configuration values
/// and ensures that necessary values are provided, throwing exceptions when they are not.
abstract class InitService {
  /// Initializes the URL for the JSON configuration.
  ///
  /// [jsonUrl] - An optional default URL. If no environment variable is found,
  /// the method will throw a [BackdoorFlutterException] if the URL is empty.
  ///
  /// Returns:
  /// - A [String] representing the JSON URL.
  static String initializeUrl(String? jsonUrl) {
    String uri = String.fromEnvironment('BACKDOOR_JSON_URL',
        defaultValue: jsonUrl ?? '');

    if (uri.isEmpty) {
      throw BackdoorFlutterException(
        message: 'Please Provide BACKDOOR_JSON_URL in env or init method',
        type: BackdoorFlutterExceptionType.VALUE_NOT_FOUND,
      );
    }

    return uri;
  }

  /// Initializes the application name.
  ///
  /// [appName] - An optional default application name. If no environment variable is found,
  /// the method will throw a [BackdoorFlutterException] if the name is empty.
  ///
  /// Returns:
  /// - A [String] representing the application name.
  static String initializeAppName(String? appName) {
    String name = String.fromEnvironment('BACKDOOR_APP_NAME',
        defaultValue: appName ?? '');

    if (name.isEmpty) {
      throw BackdoorFlutterException(
        message: 'Please Provide BACKDOOR_APP_NAME in env or init method',
        type: BackdoorFlutterExceptionType.VALUE_NOT_FOUND,
      );
    }

    return name;
  }

  /// Initializes the version of the backdoor configuration.
  ///
  /// [version] - An optional default version. If no environment variable is found,
  /// the method will throw a [BackdoorFlutterException] if the version is zero or negative.
  ///
  /// Returns:
  /// - A [double] representing the non-zero version.
  static double initializeVersion(double? version) {
    double backdoorVersion = double.tryParse(String.fromEnvironment(
            'BACKDOOR_VERSION',
            defaultValue: version?.toString() ?? '0.0')) ??
        0.0;

    if (backdoorVersion <= 0) {
      throw BackdoorFlutterException(
        message:
            'Please Provide non-zero BACKDOOR_VERSION in env or init method',
        type: BackdoorFlutterExceptionType.VALUE_NOT_FOUND,
      );
    }

    return backdoorVersion;
  }

  /// Initializes the auto decrement setting for launch count.
  ///
  /// [decrement] - An optional default value for auto decrement. If the environment variable is not set,
  /// the method will throw a [BackdoorFlutterException] if no value is provided.
  ///
  /// Returns:
  /// - A [bool] indicating whether auto decrement is enabled.
  static bool initializeAutoDecrement(bool? decrement) {
    const hasEnvBool = bool.hasEnvironment('BACKDOOR_AUTO_DECREMENT');
    if (hasEnvBool)
      return const bool.fromEnvironment('BACKDOOR_AUTO_DECREMENT');

    if (decrement == null) {
      throw BackdoorFlutterException(
        message: 'Please Provide BACKDOOR_AUTO_DECREMENT in env or init method',
        type: BackdoorFlutterExceptionType.VALUE_NOT_FOUND,
      );
    }

    return decrement;
  }
}
