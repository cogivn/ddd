/// Interface for mobile verification response in domain layer
abstract class MobileVerification {
  /// OTP token received from server
  String? get mobileToken;
}