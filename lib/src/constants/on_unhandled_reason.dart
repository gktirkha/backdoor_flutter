// ignore_for_file: constant_identifier_names
library backdoor_flutter;

/// Enumeration representing various reasons for unhandled cases. when OnUnhandled is invoked

enum OnUnhandledReason {
  /// Indicates that the application is in a paid state.
  PAID,

  /// Indicates that the application is in an unpaid state.
  UNPAID,

  /// Indicates that the application was not found in the JSON configuration.
  APP_NOT_FOUND_IN_JSON,

  /// Indicates that the application is in a limited launch state.
  LIMITED_LAUNCH,

  /// Indicates that the application has exceeded its allowed launch count.
  LIMITED_LAUNCH_EXCEEDED,

  /// Indicates a warning for the impending end of a trial period.
  TRIAL_WARNING,

  /// Indicates that the trial period has ended.
  TRIAL_ENDED,

  /// Indicates that the application is currently in a trial state.
  TRIAL,

  /// Indicates that an exception occurred during operation.
  EXCEPTION,

  /// Indicates a mismatch between the target version and the configured version.
  TARGET_VERSION_MISMATCH,
}
