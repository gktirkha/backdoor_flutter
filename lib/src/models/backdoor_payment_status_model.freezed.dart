// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backdoor_payment_status_model.dart';

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
  @JsonKey(name: 'expiry_date')
  DateTime? get expiryDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'status')
  PaymentStatusEnum get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'message')
  String? get message => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_launch')
  int? get maxLaunch => throw _privateConstructorUsedError;
  @JsonKey(name: 'developer_details')
  Map<String, dynamic>? get developerDetails =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'should_check_after_paid')
  bool get shouldCheckAfterPaid => throw _privateConstructorUsedError;
  @JsonKey(name: 'strict_max_launch')
  bool get strictMaxLaunch => throw _privateConstructorUsedError;
  @JsonKey(name: 'min_target_build_number')
  dynamic get minTargetBuildNumber => throw _privateConstructorUsedError;

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
      {@JsonKey(name: 'expiry_date') DateTime? expiryDate,
      @JsonKey(name: 'status') PaymentStatusEnum status,
      @JsonKey(name: 'message') String? message,
      @JsonKey(name: 'max_launch') int? maxLaunch,
      @JsonKey(name: 'developer_details')
      Map<String, dynamic>? developerDetails,
      @JsonKey(name: 'should_check_after_paid') bool shouldCheckAfterPaid,
      @JsonKey(name: 'strict_max_launch') bool strictMaxLaunch,
      @JsonKey(name: 'min_target_build_number') dynamic minTargetBuildNumber});
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
    Object? expiryDate = freezed,
    Object? status = null,
    Object? message = freezed,
    Object? maxLaunch = freezed,
    Object? developerDetails = freezed,
    Object? shouldCheckAfterPaid = null,
    Object? strictMaxLaunch = null,
    Object? minTargetBuildNumber = freezed,
  }) {
    return _then(_value.copyWith(
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PaymentStatusEnum,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      maxLaunch: freezed == maxLaunch
          ? _value.maxLaunch
          : maxLaunch // ignore: cast_nullable_to_non_nullable
              as int?,
      developerDetails: freezed == developerDetails
          ? _value.developerDetails
          : developerDetails // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      shouldCheckAfterPaid: null == shouldCheckAfterPaid
          ? _value.shouldCheckAfterPaid
          : shouldCheckAfterPaid // ignore: cast_nullable_to_non_nullable
              as bool,
      strictMaxLaunch: null == strictMaxLaunch
          ? _value.strictMaxLaunch
          : strictMaxLaunch // ignore: cast_nullable_to_non_nullable
              as bool,
      minTargetBuildNumber: freezed == minTargetBuildNumber
          ? _value.minTargetBuildNumber
          : minTargetBuildNumber // ignore: cast_nullable_to_non_nullable
              as dynamic,
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
      {@JsonKey(name: 'expiry_date') DateTime? expiryDate,
      @JsonKey(name: 'status') PaymentStatusEnum status,
      @JsonKey(name: 'message') String? message,
      @JsonKey(name: 'max_launch') int? maxLaunch,
      @JsonKey(name: 'developer_details')
      Map<String, dynamic>? developerDetails,
      @JsonKey(name: 'should_check_after_paid') bool shouldCheckAfterPaid,
      @JsonKey(name: 'strict_max_launch') bool strictMaxLaunch,
      @JsonKey(name: 'min_target_build_number') dynamic minTargetBuildNumber});
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
    Object? expiryDate = freezed,
    Object? status = null,
    Object? message = freezed,
    Object? maxLaunch = freezed,
    Object? developerDetails = freezed,
    Object? shouldCheckAfterPaid = null,
    Object? strictMaxLaunch = null,
    Object? minTargetBuildNumber = freezed,
  }) {
    return _then(_$AppPaymentModelImpl(
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PaymentStatusEnum,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      maxLaunch: freezed == maxLaunch
          ? _value.maxLaunch
          : maxLaunch // ignore: cast_nullable_to_non_nullable
              as int?,
      developerDetails: freezed == developerDetails
          ? _value._developerDetails
          : developerDetails // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      shouldCheckAfterPaid: null == shouldCheckAfterPaid
          ? _value.shouldCheckAfterPaid
          : shouldCheckAfterPaid // ignore: cast_nullable_to_non_nullable
              as bool,
      strictMaxLaunch: null == strictMaxLaunch
          ? _value.strictMaxLaunch
          : strictMaxLaunch // ignore: cast_nullable_to_non_nullable
              as bool,
      minTargetBuildNumber: freezed == minTargetBuildNumber
          ? _value.minTargetBuildNumber
          : minTargetBuildNumber // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppPaymentModelImpl implements _AppPaymentModel {
  const _$AppPaymentModelImpl(
      {@JsonKey(name: 'expiry_date') this.expiryDate,
      @JsonKey(name: 'status') this.status = PaymentStatusEnum.UNPAID,
      @JsonKey(name: 'message') this.message,
      @JsonKey(name: 'max_launch') this.maxLaunch,
      @JsonKey(name: 'developer_details')
      final Map<String, dynamic>? developerDetails,
      @JsonKey(name: 'should_check_after_paid')
      this.shouldCheckAfterPaid = false,
      @JsonKey(name: 'strict_max_launch') this.strictMaxLaunch = true,
      @JsonKey(name: 'min_target_build_number')
      this.minTargetBuildNumber = '0'})
      : _developerDetails = developerDetails;

  factory _$AppPaymentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppPaymentModelImplFromJson(json);

  @override
  @JsonKey(name: 'expiry_date')
  final DateTime? expiryDate;
  @override
  @JsonKey(name: 'status')
  final PaymentStatusEnum status;
  @override
  @JsonKey(name: 'message')
  final String? message;
  @override
  @JsonKey(name: 'max_launch')
  final int? maxLaunch;
  final Map<String, dynamic>? _developerDetails;
  @override
  @JsonKey(name: 'developer_details')
  Map<String, dynamic>? get developerDetails {
    final value = _developerDetails;
    if (value == null) return null;
    if (_developerDetails is EqualUnmodifiableMapView) return _developerDetails;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'should_check_after_paid')
  final bool shouldCheckAfterPaid;
  @override
  @JsonKey(name: 'strict_max_launch')
  final bool strictMaxLaunch;
  @override
  @JsonKey(name: 'min_target_build_number')
  final dynamic minTargetBuildNumber;

  @override
  String toString() {
    return 'BackdoorPaymentModel(expiryDate: $expiryDate, status: $status, message: $message, maxLaunch: $maxLaunch, developerDetails: $developerDetails, shouldCheckAfterPaid: $shouldCheckAfterPaid, strictMaxLaunch: $strictMaxLaunch, minTargetBuildNumber: $minTargetBuildNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppPaymentModelImpl &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.maxLaunch, maxLaunch) ||
                other.maxLaunch == maxLaunch) &&
            const DeepCollectionEquality()
                .equals(other._developerDetails, _developerDetails) &&
            (identical(other.shouldCheckAfterPaid, shouldCheckAfterPaid) ||
                other.shouldCheckAfterPaid == shouldCheckAfterPaid) &&
            (identical(other.strictMaxLaunch, strictMaxLaunch) ||
                other.strictMaxLaunch == strictMaxLaunch) &&
            const DeepCollectionEquality()
                .equals(other.minTargetBuildNumber, minTargetBuildNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      expiryDate,
      status,
      message,
      maxLaunch,
      const DeepCollectionEquality().hash(_developerDetails),
      shouldCheckAfterPaid,
      strictMaxLaunch,
      const DeepCollectionEquality().hash(minTargetBuildNumber));

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
      {@JsonKey(name: 'expiry_date') final DateTime? expiryDate,
      @JsonKey(name: 'status') final PaymentStatusEnum status,
      @JsonKey(name: 'message') final String? message,
      @JsonKey(name: 'max_launch') final int? maxLaunch,
      @JsonKey(name: 'developer_details')
      final Map<String, dynamic>? developerDetails,
      @JsonKey(name: 'should_check_after_paid') final bool shouldCheckAfterPaid,
      @JsonKey(name: 'strict_max_launch') final bool strictMaxLaunch,
      @JsonKey(name: 'min_target_build_number')
      final dynamic minTargetBuildNumber}) = _$AppPaymentModelImpl;

  factory _AppPaymentModel.fromJson(Map<String, dynamic> json) =
      _$AppPaymentModelImpl.fromJson;

  @override
  @JsonKey(name: 'expiry_date')
  DateTime? get expiryDate;
  @override
  @JsonKey(name: 'status')
  PaymentStatusEnum get status;
  @override
  @JsonKey(name: 'message')
  String? get message;
  @override
  @JsonKey(name: 'max_launch')
  int? get maxLaunch;
  @override
  @JsonKey(name: 'developer_details')
  Map<String, dynamic>? get developerDetails;
  @override
  @JsonKey(name: 'should_check_after_paid')
  bool get shouldCheckAfterPaid;
  @override
  @JsonKey(name: 'strict_max_launch')
  bool get strictMaxLaunch;
  @override
  @JsonKey(name: 'min_target_build_number')
  dynamic get minTargetBuildNumber;

  /// Create a copy of BackdoorPaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppPaymentModelImplCopyWith<_$AppPaymentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
