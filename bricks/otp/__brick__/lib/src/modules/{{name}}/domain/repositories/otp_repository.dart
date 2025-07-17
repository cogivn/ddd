import 'package:dio/dio.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/domain/errors/api_error.dart';
import '../entities/mobile_verification.dart';
import '../entities/otp_verification.dart';
import '../models/otp_request.dart';

/// Type definition for post-verification function
/// 
/// This function takes an [OtpVerification] and returns a [ResultDart] with either:
/// - Success: Modified [OtpVerification]
/// - Failure: [ApiError] if post-verification fails
typedef PostVerificationFunction = Future<ResultDart<OtpVerification, ApiError>> Function(OtpVerification);

/// Type definition for custom verify OTP function
///
/// This function takes an [OtpRequest] and returns a [ResultDart] with either:
/// - Success: [OtpVerification]
/// - Failure: [ApiError] if verification fails
typedef VerifyOtpFunction = Future<ResultDart<OtpVerification, ApiError>> Function(OtpRequest, {CancelToken? token});

/// Repository interface for OTP operations
abstract class OtpRepository {
  /// Sets a post-verification function that will be called after successful OTP verification
  /// 
  /// The function takes an [OtpVerification] and returns a [ResultDart] with either:
  /// - Success: Modified [OtpVerification]
  /// - Failure: [ApiError] if post-verification fails
  void setPostVerificationFunction(PostVerificationFunction? function);

  /// Sets a custom verify OTP function that will be called instead of the default logic
  ///
  /// The function takes an [OtpRequest] and returns a [ResultDart] with either:
  /// - Success: [OtpVerification]
  /// - Failure: [ApiError] if verification fails
  void setVerifyOtpFunction(VerifyOtpFunction? function);

  /// Validates a phone number and initiates the OTP verification process
  ///
  /// Takes a [request] containing the phone number and page type to validate.
  /// Optionally accepts a [token] for request cancellation.
  ///
  /// Returns a [ResultDart] containing either:
  /// - Success: [MobileVerification] with validation status and metadata
  /// - Failure: [ApiError] with error details if validation fails
  ///
  /// The validation process includes:
  /// 1. Format and validity checking of the phone number
  /// 2. Sending OTP code to the provided number if valid
  /// 3. Returning verification metadata needed for subsequent steps
  Future<ResultDart<MobileVerification, ApiError>> validatePhone(
    OtpRequest request, {
    CancelToken? token,
  });

  /// Verifies an OTP code sent to a phone number
  ///
  /// Takes a [request] containing:
  /// - Phone number that received the code
  /// - Verification code entered by the user
  /// - Page type for context
  ///
  /// Optionally accepts a [token] for request cancellation.
  ///
  /// Returns a [ResultDart] containing either:
  /// - Success: [OtpVerification] with verification status and user data
  /// - Failure: [ApiError] with error details if verification fails
  ///
  /// The verification process:
  /// 1. Validates the provided OTP code format
  /// 2. Checks the code against the one sent to the phone number
  /// 3. Returns verification result with associated user data if successful
  Future<ResultDart<OtpVerification, ApiError>> verifyOtp(
    OtpRequest request, {
    CancelToken? token,
  });

  /// Resends an OTP code to a previously validated phone number
  ///
  /// Takes a [request] containing the phone number and page type for resending OTP.
  /// Optionally accepts a [token] for request cancellation.
  ///
  /// Returns a [ResultDart] containing either:
  /// - Success: [MobileVerification] with new verification metadata
  /// - Failure: [ApiError] with error details if resend fails
  ///
  /// The resend process:
  /// 1. Validates that the number is eligible for OTP resend
  /// 2. Generates and sends a new OTP code
  /// 3. Returns updated verification metadata
  ///
  /// Note: May have rate limiting or maximum resend attempts depending on server configuration
  Future<ResultDart<MobileVerification, ApiError>> resendOtp(
    OtpRequest request, {
    CancelToken? token,
  });
}
