/// Enum representing different reasons for unhandled scenarios.
///
/// This enum is used to categorize various reasons why an unhandled situation might occur.
///
/// Each value corresponds to a specific reason that can be used in callback functions or error handling logic.
enum OnUnhandledReasonEnum {
  /// Indicates that a payment has been completed successfully.
  PAID,

  /// Indicates that a payment has not been completed.
  UNPAID,

  /// Indicates that the app was not found in the provided JSON data.
  APP_NOT_FOUND_IN_JSON,

  /// Indicates that the app has a launch limit, and the current launch is within the allowed limit.
  LIMITED_LAUNCH,

  /// Indicates that the launch limit for the app has been exceeded.
  LIMITED_LAUNCH_EXCEEDED,

  /// Indicates that a trial warning has been triggered, likely due to an approaching trial end.
  TRAIL_WARNING,

  /// Indicates that the trial period has ended.
  TRIAL_ENDED,

  /// Indicates that the app is currently in a trial period.
  TRIAL,

  /// Indicates that an exception has occurred.
  EXCEPTION,

  /// Indicates a mismatch between the target version and the configured version of the app.
  TARGET_VERSION_MISMATCH,
}
