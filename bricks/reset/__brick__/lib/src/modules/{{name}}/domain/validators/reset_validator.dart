import '../../../../core/domain/value_objects/password.dart';
import '../constants/reset_validation_keys.dart';

/// Context object that holds the data to be validated for reset password process
///
/// This class encapsulates all form input values that need validation during
/// the password reset flow, providing a clean way to pass validation data.
/// 
/// Follows MCP-ddd-domain-layer: Use context objects for validation data
class ResetValidationContext {
  /// Creates a validation context for password reset form
  /// 
  /// [phone] The phone number entered by the user
  /// [password] The new password entered by the user
  /// [confirmPassword] The confirmation password entered by the user
  const ResetValidationContext({
    required this.phone,
    required this.password,
    required this.confirmPassword,
  });

  /// Phone number to be validated
  /// 
  /// This should be a properly formatted phone number that has
  /// previously been verified via OTP.
  final String phone;
  
  /// Password to be validated
  /// 
  /// The new password that will replace the user's existing password.
  /// Must meet security requirements defined in isPasswordValid.
  final String password;
  
  /// Confirm password to be validated against password
  /// 
  /// Must exactly match the password field to ensure the user
  /// entered their intended password correctly.
  final String confirmPassword;
}

/// Validator for reset password form inputs
///
/// This utility class provides static methods to validate user input
/// during the password reset process. It follows a functional approach
/// with pure validation functions that don't maintain state.
///
/// Follows MCP-ddd-domain-layer: Implement domain validators for business rules
/// Follows MCP-ddd-validation: Use static methods for pure validation functions
class ResetValidator {
  // Private constructor to prevent instantiation
  ResetValidator._();
  
  /// Minimum length for password
  static const int minPasswordLength = 8;
  
  /// Maximum length for password
  static const int maxPasswordLength = 15;
  
  /// Validates if phone number is not empty
  /// 
  /// Basic validation to ensure a phone number was provided.
  /// More complex phone validation should happen in the OTP flow.
  /// 
  /// [phone] The phone number to validate
  /// 
  /// Returns true if phone is not empty, false otherwise
  static bool isPhoneNotEmpty(String phone) {
    return phone.isNotEmpty;
  }
  
  /// Validates if password meets security requirements
  /// 
  /// Password must meet the following criteria:
  /// - Length between 8-15 characters
  /// - Contains at least one lowercase letter
  /// - Contains at least one uppercase letter
  /// - Contains at least one number
  /// 
  /// Delegates to the Password value object from the core domain layer.
  /// 
  /// [password] The password string to validate
  /// 
  /// Returns true if password meets all requirements, false otherwise
  static bool isPasswordValid(String password) {
    return Password.isValid(password);
  }
  
  /// Validates if confirm password matches password
  /// 
  /// Ensures that the confirmation password matches the original password
  /// and that it also meets all password validity requirements.
  /// 
  /// [password] The original password
  /// [confirmPassword] The confirmation password to compare
  /// 
  /// Returns true if passwords match and are valid, false otherwise
  static bool doPasswordsMatch(String password, String confirmPassword) {
    return password == confirmPassword && Password.isValid(confirmPassword);
  }
  
  /// Gets all validation error field keys
  /// 
  /// Performs all validations and returns a list of field keys
  /// that failed validation. This is used to highlight specific
  /// form fields that need correction.
  /// 
  /// [context] The validation context containing all form values
  /// 
  /// Returns a list of field keys that failed validation
  static List<String> getErrorFields(ResetValidationContext context) {
    final List<String> errorFields = [];
    
    // Validate phone
    if (!isPhoneNotEmpty(context.phone)) {
      errorFields.add(ResetValidationKeys.phone);
    }
    
    // Validate password
    if (!isPasswordValid(context.password)) {
      errorFields.add(ResetValidationKeys.password);
    }
    
    // Validate confirm password
    if (!doPasswordsMatch(context.password, context.confirmPassword)) {
      errorFields.add(ResetValidationKeys.confirmPassword);
    }
    
    return errorFields;
  }
  
  /// Validates if the entire form is valid
  ///
  /// Performs all validations and returns whether the entire form
  /// is valid. This is typically used to enable/disable the submit button.
  ///
  /// [context] The validation context containing all form values
  ///
  /// Returns true if all validations pass, false otherwise
  static bool isResetFormValid(ResetValidationContext context) {
    return isPhoneNotEmpty(context.phone) &&
           isPasswordValid(context.password) &&
           doPasswordsMatch(context.password, context.confirmPassword);
  }
}