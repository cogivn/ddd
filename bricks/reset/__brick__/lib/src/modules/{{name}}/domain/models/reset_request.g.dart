// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ResetPasswordRequest _$ResetPasswordRequestFromJson(
        Map<String, dynamic> json) =>
    _ResetPasswordRequest(
      phoneNumber: const PhoneNumberConverter()
          .fromJson(json['mobile_number'] as String),
      mobileToken: json['mobile_token'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$ResetPasswordRequestToJson(
        _ResetPasswordRequest instance) =>
    <String, dynamic>{
      'mobile_number':
          const PhoneNumberConverter().toJson(instance.phoneNumber),
      'mobile_token': instance.mobileToken,
      'password': instance.password,
    };
