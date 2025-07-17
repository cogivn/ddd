import 'package:flutter/foundation.dart';
import '../utils/phone_validator.dart';
import '../../../../../../generated/l10n.dart';

/// Value object representing a valid phone number
///
/// This shared PhoneNumber value object is used across the application
/// for phone number validation, formatting, and representation.
@immutable
class PhoneNumber {
  /// The validated phone number string
  final String value;

  /// Private constructor to enforce validation through factory constructor
  const PhoneNumber._internal(this.value);

  /// Creates a phone number value object with validation
  ///
  /// Throws [ArgumentError] if the phone number format is invalid
  ///
  /// By default, validates phone number using international format
  /// which allows for country codes with + prefix
  factory PhoneNumber(String value, {String? validationErrorKey}) {
    // Clean the phone number first
    final cleanedValue = PhoneValidator.cleanPhoneNumber(value);

    if (cleanedValue.isEmpty) {
      throw ArgumentError(
        S.current.auth_phone_empty,
        validationErrorKey,
      );
    }

    if (!PhoneValidator.isValidInternational(cleanedValue)) {
      throw ArgumentError(
        S.current.auth_phone_invalid_format,
        validationErrorKey,
      );
    }

    return PhoneNumber._internal(cleanedValue);
  }

  /// Creates a phone number with local validation rules (8-11 digits)
  ///
  /// This constructor uses the validation rules for local phone numbers
  /// without international country codes
  factory PhoneNumber.local(String value, {String? validationErrorKey}) {
    // Clean the phone number by removing all non-numeric characters
    final cleanedValue = value.replaceAll(RegExp(r'\D'), '');

    if (cleanedValue.isEmpty) {
      throw ArgumentError(
        S.current.auth_phone_empty,
        validationErrorKey,
      );
    }

    if (!PhoneValidator.isValidLocal(cleanedValue)) {
      throw ArgumentError(
        S.current.auth_phone_invalid_format,
        validationErrorKey,
      );
    }

    return PhoneNumber._internal(cleanedValue);
  }

  /// Safely creates a PhoneNumber without throwing exceptions
  ///
  /// Returns null if the provided value is invalid
  static PhoneNumber? tryCreate(String? value) {
    try {
      return PhoneNumber(value ?? '');
    } catch (_) {
      return null;
    }
  }

  /// Validates if the provided value is a valid phone number
  static bool isValid(String value) {
    return PhoneValidator.isValidInternational(value);
  }

  /// Formats the phone number for display using standardized formatting
  String format() {
    return PhoneValidator.format(value);
  }

  @override
  String toString() => value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PhoneNumber && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
