/// Enum representing the different payment statuses.
///
/// Each value in this enum represents a specific payment status or condition
/// related to application usage.
enum PaymentStatusEnum {
  /// Indicates that the payment has been completed.
  PAID,

  /// Indicates that the payment has not been completed.
  UNPAID,

  /// Indicates that limited launches of the application are allowed.
  ALLOW_LIMITED_LAUNCHES,

  /// Indicates that the application is currently on a trial period.
  ON_TRIAL,
}
