// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reset_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ResetPasswordRequest {
  @PhoneNumberConverter()
  @JsonKey(name: 'mobile_number')
  PhoneNumber get phoneNumber;
  @JsonKey(name: 'mobile_token')
  String get mobileToken;
  @JsonKey(name: 'password')
  String get password;

  /// Create a copy of ResetPasswordRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ResetPasswordRequestCopyWith<ResetPasswordRequest> get copyWith =>
      _$ResetPasswordRequestCopyWithImpl<ResetPasswordRequest>(
          this as ResetPasswordRequest, _$identity);

  /// Serializes this ResetPasswordRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ResetPasswordRequest &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.mobileToken, mobileToken) ||
                other.mobileToken == mobileToken) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, phoneNumber, mobileToken, password);

  @override
  String toString() {
    return 'ResetPasswordRequest(phoneNumber: $phoneNumber, mobileToken: $mobileToken, password: $password)';
  }
}

/// @nodoc
abstract mixin class $ResetPasswordRequestCopyWith<$Res> {
  factory $ResetPasswordRequestCopyWith(ResetPasswordRequest value,
          $Res Function(ResetPasswordRequest) _then) =
      _$ResetPasswordRequestCopyWithImpl;
  @useResult
  $Res call(
      {@PhoneNumberConverter()
      @JsonKey(name: 'mobile_number')
      PhoneNumber phoneNumber,
      @JsonKey(name: 'mobile_token') String mobileToken,
      @JsonKey(name: 'password') String password});
}

/// @nodoc
class _$ResetPasswordRequestCopyWithImpl<$Res>
    implements $ResetPasswordRequestCopyWith<$Res> {
  _$ResetPasswordRequestCopyWithImpl(this._self, this._then);

  final ResetPasswordRequest _self;
  final $Res Function(ResetPasswordRequest) _then;

  /// Create a copy of ResetPasswordRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phoneNumber = null,
    Object? mobileToken = null,
    Object? password = null,
  }) {
    return _then(_self.copyWith(
      phoneNumber: null == phoneNumber
          ? _self.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as PhoneNumber,
      mobileToken: null == mobileToken
          ? _self.mobileToken
          : mobileToken // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _ResetPasswordRequest implements ResetPasswordRequest {
  _ResetPasswordRequest(
      {@PhoneNumberConverter()
      @JsonKey(name: 'mobile_number')
      required this.phoneNumber,
      @JsonKey(name: 'mobile_token') required this.mobileToken,
      @JsonKey(name: 'password') required this.password});
  factory _ResetPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestFromJson(json);

  @override
  @PhoneNumberConverter()
  @JsonKey(name: 'mobile_number')
  final PhoneNumber phoneNumber;
  @override
  @JsonKey(name: 'mobile_token')
  final String mobileToken;
  @override
  @JsonKey(name: 'password')
  final String password;

  /// Create a copy of ResetPasswordRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ResetPasswordRequestCopyWith<_ResetPasswordRequest> get copyWith =>
      __$ResetPasswordRequestCopyWithImpl<_ResetPasswordRequest>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ResetPasswordRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ResetPasswordRequest &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.mobileToken, mobileToken) ||
                other.mobileToken == mobileToken) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, phoneNumber, mobileToken, password);

  @override
  String toString() {
    return 'ResetPasswordRequest(phoneNumber: $phoneNumber, mobileToken: $mobileToken, password: $password)';
  }
}

/// @nodoc
abstract mixin class _$ResetPasswordRequestCopyWith<$Res>
    implements $ResetPasswordRequestCopyWith<$Res> {
  factory _$ResetPasswordRequestCopyWith(_ResetPasswordRequest value,
          $Res Function(_ResetPasswordRequest) _then) =
      __$ResetPasswordRequestCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@PhoneNumberConverter()
      @JsonKey(name: 'mobile_number')
      PhoneNumber phoneNumber,
      @JsonKey(name: 'mobile_token') String mobileToken,
      @JsonKey(name: 'password') String password});
}

/// @nodoc
class __$ResetPasswordRequestCopyWithImpl<$Res>
    implements _$ResetPasswordRequestCopyWith<$Res> {
  __$ResetPasswordRequestCopyWithImpl(this._self, this._then);

  final _ResetPasswordRequest _self;
  final $Res Function(_ResetPasswordRequest) _then;

  /// Create a copy of ResetPasswordRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? phoneNumber = null,
    Object? mobileToken = null,
    Object? password = null,
  }) {
    return _then(_ResetPasswordRequest(
      phoneNumber: null == phoneNumber
          ? _self.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as PhoneNumber,
      mobileToken: null == mobileToken
          ? _self.mobileToken
          : mobileToken // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
