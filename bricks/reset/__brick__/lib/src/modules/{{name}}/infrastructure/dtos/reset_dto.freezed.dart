// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reset_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ResetDto implements DiagnosticableTreeMixin {
  @JsonKey(name: 'access_token')
  String get token;

  /// Create a copy of ResetDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ResetDtoCopyWith<ResetDto> get copyWith =>
      _$ResetDtoCopyWithImpl<ResetDto>(this as ResetDto, _$identity);

  /// Serializes this ResetDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'ResetDto'))
      ..add(DiagnosticsProperty('token', token));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ResetDto &&
            (identical(other.token, token) || other.token == token));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, token);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ResetDto(token: $token)';
  }
}

/// @nodoc
abstract mixin class $ResetDtoCopyWith<$Res> {
  factory $ResetDtoCopyWith(ResetDto value, $Res Function(ResetDto) _then) =
      _$ResetDtoCopyWithImpl;
  @useResult
  $Res call({@JsonKey(name: 'access_token') String token});
}

/// @nodoc
class _$ResetDtoCopyWithImpl<$Res> implements $ResetDtoCopyWith<$Res> {
  _$ResetDtoCopyWithImpl(this._self, this._then);

  final ResetDto _self;
  final $Res Function(ResetDto) _then;

  /// Create a copy of ResetDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
  }) {
    return _then(_self.copyWith(
      token: null == token
          ? _self.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _ResetDto with DiagnosticableTreeMixin implements ResetDto {
  const _ResetDto({@JsonKey(name: 'access_token') this.token = ''});
  factory _ResetDto.fromJson(Map<String, dynamic> json) =>
      _$ResetDtoFromJson(json);

  @override
  @JsonKey(name: 'access_token')
  final String token;

  /// Create a copy of ResetDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ResetDtoCopyWith<_ResetDto> get copyWith =>
      __$ResetDtoCopyWithImpl<_ResetDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ResetDtoToJson(
      this,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'ResetDto'))
      ..add(DiagnosticsProperty('token', token));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ResetDto &&
            (identical(other.token, token) || other.token == token));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, token);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ResetDto(token: $token)';
  }
}

/// @nodoc
abstract mixin class _$ResetDtoCopyWith<$Res>
    implements $ResetDtoCopyWith<$Res> {
  factory _$ResetDtoCopyWith(_ResetDto value, $Res Function(_ResetDto) _then) =
      __$ResetDtoCopyWithImpl;
  @override
  @useResult
  $Res call({@JsonKey(name: 'access_token') String token});
}

/// @nodoc
class __$ResetDtoCopyWithImpl<$Res> implements _$ResetDtoCopyWith<$Res> {
  __$ResetDtoCopyWithImpl(this._self, this._then);

  final _ResetDto _self;
  final $Res Function(_ResetDto) _then;

  /// Create a copy of ResetDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? token = null,
  }) {
    return _then(_ResetDto(
      token: null == token
          ? _self.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
