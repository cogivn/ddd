// filepath: /Users/norashing/Documents/work/flutter.app.mighty_bush/lib/src/modules/otp/infrastructure/dtos/otp_verification_dto.dart

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/otp_verification.dart';
import '../../domain/models/otp_request.dart';

part 'otp_verification_dto.freezed.dart';
part 'otp_verification_dto.g.dart';

/// DTO for OTP verification response
@freezed
abstract class OtpVerificationDto with _$OtpVerificationDto implements OtpVerification {
  const OtpVerificationDto._();
  
  /// Creates an OTP verification DTO
  const factory OtpVerificationDto({
    /// Whether the request was successful
    required bool status,
    
    /// Message from the server
    required String message,
    
    /// Whether the OTP code was verified successfully
    required bool verified,

    /// Optional user data associated with the verification
    @JsonKey(includeFromJson: true, includeToJson: true) OtpRequest? request,
  }) = _OtpVerificationDto;
  
  /// Creates an OTP verification DTO from JSON
  factory OtpVerificationDto.fromJson(Map<String, dynamic> json) => 
      _$OtpVerificationDtoFromJson(json);
}