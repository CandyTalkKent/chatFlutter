import 'package:flutter/material.dart';
import 'package:ui_with_fluttrer/common/Global.dart';
import 'package:ui_with_fluttrer/models/User.dart';
import 'package:ui_with_fluttrer/routes/ChatScreenRoute.dart';

class MessagerItem extends StatelessWidget {
  User user;

  String lastMessage;

  String lastMessageTime;

  MessagerItem({this.user,this.lastMessage,this.lastMessageTime}): assert (lastMessageTime != null);


//  ClipRRect( //剪裁为圆角矩形
//  borderRadius: BorderRadius.circular(5.0),
//  child: avatar,
//  ),
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Image.asset(
                    "images/WechatIMG1.jpeg",
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(Global.getUser().userName == user.userName
                  ? "我"
                  : user.userName),
              subtitle: Text(lastMessage??""),
              onTap: () => _dealWithTap(context),
            ),
          ],
        ),
      ),
    );
    ;
  }

  void _dealWithTap(BuildContext context) {
    Navigator.push(context, new MaterialPageRoute(builder: (context) {
      return new ChatScreenRoute(user: user,);
    }));
  }
}
