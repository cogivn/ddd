import 'package:flutter/foundation.dart';

/// A value object representing a valid email address.
///
/// This class ensures that all email addresses in the system follow
/// the correct format through validation at creation time.
@immutable
class Email {
  /// The validated email address value
  final String value;

  /// Private constructor for creating an Email instance with validated value
  const Email._internal(this.value);

  /// Creates a new Email instance with validation
  /// 
  /// Throws an [ArgumentError] if the provided email is not valid
  factory Email(String value) {
    if (!isValidEmail(value)) {
      throw ArgumentError('Invalid email format: $value');
    }
    return Email._internal(value);
  }

  /// Creates a new Email instance with the empty string
  factory Email.empty() => const Email._internal('');

  /// Validates if the provided string is a valid email address
  /// 
  /// Returns true if the email format is valid, false otherwise
  static bool isValidEmail(String value) {
    if (value.isEmpty) return false;
    
    const pattern = r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.[a-zA-Z]+$';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Email && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Email($value)';
}