import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../src/core/domain/value_objects/phone_number.dart';
import '../../../../core/domain/converters/phone_number_converter.dart';

part 'reset_request.freezed.dart';
part 'reset_request.g.dart';

/// Request model for resetting password
///
/// This model represents the data required to make a password reset request
/// to the API. It encapsulates all necessary parameters for the password
/// reset endpoint and provides proper JSON serialization.
///
/// Follows the API specification for the /member_account/resetPassword endpoint
/// Follows MCP-ddd-domain-layer: Use value objects for domain primitives
@freezed
abstract class ResetPasswordRequest with _$ResetPasswordRequest {
  /// Creates a request to reset password
  /// 
  /// This factory constructor creates a properly structured password reset request
  /// for the API with all required fields properly named for serialization.
  /// 
  /// [phoneNumber] The verified phone number of the user requesting password reset
  /// [mobileToken] The verification token received during OTP verification process
  /// [password] The new password to set for the user's account
  /// 
  /// Note: Additional fields like app_version, api_version, and mobile_kind
  /// are automatically added by DefaultFieldsInterceptor
  factory ResetPasswordRequest({
    @PhoneNumberConverter()
    @JsonKey(name: 'mobile_number')
    required PhoneNumber phoneNumber,

    @JsonKey(name: 'mobile_token')
    required String mobileToken,

    @JsonKey(name: 'password')
    required String password,
  }) = _ResetPasswordRequest;

  /// Factory for JSON deserialization
  /// 
  /// This is used for deserialization from the API response.
  /// Generally not used directly but required for Freezed.
  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestFromJson(json);
}