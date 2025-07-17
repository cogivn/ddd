import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../common/utils/app_environment.dart';
import '../../../../common/utils/logger.dart';
import '../../../../core/domain/errors/api_error.dart';
import '../../domain/entities/delete_account.dart';
import '../../domain/models/delete_account_request.dart';
import '../../domain/repositories/delete_account_repository.dart';
import '../dtos/delete_account_dto.dart';

/// Mock implementation of the DeleteAccountRepository interface for testing
///
/// This class provides a mock implementation used in the alpha environment.
///
/// Follows MCP-ddd-infrastructure-layer: Implement mock repositories for testing
@alpha
@LazySingleton(as: DeleteAccountRepository)
class DeleteAccountRepositoryMock implements DeleteAccountRepository {
  /// Creates a new instance of DeleteAccountRepositoryMock
  DeleteAccountRepositoryMock();

  @override
  Future<ResultDart<DeleteAccount, ApiError>> deleteAccount(
    DeleteAccountRequest request, {
    CancelToken? token,
  }) async {
    logger.i('[DeleteAccountRepositoryMock] Mock deleting account '
        'with reason: "${request.reason}"');

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Basic validation - reason must be provided and have minimum length
    if (request.reason.trim().length < 5) {
      logger.w('[DeleteAccountRepositoryMock] Invalid reason: too short');
      return Failure(
        ApiError.server(
          message: 'Please provide a valid reason for deleting your'
              ' account (minimum 5 characters)',
          code: 400,
        ),
      );
    }

    // Return success with a DeleteAccount DTO
    logger.i('[DeleteAccountRepositoryMock] Mock account deletion successful');
    return Success(
      DeleteAccountDto(
        id: 1,
        reason: request.reason,
        success: true,
      ),
    );
  }

  @override
  Future<DeleteAccount> checkDeletionEligibility() async {
    logger.i('[DeleteAccountRepositoryMock] Checking mock account'
        ' deletion eligibility');

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // For testing purposes, simulate a successful eligibility check
    return const DeleteAccountDto(
      success: true,
      reason: '',
    );
  }
}
