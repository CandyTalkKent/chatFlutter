import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ui_with_fluttrer/routes/LoginRoute.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'common/Global.dart';

void main() {
  //连接netty 后台服务端进行长连接
  WebSocketChannel channel =
      IOWebSocketChannel.connect('ws://111.231.77.71:8081/websocket');

  StreamController<String> sc = StreamController<String>.broadcast();


  channel.stream.listen((data){
    //将websocket包装为broadcast  （如果有更好的方式可以改进）
    sc.add(data);
  },onDone: (){
    print("连接断开!!!");
  });

  Global.saveWebSocketChannel(channel);
  Global.saveStreamController(sc);
  runApp(new FriendlychatApp());
}

//final ThemeData kIOSTheme = new ThemeData(
//  primarySwatch: Colors.orange,
//  primaryColor: Colors.grey[100],
//  primaryColorBrightness: Brightness.light,
//);
//
//final ThemeData kDefaultTheme = new ThemeData(
//  primarySwatch: Colors.purple,
//  accentColor: Colors.orangeAccent[400],
//);

class FriendlychatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "Friendlychat",
        home: WillPopScope(
          onWillPop:() async{
            //发起请求 删除服务端连接

            Global.getStreamController().close();
          },
          child: Scaffold(
            body: new LoginRoute(),
          ),
        ));
  }


}
