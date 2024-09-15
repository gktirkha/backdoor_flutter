// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backdoor_payment_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentStatusModelImpl _$$PaymentStatusModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PaymentStatusModelImpl(
      apps: (json['apps'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            k, BackdoorPaymentModel.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$$PaymentStatusModelImplToJson(
        _$PaymentStatusModelImpl instance) =>
    <String, dynamic>{
      'apps': instance.apps,
    };

_$AppPaymentModelImpl _$$AppPaymentModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AppPaymentModelImpl(
      expiryDate: json['expiry_date'] == null
          ? null
          : DateTime.parse(json['expiry_date'] as String),
      status: $enumDecodeNullable(_$PaymentStatusEnumEnumMap, json['status']) ??
          PaymentStatusEnum.UNPAID,
      message: json['message'] as String?,
      maxLaunch: (json['max_launch'] as num?)?.toInt(),
      developerDetails: json['developer_details'] as Map<String, dynamic>?,
      shouldCheckAfterPaid: json['should_check_after_paid'] as bool? ?? false,
      strictMaxLaunch: json['strict_max_launch'] as bool? ?? true,
      minTargetBuildNumber: json['min_target_build_number'] ?? '0',
    );

Map<String, dynamic> _$$AppPaymentModelImplToJson(
        _$AppPaymentModelImpl instance) =>
    <String, dynamic>{
      'expiry_date': instance.expiryDate?.toIso8601String(),
      'status': _$PaymentStatusEnumEnumMap[instance.status]!,
      'message': instance.message,
      'max_launch': instance.maxLaunch,
      'developer_details': instance.developerDetails,
      'should_check_after_paid': instance.shouldCheckAfterPaid,
      'strict_max_launch': instance.strictMaxLaunch,
      'min_target_build_number': instance.minTargetBuildNumber,
    };

const _$PaymentStatusEnumEnumMap = {
  PaymentStatusEnum.PAID: 'PAID',
  PaymentStatusEnum.UNPAID: 'UNPAID',
  PaymentStatusEnum.ALLOW_LIMITED_LAUNCHES: 'ALLOW_LIMITED_LAUNCHES',
  PaymentStatusEnum.ON_TRIAL: 'ON_TRIAL',
};
