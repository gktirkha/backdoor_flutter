import 'models/backdoor_payment_status_model.dart';

/// A callback function that is triggered when the app's payment status is "PAID".
///
/// [paymentStatusModel] - The [BackdoorPaymentModel] containing details about the payment status.
typedef OnPaid = Function(
  BackdoorPaymentModel paymentStatusModel,
);

/// A callback function that is triggered when the app allows limited launches.
///
/// [paymentStatusModel] - The [BackdoorPaymentModel] containing details about the payment status.
typedef OnLimitedLaunches = Function(
  BackdoorPaymentModel paymentStatusModel,
  int? currentLaunchCount,
);

/// A callback function that is triggered when the limited launches are exceeded.
///
/// [paymentStatusModel] - The [BackdoorPaymentModel] containing details about the payment status.
typedef OnLimitedLaunchesExceeded = Function(
  BackdoorPaymentModel paymentStatusModel,
);

/// A callback function that is triggered when the app's payment status is "UNPAID".
///
/// [paymentStatusModel] - The [BackdoorPaymentModel] containing details about the payment status.
typedef OnUnpaid = Function(
  BackdoorPaymentModel paymentStatusModel,
);

/// A callback function that is triggered when the app is on trial.
///
/// [paymentStatusModel] - The [BackdoorPaymentModel] containing details about the payment status.
typedef OnTrial = Function(
  BackdoorPaymentModel paymentStatusModel,
);

/// A callback function that is triggered when the trial period expires.
///
/// [paymentStatusModel] - The [BackdoorPaymentModel] containing details about the payment status.
typedef OnTrialExpire = Function(
  BackdoorPaymentModel paymentStatusModel,
);

/// A callback function that is triggered when an exception occurs.
///
/// [exception] - The [Exception] that was thrown.
/// [paymentStatusModel] - An optional [BackdoorPaymentModel] containing details about the payment status at the time of the exception.
typedef OnException = Function(
  Exception exception,
  BackdoorPaymentModel? paymentStatusModel,
);

/// A callback function that is triggered when an AppName is not found in json.
///
/// [apiResponse] - An optional [BackdoorPaymentApiResponseModel] containing API Response.
typedef OnAppNotFoundINJson = Function(
  BackdoorPaymentApiResponseModel? apiResponse,
);
