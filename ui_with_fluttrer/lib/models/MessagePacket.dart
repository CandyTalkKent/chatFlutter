import 'package:json_annotation/json_annotation.dart';
import "User.dart";
part 'MessagePacket.g.dart';

@JsonSerializable()
class MessagePacket {
    MessagePacket();

    String command;
    String message;
    User fromUser;
    User toUser;
    
    factory MessagePacket.fromJson(Map<String,dynamic> json) => _$MessagePacketFromJson(json);
    Map<String, dynamic> toJson() => _$MessagePacketToJson(this);
}
