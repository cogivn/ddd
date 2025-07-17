part of 'delete_account_notifier.dart';

// Follows MCP-ddd-application-layer: Define state classes with freezed
@freezed
class DeleteAccountStatus with _$DeleteAccountStatus {
  const factory DeleteAccountStatus.initial() = _InitialStatus;

  const factory DeleteAccountStatus.loading() = _LoadingStatus;

  const factory DeleteAccountStatus.error(DeleteAccountError err) =
      _ErrorStatus;

  const factory DeleteAccountStatus.input(DeleteAccountInput data) =
      _InputStatus;

  const factory DeleteAccountStatus.success() = _SuccessStatus;

  const factory DeleteAccountStatus.ineligible(String reason) =
      _IneligibleStatus;

  const factory DeleteAccountStatus.eligible() = _EligibleStatus;
}

@freezed
abstract class DeleteAccountInput with _$DeleteAccountInput {
  const DeleteAccountInput._();

  const factory DeleteAccountInput({
    @Default('') String reason,
    @Default('') String confirmReason,
  }) = _DeleteAccountInput;

  /// Determines if the delete account form is valid
  bool isReasonValid({String? reason}) {
    final validator = DeleteAccountValidator();
    return validator.validateReason(reason ?? this.reason);
  }

  /// Determines if the confirm reason is valid
  bool isConfirmReasonValid({String? reason}) {
    final validator = DeleteAccountValidator();
    return validator.validateConfirmReason(reason ?? confirmReason);
  }
}

@freezed
abstract class DeleteAccountState with _$DeleteAccountState {
  const DeleteAccountState._();

  const factory DeleteAccountState({
    @Default(DeleteAccountStatus.initial()) DeleteAccountStatus status,
    @Default(DeleteAccountInput()) DeleteAccountInput input,
    DeleteAccount? data,
  }) = _DeleteAccountState;

  bool get isLoading => status is _LoadingStatus;

  bool get isSuccess => status is _SuccessStatus;

  bool get hasErrors => status is _ErrorStatus;

  bool get isEligible => status is _EligibleStatus;

  bool get isIneligible => status is _IneligibleStatus;
}

// Follows MCP-ddd-application-layer: Use extensions for state transitions
extension DeleteAccountStateX on DeleteAccountState {
  // State transition helpers
  DeleteAccountState get loading => copyWith(
        status: const DeleteAccountStatus.loading(),
      );

  DeleteAccountState onSuccess() => copyWith(
        status: const DeleteAccountStatus.success(),
      );

  DeleteAccountState onEligible() => copyWith(
        status: const DeleteAccountStatus.eligible(),
      );

  DeleteAccountState onIneligible(String reason) => copyWith(
        status: DeleteAccountStatus.ineligible(reason),
      );

  // Error handling
  DeleteAccountState onApiError(ApiError error) => onError(
        DeleteAccountError.api(error),
      );

  DeleteAccountState onError(DeleteAccountError error) => copyWith(
        status: DeleteAccountStatus.error(error),
      );

  DeleteAccountState onInput(DeleteAccountInput input) => copyWith(
        status: DeleteAccountStatus.input(input),
        input: input,
      );

  /// Returns the error message for the current state if it's an error state
  String? getErrorMessage(String? key) => switch (status) {
        _ErrorStatus(:final err) => err.getMessage(getIt(), key: key),
        _ => null,
      };

  /// Transitions to error state for input validation errors
  DeleteAccountState onInputError(List<String> errorCases) => copyWith(
        status: DeleteAccountStatus.error(
          DeleteAccountError.input(errorCases),
        ),
      );

  /// Updates the state with validation errors
  DeleteAccountState onValidationErrors(List<String> errorCases) =>
      errorCases.isEmpty ? this : onInputError(errorCases);
}
