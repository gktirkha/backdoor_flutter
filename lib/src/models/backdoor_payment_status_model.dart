import 'package:freezed_annotation/freezed_annotation.dart';

import '../payment_status_enum.dart';

part 'backdoor_payment_status_model.freezed.dart';
part 'backdoor_payment_status_model.g.dart';

/// A model representing the API response containing payment status information for various apps.
///
/// This class is used to deserialize the JSON response from the backend, which includes
/// a mapping of app names to their respective [BackdoorPaymentModel] objects.
@freezed
class BackdoorPaymentApiResponseModel with _$BackdoorPaymentApiResponseModel {
  /// Creates a new instance of [BackdoorPaymentApiResponseModel].
  ///
  /// [apps] - A map of app names to their respective [BackdoorPaymentModel] objects.
  const factory BackdoorPaymentApiResponseModel({
    @JsonKey(name: 'apps') Map<String, BackdoorPaymentModel>? apps,
  }) = _PaymentStatusModel;

  /// Creates an instance of [BackdoorPaymentApiResponseModel] from JSON.
  ///
  /// [json] - A map of string keys to dynamic values representing the JSON response.
  factory BackdoorPaymentApiResponseModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$BackdoorPaymentApiResponseModelFromJson(json);
}

/// A model representing the payment status and related details for a specific app.
///
/// This class includes information such as the payment status, expiry date, and developer details.
/// It is used for serializing and deserializing the JSON representation of the app's payment status.
@freezed
class BackdoorPaymentModel with _$BackdoorPaymentModel {
  /// Creates a new instance of [BackdoorPaymentModel].
  ///
  /// [expiryDate] - The date when the current trial or subscription expires.
  /// [status] - The payment status of the app, defaulting to [PaymentStatusEnum.UNPAID].
  /// [message] - An optional message related to the payment status.
  /// [maxLaunch] - The maximum number of launches allowed, if applicable.
  /// [developerDetails] - Optional additional details about the developer.
  /// [shouldCheckAfterPaid] - A flag indicating whether further checks should be performed after payment.
  /// [strictMaxLaunch] - A flag indicating whether the maximum launch limit should be strictly enforced.
  const factory BackdoorPaymentModel({
    @JsonKey(name: 'expiry_date') DateTime? expiryDate,
    @Default(PaymentStatusEnum.UNPAID)
    @JsonKey(name: 'status')
    PaymentStatusEnum status,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'max_launch') int? maxLaunch,
    @JsonKey(name: 'developer_details') Map<String, dynamic>? developerDetails,
    @Default(false)
    @JsonKey(name: 'should_check_after_paid')
    bool shouldCheckAfterPaid,
    @Default(true) @JsonKey(name: 'strict_max_launch') bool strictMaxLaunch,
    @Default('0')
    @JsonKey(name: 'min_target_build_number')
    dynamic minTargetBuildNumber,
  }) = _AppPaymentModel;

  /// Creates an instance of [BackdoorPaymentModel] from JSON.
  ///
  /// [json] - A map of string keys to dynamic values representing the JSON data.
  factory BackdoorPaymentModel.fromJson(Map<String, dynamic> json) =>
      _$BackdoorPaymentModelFromJson(json);
}
