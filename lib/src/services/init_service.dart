import '../exception/backdoor_flutter_exception.dart';

abstract class InitService {
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
