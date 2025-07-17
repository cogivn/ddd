
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/mobile_verification.dart';

part 'mobile_verification_dto.freezed.dart';
part 'mobile_verification_dto.g.dart';

/// DTO for mobile verification response
@freezed
abstract class MobileVerificationDto with _$MobileVerificationDto implements MobileVerification {
  const MobileVerificationDto._();
  
  /// Creates a mobile verification DTO
  const factory MobileVerificationDto({
    /// OTP token received from server
    @JsonKey(name: 'mobile_token') String? mobileToken,
  }) = _MobileVerificationDto;

  factory MobileVerificationDto.fromJson(Map<String, dynamic> json) =>
      _$MobileVerificationDtoFromJson(json);
}