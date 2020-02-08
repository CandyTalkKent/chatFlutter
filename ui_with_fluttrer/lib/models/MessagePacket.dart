import 'package:json_annotation/json_annotation.dart';

part 'MessagePacket.g.dart';

@JsonSerializable()
class MessagePacket {
    MessagePacket();

    String command;
    String message;
    Map<String,dynamic> fromUser;
    Map<String,dynamic> toUser;
    
    factory MessagePacket.fromJson(Map<String,dynamic> json) => _$MessagePacketFromJson(json);
    Map<String, dynamic> toJson() => _$MessagePacketToJson(this);
}
