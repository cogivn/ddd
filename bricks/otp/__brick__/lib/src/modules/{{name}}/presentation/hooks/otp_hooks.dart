import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../common/extensions/build_context_x.dart';
import '../../../../common/widgets/widgets.dart';
import '../../../../core/domain/value_objects/value_objects.dart';
import '../../application/otp_notifier/otp_notifier.dart';
import '../../domain/enums/otp_page_type.dart';
import '../../domain/errors/otp_error.dart';

/// Model class encapsulating all state and behavior for OTP verification screen
///
/// This model is returned by the [useOtpVerify] hook and contains everything
/// needed to render and interact with the OTP verification UI.
class OtpVerifyModel {
  /// Creates a model containing all state for OTP verification
  /// 
  /// All parameters are required as they represent crucial state for the verification process
  const OtpVerifyModel({
    required this.otpController,
    required this.focusNode,
    required this.error,
    required this.countdownController,
    required this.isLoading,
    required this.isResendingCode,
    required this.isCodeVerified,
    required this.pageType,
    required this.phoneNumber,
  });

  /// Controller for the OTP input field
  final TextEditingController otpController;
  
  /// Focus node to control focus on the OTP input field
  final FocusNode focusNode;
  
  /// Error message to display when validation fails
  final ValueNotifier<String?> error;
  
  /// Controller for the countdown timer used for resend functionality
  final CountdownController countdownController;
  
  /// Whether a network request is in progress
  final bool isLoading;
  
  /// Whether code is being resent to the phone number
  final bool isResendingCode;
  
  /// Whether the OTP has been successfully verified
  final bool isCodeVerified;
  
  /// The context in which this OTP flow is being used
  final OtpPageType pageType;
  
  /// The phone number to which the OTP was sent
  final String phoneNumber;
}

/// Model class encapsulating all state and behavior for OTP phone entry screen
///
/// This model is returned by the [useOtpPhone] hook and contains everything
/// needed to render and interact with the phone input UI.
class OtpPhoneModel {
  /// Creates a model containing all state for phone number input
  /// 
  /// All parameters are required as they represent crucial state for the phone input process
  const OtpPhoneModel({
    required this.phoneController,
    required this.phoneError,
    required this.isPhoneValid,
    required this.isLoading,
    required this.validatePhone,
    required this.onSubmit,
    required this.pageType,
    required this.isButtonEnabled,
  });

  /// Controller for the phone number input field
  final TextEditingController phoneController;
  
  /// Error message to display when validation fails
  final ValueNotifier<String?> phoneError;
  
  /// Whether the current phone number input is valid
  final ValueNotifier<bool> isPhoneValid;
  
  /// Whether a network request is in progress
  final bool isLoading;
  
  /// Function to validate a phone number input
  final Function(String) validatePhone;
  
  /// Function to submit the phone number for validation
  final VoidCallback onSubmit;
  
  /// The context in which this OTP flow is being used
  final OtpPageType pageType;

  /// Whether the submit button should be enabled
  final ValueNotifier<bool> isButtonEnabled;
}

/// Custom hook that manages OTP phone entry state and validation
///
/// This hook centralizes all logic related to the phone input screen, including:
/// - Phone number validation
/// - Error handling
/// - API communication through Riverpod notifiers
/// - Form submission
///
/// @param ref Riverpod reference to access state providers
/// @param pageType Context specifying where the OTP flow is used (registration, password reset, etc)
/// @return [OtpPhoneModel] containing all state and functions for the UI
OtpPhoneModel useOtpPhone(WidgetRef ref, {required OtpPageType pageType}) {
  // Watch loading state reactively to show UI indicators
  final isLoading = ref.watch(otpProvider.select((s) => s.isLoading));
  final context = useContext();

  // Initialize controllers and mutable state
  final phoneController = useTextEditingController();
  final phoneError = useState<String?>(null);
  final isPhoneValid = useState<bool>(false);
  final isButtonEnabled = useState<bool>(false);

  // Reset OTP state when page is first loaded to ensure clean state
  useEffect(() {
    Future.microtask(() {
      ref.read(otpProvider.notifier).resetOtpState();
    });
    return null; // No cleanup needed
  }, const []); // Empty dependency array means run once on init

  // Listen for error changes from the notifier and update local error state
  useEffect(() {
    final listener = ref.listenManual(
      otpProvider.select((state) => state.status),
      (previous, current) {
        // Extract API errors and update local error state
        phoneError.value = current.whenOrNull(
          error: (err) => err.whenOrNull(
            api: (apiError) => apiError.message,
          ),
        );
      }
    );
    // Return cleanup function to unsubscribe when hook is disposed
    return listener.close;
  }, const []);

  // Listen for changes in the phone input to update button enabled state
  useEffect(() {
    void updateButtonState() {
      isButtonEnabled.value = phoneController.text.isNotEmpty;
    }

    // Set initial state
    updateButtonState();

    // Add listener for text changes
    phoneController.addListener(updateButtonState);

    // Return cleanup function to remove listener
    return () => phoneController.removeListener(updateButtonState);
  }, [phoneController]);

  /// Validates phone number format using domain value object
  ///
  /// Updates local validation state based on the result:
  /// - Clears error and sets valid flag if valid
  /// - Sets error message and invalid flag if invalid
  void validatePhone(String value) {
    try {
      // Attempt to create value object which validates format
      PhoneNumber(value);
      // Phone is valid, clear error and set valid flag
      phoneError.value = null;
      isPhoneValid.value = true;
    } catch (e) {
      // Phone is invalid, set error message and invalid flag
      phoneError.value = context.s.otp_error_invalid_phone;
      isPhoneValid.value = false;
    }
  }

  /// Handles submission of the phone number for validation
  ///
  /// Only proceeds if the phone number is valid,
  /// then calls the notifier to start the validation process
  void onSubmit() {
    // Guard clause: don't proceed if phone is invalid
    if (!isPhoneValid.value) return;

    final phoneNumber = phoneController.text.trim();
    // Call notifier to initiate API call with the phone number
    ref.read(otpProvider.notifier).validatePhoneNumber(
      phoneNumber,
      pageType: pageType,
    );
  }

  // Return model with all the required state and functions
  return OtpPhoneModel(
    phoneController: phoneController,
    phoneError: phoneError,
    isPhoneValid: isPhoneValid,
    isLoading: isLoading,
    validatePhone: validatePhone,
    onSubmit: onSubmit,
    pageType: pageType,
    isButtonEnabled: isButtonEnabled,
  );
}

/// Custom hook that manages OTP verification state and UI interactions
///
/// This hook centralizes all logic related to the OTP verification screen, including:
/// - OTP input handling
/// - Error handling
/// - Countdown timer for resend functionality
/// - Navigation on successful verification
/// - Pre-filling OTP if available
///
/// @param ref Riverpod reference to access state providers
/// @return [OtpVerifyModel] containing all state and functions for the UI
OtpVerifyModel useOtpVerify(WidgetRef ref) {
  // Watch state selectively using select() for optimal performance
  final input = ref.watch(otpProvider.select((s) => s.input));
  final isLoading = ref.watch(otpProvider.select((s) => s.isLoading));
  final isResendingCode = ref.watch(otpProvider.select((s) => s.isResendingCode));
  final isCodeVerified = ref.watch(otpProvider.select((s) => s.isCodeVerified));

  // Initialize controllers and mutable state
  final otpController = useTextEditingController();
  final focusNode = useFocusNode();
  final error = useState<String?>(null);
  final countdownController = useCountdownController(autoStart: true);

  // Handle OTP resend: clear field, restart countdown timer, and focus input
  useEffect(() {
    if (!isLoading && isResendingCode) {
      otpController.clear();
      focusNode.requestFocus();
      countdownController.restart();
    }
    return null; // No cleanup needed
  }, [isLoading, isResendingCode]);

  // Handle successful verification by navigating back with result
  useEffect(() {
    void checkAndNavigate() {
      if (!isLoading &&
          isCodeVerified &&
          navigatorKey.currentContext?.mounted == true) {
        // Return true to indicate successful verification
        navigatorKey.currentContext?.maybePop(true);
      }
    }

    checkAndNavigate();
    return null; // No cleanup needed
  }, [isLoading, isCodeVerified]);

  // Listen for verification errors from the notifier and update local error state
  useEffect(() {
    final listener = ref.listenManual(
      otpProvider.select((state) => state.status),
      (previous, current) {
        // Extract verification errors and API errors for display
        error.value = current.whenOrNull(
          error: (err) => err.whenOrNull(
            verification: (message) => message,
            api: (apiError) => apiError.message,
          ),
        );
      }
    );
    // Return cleanup function to unsubscribe when hook is disposed
    return listener.close;
  }, const []);

  // Pre-fill OTP field if a verification code is available in state
  useEffect(() {
    final mobileToken = input.verificationCode;
    if (mobileToken != null) {
      otpController.text = mobileToken;
    }
    return null; // No cleanup needed
  }, [input.verificationCode]);

  // Return model with all the required state and controllers
  return OtpVerifyModel(
    otpController: otpController,
    focusNode: focusNode,
    error: error,
    countdownController: countdownController,
    isLoading: isLoading,
    isResendingCode: isResendingCode,
    isCodeVerified: isCodeVerified,
    pageType: input.pageType,
    phoneNumber: input.phone,
  );
}