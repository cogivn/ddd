import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/domain/converters/phone_number_converter.dart';
import '../../../../core/domain/value_objects/phone_number.dart';

part 'register_request.freezed.dart';
part 'register_request.g.dart';

/// Request model for the registration process
@freezed
sealed class RegisterRequest with _$RegisterRequest {
  const RegisterRequest._();

  /// Creates a registration request with validated phone number and mobile token
  ///
  /// This is the final step of registration after phone number validation and OTP verification
  const factory RegisterRequest.register({
    /// The verified phone number
    @PhoneNumberConverter()
    @JsonKey(name: 'mobile_number')
    required PhoneNumber phoneNumber,
    
    /// The mobile token from OTP verification process
    @JsonKey(name: 'mobile_token')
    required String mobileToken,
    
    /// User's password
    @JsonKey(name: 'password')
    required String password,
    
    /// Push notification token for the device
    @JsonKey(name: 'push_token')
    String? pushToken,
  }) = RegisterWithPhoneRequest;

  /// Creates a RegisterRequest from JSON
  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
}