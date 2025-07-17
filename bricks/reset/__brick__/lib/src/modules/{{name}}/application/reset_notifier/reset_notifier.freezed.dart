// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reset_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ResetStatus {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ResetStatus);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ResetStatus()';
  }
}

/// @nodoc
class $ResetStatusCopyWith<$Res> {
  $ResetStatusCopyWith(ResetStatus _, $Res Function(ResetStatus) __);
}

/// @nodoc

class _InitialStatus implements ResetStatus {
  const _InitialStatus();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _InitialStatus);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ResetStatus.initial()';
  }
}

/// @nodoc

class _LoadingStatus implements ResetStatus {
  const _LoadingStatus();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _LoadingStatus);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ResetStatus.loading()';
  }
}

/// @nodoc

class _ErrorStatus implements ResetStatus {
  const _ErrorStatus(this.err);

  final ResetError err;

  /// Create a copy of ResetStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ErrorStatusCopyWith<_ErrorStatus> get copyWith =>
      __$ErrorStatusCopyWithImpl<_ErrorStatus>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ErrorStatus &&
            (identical(other.err, err) || other.err == err));
  }

  @override
  int get hashCode => Object.hash(runtimeType, err);

  @override
  String toString() {
    return 'ResetStatus.error(err: $err)';
  }
}

/// @nodoc
abstract mixin class _$ErrorStatusCopyWith<$Res>
    implements $ResetStatusCopyWith<$Res> {
  factory _$ErrorStatusCopyWith(
          _ErrorStatus value, $Res Function(_ErrorStatus) _then) =
      __$ErrorStatusCopyWithImpl;
  @useResult
  $Res call({ResetError err});

  $ResetErrorCopyWith<$Res> get err;
}

/// @nodoc
class __$ErrorStatusCopyWithImpl<$Res> implements _$ErrorStatusCopyWith<$Res> {
  __$ErrorStatusCopyWithImpl(this._self, this._then);

  final _ErrorStatus _self;
  final $Res Function(_ErrorStatus) _then;

  /// Create a copy of ResetStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? err = null,
  }) {
    return _then(_ErrorStatus(
      null == err
          ? _self.err
          : err // ignore: cast_nullable_to_non_nullable
              as ResetError,
    ));
  }

  /// Create a copy of ResetStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ResetErrorCopyWith<$Res> get err {
    return $ResetErrorCopyWith<$Res>(_self.err, (value) {
      return _then(_self.copyWith(err: value));
    });
  }
}

/// @nodoc

class _SuccessStatus implements ResetStatus {
  const _SuccessStatus();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _SuccessStatus);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ResetStatus.success()';
  }
}

/// @nodoc
mixin _$ResetInput {
  String get phone;
  String get password;
  String get confirmPassword;
  String get verificationCode;

  /// Create a copy of ResetInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ResetInputCopyWith<ResetInput> get copyWith =>
      _$ResetInputCopyWithImpl<ResetInput>(this as ResetInput, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ResetInput &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.confirmPassword, confirmPassword) ||
                other.confirmPassword == confirmPassword) &&
            (identical(other.verificationCode, verificationCode) ||
                other.verificationCode == verificationCode));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, phone, password, confirmPassword, verificationCode);

  @override
  String toString() {
    return 'ResetInput(phone: $phone, password: $password, confirmPassword: $confirmPassword, verificationCode: $verificationCode)';
  }
}

/// @nodoc
abstract mixin class $ResetInputCopyWith<$Res> {
  factory $ResetInputCopyWith(
          ResetInput value, $Res Function(ResetInput) _then) =
      _$ResetInputCopyWithImpl;
  @useResult
  $Res call(
      {String phone,
      String password,
      String confirmPassword,
      String verificationCode});
}

/// @nodoc
class _$ResetInputCopyWithImpl<$Res> implements $ResetInputCopyWith<$Res> {
  _$ResetInputCopyWithImpl(this._self, this._then);

  final ResetInput _self;
  final $Res Function(ResetInput) _then;

  /// Create a copy of ResetInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
    Object? password = null,
    Object? confirmPassword = null,
    Object? verificationCode = null,
  }) {
    return _then(_self.copyWith(
      phone: null == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      confirmPassword: null == confirmPassword
          ? _self.confirmPassword
          : confirmPassword // ignore: cast_nullable_to_non_nullable
              as String,
      verificationCode: null == verificationCode
          ? _self.verificationCode
          : verificationCode // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _ResetInput extends ResetInput {
  const _ResetInput(
      {this.phone = '',
      this.password = '',
      this.confirmPassword = '',
      this.verificationCode = ''})
      : super._();

  @override
  @JsonKey()
  final String phone;
  @override
  @JsonKey()
  final String password;
  @override
  @JsonKey()
  final String confirmPassword;
  @override
  @JsonKey()
  final String verificationCode;

  /// Create a copy of ResetInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ResetInputCopyWith<_ResetInput> get copyWith =>
      __$ResetInputCopyWithImpl<_ResetInput>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ResetInput &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.confirmPassword, confirmPassword) ||
                other.confirmPassword == confirmPassword) &&
            (identical(other.verificationCode, verificationCode) ||
                other.verificationCode == verificationCode));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, phone, password, confirmPassword, verificationCode);

  @override
  String toString() {
    return 'ResetInput(phone: $phone, password: $password, confirmPassword: $confirmPassword, verificationCode: $verificationCode)';
  }
}

/// @nodoc
abstract mixin class _$ResetInputCopyWith<$Res>
    implements $ResetInputCopyWith<$Res> {
  factory _$ResetInputCopyWith(
          _ResetInput value, $Res Function(_ResetInput) _then) =
      __$ResetInputCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String phone,
      String password,
      String confirmPassword,
      String verificationCode});
}

/// @nodoc
class __$ResetInputCopyWithImpl<$Res> implements _$ResetInputCopyWith<$Res> {
  __$ResetInputCopyWithImpl(this._self, this._then);

  final _ResetInput _self;
  final $Res Function(_ResetInput) _then;

  /// Create a copy of ResetInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? phone = null,
    Object? password = null,
    Object? confirmPassword = null,
    Object? verificationCode = null,
  }) {
    return _then(_ResetInput(
      phone: null == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      confirmPassword: null == confirmPassword
          ? _self.confirmPassword
          : confirmPassword // ignore: cast_nullable_to_non_nullable
              as String,
      verificationCode: null == verificationCode
          ? _self.verificationCode
          : verificationCode // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$ResetState {
  ResetStatus get status;
  ResetInput get input;

  /// Create a copy of ResetState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ResetStateCopyWith<ResetState> get copyWith =>
      _$ResetStateCopyWithImpl<ResetState>(this as ResetState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ResetState &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.input, input) || other.input == input));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, input);

  @override
  String toString() {
    return 'ResetState(status: $status, input: $input)';
  }
}

/// @nodoc
abstract mixin class $ResetStateCopyWith<$Res> {
  factory $ResetStateCopyWith(
          ResetState value, $Res Function(ResetState) _then) =
      _$ResetStateCopyWithImpl;
  @useResult
  $Res call({ResetStatus status, ResetInput input});

  $ResetStatusCopyWith<$Res> get status;
  $ResetInputCopyWith<$Res> get input;
}

/// @nodoc
class _$ResetStateCopyWithImpl<$Res> implements $ResetStateCopyWith<$Res> {
  _$ResetStateCopyWithImpl(this._self, this._then);

  final ResetState _self;
  final $Res Function(ResetState) _then;

  /// Create a copy of ResetState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? input = null,
  }) {
    return _then(_self.copyWith(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as ResetStatus,
      input: null == input
          ? _self.input
          : input // ignore: cast_nullable_to_non_nullable
              as ResetInput,
    ));
  }

  /// Create a copy of ResetState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ResetStatusCopyWith<$Res> get status {
    return $ResetStatusCopyWith<$Res>(_self.status, (value) {
      return _then(_self.copyWith(status: value));
    });
  }

  /// Create a copy of ResetState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ResetInputCopyWith<$Res> get input {
    return $ResetInputCopyWith<$Res>(_self.input, (value) {
      return _then(_self.copyWith(input: value));
    });
  }
}

/// @nodoc

class _ResetState extends ResetState {
  const _ResetState(
      {this.status = const ResetStatus.initial(),
      this.input = const ResetInput()})
      : super._();

  @override
  @JsonKey()
  final ResetStatus status;
  @override
  @JsonKey()
  final ResetInput input;

  /// Create a copy of ResetState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ResetStateCopyWith<_ResetState> get copyWith =>
      __$ResetStateCopyWithImpl<_ResetState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ResetState &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.input, input) || other.input == input));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, input);

  @override
  String toString() {
    return 'ResetState(status: $status, input: $input)';
  }
}

/// @nodoc
abstract mixin class _$ResetStateCopyWith<$Res>
    implements $ResetStateCopyWith<$Res> {
  factory _$ResetStateCopyWith(
          _ResetState value, $Res Function(_ResetState) _then) =
      __$ResetStateCopyWithImpl;
  @override
  @useResult
  $Res call({ResetStatus status, ResetInput input});

  @override
  $ResetStatusCopyWith<$Res> get status;
  @override
  $ResetInputCopyWith<$Res> get input;
}

/// @nodoc
class __$ResetStateCopyWithImpl<$Res> implements _$ResetStateCopyWith<$Res> {
  __$ResetStateCopyWithImpl(this._self, this._then);

  final _ResetState _self;
  final $Res Function(_ResetState) _then;

  /// Create a copy of ResetState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? input = null,
  }) {
    return _then(_ResetState(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as ResetStatus,
      input: null == input
          ? _self.input
          : input // ignore: cast_nullable_to_non_nullable
              as ResetInput,
    ));
  }

  /// Create a copy of ResetState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ResetStatusCopyWith<$Res> get status {
    return $ResetStatusCopyWith<$Res>(_self.status, (value) {
      return _then(_self.copyWith(status: value));
    });
  }

  /// Create a copy of ResetState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ResetInputCopyWith<$Res> get input {
    return $ResetInputCopyWith<$Res>(_self.input, (value) {
      return _then(_self.copyWith(input: value));
    });
  }
}

// dart format on
