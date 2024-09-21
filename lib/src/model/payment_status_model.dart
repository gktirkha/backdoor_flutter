import 'package:freezed_annotation/freezed_annotation.dart';

import '../constants/payment_status.dart';

part 'payment_status_model.freezed.dart';
part 'payment_status_model.g.dart';

@freezed
class BackdoorPaymentApiResponseModel with _$BackdoorPaymentApiResponseModel {
  const factory BackdoorPaymentApiResponseModel({
    @JsonKey(name: 'apps') Map<String, BackdoorPaymentModel>? apps,
  }) = _PaymentStatusModel;

  factory BackdoorPaymentApiResponseModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$BackdoorPaymentApiResponseModelFromJson(json);
}

@freezed
class BackdoorPaymentModel with _$BackdoorPaymentModel {
  const factory BackdoorPaymentModel({
    @JsonKey(name: 'status') PaymentStatus? status,
    @JsonKey(name: 'target_version') double? targetVersion,
    @Default(false) @JsonKey(name: 'should_check_after_paid') bool shouldCheckAfterPaid,
    @Default(false) @JsonKey(name: 'check_during_trial') bool checkDuringTrial,
    @JsonKey(name: 'expire_date') DateTime? expireDateTime,
    @JsonKey(name: 'warning_date') DateTime? warningDate,
    @Default(true) @JsonKey(name: 'strict_max_launch') bool strictMaxLaunch,
    @JsonKey(name: 'max_launch') int? maxLaunch,
  }) = _AppPaymentModel;

  factory BackdoorPaymentModel.fromJson(Map<String, dynamic> json) => _$BackdoorPaymentModelFromJson(json);
}
