// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_notifier.dart';

// **************************************************************************
// FrxGenerator
// **************************************************************************

extension ResetStatusX on ResetStatus {
  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(ResetError err) error,
    required R Function() success,
  }) {
    return switch (this) {
      _InitialStatus() => initial(),
      _LoadingStatus() => loading(),
      _ErrorStatus(:final err) => error(err),
      _SuccessStatus() => success(),
      _ => throw UnsupportedError('Unsupported union case'),
    };
  }

  R maybeWhen<R>({
    R Function()? initial,
    R Function()? loading,
    R Function(ResetError err)? error,
    R Function()? success,
    required R Function() orElse,
  }) {
    return switch (this) {
      _InitialStatus() when initial != null => initial(),
      _LoadingStatus() when loading != null => loading(),
      _ErrorStatus(:final err) when error != null => error(err),
      _SuccessStatus() when success != null => success(),
      _ => orElse(),
    };
  }

  R? whenOrNull<R>({
    R? Function()? initial,
    R? Function()? loading,
    R? Function(ResetError err)? error,
    R? Function()? success,
  }) {
    return switch (this) {
      _InitialStatus() => initial?.call(),
      _LoadingStatus() => loading?.call(),
      _ErrorStatus(:final err) => error?.call(err),
      _SuccessStatus() => success?.call(),
      _ => null,
    };
  }
}
