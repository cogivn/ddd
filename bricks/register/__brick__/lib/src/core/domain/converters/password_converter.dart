import 'package:json_annotation/json_annotation.dart';
import '../value_objects/value_objects.dart';

/// A JsonConverter that converts between Password and String
///
/// This allows Password value objects to be used directly in freezed classes
/// with proper serialization/deserialization support.
/// Note: This converter handles the Password domain object with proper validation.
class PasswordConverter implements JsonConverter<Password, String> {
  /// Default constructor
  const PasswordConverter();

  @override
  Password fromJson(String json) {
    return Password(json);
  }

  @override
  String toJson(Password object) {
    return object.value;
  }
}

/// A nullable JsonConverter for Password
class NullablePasswordConverter implements JsonConverter<Password?, String?> {
  /// Default constructor
  const NullablePasswordConverter();

  @override
  Password? fromJson(String? json) {
    if (json == null || json.isEmpty) {
      return null;
    }
    try {
      return Password(json);
    } catch (_) {
      return null;
    }
  }

  @override
  String? toJson(Password? object) {
    return object?.value;
  }
}