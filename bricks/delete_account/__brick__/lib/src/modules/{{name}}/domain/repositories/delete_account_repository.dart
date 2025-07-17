import 'package:dio/dio.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/domain/errors/api_error.dart';
import '../entities/delete_account.dart';
import '../models/delete_account_request.dart';

/// Repository interface for account deletion operations
/// 
/// This interface defines the contract for deleting a user account.
/// Follows MCP-ddd-domain-layer: Define repository interfaces in domain layer
abstract class DeleteAccountRepository {
  /// Deletes the user's account
  /// 
  /// [request] The reason for deletion and other required data
  /// [token] Optional token for cancelling the request
  Future<ResultDart<DeleteAccount, ApiError>> deleteAccount(
    DeleteAccountRequest request, 
    {CancelToken? token}
  );

  /// Checks if the user can delete their account
  /// 
  /// This method verifies if the user meets the requirements to delete their account,
  /// such as not having pending orders or active subscriptions.
  /// 
  /// Returns a [DeleteAccount] object with the eligibility information
  Future<DeleteAccount> checkDeletionEligibility();
}

