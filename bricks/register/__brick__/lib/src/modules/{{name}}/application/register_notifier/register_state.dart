part of 'register_notifier.dart';

@freezed
class RegisterStatus with _$RegisterStatus {
  const factory RegisterStatus.initial() = _InitialStatus;
  const factory RegisterStatus.loading() = _LoadingStatus;
  const factory RegisterStatus.error(RegisterError err) = _ErrorStatus;
  const factory RegisterStatus.success() = _SuccessStatus;
}

@freezed
abstract class RegisterInput with _$RegisterInput {
  const RegisterInput._();

  const factory RegisterInput({
    @Default('') String phone,
    @Default('') String password,
    @Default('') String cPassword,
    @Default('') String verificationCode,
  }) = _RegisterInput;

  /// Returns a list of error field keys based on validation rules
  List<String> getErrorCase() {
    final context = RegisterValidationContext(
      email: phone, // Assuming phone is used as email here
      password: password,
      confirmPassword: cPassword,
    );
    return RegisterValidator.getErrorFields(context);
  }

  /// Determines if the registration form is valid
  bool isValid() {
    final context = RegisterValidationContext(
      email: phone,
      password: password,
      confirmPassword: cPassword,
    );
    return RegisterValidator.isRegisterFormValid(context);
  }
}

@freezed
abstract class RegisterState with _$RegisterState {
  const RegisterState._();

  const factory RegisterState({
    @Default(RegisterStatus.initial()) RegisterStatus status,
    @Default(RegisterInput()) RegisterInput input,
    // Supportive? supportive,
  }) = _RegisterState;

  bool get isLoading => status is _LoadingStatus;
  bool get hasErrors => status is _ErrorStatus;
}

extension RegisterStateX on RegisterState {
  RegisterState get loading => copyWith(status: const RegisterStatus.loading());


  RegisterState onSuccess() => copyWith(
        status: const RegisterStatus.success(),
      );

  /// Returns field validation errors in the current state
  List<String> get validationErrors => input.getErrorCase();

  /// Checks if there's an error for a specific field
  bool hasErrorFor(String fieldKey) => validationErrors.contains(fieldKey);

  /// Transitions to error state for input validation errors
  RegisterState onInputError(List<String> errorCases) => copyWith(
        status: RegisterStatus.error(
          RegisterError.input(errorCases),
        ),
      );

  /// Updates the state with validation errors
  RegisterState onValidationErrors(List<String> errorCases) => onInputError(errorCases);
}