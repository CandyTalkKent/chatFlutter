// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LoginRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) {
  return LoginRequest()
    ..user = json['user']
    ..password = json['password'] as String;
}

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{'user': instance.user, 'password': instance.password};
