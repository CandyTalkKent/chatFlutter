import 'package:ui_with_fluttrer/models/User.dart';

class MessageWrap {
  User user;
  String text;
  bool selfFlag;

  MessageWrap({this.user, this.text, this.selfFlag});

  static MessageWrap fromJson(Map<String, dynamic> json) {
    return MessageWrap()
      ..user = json['user'] as User
      ..text = json['text'] as String
      ..selfFlag = json['selfFlag'] as bool;
  }

  static Map<String, dynamic> toJson(MessageWrap instance) => <String, dynamic>{
    'user': instance.user,
    'text': instance.text,
    'selfFlag': instance.selfFlag,
  };
}