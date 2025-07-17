// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_error.dart';

// **************************************************************************
// FrxGenerator
// **************************************************************************

extension ResetErrorX on ResetError {
  R when<R>({
    required R Function(ApiError error) api,
    required R Function(String message) db,
    required R Function(String message) unknown,
    required R Function(List<String> cases) input,
  }) {
    return switch (this) {
      ResetApiError(:final error) => api(error),
      ResetDbError(:final message) => db(message),
      ResetUnknownError(:final message) => unknown(message),
      ResetInputError(:final cases) => input(cases),
    };
  }

  R maybeWhen<R>({
    R Function(ApiError error)? api,
    R Function(String message)? db,
    R Function(String message)? unknown,
    R Function(List<String> cases)? input,
    required R Function() orElse,
  }) {
    return switch (this) {
      ResetApiError(:final error) when api != null => api(error),
      ResetDbError(:final message) when db != null => db(message),
      ResetUnknownError(:final message) when unknown != null =>
        unknown(message),
      ResetInputError(:final cases) when input != null => input(cases),
      _ => orElse(),
    };
  }

  R? whenOrNull<R>({
    R? Function(ApiError error)? api,
    R? Function(String message)? db,
    R? Function(String message)? unknown,
    R? Function(List<String> cases)? input,
  }) {
    return switch (this) {
      ResetApiError(:final error) => api?.call(error),
      ResetDbError(:final message) => db?.call(message),
      ResetUnknownError(:final message) => unknown?.call(message),
      ResetInputError(:final cases) => input?.call(cases),
    };
  }

  R map<R>({
    required R Function(ResetApiError value) api,
    required R Function(ResetDbError value) db,
    required R Function(ResetUnknownError value) unknown,
    required R Function(ResetInputError value) input,
  }) {
    return switch (this) {
      ResetApiError() => api(this as ResetApiError),
      ResetDbError() => db(this as ResetDbError),
      ResetUnknownError() => unknown(this as ResetUnknownError),
      ResetInputError() => input(this as ResetInputError),
    };
  }

  R maybeMap<R>({
    R Function(ResetApiError value)? api,
    R Function(ResetDbError value)? db,
    R Function(ResetUnknownError value)? unknown,
    R Function(ResetInputError value)? input,
    required R Function() orElse,
  }) {
    return switch (this) {
      ResetApiError() => api?.call(this as ResetApiError) ?? orElse(),
      ResetDbError() => db?.call(this as ResetDbError) ?? orElse(),
      ResetUnknownError() =>
        unknown?.call(this as ResetUnknownError) ?? orElse(),
      ResetInputError() => input?.call(this as ResetInputError) ?? orElse(),
    };
  }

  R? mapOrNull<R>({
    R? Function(ResetApiError value)? api,
    R? Function(ResetDbError value)? db,
    R? Function(ResetUnknownError value)? unknown,
    R? Function(ResetInputError value)? input,
  }) {
    return switch (this) {
      ResetApiError() => api?.call(this as ResetApiError),
      ResetDbError() => db?.call(this as ResetDbError),
      ResetUnknownError() => unknown?.call(this as ResetUnknownError),
      ResetInputError() => input?.call(this as ResetInputError),
    };
  }
}
