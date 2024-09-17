import '../exception/backdoor_flutter_exception.dart';

/// A service class responsible for initializing configuration values from environment variables
/// or provided defaults.
///
/// This class contains static methods for initializing URLs, application names, versions, and
/// auto-decrement flags. It throws [BackdoorFlutterException] if required environment variables
/// or parameters are missing or invalid.
abstract class InitService {
  /// Initializes and retrieves the URL from environment variables or a provided default.
  ///
  /// This method looks for the environment variable [BACKDOOR_JSON_URL]. If the environment
  /// variable is not set, it uses the provided [jsonUrl] as a fallback.
  ///
  /// Throws [BackdoorFlutterException] if the URL is empty after checking the environment
  /// variable and the default value.
  ///
  /// [jsonUrl] The default URL to use if the environment variable is not set.
  ///
  /// Returns the initialized URL as a [String].
  static String initializeUrl(String? jsonUrl) {
    String uri = String.fromEnvironment('BACKDOOR_JSON_URL', defaultValue: jsonUrl ?? '');

    if (uri.isEmpty) {
      throw BackdoorFlutterException(
        message: 'Please Provide BACKDOOR_JSON_URL in env or init method',
        type: BackdoorFlutterExceptionType.VALUE_NOT_FOUND,
      );
    }

    return uri;
  }

  /// Initializes and retrieves the application name from environment variables or a provided default.
  ///
  /// This method looks for the environment variable [APP_NAME]. If the environment variable
  /// is not set, it uses the provided [appName] as a fallback.
  ///
  /// Throws [BackdoorFlutterException] if the application name is empty after checking the
  /// environment variable and the default value.
  ///
  /// [appName] The default application name to use if the environment variable is not set.
  ///
  /// Returns the initialized application name as a [String].
  static String initializeAppName(String? appName) {
    String name = String.fromEnvironment('APP_NAME', defaultValue: appName ?? '');

    if (name.isEmpty) {
      throw BackdoorFlutterException(
        message: 'Please Provide APP_NAME in env or init method',
        type: BackdoorFlutterExceptionType.VALUE_NOT_FOUND,
      );
    }

    return name;
  }

  /// Initializes and retrieves the version number from environment variables or a provided default.
  ///
  /// This method looks for the environment variable [BACKDOOR_VERSION]. If the environment variable
  /// is not set or invalid, it uses the provided [version] as a fallback.
  ///
  /// Throws [BackdoorFlutterException] if the version is zero or if the environment variable and
  /// default value both fail to provide a valid version.
  ///
  /// [version] The default version to use if the environment variable is not set or is invalid.
  ///
  /// Returns the initialized version number as a [double].
  static double initializeVersion(double? version) {
    double backdoorVersion = double.tryParse(String.fromEnvironment('BACKDOOR_VERSION', defaultValue: version?.toString() ?? '0.0')) ?? 0.0;

    if (backdoorVersion == 0) {
      throw BackdoorFlutterException(
        message: 'Please Provide non zero BACKDOOR_VERSION in env or init method',
        type: BackdoorFlutterExceptionType.VALUE_NOT_FOUND,
      );
    }

    return backdoorVersion;
  }

  /// Initializes and retrieves the auto-decrement flag from environment variables or a provided default.
  ///
  /// This method looks for the environment variable [BACKDOOR_AUTO_DECREMENT]. If the environment
  /// variable is not set, it uses the provided [decrement] as a fallback.
  ///
  /// Throws [BackdoorFlutterException] if the environment variable is not set and the [decrement]
  /// parameter is null.
  ///
  /// [decrement] The default value for auto-decrement if the environment variable is not set.
  ///
  /// Returns the initialized auto-decrement flag as a [bool].
  static bool initializeAutoDecrement(bool? decrement) {
    const hasEnvBool = bool.hasEnvironment('BACKDOOR_AUTO_DECREMENT');
    if (hasEnvBool) return const bool.fromEnvironment('BACKDOOR_AUTO_DECREMENT');

    if (decrement == null) {
      throw BackdoorFlutterException(
        message: 'Please Provide BACKDOOR_AUTO_DECREMENT in env or init method',
        type: BackdoorFlutterExceptionType.VALUE_NOT_FOUND,
      );
    }

    return decrement;
  }
}
