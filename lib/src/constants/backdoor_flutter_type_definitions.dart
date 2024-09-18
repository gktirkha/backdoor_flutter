import '../exception/backdoor_flutter_exception.dart';
import '../model/payment_status_model.dart';
import 'on_unhandled_reason.dart';

typedef OnUnhandled = Function(OnUnhandledReason reason, BackdoorPaymentModel? backdoorPaymentModel);

typedef OnException = Function(BackdoorFlutterException exception);

typedef OnAppNotFound = Function();

typedef OnPaid = Function(BackdoorPaymentModel backdoorPaymentModel);

typedef OnUnPaid = Function(BackdoorPaymentModel backdoorPaymentModel);

typedef OnLimitedLaunch = Function(BackdoorPaymentModel backdoorPaymentModel, int currentCount);

typedef OnLimitedLaunchExceeded = Function(BackdoorPaymentModel backdoorPaymentModel);

typedef OnTrial = Function(BackdoorPaymentModel backdoorPaymentModel, DateTime expiryDate, DateTime? warningDate);

typedef OnTrialWarning = Function(BackdoorPaymentModel backdoorPaymentModel, DateTime expiryDate, DateTime warningDate);

typedef OnTrialEnded = Function(BackdoorPaymentModel backdoorPaymentModel, DateTime expiryDate);

typedef OnTargetVersionMisMatch = Function(BackdoorPaymentModel backdoorPaymentModel, double targetVersion, double configuredVersion);
