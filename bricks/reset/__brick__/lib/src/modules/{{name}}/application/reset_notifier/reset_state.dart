part of 'reset_notifier.dart';

// Follows MCP-ddd-application-layer: Define state classes with freezed
@freezed
class ResetStatus with _$ResetStatus {
  const factory ResetStatus.initial() = _InitialStatus;
  const factory ResetStatus.loading() = _LoadingStatus;
  const factory ResetStatus.error(ResetError err) = _ErrorStatus;
  const factory ResetStatus.success() = _SuccessStatus;
}

@freezed
abstract class ResetInput with _$ResetInput {
  const ResetInput._();

  const factory ResetInput({
    @Default('') String phone,
    @Default('') String password,
    @Default('') String confirmPassword,
    @Default('') String verificationCode,
  }) = _ResetInput;

  /// Returns a list of error field keys based on validation rules
  List<String> getErrorCase() {
    final context = ResetValidationContext(
      phone: phone,
      password: password,
      confirmPassword: confirmPassword,
    );
    return ResetValidator.getErrorFields(context);
  }

  /// Determines if the reset password form is valid
  bool isValid() {
    final context = ResetValidationContext(
      phone: phone,
      password: password,
      confirmPassword: confirmPassword,
    );
    return ResetValidator.isResetFormValid(context);
  }
}

@freezed
abstract class ResetState with _$ResetState {
  const ResetState._();

  const factory ResetState({
    @Default(ResetStatus.initial()) ResetStatus status,
    @Default(ResetInput()) ResetInput input,
  }) = _ResetState;

  bool get isLoading => status is _LoadingStatus;
  bool get isSuccess => status is _SuccessStatus;
  bool get hasErrors => status is _ErrorStatus;
}

// Follows MCP-ddd-application-layer: Use extensions for state transitions
extension ResetStateX on ResetState {
  // State transition helpers
  ResetState get loading => copyWith(status: const ResetStatus.loading());

  ResetState onLoaded(dynamic data) => copyWith(
        status: const ResetStatus.success(),
      );

  ResetState onSuccess(bool success) => copyWith(
        status: const ResetStatus.success(),
      );

  // Error handling
  ResetState onApiError(ApiError error) => onError(ResetError.api(error));

  ResetState onError(ResetError error) => copyWith(
        status: ResetStatus.error(error),
      );

  /// Returns field validation errors in the current state
  List<String> get validationErrors => input.getErrorCase();

  /// Checks if there's an error for a specific field
  bool hasErrorFor(String fieldKey) => validationErrors.contains(fieldKey);

  /// Transitions to error state for input validation errors
  ResetState onInputError(List<String> errorCases) => copyWith(
        status: ResetStatus.error(
          ResetError.input(errorCases),
        ),
      );

  /// Updates the state with validation errors
  ResetState onValidationErrors(List<String> errorCases) =>
      onInputError(errorCases);
}
