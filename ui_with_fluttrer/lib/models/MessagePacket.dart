import 'package:json_annotation/json_annotation.dart';
import 'package:ui_with_fluttrer/models/Serializable.dart';
import "User.dart";
part 'MessagePacket.g.dart';

@JsonSerializable()
class MessagePacket extends Serializable{
    MessagePacket();

    String command;
    String message;
    User fromUser;
    User toUser;

    MessagePacket.wrap({this.command,this.message,this.fromUser,this.toUser});
    
    factory MessagePacket.fromJson(Map<String,dynamic> json) => _$MessagePacketFromJson(json);
    Map<String, dynamic> toJson() => _$MessagePacketToJson(this);
}
