import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../common/utils/app_environment.dart';
import '../../../../common/utils/logger.dart';
import '../../../../core/domain/errors/api_error.dart';
import '../../../../core/infrastructure/datasources/remote/api/api_client.dart';
import '../../../../core/domain/services/auth_service.dart';
import '../../../../core/application/events/auth_event_bus.dart';
import '../../domain/entities/delete_account.dart';
import '../../domain/models/delete_account_request.dart';
import '../../domain/repositories/delete_account_repository.dart';
import '../dtos/delete_account_dto.dart';
import '../service/delete_account_client.dart';

/// Implementation of the DeleteAccountRepository interface
///
/// This class provides the concrete implementation of the DeleteAccountRepository
/// interface by communicating with the backend API via DeleteAccountClient.
///
/// Follows MCP-ddd-infrastructure-layer: Implement repository interfaces from domain layer
/// Follows MCP-ddd-infrastructure-layer: Use dependency injection for repository dependencies
@LazySingleton(
  as: DeleteAccountRepository,
  env: AppEnvironment.environments,
)
class DeleteAccountRepositoryImpl implements DeleteAccountRepository {
  final DeleteAccountClient _client;
  final AuthService _authService;
  final AuthEventBus _authEventBus;
  /// Creates a new instance of DeleteAccountRepositoryImpl
  ///
  /// [client] The API client used to communicate with the backend
  const DeleteAccountRepositoryImpl(
    this._client,
    this._authService,
    this._authEventBus,
  );

  @override
  Future<ResultDart<DeleteAccount, ApiError>> deleteAccount(
    DeleteAccountRequest request, {
    CancelToken? token,
  }) async {
    logger.i('[DeleteAccountRepository] Sending delete account'
        ' request with reason: "${request.reason}"');
    return _client.deleteAccount(request, token).tryGet((response) async {
      logger.i('[DeleteAccountRepository] Account deletion successful');
      await _authService.logout();
      // Notify all listeners about the logout event
      _authEventBus.notifyUnauthorized();
      // Return success with a DeleteAccount DTO
      return DeleteAccountDto(
        id: 1, // Default ID since the API returns no data
        reason: request.reason,
        success: true,
      );
    });
  }

  @override
  Future<DeleteAccount> checkDeletionEligibility() async {
    logger.i('[DeleteAccountRepository] Checking account deletion eligibility');

    // In a real implementation, this would call an API endpoint
    // For now, simulate a successful eligibility check
    await Future.delayed(const Duration(milliseconds: 300));

    return const DeleteAccountDto(
      success: true,
      reason: '',
    );
  }
}
