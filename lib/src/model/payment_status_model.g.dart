// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_status_model.dart';

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
      status: $enumDecodeNullable(_$PaymentStatusEnumMap, json['status']),
      targetVersion: (json['target_version'] as num?)?.toDouble(),
      shouldCheckAfterPaid: json['should_check_after_paid'] as bool? ?? false,
      expireDateTime: json['expire_date'] == null
          ? null
          : DateTime.parse(json['expire_date'] as String),
      warningDate: json['warning_date'] == null
          ? null
          : DateTime.parse(json['warning_date'] as String),
      strictMaxLaunch: json['strict_max_launch'] as bool? ?? false,
      maxLaunch: (json['max_launch'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$AppPaymentModelImplToJson(
        _$AppPaymentModelImpl instance) =>
    <String, dynamic>{
      'status': _$PaymentStatusEnumMap[instance.status],
      'target_version': instance.targetVersion,
      'should_check_after_paid': instance.shouldCheckAfterPaid,
      'expire_date': instance.expireDateTime?.toIso8601String(),
      'warning_date': instance.warningDate?.toIso8601String(),
      'strict_max_launch': instance.strictMaxLaunch,
      'max_launch': instance.maxLaunch,
    };

const _$PaymentStatusEnumMap = {
  PaymentStatus.PAID: 'PAID',
  PaymentStatus.UNPAID: 'UNPAID',
  PaymentStatus.ALLOW_LIMITED_LAUNCHES: 'ALLOW_LIMITED_LAUNCHES',
  PaymentStatus.ON_TRIAL: 'ON_TRIAL',
};
