import 'package:dio/dio.dart';

import '../../../../../../../generated/l10n.dart';
import '../../../../../../common/utils/logger.dart';
import '../../../../../application/events/auth_event_bus.dart';
import '../../../../../domain/errors/api_error.dart';
import '../../../../../domain/services/auth_service.dart';
import '../base/api_response.dart';

/// Interceptor for handling API errors in responses
class ErrorInterceptor extends InterceptorsWrapper {
  final AuthService _authService;
  final AuthEventBus _authEventBus;

  ErrorInterceptor(this._authService, this._authEventBus);

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (_isMapResponse(response)) {
      final data = response.data as Map<String, dynamic>;
      // First try the standard error format
      if (_hasStandardError(data)) {
        final apiError = _handleStandardError(
          data,
          ignoreAuthHandler: false,
          endpoint: response.requestOptions.path,
        );
        throw DioException(
          type: DioExceptionType.badResponse,
          message: apiError.message,
          requestOptions: response.requestOptions,
          response: response,
          error: apiError,
        );
      }
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final response = err.response;
    final requestOptions = err.requestOptions;
    Map<String, dynamic> requests = requestOptions.queryParameters;
    DioException dioException = err;
    String endpoint = requestOptions.path;

    /// Check if the request is an authentication repository
    /// This is used to ignore auth handling for specific requests
    /// For example, when handling update phone requests or verifying OTPs
    ///
    /// This is a temporary solution until we have a better way to handle auth errors
    /// It allows us to ignore auth handling for specific requests
    /// This should be removed once we have a better way to handle auth errors
    final ignoreAuthHandler = requests.containsKey('ig_auth_handler') &&
        requests['ig_auth_handler'] == true;

    if (_isMapResponse(response)) {
      final data = response!.data as Map<String, dynamic>;
      // First try the standard error format
      if (_hasStandardError(data)) {
        final apiError = _handleStandardError(
          data,
          ignoreAuthHandler: ignoreAuthHandler,
          endpoint: endpoint,
        );
        dioException = dioException.copyWith(error: apiError);
      }
    }
    handler.next(dioException);
  }

  /// Handles unauthorized errors by logging out the user and notifying the app
  Future<void> _handleUnauthorized(ApiError error) async {
    logger.w('Handling 401 unauthorized: $error');
    // Attempt to logout the user
    final success = await _authService.logout();

    if (success) {
      // Notify all listeners about the unauthorized state
      _authEventBus.notifyUnauthorized();
      logger.i('User logged out due to 401 unauthorized response');
    } else {
      logger.e('Failed to logout user after 401 unauthorized response');
    }
  }

  /// Handle force update errors by notifying the app
  // Future<void> _notifyToForceUpdate(AppEvent events) async {
  //   // Notify the app about the force update requirement
  //   ForceUpdateConfig.instance.shouldSkipForceUpdate(events.endpoint)
  //       ? logger.w('Skipping force update notification'
  //       ' for endpoint: ${events.endpoint}')
  //       : _appEventBus.emit(events);
  // }

  /// Checks if the response data is a Map
  bool _isMapResponse(Response? response) {
    return response?.data is Map<String, dynamic>;
  }

  /// Checks if the response has a standard error format
  bool _hasStandardError(Map<String, dynamic> data) {
    return data.containsKey('result') &&
        data['result'] is Map<String, dynamic> &&
        _hasError(ResultData.fromJson(data['result'] as Map<String, dynamic>));
  }

  /// Checks if a ResultData instance contains an error code
  bool _hasError(ResultData result) {
    return result.code >= 400 || result.message == 'upgrade_required';
  }

  /// Handles a standard format error
  ApiError _handleStandardError(
    Map<String, dynamic> data, {
    bool ignoreAuthHandler = false,
    String? endpoint,
  }) {
    final json = data['result'] as Map<String, dynamic>;
    final result = ResultData.fromJson(json);

    // Create a temporary SingleApiResponse to use its getLocalizedMessageFromCurrentLocale method
    final res = SingleApiResponse(data: null, result: result);
    final localizedMessage = res.getLocalizedMessageFromCurrentLocale() ??
        S.current.error_unexpected;

    // Handle 401 unauthorized errors
    if (result.code == 401) {
      final exception = ApiError.unauthorized(localizedMessage);
      if (!ignoreAuthHandler) {
        logger.w('Unauthorized. Handling with auth repository');
        _handleUnauthorized(exception);
      } else {
        logger.w('Unauthorized error ignored due to ignoreAuthHandler=true');
      }
      return exception;
    }
    /*else if (result.code == 426 || result.message == 'upgrade_required') {
      // Handle force update errors
      final dataJson = data['data'] as Map<String, dynamic>? ?? {};
      final result = MobileVersionData.fromJson(dataJson);
      final events = ForceUpdateRequiredEvent.fromModel(
        model: result.mobileVersion,
        endpoint: endpoint ?? '',
      );
      _notifyToForceUpdate(events);

      return ApiError.version(
        code: 426,
        message: localizedMessage,
        v: result.mobileVersion,
      );
    }*/

    return ApiError.server(
      code: result.code,
      message: localizedMessage,
    );
  }
}
