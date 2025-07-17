import '../models/otp_request.dart';

/// Entity representing an OTP verification response
abstract interface class OtpVerification {
  /// Whether the request was successful
  bool get status;
  
  /// Message from the server
  String get message;
  
  /// Whether the OTP code was verified successfully
  bool get verified;

  /// Optional user data associated with the verification
  OtpRequest? get request;
}