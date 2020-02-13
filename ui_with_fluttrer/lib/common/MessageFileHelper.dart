import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:ui_with_fluttrer/components/MessageWrap.dart';
import 'package:ui_with_fluttrer/models/User.dart';

import 'Global.dart';

class MessageFileHelper{

  static Future<File> getLocalFile(User user) async {
    // get the path to the document directory.
    String dir = (await getApplicationDocumentsDirectory()).path;
    String toUserId = user.userId.toString();
    String myUserId = Global.user.userId.toString() + "_";
    return new File('$dir/messages_$myUserId$toUserId');
  }


  static Future<String> readMessages(User user) async {
    try {
      File file = await getLocalFile(user);
      String contents = await file.readAsString();
      return contents;
    } on FileSystemException {}
  }


  static Future<Null> saveMessage(MessageWrap messageWrap, User user) async {
    File file = await getLocalFile(user);
    Map jsonObj = MessageWrap.toJson(messageWrap);
    String jsonStr = json.encode(jsonObj);
    String content = jsonStr + "%%";

    await file.writeAsString(content, mode: FileMode.append);
  }



  // message list 消息列表
  static Future<File> getLocalMessagesFile(User mySelf) async {
    // get the path to the document directory.
    String dir = (await getApplicationDocumentsDirectory()).path;
    String userId = mySelf.userId.toString();
    return new File('$dir/messageList_$userId');
  }



  static Future<String> readMessageList(User mySelf) async {
    try {
      File file = await getLocalMessagesFile(mySelf);
      String contents = await file.readAsString();
      return contents;
    } on FileSystemException {}
  }
  static Future<Null> saveMessagerItem(MessageWrap messageWrap, User mySelf) async {
    File file = await getLocalMessagesFile(mySelf);
    Map jsonObj = MessageWrap.toJson(messageWrap);
    String jsonStr = json.encode(jsonObj);
    String content = jsonStr + "%%";

    await file.writeAsString(content, mode: FileMode.append);
  }


  static Future<Null> saveMessageList(List<MessageWrap> messagerList, User mySelf) async {
    File file = await getLocalMessagesFile(mySelf);

    String content = "";
    for(MessageWrap wrap in messagerList){
      Map jsonObj = MessageWrap.toJson(wrap);
      String jsonStr = json.encode(jsonObj)+ "%%";
      content = content + jsonStr;
    }

    await file.writeAsString(content, mode: FileMode.append);
  }





}