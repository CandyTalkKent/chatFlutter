import 'dart:async';
import 'dart:convert';

import 'package:ui_with_fluttrer/components/MessageWrap.dart';
import 'package:ui_with_fluttrer/components/MessagerItem.dart';
import 'package:ui_with_fluttrer/models/User.dart';

import 'Global.dart';
import 'MessageFileHelper.dart';

class AsyncMessageListener {
  StreamSubscription streamSubscription;
  static StreamController messageSc =StreamController.broadcast();
  static List<MessagerItem> messagersForSave = new List<MessagerItem>();

  AsyncMessageListener() {
    //启动的时候 构造messageForSave 列表  //从本地列表中读取




    //开启对消息的监听
    streamSubscription = Global.getStreamController().stream.listen((data) {
      Map<String, dynamic> jsonObject = json.decode(data);
      if (jsonObject["resCode"] == "200" && jsonObject["type"] == "2") {
        //说明是来信
        Map fromUserJson = jsonObject["data"]["fromUser"];
        String text = jsonObject["data"]["message"];

        MessageWrap messageWrap = new MessageWrap(
            user: User.fromJson(fromUserJson), text: text, selfFlag: false);

        //入库
        MessageFileHelper.saveMessage(messageWrap, User.fromJson(fromUserJson));

        User user = User.fromJson(fromUserJson);
        if (user.userId != Global.user.userId) {
          //如果不是自己的信息才需要刷新
          MessagerItem messagerItem = new MessagerItem(
            user: User.fromJson(fromUserJson),
            lastMessage: text,
          );

          if (!judgeMessageItemExistInList(
              AsyncMessageListener.messagersForSave, user.userId)) {
            addMessage(messagerItem);
          }

          //刷新lastmessage
          editLastMessage(user, text);
          //通知子组件 更新ui
          messageSc.sink.add("MESSAGE_RECEIVED");

        } else {
          //如果是自己的信息 就刷新last message
          editLastMessage(Global.user, text);
          //通知子组件 更新ui
          messageSc.sink.add("MESSAGE_RECEIVED");
        }
      }
    });
  }

  bool judgeMessageItemExistInList(
      List<MessagerItem> messagersForSave, int userid) {
    for (MessagerItem item in messagersForSave) {
      if (item.user.userId == userid) {
        return true;
      }
    }
    return false;
  }

  void addMessage(MessagerItem messagerItem) {
    AsyncMessageListener.messagersForSave.add(messagerItem);
  }


  void editLastMessage(User user, String text) {
    int index = 0;
    for (MessagerItem item in AsyncMessageListener.messagersForSave) {
      if (item.user.userId == user.userId) {
        AsyncMessageListener.messagersForSave.remove(item);
        MessagerItem messagerItem = new MessagerItem(
          user: user,
          lastMessage: text,
        );
        AsyncMessageListener.messagersForSave.insert(index, messagerItem);
      }
    }
  }



  static void saveMessageList(){
    List<MessageWrap > list = new List<MessageWrap>();

    for(MessagerItem item in AsyncMessageListener.messagersForSave){

      MessageWrap messageWrap = new MessageWrap(
        user: item.user,
        text: item.lastMessage,
      );

      list.add(messageWrap);
    }

    MessageFileHelper.saveMessageList(list, Global.user);
  }
}

