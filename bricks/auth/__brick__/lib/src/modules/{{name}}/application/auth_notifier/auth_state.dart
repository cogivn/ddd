part of 'auth_notifier.dart';


@freezed
abstract class AuthStatus with _$AuthStatus {
  const factory AuthStatus.unauthenticated() = _InitialStatus;
  const factory AuthStatus.input(AuthInput data) = _InputStatus;
  const factory AuthStatus.loading() = _LoadingStatus;
  const factory AuthStatus.error(AuthError err) = _ErrorStatus;
  const factory AuthStatus.authenticated(User user) = _LoadedStatus;
}

@freezed
abstract class AuthInput with _$AuthInput {
  const AuthInput._();

  const factory AuthInput({
    @Default('') String phone,
    @Default('') String password,
  }) = _AuthInput;

  /// Returns a list of error field keys based on validation rules
  List<String> getErrorCase() {
    final context = AuthValidationContext(phone: phone, password: password);
    return AuthenticationValidator.getErrorFields(context);
  }

  /// Determines if the login form is valid
  bool isValid() {
    final context = AuthValidationContext(phone: phone, password: password);
    return AuthenticationValidator.isLoginFormValid(context);
  }
}

@freezed
abstract class AuthState with _$AuthState {
  const AuthState._();

  const factory AuthState({
    @Default(AuthStatus.unauthenticated()) AuthStatus status,
    @Default(AuthInput()) AuthInput input,
    User? user,
  }) = _AuthState;

  /// Convenience getter to check if the state is loading
  bool get isLoading => status == const AuthStatus.loading();

  /// Returns field validation errors in the current state
  List<String> get validationErrors => input.getErrorCase();

  /// Checks if there's an error for a specific field
  bool hasErrorFor(String fieldKey) => validationErrors.contains(fieldKey);

  /// Checks if the user is authenticated
  bool get isAuthenticated => status is _LoadedStatus;
}

/// State transition methods - grouped logically
extension AuthStateX on AuthState {
  /// Transitions to loading state
  AuthState get loading => copyWith(
        status: const AuthStatus.loading(),
      );

  /// Transitions to error state with domain error
  /// Also resets the input field values when transitioning to error state
  AuthState onError(AuthError error) => copyWith(
        status: AuthStatus.error(error),
      );

  /// Convenience method to wrap API errors
  /// Also resets the input field values for API errors
  AuthState onApiError(ApiError apiError) => copyWith(
        status: AuthStatus.error(AuthError.api(apiError)),
      );

  /// Transitions to error state for invalid phone
  /// Only resets the phone input value
  AuthState onInvalidPhone(String message) => copyWith(
        status: AuthStatus.error(AuthError.phone(message)), // Reset only phone
      );

  /// Transitions to error state for invalid password
  AuthState onInvalidPassword(String message) => copyWith(
        status: AuthStatus.error(AuthError.password(message)),
      );

  /// Transitions to error state for input validation errors
  /// Takes a list of error field keys and creates appropriate error messages
  ///
  /// [errorFields] List of field keys that failed validation
  ///
  /// Returns updated state with appropriate error status
  AuthState onValidationErrors(List<String> errorFields) {
    if (errorFields.isEmpty) return this;

    // First check for phone errors as they're more critical
    if (errorFields.contains(AuthValidationKeys.phone)) {
      final message = input.phone.isEmpty
          ? S.current.auth_phone_empty
          : S.current.auth_phone_invalid_format;
      return onInvalidPhone(message);
    }

    // Then check for password errors
    if (errorFields.contains(AuthValidationKeys.password)) {
      final message = input.password.isEmpty
          ? S.current.auth_password_empty
          : S.current.error_invalid_password;
      return onInvalidPassword(message);
    }

    // If we get here, there are validation errors but they're not
    // standard phone/password errors - create a generic error
    return onError(AuthError.unexpected(S.current.error_unexpected));
  }

  /// Transitions to authenticated state with user data
  AuthState onAuthenticated(User user) => copyWith(
        status: AuthStatus.authenticated(user),
        user: user,
      );

  /// Transitions to input state
  AuthState onInput(AuthInput input) => copyWith(
        status: AuthStatus.input(input),
        input: input,
      );

  /// Updates phone input value
  AuthState updatePhone(String phone) {
    final input = this.input.copyWith(phone: phone);
    return copyWith(input: input, status: AuthStatus.input(input));
  }

  /// Updates password input value
  AuthState updatePassword(String password) {
    final input = this.input.copyWith(password: password);
    return copyWith(input: input, status: AuthStatus.input(input));
  }
}

/// UI helper extension with message formatting
extension AuthStateUI on AuthState {
  /// Returns localized error message for form display
  String? getErrorMessageFor({
    required BuildContext context,
    required String fieldKey,
  }) {
    // Check if there's a specific domain error
    if (status is _ErrorStatus) {
      final authError = (status as _ErrorStatus).err;
      // Try to get error message from the AuthError class
      final errorMessage = authError.getMessage(context, key: fieldKey);
      if (errorMessage != null) return errorMessage;
    }

    return null;
  }
}
