/// Enum representing the various payment statuses for an app.
enum PaymentStatusEnum {
  /// The app has been paid for.
  PAID,

  /// The app has not been paid for.
  UNPAID,

  /// The app allows limited launches before requiring further action.
  ALLOW_LIMITED_LAUNCHES,

  /// The app is currently in a trial period.
  ON_TRIAL,
}
