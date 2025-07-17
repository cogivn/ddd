import 'package:json_annotation/json_annotation.dart';

/// Enum representing the different contexts in which the OTP flow can be used
///
/// This enum allows the OTP module to be customized for different use cases
/// such as registration, password reset, account updates, or payment card binding.

@JsonEnum(valueField: 'code')
enum OtpPageType {
  /// User registration flow
  registration(1),

  /// Password reset/recovery flow
  forgotPassword(2),

  /// Account information update flow
  updateInfo(3),

  /// Payment card binding flow
  cardBinding(4);

  const OtpPageType(this.code);

  final int code;
}
