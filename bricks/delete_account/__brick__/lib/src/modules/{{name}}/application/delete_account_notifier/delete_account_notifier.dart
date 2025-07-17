import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

import '../../../../common/utils/getit_utils.dart';
import '../../../../common/utils/logger.dart';
import '../../../../core/domain/errors/api_error.dart';
import '../../domain/constants/delete_account_validation_keys.dart';
import '../../domain/entities/delete_account.dart';
import '../../domain/errors/delete_account_error.dart';
import '../../domain/models/delete_account_request.dart';
import '../../domain/repositories/delete_account_repository.dart';
import '../../domain/validators/delete_account_validator.dart';

part 'delete_account_state.dart';
part 'delete_account_notifier.freezed.dart';

/// Provider for the DeleteAccountNotifier
///
/// Follows MCP-ddd-application-layer: Use dependency injection for repositories
@ProviderFor(DeleteAccountNotifier)
final deleteAccountProvider =
    AutoDisposeNotifierProvider<DeleteAccountNotifier, DeleteAccountState>(
  () => getIt<DeleteAccountNotifier>(),
);

/// Notifier for managing the delete account state and operations
///
/// Follows MCP-ddd-application-layer: Implement application services as notifiers
@injectable
class DeleteAccountNotifier extends AutoDisposeNotifier<DeleteAccountState> {
  final DeleteAccountRepository _repository;
  final String _instanceId = const Uuid().v4();
  CancelToken? _cancelToken;

  DeleteAccountNotifier(this._repository) {
    logger.d('[DeleteAccountNotifier] Created new instance $_instanceId');
  }

  @override
  DeleteAccountState build() {
    ref.onDispose(() {
      logger.d('[DeleteAccountNotifier] Disposed instance $_instanceId');
      _cancelOngoingRequests();
    });
    return const DeleteAccountState();
  }

  /// Cancels any ongoing API requests
  void _cancelOngoingRequests() {
    if (_cancelToken != null) {
      logger.d('[DeleteAccountNotifier] Cancelling requests '
          'for instance $_instanceId');
      _cancelToken?.cancel('Notifier was disposed');
      _cancelToken = null;
    }
  }

  /// Creates a new cancel token for API requests
  CancelToken _createCancelToken() {
    _cancelOngoingRequests();
    _cancelToken = CancelToken();
    return _cancelToken!;
  }

  /// Update the reason in the input state
  ///
  /// [reason] The new reason value for account deletion
  void onReasonChanged(String reason) {
    // Update the reason in the state, validate the input first
    if (!_validateReason(reason: reason)) {
      return;
    }
    state = state.onInput(state.input.copyWith(reason: reason));
  }

  /// Update the confirm reason in the input state
  ///
  /// [confirmReason] The new confirm reason value for account deletion
  void onConfirmReasonChanged(String confirmReason) {
    // Update the confirm reason in the state, validate the input first
    if (!_validateConfirmReason(confirmReason: confirmReason)) {
      return;
    }
    state = state.onInput(state.input.copyWith(confirmReason: confirmReason));
  }

  /// Validates the current input and returns if it's valid
  ///
  /// If invalid, updates the state with validation errors
  ///
  /// Returns true if valid, false otherwise
  bool _validateReason({String? reason}) {
    final isValid = state.input.isReasonValid(reason: reason);
    final errorKeys = <String>[DeleteAccountValidationKeys.reason];
    if (!isValid) {
      state = state.onValidationErrors(errorKeys);
      return false;
    }

    return true;
  }

  /// Validates the confirm reason
  ///
  /// [confirmReason] The confirmation reason provided by the user
  ///
  /// Returns true if valid, false otherwise
  bool _validateConfirmReason({String? confirmReason}) {
    final isValid = state.input.isConfirmReasonValid(reason: confirmReason);
    final errorKeys = <String>[DeleteAccountValidationKeys.confirmReason];
    if (!isValid) {
      state = state.onValidationErrors(errorKeys);
      return false;
    }

    return true;
  }

  /// Submit request to delete user's account
  ///
  /// Validates the input reason first, and if valid, sends the request
  /// to delete the user's account
  Future<void> submit() async {
    // Create deletion request
    final request = DeleteAccountRequest(reason: state.input.reason);

    // Set loading state
    state = state.loading;

    // Send deletion request to repository
    final result = await _repository.deleteAccount(
      request,
      token: _createCancelToken(),
    );

    // Handle the results
    state = result.fold((success) => state.onSuccess(), state.onApiError);
  }

  /// Reset the state to initial
  void resetState() {
    state = const DeleteAccountState();
  }
}
