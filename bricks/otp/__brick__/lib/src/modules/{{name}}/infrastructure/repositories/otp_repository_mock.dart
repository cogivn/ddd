import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/domain/errors/api_error.dart';
import '../../domain/repositories/otp_repository.dart';
import '../../domain/models/otp_request.dart';
import '../../../../common/utils/app_environment.dart';
import '../../domain/entities/mobile_verification.dart';
import '../../domain/entities/otp_verification.dart';
import '../dtos/mobile_verification_dto.dart';
import '../dtos/otp_verification_dto.dart';

/// Mock implementation of OTP repository for testing purposes
@alpha
@LazySingleton(as: OtpRepository)
class OtpRepositoryMock implements OtpRepository {
  PostVerificationFunction? _postVerificationFunction;
  VerifyOtpFunction? _customVerifyOtpFunction;

  @override
  void setPostVerificationFunction(PostVerificationFunction? function) {
    _postVerificationFunction = function;
  }

  @override
  void setVerifyOtpFunction(VerifyOtpFunction? function) {
    _customVerifyOtpFunction = function;
  }

  /// Simulates validating a phone number and sending an OTP
  @override
  Future<ResultDart<MobileVerification, ApiError>> validatePhone(
      OtpRequest request,
      {CancelToken? token}) async {
    // Simulate a short delay like a network call would have
    await Future.delayed(const Duration(milliseconds: 300));

    // Simulate validation - reject specific test numbers
    if (request.phoneNumber.value == '+1111111111') {
      return Failure(
        ApiError.server(
          message: 'Invalid phone number format',
          code: 400,
        ),
      );
    }

    // Return successful result for valid numbers
    return Success(
      const MobileVerificationDto(
       mobileToken: '1234'
      ),
    );
  }

  /// Simulates verifying an OTP code
  @override
  Future<ResultDart<OtpVerification, ApiError>> verifyOtp(OtpRequest request,
      {CancelToken? token}) async {
    final customFn = _customVerifyOtpFunction;
    if (customFn != null) {
      return await customFn(request, token: token);
    }
    await Future.delayed(const Duration(milliseconds: 300));
    final code = request.whenOrNull(verify: (_, code, __) => code);
    // Simulate verification - accept only specific code for testing
    if (code?.value != '1234') {
      return Failure(
        ApiError.server(
          message: 'Invalid verification code',
          code: 400,
        ),
      );
    }
    // Return successful result for correct code
    final verification = const OtpVerificationDto(
      status: true,
      message: 'Phone number verified successfully',
      verified: true,
    );
    // Call post-verification function if set
    if (_postVerificationFunction == null) {
      return Success(verification);
    }
    try {
      final result = await _postVerificationFunction!(verification);
      return result;
    } catch (e) {
      return Failure(ApiError.internal(e.toString()));
    }
  }

  /// Simulates resending an OTP to a phone number
  @override
  Future<ResultDart<MobileVerification, ApiError>> resendOtp(OtpRequest request,
      {CancelToken? token}) async {
    // Simulate a short delay like a network call would have
    await Future.delayed(const Duration(milliseconds: 250));

    // Simulate limit on resends for certain numbers
    if (request.phoneNumber.value == '+2222222222') {
      return Failure(
        ApiError.server(
          message: 'Too many OTP requests for this number',
          code: 429,
        ),
      );
    }

    // Simulate resending OTP
    return Success(
      const MobileVerificationDto(
        mobileToken: '1234'
      ),
    );
  }
}
