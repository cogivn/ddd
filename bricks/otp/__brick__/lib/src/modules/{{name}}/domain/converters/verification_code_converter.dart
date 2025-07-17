import 'package:json_annotation/json_annotation.dart';
import '../value_objects/verification_code.dart';

/// A JsonConverter that converts between VerificationCode value object and String
///
/// This allows VerificationCode value objects to be used directly in freezed classes
/// with proper serialization/deserialization support.
class VerificationCodeConverter implements JsonConverter<VerificationCode, String> {
  /// Default constructor
  const VerificationCodeConverter();

  @override
  VerificationCode fromJson(String json) {
    return VerificationCode(json);
  }

  @override
  String toJson(VerificationCode object) {
    return object.value;
  }
}

/// A nullable JsonConverter for VerificationCode value object
class NullableVerificationCodeConverter implements JsonConverter<VerificationCode?, String?> {
  /// Default constructor
  const NullableVerificationCodeConverter();

  @override
  VerificationCode? fromJson(String? json) {
    if (json == null || json.isEmpty) {
      return null;
    }
    try {
      return VerificationCode(json);
    } catch (_) {
      return null;
    }
  }

  @override
  String? toJson(VerificationCode? object) {
    return object?.value;
  }
}