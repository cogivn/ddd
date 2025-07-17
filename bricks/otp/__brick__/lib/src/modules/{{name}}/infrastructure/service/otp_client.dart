import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/infrastructure/datasources/remote/api/base/api_response.dart';
import '../../domain/models/otp_request.dart';
import '../dtos/mobile_verification_dto.dart';

part 'otp_client.g.dart';

/// API client for OTP-related operations
@RestApi()
@injectable
abstract class OtpClient {
  /// Factory constructor with Dio injection
  @factoryMethod
  factory OtpClient(Dio dio) = _OtpClient;

  /// Checks if a mobile number is already registered and sends OTP
  @POST('/member_account/check_mobile_no')
  Future<SingleApiResponse<MobileVerificationDto>> validateAndSendOtp(
    @Body() OtpRequest request, {
    @CancelRequest() CancelToken? cancelToken,
  });

  /// Verifies an OTP code sent to mobile number
  @POST('/member_account/verify_mobile_no')
  Future<SingleApiResponse<dynamic>> verifyOtp(
    @Body() OtpRequest request, {
    @CancelRequest() CancelToken? cancelToken,
  });
}
