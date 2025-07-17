import 'package:json_annotation/json_annotation.dart';
import '../value_objects/phone_number.dart';

/// A JsonConverter that converts between PhoneNumber value object and String
///
/// This allows PhoneNumber value objects to be used directly in freezed classes
/// with proper serialization/deserialization support.
class PhoneNumberConverter implements JsonConverter<PhoneNumber, String> {
  /// Default constructor
  const PhoneNumberConverter();

  @override
  PhoneNumber fromJson(String json) {
    return PhoneNumber(json);
  }

  @override
  String toJson(PhoneNumber object) {
    return object.value;
  }
}

/// A nullable JsonConverter for PhoneNumber value object
class NullablePhoneNumberConverter implements JsonConverter<PhoneNumber?, String?> {
  /// Default constructor
  const NullablePhoneNumberConverter();

  @override
  PhoneNumber? fromJson(String? json) {
    if (json == null || json.isEmpty) {
      return null;
    }
    try {
      return PhoneNumber(json);
    } catch (_) {
      return null;
    }
  }

  @override
  String? toJson(PhoneNumber? object) {
    return object?.value;
  }
}