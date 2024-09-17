import '../exception/backdoor_flutter_exception.dart';
import '../model/payment_status_model.dart';
import 'on_unhandled_reason_enum.dart';

/// A callback function type that handles unhandled reasons.
///
/// [reason] provides the specific reason why the callback is invoked.
/// [backdoorPaymentModel] may contain information about the payment status,
/// or be null if not applicable.
typedef OnUnhandled = Function(OnUnhandledReasonEnum reason, BackdoorPaymentModel? backdoorPaymentModel);

/// A callback function type for handling exceptions.
///
/// [exception] represents the exception that occurred.
typedef OnException = Function(BackdoorFlutterException exception);

/// A callback function type for handling cases where the app is not found.
typedef OnAppNotFound = Function();

/// A callback function type for handling successful payment.
///
/// [backdoorPaymentModel] contains information about the payment status.
typedef OnPaid = Function(BackdoorPaymentModel backdoorPaymentModel);

/// A callback function type for handling failed payment.
///
/// [backdoorPaymentModel] contains information about the payment status.
typedef OnUnPaid = Function(BackdoorPaymentModel backdoorPaymentModel);

/// A callback function type for handling cases where the app launch is limited.
///
/// [backdoorPaymentModel] contains information about the payment status.
/// [currentCount] is the current count of launches.
typedef OnLimitedLaunch = Function(BackdoorPaymentModel backdoorPaymentModel, int currentCount);

/// A callback function type for handling cases where the launch limit is exceeded.
///
/// [backdoorPaymentModel] contains information about the payment status.
typedef OnLimitedLaunchExceeded = Function(BackdoorPaymentModel backdoorPaymentModel);

/// A callback function type for handling trial periods.
///
/// [backdoorPaymentModel] contains information about the payment status.
/// [expiryDate] is the date when the trial expires.
/// [warningDate] is an optional date when a warning is given before the trial ends.
typedef OnTrial = Function(BackdoorPaymentModel backdoorPaymentModel, DateTime expiryDate, DateTime? warningDate);

/// A callback function type for handling trial warnings.
///
/// [backdoorPaymentModel] contains information about the payment status.
/// [expiryDate] is the date when the trial expires.
/// [warningDate] is the date when the warning is issued.
typedef OnTrialWarning = Function(BackdoorPaymentModel backdoorPaymentModel, DateTime expiryDate, DateTime warningDate);

/// A callback function type for handling the end of a trial period.
///
/// [backdoorPaymentModel] contains information about the payment status.
/// [expiryDate] is the date when the trial expired.
typedef OnTrialEnded = Function(BackdoorPaymentModel backdoorPaymentModel, DateTime expiryDate);

/// A callback function type for handling target version mismatches.
///
/// [backdoorPaymentModel] contains information about the payment status.
/// [targetVersion] is the version that the app is targeting.
/// [configuredVersion] is the version that is configured in the app.
typedef OnTargetVersionMisMatch = Function(BackdoorPaymentModel backdoorPaymentModel, double targetVersion, double configuredVersion);
