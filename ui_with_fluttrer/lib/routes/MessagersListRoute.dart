import 'package:flutter/material.dart';
import 'package:ui_with_fluttrer/components/MessagerItem.dart';
import 'package:ui_with_fluttrer/models/index.dart';

class MessagersListRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: Text("我的联系人"),
      ),
      body: MessagersList(),
    );
  }
}

class MessagersList extends StatefulWidget {
  @override
  MessagersListState createState() => MessagersListState();
}

class MessagersListState extends State<MessagersList> {
  List<MessagerItem> _messagers = new List<MessagerItem>();

  @override
  Widget build(BuildContext context) {
    User user = new User();
    user.userName = "王博";
    _messagers.add(new MessagerItem(user: user));

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
}
