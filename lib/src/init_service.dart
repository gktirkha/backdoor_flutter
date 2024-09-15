import 'backdoor_flutter_exception.dart';

/// A service class for initializing configuration settings from environment variables or method arguments.
///
/// This class provides static methods to initialize various configuration parameters needed
/// for the BackdoorFlutter class.
abstract class InitService {
  /// Initializes the URL used for fetching JSON data.
  ///
  /// This method retrieves the URL from environment variables or uses the provided default value.
  /// Throws a [BackdoorFlutterException] if no URL is provided.
  ///
  /// [jsonUrl] - The default URL to use if the environment variable is not set.
  ///
  /// Returns the initialized URL.
  static String initializeUrl(String? jsonUrl) {
    String uri =
        String.fromEnvironment('BACKDOOR_URL', defaultValue: jsonUrl ?? '');

    if (uri.isEmpty) {
      throw BackdoorFlutterException(
        message: 'Please Provide Json Url in env or init method',
      );
    }

    return uri;
  }

  /// Initializes the app name.
  ///
  /// This method retrieves the app name from environment variables or uses the provided default value.
  /// Throws a [BackdoorFlutterException] if no app name is provided.
  ///
  /// [appName] - The default app name to use if the environment variable is not set.
  ///
  /// Returns the initialized app name.
  static String initializeAppName(String? appName) {
    String name = String.fromEnvironment(
      'BACKDOOR_APP_NAME',
      defaultValue: appName ?? '',
    );

    if (name.isEmpty) {
      throw BackdoorFlutterException(
        message: 'Please Provide App Name in env or init method',
      );
    }

    return name;
  }

  /// Initializes the auto-decrement flag.
  ///
  /// This method retrieves the auto-decrement setting from environment variables or uses the provided default value.
  ///
  /// [autoDecrement] - The default value for auto-decrement if the environment variable is not set.
  ///
  /// Returns the initialized auto-decrement flag.
  static bool initializeAutoDecrement(bool? autoDecrement) {
    bool decrement = bool.fromEnvironment(
      'BACKDOOR_AUTO_DECREMENT',
      defaultValue: autoDecrement ?? true,
    );

    return decrement;
  }
}
