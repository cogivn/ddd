import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/domain/converters/phone_number_converter.dart';
import '../../../../core/domain/value_objects/value_objects.dart';
import '../../../../core/domain/converters/password_converter.dart';

part 'auth_request.freezed.dart';
part 'auth_request.g.dart';

/// Login request model for authentication
@freezed
abstract class LoginRequest with _$LoginRequest {
  const LoginRequest._();

  /// Creates a login request with the required parameters
  const factory LoginRequest({
    /// The phone number for authentication
    @PhoneNumberConverter() required PhoneNumber mobileNumber,
    
    /// The password for authentication
    @PasswordConverter() required Password password,
    
    /// Optional push notification token
    @Default('') String? pushToken,
  }) = _LoginRequest;
  
  /// Creates a LoginRequest from JSON map
  factory LoginRequest.fromJson(Map<String, dynamic> json) => 
      _$LoginRequestFromJson(json);
}

/// Request model for updating user profile
///
/// This model matches the API requirements for the `/member_account/update` endpoint.
/// Follows MCP-ddd-domain-layer: Define request models for API operations
@freezed
abstract class UpdateProfileRequest with _$UpdateProfileRequest {
  const UpdateProfileRequest._();

  /// Creates an update profile request with the parameters allowed by the API
  const factory UpdateProfileRequest({
    /// User's title (1: Mr, 2: Mrs, 3: Ms)
    @JsonKey(name: 'title') String? title,
    
    /// User's first name
    @JsonKey(name: 'first_name') String? firstName,
    
    /// User's last name
    @JsonKey(name: 'last_name') String? lastName,
    
    /// User's mobile number (8-digit format)
    @JsonKey(name: 'mobile_number') String? mobileNumber,
    
    /// SMS verification token (required when updating mobile number)
    @JsonKey(name: 'mobile_token') String? mobileToken,
    
    /// User's email address
    @JsonKey(name: 'email') String? email,
    
    /// Shell bonus card number
    @JsonKey(name: 'shell_bonus_card_number') String? shellBonusCardNumber,
    
    /// Donation receipt name
    @JsonKey(name: 'donation_receipt_name') String? donationReceiptName,
    
    /// Donation receipt address
    @JsonKey(name: 'donation_receipt_address') String? donationReceiptAddress,
  }) = _UpdateProfileRequest;
  
  /// Creates an UpdateProfileRequest from JSON map
  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) => 
      _$UpdateProfileRequestFromJson(json);
}