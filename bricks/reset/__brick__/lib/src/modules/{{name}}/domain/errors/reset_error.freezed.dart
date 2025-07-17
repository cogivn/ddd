// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reset_error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ResetError {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ResetError);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ResetError()';
  }
}

/// @nodoc
class $ResetErrorCopyWith<$Res> {
  $ResetErrorCopyWith(ResetError _, $Res Function(ResetError) __);
}

/// @nodoc

class ResetApiError extends ResetError {
  const ResetApiError(this.error) : super._();

  final ApiError error;

  /// Create a copy of ResetError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ResetApiErrorCopyWith<ResetApiError> get copyWith =>
      _$ResetApiErrorCopyWithImpl<ResetApiError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ResetApiError &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  String toString() {
    return 'ResetError.api(error: $error)';
  }
}

/// @nodoc
abstract mixin class $ResetApiErrorCopyWith<$Res>
    implements $ResetErrorCopyWith<$Res> {
  factory $ResetApiErrorCopyWith(
          ResetApiError value, $Res Function(ResetApiError) _then) =
      _$ResetApiErrorCopyWithImpl;
  @useResult
  $Res call({ApiError error});

  $ApiErrorCopyWith<$Res> get error;
}

/// @nodoc
class _$ResetApiErrorCopyWithImpl<$Res>
    implements $ResetApiErrorCopyWith<$Res> {
  _$ResetApiErrorCopyWithImpl(this._self, this._then);

  final ResetApiError _self;
  final $Res Function(ResetApiError) _then;

  /// Create a copy of ResetError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(ResetApiError(
      null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as ApiError,
    ));
  }

  /// Create a copy of ResetError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ApiErrorCopyWith<$Res> get error {
    return $ApiErrorCopyWith<$Res>(_self.error, (value) {
      return _then(_self.copyWith(error: value));
    });
  }
}

/// @nodoc

class ResetDbError extends ResetError {
  const ResetDbError(this.message) : super._();

  final String message;

  /// Create a copy of ResetError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ResetDbErrorCopyWith<ResetDbError> get copyWith =>
      _$ResetDbErrorCopyWithImpl<ResetDbError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ResetDbError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'ResetError.db(message: $message)';
  }
}

/// @nodoc
abstract mixin class $ResetDbErrorCopyWith<$Res>
    implements $ResetErrorCopyWith<$Res> {
  factory $ResetDbErrorCopyWith(
          ResetDbError value, $Res Function(ResetDbError) _then) =
      _$ResetDbErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$ResetDbErrorCopyWithImpl<$Res> implements $ResetDbErrorCopyWith<$Res> {
  _$ResetDbErrorCopyWithImpl(this._self, this._then);

  final ResetDbError _self;
  final $Res Function(ResetDbError) _then;

  /// Create a copy of ResetError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(ResetDbError(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class ResetUnknownError extends ResetError {
  const ResetUnknownError(this.message) : super._();

  final String message;

  /// Create a copy of ResetError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ResetUnknownErrorCopyWith<ResetUnknownError> get copyWith =>
      _$ResetUnknownErrorCopyWithImpl<ResetUnknownError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ResetUnknownError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'ResetError.unknown(message: $message)';
  }
}

/// @nodoc
abstract mixin class $ResetUnknownErrorCopyWith<$Res>
    implements $ResetErrorCopyWith<$Res> {
  factory $ResetUnknownErrorCopyWith(
          ResetUnknownError value, $Res Function(ResetUnknownError) _then) =
      _$ResetUnknownErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$ResetUnknownErrorCopyWithImpl<$Res>
    implements $ResetUnknownErrorCopyWith<$Res> {
  _$ResetUnknownErrorCopyWithImpl(this._self, this._then);

  final ResetUnknownError _self;
  final $Res Function(ResetUnknownError) _then;

  /// Create a copy of ResetError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(ResetUnknownError(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class ResetInputError extends ResetError {
  const ResetInputError(final List<String> cases)
      : _cases = cases,
        super._();

  final List<String> _cases;
  List<String> get cases {
    if (_cases is EqualUnmodifiableListView) return _cases;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cases);
  }

  /// Create a copy of ResetError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ResetInputErrorCopyWith<ResetInputError> get copyWith =>
      _$ResetInputErrorCopyWithImpl<ResetInputError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ResetInputError &&
            const DeepCollectionEquality().equals(other._cases, _cases));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_cases));

  @override
  String toString() {
    return 'ResetError.input(cases: $cases)';
  }
}

/// @nodoc
abstract mixin class $ResetInputErrorCopyWith<$Res>
    implements $ResetErrorCopyWith<$Res> {
  factory $ResetInputErrorCopyWith(
          ResetInputError value, $Res Function(ResetInputError) _then) =
      _$ResetInputErrorCopyWithImpl;
  @useResult
  $Res call({List<String> cases});
}

/// @nodoc
class _$ResetInputErrorCopyWithImpl<$Res>
    implements $ResetInputErrorCopyWith<$Res> {
  _$ResetInputErrorCopyWithImpl(this._self, this._then);

  final ResetInputError _self;
  final $Res Function(ResetInputError) _then;

  /// Create a copy of ResetError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? cases = null,
  }) {
    return _then(ResetInputError(
      null == cases
          ? _self._cases
          : cases // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

// dart format on
