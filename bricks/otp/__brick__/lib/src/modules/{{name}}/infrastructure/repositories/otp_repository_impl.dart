import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../common/utils/app_environment.dart';
import '../../../../core/domain/errors/api_error.dart';
import '../../../../core/infrastructure/datasources/remote/api/api_client.dart';
import '../../domain/entities/mobile_verification.dart';
import '../../domain/entities/otp_verification.dart';
import '../../domain/models/otp_request.dart';
import '../../domain/repositories/otp_repository.dart';
import '../dtos/otp_verification_dto.dart';
import '../service/otp_client.dart';

/// Implementation of the OTP repository interface
@LazySingleton(
  as: OtpRepository,
  env: AppEnvironment.environments,
)
class OtpRepositoryImpl implements OtpRepository {
  final OtpClient _client;
  PostVerificationFunction? _postVerificationFunction;
  VerifyOtpFunction? _customVerifyOtpFunction;

  /// Constructor with OTP client dependency
  OtpRepositoryImpl(this._client);

  @override
  void setPostVerificationFunction(PostVerificationFunction? function) {
    _postVerificationFunction = function;
  }

  @override
  void setVerifyOtpFunction(VerifyOtpFunction? function) {
    _customVerifyOtpFunction = function;
  }

  @override
  Future<ResultDart<MobileVerification, ApiError>> validatePhone(
      OtpRequest request,
      {CancelToken? token}) async {
    try {
      // Return result directly from the API client
      return _client
          .validateAndSendOtp(request, cancelToken: token)
          .tryGet((result) => result.data);
    } catch (e) {
      return Failure(ApiError.internal(
        'Failed to validate phone number: ${e.toString()}',
      ));
    }
  }

  @override
  Future<ResultDart<OtpVerification, ApiError>> verifyOtp(
    OtpRequest request, {
    CancelToken? token,
  }) async {
    try {
      final customFn = _customVerifyOtpFunction;
      if (customFn != null) {
        return await customFn(request, token: token);
      }
      final verificationResult = await _client
          .verifyOtp(request, cancelToken: token)
          .tryGet(
            (response) => OtpVerificationDto(
              request: request,
              status: response.result.code == 200,
              message: response.getLocalizedMessageFromCurrentLocale() ?? '',
              verified: response.result.code == 200,
            ),
          );
      final postVerificationFunction = _postVerificationFunction;
      if (postVerificationFunction == null) {
        return verificationResult;
      }
      return verificationResult
          .toAsyncResult()
          .flatMap(postVerificationFunction);
    } catch (e) {
      return Failure(ApiError.internal(e.toString()));
    }
  }

  @override
  Future<ResultDart<MobileVerification, ApiError>> resendOtp(OtpRequest request,
      {CancelToken? token}) async {
    try {
      // Return result directly from the API client
      return await _client
          .validateAndSendOtp(request, cancelToken: token)
          .tryGet((result) => result.data);
    } catch (e) {
      return Failure(ApiError.internal(
        'Failed to resend OTP: ${e.toString()}',
      ));
    }
  }
}
