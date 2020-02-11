import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ui_with_fluttrer/common/DioUtil.dart';
import 'package:ui_with_fluttrer/common/Global.dart';
import 'package:ui_with_fluttrer/components/ContactItem.dart';
import 'package:ui_with_fluttrer/components/MessagerItem.dart';
import 'package:ui_with_fluttrer/models/index.dart';

class MessagersListRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MessagersList();
  }
}

class MessagersList extends StatefulWidget {
  @override
  MessagersListState createState() => MessagersListState();
}

class MessagersListState extends State<MessagersList> {
  List<MessagerItem> _messagers = new List<MessagerItem>();

  List<ContactItem> _contactList = new List<ContactItem>();

  MessagersListState() {
    if (_messagers.isEmpty) {
      //自己的信息置顶
      _messagers.add(new MessagerItem(
        user: Global.user,
      ));

      //初始需要获取本地聊天列表
    }

    if (_contactList.isEmpty) {
      _contactList.add(new ContactItem(
        user: Global.user,
      ));

      //从服务器获取联系人列表
      var future = DioUtil.get("http://111.231.77.71:8083/contact/list",
          {"userId": Global.user.userId});
      future.then((response) {
        var list = response.data["data"];
        for (var json in list) {
          User user = User.fromJson(json);
          _contactList.add(new ContactItem(
            user: user,
          ));
        }
      });
    }
  }

  User user = Global.getUser();

  int _selectedIndex = 0;

  Widget currentBodyWidget;

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
        fixedColor:  Colors.amberAccent,
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
          itemCount: _messagers.length,
          // Provide a builder function. This is where the magic happens.
          // Convert each item into a widget based on the type of item it is.
          itemBuilder: (context, index) {
            final item = _messagers[index];
            return item;
          });
    }

    //联系人列表
    if (selectedIndex == 1) {
      return ListView.builder(
          // Let the ListView know how many items it needs to build.
          itemCount: _contactList.length,
          // Provide a builder function. This is where the magic happens.
          // Convert each item into a widget based on the type of item it is.
          itemBuilder: (context, index) {
            final item = _contactList[index];
            return item;
          });
    }

    //我的 profile
  }

  Widget _buildAppBar(int selectedIndex) {
    if (selectedIndex == 0) {
      return AppBar(
        backgroundColor: Colors.amberAccent,
        title: Text("博信"),
      );
    }

    if (selectedIndex == 1) {
      return AppBar(
        backgroundColor: Colors.amberAccent,
        title: Text("通讯录"),
      );
    }
  }
}
