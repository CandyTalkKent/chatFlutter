import 'package:flutter/material.dart';
import 'package:ui_with_fluttrer/models/User.dart';

class MessagerItem extends StatelessWidget {
  User user;

  MessagerItem({this.user});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Container(
                decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white),
                child: Image.asset(
                  "images/WechatIMG1.jpeg",
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(user.userName),
              subtitle: Text('last message'),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
