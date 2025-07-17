import 'dart:async';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:result_dart/result_dart.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../../../../../generated/l10n.dart';
import '../../../../../common/utils/app_environment.dart';
import '../../../../../common/utils/logger.dart';
import '../../../../domain/services/auth_service.dart';
import '../../../../application/events/auth_event_bus.dart';
import '../../../../domain/interfaces/lang_repository.dart';
import '../../../../domain/errors/api_error.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/lang_interceptor.dart';

@module
abstract class ApiModule {
  @Named('baseUrl')
  String get baseUrl => AppEnvironment.apiUrl;

  @singleton
  Dio dio(
    @Named('baseUrl') String url,
    LangRepository repo,
    Talker talker,
    AuthService authService,
    AuthEventBus bus,
  ) {
    return Dio(
      BaseOptions(
        baseUrl: url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'Accept': 'application/json',
        },
        queryParameters: {},
      ),
    )..interceptors.addAll([
        LangInterceptor(repo),
        AuthInterceptor(),
        TalkerDioLogger(
          talker: talker,
          settings: TalkerDioLoggerSettings(
            responsePen: AnsiPen()..blue(),
            // All http responses enabled for console logging
            printResponseData: true,
            // All http requests disabled for console logging
            printRequestData: true,
            // Response logs including http - headers
            printResponseHeaders: false,
            // Request logs without http - headers
            printRequestHeaders: true,
          ),
        ),
        ErrorInterceptor(authService, bus),
      ]);
  }
}

extension FutureX<T extends Object> on Future<T> {
  FutureOr<T> getOrThrow() async {
    try {
      return await this;
    } on ApiError {
      rethrow;
    } on DioException catch (e) {
      logger.e(e, stackTrace: e.stackTrace);
      throw e.toApiError();
    } on Error catch (e) {
      logger.e(e, stackTrace: e.stackTrace);
      throw ApiError.internal(e.toString());
    } catch (e) {
      throw ApiError.internal(e.toString());
    }
  }

  FutureOr<ResultDart<R, ApiError>> tryGet<R extends Object>(
      FutureOr<R> Function(T) response) async {
    try {
      return (await response.call(await getOrThrow())).toSuccess();
    } on ApiError catch (e) {
      return e.toFailure();
    } catch (e) {
      return ApiError.internal(e.toString()).toFailure();
    }
  }
}


extension FutureResultX<T extends Object> on Future<ResultDart<T, ApiError>> {
  FutureOr<W> fold<W>(
      W Function(T success) onSuccess,
      W Function(ApiError failure) onFailure,
      ) async {
    try {
      final result = await getOrThrow();
      return onSuccess(result);
    } on ApiError catch (e) {
      return onFailure(e);
    }
  }
}

extension DioExceptionX on DioException {
  /// Converts a DioException to the appropriate ApiError type
  ///
  /// This method handles three main cases:
  /// 1. Cancellation errors
  /// 2. Errors that are already ApiError instances
  /// 3. Other errors that need to be converted based on status code
  ApiError toApiError() {
    // Handle request cancellation
    if (type == DioExceptionType.cancel) {
      return ApiError.cancelled();
    }
    // If error is already an ApiError instance, return it directly
    else if (error is ApiError) {
      return error as ApiError;
    }
    // Handle other error types based on status code
    else {
      final statusCode = response?.statusCode ?? -1;

      // Use default error message for fallback
      final message = S.current.error_unexpected;

      // Create appropriate ApiError type based on status code
      if (statusCode == 401) {
        return ApiError.unauthorized(message);
      } else if (statusCode >= 400 && statusCode < 500) {
        return ApiError.server(code: statusCode, message: message);
      } else {
        return ApiError.network(code: 500, message: message);
      }
    }
  }
}