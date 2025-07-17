import 'package:dio/dio.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/domain/errors/api_error.dart';
import '../models/reset_request.dart';

/// Repository interface for the reset password module
///
/// This repository defines the contract for password reset functionality.
/// It follows the domain-driven design pattern where interfaces are defined
/// in the domain layer and implementations are in the infrastructure layer.
/// 
/// Follows MCP-ddd-domain-layer: Define repository interfaces with ResultDart return types
abstract class ResetRepository {
  /// Resets a user's password using verification from their phone number
  ///
  /// This method handles the API communication to reset a user's password
  /// after they've verified their identity through a phone verification code.
  /// 
  /// [request] Contains all required information for password reset including:
  ///   - Phone number (verified through OTP)
  ///   - Mobile token (from verification process)
  ///   - New password
  ///
  /// [token] Optional cancellation token to allow cancelling in-progress requests
  ///
  /// Returns a [ResultDart] containing either:
  /// - Success(true) when the password was successfully reset
  /// - Failure(ApiError) when the reset operation fails with error details
  Future<ResultDart<bool, ApiError>> resetPassword(
    ResetPasswordRequest request, {
    CancelToken? token,
  });
}
