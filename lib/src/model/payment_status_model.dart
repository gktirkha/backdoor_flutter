import 'package:freezed_annotation/freezed_annotation.dart';

import '../constants/payment_status_enum.dart';

part 'payment_status_model.freezed.dart';
part 'payment_status_model.g.dart';

/// A model representing the API response for payment status.
///
/// This class is used to deserialize the response from an API that provides payment status information
/// for various applications.
@freezed
class BackdoorPaymentApiResponseModel with _$BackdoorPaymentApiResponseModel {
  /// Creates an instance of [BackdoorPaymentApiResponseModel].
  ///
  /// [apps] is an optional map where the key is a string representing the app identifier,
  /// and the value is a [BackdoorPaymentModel] instance containing payment details for the app.
  const factory BackdoorPaymentApiResponseModel({
    @JsonKey(name: 'apps') Map<String, BackdoorPaymentModel>? apps,
  }) = _PaymentStatusModel;

  /// Creates an instance of [BackdoorPaymentApiResponseModel] from a JSON map.
  ///
  /// [json] is a map representing the JSON response from the API.
  factory BackdoorPaymentApiResponseModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$BackdoorPaymentApiResponseModelFromJson(json);
}

/// A model representing payment details for an application.
///
/// This class contains information about the payment status, versioning, and launch constraints for an app.
@freezed
class BackdoorPaymentModel with _$BackdoorPaymentModel {
  /// Creates an instance of [BackdoorPaymentModel].
  ///
  /// [status] indicates the payment status of the app, defaulting to [PaymentStatusEnum.UNPAID].
  /// [targetVersion] is an optional version number that the app is targeting.
  /// [shouldCheckAfterPaid] determines if the app should be checked after payment, defaulting to false.
  /// [expireDateTime] is an optional date and time when the app's access expires.
  /// [warningDate] is an optional date and time when a warning should be issued before the access expires.
  /// [strictMaxLaunch] determines if there is a strict limit on the number of launches, defaulting to false.
  /// [maxLaunch] is an optional integer specifying the maximum number of launches allowed.
  const factory BackdoorPaymentModel({
    @Default(PaymentStatusEnum.UNPAID) @JsonKey(name: 'status') PaymentStatusEnum status,
    @JsonKey(name: 'target_version') double? targetVersion,
    @Default(false) @JsonKey(name: 'should_check_after_paid') bool shouldCheckAfterPaid,
    @JsonKey(name: 'expire_date') DateTime? expireDateTime,
    @JsonKey(name: 'warning_date') DateTime? warningDate,
    @Default(false) @JsonKey(name: 'strict_max_launch') bool strictMaxLaunch,
    @JsonKey(name: 'max_launch') int? maxLaunch,
  }) = _AppPaymentModel;

  /// Creates an instance of [BackdoorPaymentModel] from a JSON map.
  ///
  /// [json] is a map representing the JSON data for the app's payment details.
  factory BackdoorPaymentModel.fromJson(Map<String, dynamic> json) => _$BackdoorPaymentModelFromJson(json);
}
