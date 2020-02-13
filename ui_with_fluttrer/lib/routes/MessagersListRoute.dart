import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ui_with_fluttrer/common/AsyncMessageListener.dart';
import 'package:ui_with_fluttrer/common/Global.dart';
import 'package:ui_with_fluttrer/components/MessagerItem.dart';
import 'package:ui_with_fluttrer/models/index.dart';
import 'package:ui_with_fluttrer/routes/CityInfoSelectorRoute.dart';

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

  User user = Global.getUser();

  int _selectedIndex = 0;

  @override
  void initState() {
    streamSubscription = AsyncMessageListener.messageSc.stream.listen((data) {
      if (data == "MESSAGE_RECEIVED") {
        setState(() {});
      }
    });

    if (AsyncMessageListener.messagersForSave.isEmpty) {
      //自己的信息置顶
      AsyncMessageListener.messagersForSave.add(new MessagerItem(
        user: Global.user,
      ));
      //初始需要获取本地聊天列表
    }
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
          itemCount: AsyncMessageListener.messagersForSave.length,
          // Provide a builder function. This is where the magic happens.
          // Convert each item into a widget based on the type of item it is.
          itemBuilder: (context, index) {
            final item = AsyncMessageListener.messagersForSave[index];
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
}
