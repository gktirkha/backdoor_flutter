// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_status_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BackdoorPaymentApiResponseModel _$BackdoorPaymentApiResponseModelFromJson(
    Map<String, dynamic> json) {
  return _PaymentStatusModel.fromJson(json);
}

/// @nodoc
mixin _$BackdoorPaymentApiResponseModel {
  @JsonKey(name: 'apps')
  Map<String, BackdoorPaymentModel>? get apps =>
      throw _privateConstructorUsedError;

  /// Serializes this BackdoorPaymentApiResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BackdoorPaymentApiResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BackdoorPaymentApiResponseModelCopyWith<BackdoorPaymentApiResponseModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BackdoorPaymentApiResponseModelCopyWith<$Res> {
  factory $BackdoorPaymentApiResponseModelCopyWith(
          BackdoorPaymentApiResponseModel value,
          $Res Function(BackdoorPaymentApiResponseModel) then) =
      _$BackdoorPaymentApiResponseModelCopyWithImpl<$Res,
          BackdoorPaymentApiResponseModel>;
  @useResult
  $Res call({@JsonKey(name: 'apps') Map<String, BackdoorPaymentModel>? apps});
}

/// @nodoc
class _$BackdoorPaymentApiResponseModelCopyWithImpl<$Res,
        $Val extends BackdoorPaymentApiResponseModel>
    implements $BackdoorPaymentApiResponseModelCopyWith<$Res> {
  _$BackdoorPaymentApiResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BackdoorPaymentApiResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? apps = freezed,
  }) {
    return _then(_value.copyWith(
      apps: freezed == apps
          ? _value.apps
          : apps // ignore: cast_nullable_to_non_nullable
              as Map<String, BackdoorPaymentModel>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentStatusModelImplCopyWith<$Res>
    implements $BackdoorPaymentApiResponseModelCopyWith<$Res> {
  factory _$$PaymentStatusModelImplCopyWith(_$PaymentStatusModelImpl value,
          $Res Function(_$PaymentStatusModelImpl) then) =
      __$$PaymentStatusModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'apps') Map<String, BackdoorPaymentModel>? apps});
}

/// @nodoc
class __$$PaymentStatusModelImplCopyWithImpl<$Res>
    extends _$BackdoorPaymentApiResponseModelCopyWithImpl<$Res,
        _$PaymentStatusModelImpl>
    implements _$$PaymentStatusModelImplCopyWith<$Res> {
  __$$PaymentStatusModelImplCopyWithImpl(_$PaymentStatusModelImpl _value,
      $Res Function(_$PaymentStatusModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of BackdoorPaymentApiResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? apps = freezed,
  }) {
    return _then(_$PaymentStatusModelImpl(
      apps: freezed == apps
          ? _value._apps
          : apps // ignore: cast_nullable_to_non_nullable
              as Map<String, BackdoorPaymentModel>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentStatusModelImpl implements _PaymentStatusModel {
  const _$PaymentStatusModelImpl(
      {@JsonKey(name: 'apps') final Map<String, BackdoorPaymentModel>? apps})
      : _apps = apps;

  factory _$PaymentStatusModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentStatusModelImplFromJson(json);

  final Map<String, BackdoorPaymentModel>? _apps;
  @override
  @JsonKey(name: 'apps')
  Map<String, BackdoorPaymentModel>? get apps {
    final value = _apps;
    if (value == null) return null;
    if (_apps is EqualUnmodifiableMapView) return _apps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'BackdoorPaymentApiResponseModel(apps: $apps)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentStatusModelImpl &&
            const DeepCollectionEquality().equals(other._apps, _apps));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_apps));

  /// Create a copy of BackdoorPaymentApiResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentStatusModelImplCopyWith<_$PaymentStatusModelImpl> get copyWith =>
      __$$PaymentStatusModelImplCopyWithImpl<_$PaymentStatusModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentStatusModelImplToJson(
      this,
    );
  }
}

abstract class _PaymentStatusModel implements BackdoorPaymentApiResponseModel {
  const factory _PaymentStatusModel(
          {@JsonKey(name: 'apps')
          final Map<String, BackdoorPaymentModel>? apps}) =
      _$PaymentStatusModelImpl;

  factory _PaymentStatusModel.fromJson(Map<String, dynamic> json) =
      _$PaymentStatusModelImpl.fromJson;

  @override
  @JsonKey(name: 'apps')
  Map<String, BackdoorPaymentModel>? get apps;

  /// Create a copy of BackdoorPaymentApiResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentStatusModelImplCopyWith<_$PaymentStatusModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BackdoorPaymentModel _$BackdoorPaymentModelFromJson(Map<String, dynamic> json) {
  return _AppPaymentModel.fromJson(json);
}

/// @nodoc
mixin _$BackdoorPaymentModel {
  @JsonKey(name: 'status')
  PaymentStatus? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'target_version')
  double? get targetVersion => throw _privateConstructorUsedError;
  @JsonKey(name: 'should_check_after_paid')
  bool get shouldCheckAfterPaid => throw _privateConstructorUsedError;
  @JsonKey(name: 'expire_date')
  DateTime? get expireDateTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'warning_date')
  DateTime? get warningDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'strict_max_launch')
  bool get strictMaxLaunch => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_launch')
  int? get maxLaunch => throw _privateConstructorUsedError;

  /// Serializes this BackdoorPaymentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BackdoorPaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BackdoorPaymentModelCopyWith<BackdoorPaymentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BackdoorPaymentModelCopyWith<$Res> {
  factory $BackdoorPaymentModelCopyWith(BackdoorPaymentModel value,
          $Res Function(BackdoorPaymentModel) then) =
      _$BackdoorPaymentModelCopyWithImpl<$Res, BackdoorPaymentModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'status') PaymentStatus? status,
      @JsonKey(name: 'target_version') double? targetVersion,
      @JsonKey(name: 'should_check_after_paid') bool shouldCheckAfterPaid,
      @JsonKey(name: 'expire_date') DateTime? expireDateTime,
      @JsonKey(name: 'warning_date') DateTime? warningDate,
      @JsonKey(name: 'strict_max_launch') bool strictMaxLaunch,
      @JsonKey(name: 'max_launch') int? maxLaunch});
}

/// @nodoc
class _$BackdoorPaymentModelCopyWithImpl<$Res,
        $Val extends BackdoorPaymentModel>
    implements $BackdoorPaymentModelCopyWith<$Res> {
  _$BackdoorPaymentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BackdoorPaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? targetVersion = freezed,
    Object? shouldCheckAfterPaid = null,
    Object? expireDateTime = freezed,
    Object? warningDate = freezed,
    Object? strictMaxLaunch = null,
    Object? maxLaunch = freezed,
  }) {
    return _then(_value.copyWith(
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PaymentStatus?,
      targetVersion: freezed == targetVersion
          ? _value.targetVersion
          : targetVersion // ignore: cast_nullable_to_non_nullable
              as double?,
      shouldCheckAfterPaid: null == shouldCheckAfterPaid
          ? _value.shouldCheckAfterPaid
          : shouldCheckAfterPaid // ignore: cast_nullable_to_non_nullable
              as bool,
      expireDateTime: freezed == expireDateTime
          ? _value.expireDateTime
          : expireDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      warningDate: freezed == warningDate
          ? _value.warningDate
          : warningDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      strictMaxLaunch: null == strictMaxLaunch
          ? _value.strictMaxLaunch
          : strictMaxLaunch // ignore: cast_nullable_to_non_nullable
              as bool,
      maxLaunch: freezed == maxLaunch
          ? _value.maxLaunch
          : maxLaunch // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppPaymentModelImplCopyWith<$Res>
    implements $BackdoorPaymentModelCopyWith<$Res> {
  factory _$$AppPaymentModelImplCopyWith(_$AppPaymentModelImpl value,
          $Res Function(_$AppPaymentModelImpl) then) =
      __$$AppPaymentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'status') PaymentStatus? status,
      @JsonKey(name: 'target_version') double? targetVersion,
      @JsonKey(name: 'should_check_after_paid') bool shouldCheckAfterPaid,
      @JsonKey(name: 'expire_date') DateTime? expireDateTime,
      @JsonKey(name: 'warning_date') DateTime? warningDate,
      @JsonKey(name: 'strict_max_launch') bool strictMaxLaunch,
      @JsonKey(name: 'max_launch') int? maxLaunch});
}

/// @nodoc
class __$$AppPaymentModelImplCopyWithImpl<$Res>
    extends _$BackdoorPaymentModelCopyWithImpl<$Res, _$AppPaymentModelImpl>
    implements _$$AppPaymentModelImplCopyWith<$Res> {
  __$$AppPaymentModelImplCopyWithImpl(
      _$AppPaymentModelImpl _value, $Res Function(_$AppPaymentModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of BackdoorPaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? targetVersion = freezed,
    Object? shouldCheckAfterPaid = null,
    Object? expireDateTime = freezed,
    Object? warningDate = freezed,
    Object? strictMaxLaunch = null,
    Object? maxLaunch = freezed,
  }) {
    return _then(_$AppPaymentModelImpl(
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PaymentStatus?,
      targetVersion: freezed == targetVersion
          ? _value.targetVersion
          : targetVersion // ignore: cast_nullable_to_non_nullable
              as double?,
      shouldCheckAfterPaid: null == shouldCheckAfterPaid
          ? _value.shouldCheckAfterPaid
          : shouldCheckAfterPaid // ignore: cast_nullable_to_non_nullable
              as bool,
      expireDateTime: freezed == expireDateTime
          ? _value.expireDateTime
          : expireDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      warningDate: freezed == warningDate
          ? _value.warningDate
          : warningDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      strictMaxLaunch: null == strictMaxLaunch
          ? _value.strictMaxLaunch
          : strictMaxLaunch // ignore: cast_nullable_to_non_nullable
              as bool,
      maxLaunch: freezed == maxLaunch
          ? _value.maxLaunch
          : maxLaunch // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppPaymentModelImpl implements _AppPaymentModel {
  const _$AppPaymentModelImpl(
      {@JsonKey(name: 'status') this.status,
      @JsonKey(name: 'target_version') this.targetVersion,
      @JsonKey(name: 'should_check_after_paid')
      this.shouldCheckAfterPaid = false,
      @JsonKey(name: 'expire_date') this.expireDateTime,
      @JsonKey(name: 'warning_date') this.warningDate,
      @JsonKey(name: 'strict_max_launch') this.strictMaxLaunch = false,
      @JsonKey(name: 'max_launch') this.maxLaunch});

  factory _$AppPaymentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppPaymentModelImplFromJson(json);

  @override
  @JsonKey(name: 'status')
  final PaymentStatus? status;
  @override
  @JsonKey(name: 'target_version')
  final double? targetVersion;
  @override
  @JsonKey(name: 'should_check_after_paid')
  final bool shouldCheckAfterPaid;
  @override
  @JsonKey(name: 'expire_date')
  final DateTime? expireDateTime;
  @override
  @JsonKey(name: 'warning_date')
  final DateTime? warningDate;
  @override
  @JsonKey(name: 'strict_max_launch')
  final bool strictMaxLaunch;
  @override
  @JsonKey(name: 'max_launch')
  final int? maxLaunch;

  @override
  String toString() {
    return 'BackdoorPaymentModel(status: $status, targetVersion: $targetVersion, shouldCheckAfterPaid: $shouldCheckAfterPaid, expireDateTime: $expireDateTime, warningDate: $warningDate, strictMaxLaunch: $strictMaxLaunch, maxLaunch: $maxLaunch)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppPaymentModelImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.targetVersion, targetVersion) ||
                other.targetVersion == targetVersion) &&
            (identical(other.shouldCheckAfterPaid, shouldCheckAfterPaid) ||
                other.shouldCheckAfterPaid == shouldCheckAfterPaid) &&
            (identical(other.expireDateTime, expireDateTime) ||
                other.expireDateTime == expireDateTime) &&
            (identical(other.warningDate, warningDate) ||
                other.warningDate == warningDate) &&
            (identical(other.strictMaxLaunch, strictMaxLaunch) ||
                other.strictMaxLaunch == strictMaxLaunch) &&
            (identical(other.maxLaunch, maxLaunch) ||
                other.maxLaunch == maxLaunch));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      targetVersion,
      shouldCheckAfterPaid,
      expireDateTime,
      warningDate,
      strictMaxLaunch,
      maxLaunch);

  /// Create a copy of BackdoorPaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppPaymentModelImplCopyWith<_$AppPaymentModelImpl> get copyWith =>
      __$$AppPaymentModelImplCopyWithImpl<_$AppPaymentModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppPaymentModelImplToJson(
      this,
    );
  }
}

abstract class _AppPaymentModel implements BackdoorPaymentModel {
  const factory _AppPaymentModel(
      {@JsonKey(name: 'status') final PaymentStatus? status,
      @JsonKey(name: 'target_version') final double? targetVersion,
      @JsonKey(name: 'should_check_after_paid') final bool shouldCheckAfterPaid,
      @JsonKey(name: 'expire_date') final DateTime? expireDateTime,
      @JsonKey(name: 'warning_date') final DateTime? warningDate,
      @JsonKey(name: 'strict_max_launch') final bool strictMaxLaunch,
      @JsonKey(name: 'max_launch')
      final int? maxLaunch}) = _$AppPaymentModelImpl;

  factory _AppPaymentModel.fromJson(Map<String, dynamic> json) =
      _$AppPaymentModelImpl.fromJson;

  @override
  @JsonKey(name: 'status')
  PaymentStatus? get status;
  @override
  @JsonKey(name: 'target_version')
  double? get targetVersion;
  @override
  @JsonKey(name: 'should_check_after_paid')
  bool get shouldCheckAfterPaid;
  @override
  @JsonKey(name: 'expire_date')
  DateTime? get expireDateTime;
  @override
  @JsonKey(name: 'warning_date')
  DateTime? get warningDate;
  @override
  @JsonKey(name: 'strict_max_launch')
  bool get strictMaxLaunch;
  @override
  @JsonKey(name: 'max_launch')
  int? get maxLaunch;

  /// Create a copy of BackdoorPaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppPaymentModelImplCopyWith<_$AppPaymentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
