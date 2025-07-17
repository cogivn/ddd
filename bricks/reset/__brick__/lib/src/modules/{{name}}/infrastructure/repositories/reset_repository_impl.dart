import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../common/utils/app_environment.dart';
import '../../../../core/domain/errors/api_error.dart';
import '../../../../core/infrastructure/datasources/remote/api/api_client.dart';
import '../../domain/models/reset_request.dart';
import '../../domain/repositories/reset_repository.dart';
import '../service/reset_client.dart';

// Follows MCP-ddd-infrastructure-layer: Repository implementation with proper DI annotations
@LazySingleton(as: ResetRepository, env: AppEnvironment.environments)
class ResetRepositoryImpl implements ResetRepository {
  final ResetClient _client;

  /// Creates a new instance of the reset repository implementation
  ResetRepositoryImpl(this._client);

  /// Resets a user's password using their phone number and verification code
  /// 
  /// This implementation calls the reset password API endpoint via the ResetClient.
  /// It transforms the API response to a simple boolean success status.
  ///
  /// [request] Contains the phone number, verification code, and new password
  /// [token] Optional cancel token to allow request cancellation
  ///
  /// Returns a [ResultDart] containing:
  /// - Success(true) if the password was reset successfully
  /// - Failure(ApiError) if the request failed for any reason
  @override
  Future<ResultDart<bool, ApiError>> resetPassword(
    ResetPasswordRequest request, {
    CancelToken? token,
  }) async =>
      _client
          .resetPassword(request, token)
          .tryGet((result) => result.data.token.isNotEmpty);
}
