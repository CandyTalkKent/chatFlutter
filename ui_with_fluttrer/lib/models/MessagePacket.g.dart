// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MessagePacket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessagePacket _$MessagePacketFromJson(Map<String, dynamic> json) {
  return MessagePacket()
    ..command = json['command'] as String
    ..message = json['message'] as String
    ..fromUser = json['fromUser'] as Map<String, dynamic>
    ..toUser = json['toUser'] as Map<String, dynamic>;
}

Map<String, dynamic> _$MessagePacketToJson(MessagePacket instance) =>
    <String, dynamic>{
      'command': instance.command,
      'message': instance.message,
      'fromUser': instance.fromUser,
      'toUser': instance.toUser
    };
