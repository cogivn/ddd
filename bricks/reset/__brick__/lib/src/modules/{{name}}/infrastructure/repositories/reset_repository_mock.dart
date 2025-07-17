import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../common/utils/app_environment.dart';
import '../../../../common/utils/logger.dart';
import '../../../../core/domain/errors/api_error.dart';
import '../../domain/models/reset_request.dart';
import '../../domain/repositories/reset_repository.dart';

// Follows MCP-ddd-infrastructure-layer: Mock repository with @alpha annotation
@alpha
@LazySingleton(as: ResetRepository)
class ResetRepositoryMock implements ResetRepository {
  /// Creates a new instance of the mock reset repository
  ResetRepositoryMock();
  
  /// Provides a mock implementation for password reset functionality
  /// 
  /// This mock implementation simulates the password reset API behavior:
  /// - Adds a delay to simulate network latency
  /// - Logs the request for debugging purposes
  /// - Validates password length as a basic test case
  ///
  /// [request] Contains the phone number, verification code, and new password
  /// [token] Optional cancel token (not used in mock implementation)
  ///
  /// Returns a [ResultDart] containing:
  /// - Success(true) if the password length is at least 6 characters
  /// - Failure(ApiError) with a 400 code if the password is too short
  @override
  Future<ResultDart<bool, ApiError>> resetPassword(
    ResetPasswordRequest request, {
    CancelToken? token,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    logger.d('[MOCK] Reset password called with phone: ${request.phoneNumber.value}');
    
    // For testing purposes, succeed if password is valid
    if (request.password.length >= 6) {
      return const Success(true);
    } else {
      return Failure(
        ApiError.server(
          message: 'Password must be at least 6 characters',
          code: 400,
        ),
      );
    }
  }
}