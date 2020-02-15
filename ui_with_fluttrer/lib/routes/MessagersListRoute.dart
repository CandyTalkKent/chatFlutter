import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ui_with_fluttrer/common/AsyncMessageListener.dart';
import 'package:ui_with_fluttrer/common/Global.dart';
import 'package:ui_with_fluttrer/components/MessagerItem.dart';
import 'package:ui_with_fluttrer/models/index.dart';
import 'package:ui_with_fluttrer/routes/CityInfoSelectorRoute.dart';
import 'package:ui_with_fluttrer/sqlite/MessageSqliteProvider.dart';

class MessagersListRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    new AsyncMessageListener();
    return MessagersList();
  }
}

class MessagersList extends StatefulWidget {
  @override
  MessagersListState createState() => MessagersListState();
}

class MessagersListState extends State<MessagersList> {
  StreamSubscription streamSubscription;

  static List<MessagerItem> messages = new List<MessagerItem>();

  User user = Global.getUser();

  int _selectedIndex = 0;

  @override
  void initState() {
    //初始化messages
    initMessages();

    //监听消息，并落入sqlite库
    streamSubscription = Global.getStreamController().stream.listen((data) {
      Map<String, dynamic> jsonObject = json.decode(data);
      if (jsonObject["resCode"] == "200" && jsonObject["type"] == "2") {
        //说明是来信
        Map fromUserJson = jsonObject["data"]["fromUser"];
        String text = jsonObject["data"]["message"];
        String fromUserJsonStr = json.encode(fromUserJson);

        User user = User.fromJson(fromUserJson);
        DateTime now = DateTime.now();
        String nowStr = now.toString();
        //sqlite入库
        MessageSqliteProvider.insert(Message(
            fromUserId: user.userId,
            toUserId: Global.getUser().userId,
            text: text,
            time: nowStr,
            fromUserInfo: fromUserJsonStr)); //

        if (user.userId != Global.user.userId) {
          //如果不是自己的信息才需要刷新
          MessagerItem messagerItem = new MessagerItem(
            user: User.fromJson(fromUserJson),
            lastMessage: text,
            lastMessageTime: nowStr,
          );

          if (!judgeMessageItemExistInList(messages, user.userId)) {
            addMessage(messagerItem);
          }

          //刷新lastmessage
          editLastMessage(user, text,nowStr);
          setState(() {
            //排序
          });
        } else {
          //如果是自己的信息 就刷新last message
          editLastMessage(Global.user, text,nowStr);
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    streamSubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(_selectedIndex),
      body: _buildBody(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        // 底部导航
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.comment), title: Text("博信")),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.book), title: Text('通讯录')),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.user), title: Text('我')),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBody(int selectedIndex) {
    //消息列表
    if (selectedIndex == 0) {
      return ListView.builder(
          // Let the ListView know how many items it needs to build.
          itemCount: messages.length,
          // Provide a builder function. This is where the magic happens.
          // Convert each item into a widget based on the type of item it is.
          itemBuilder: (context, index) {
            final item = messages[index];
            return item;
          });
    }

    //联系人列表
    if (selectedIndex == 1) {
      return new ContactInfoSelectRoute();
    }

    //我的 profile
  }

  Widget _buildAppBar(int selectedIndex) {
    if (selectedIndex == 0) {
      return AppBar(
        title: Text("博信"),
      );
    }

    if (selectedIndex == 1) {
      return AppBar(
        title: Text("通讯录"),
      );
    }
  }

  void initMessages() async {
    //从sqlite中捞数据
    Future<List<Message>> future =
        MessageSqliteProvider.getMessageListByToUserId(Global.user.userId);
    future.then((messageList) {
      if(messageList == null){
        return;
      }
      messageList.forEach((message) {
//        MessagerItem messagerItem = new MessagerItem(
//          user: user,
//          lastMessage: text,
//        );
        String fromUserInfoJsonStr = message.fromUserInfo;
        String text = message.text;
        User fromUser = User.fromJson(json.decode(fromUserInfoJsonStr));

        //判断message中是否有该user的信息，并且比较时间进行判断是否更新lastmessage 和time
        dealWithLastMessageAndTime(fromUser, message);
      });


      //对于信息进行排序
      messages.sort((aItem,bItem){
        DateTime aTime = DateTime.parse(aItem.lastMessageTime);
        DateTime bTime = DateTime.parse(bItem.lastMessageTime);
        return aTime.isAfter(bTime)? -1 : 1;
      });


      setState(() {

      });

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
    messages.insert(0, messagerItem);
  }

  void dealWithLastMessageAndTime(User fromUser, Message message) {
    for (MessagerItem item in messages) {
      if (item.user.userId == fromUser.userId) {
        String time = message.time;
        DateTime timeDt = DateTime.parse(time);
        DateTime lastMessageTimeDt = DateTime.parse(item.lastMessageTime);
        if (timeDt.isAfter(lastMessageTimeDt)) {
          //替换操作  只允许来信人的信息只显示一条
          item.lastMessageTime = timeDt.toString();
          item.lastMessage = message.text;
        }
        return;
      }
    }

    //如果没有此人的信息就添加
    MessagerItem messagerItem = new MessagerItem(
      user: fromUser,
      lastMessage: message.text,
      lastMessageTime: message.time,
    );

    messages.add(messagerItem);
  }

  void editLastMessage(User user, String text,String lastMessageTime) {
    int index = 0;
    for (MessagerItem item in messages) {
      if (item.user.userId == user.userId) {
        messages.remove(item);
        MessagerItem messagerItem = new MessagerItem(
          user: user,
          lastMessage: text,
          lastMessageTime: lastMessageTime,
        );
        messages.insert(index, messagerItem);
      }
    }
  }
}
