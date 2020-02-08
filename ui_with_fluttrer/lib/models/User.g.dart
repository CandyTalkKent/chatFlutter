// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'User.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User()
    ..userId = json['userId'] as String
    ..userName = json['userName'] as String
    ..password = json['password'] as String
    ..phone = json['phone'] as String
    ..userNickName = json['userNickName'] as String
    ..address = json['address'] as String
    ..email = json['email'] as String
    ..homeTown = json['homeTown'] as String;
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userId': instance.userId,
      'userName': instance.userName,
      'password': instance.password,
      'phone': instance.phone,
      'userNickName': instance.userNickName,
      'address': instance.address,
      'email': instance.email,
      'homeTown': instance.homeTown
    };
