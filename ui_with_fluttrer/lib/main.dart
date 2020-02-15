import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui_with_fluttrer/common/LoginFileHelper.dart';
import 'package:ui_with_fluttrer/common/PacketEncode.dart';
import 'package:ui_with_fluttrer/routes/LoginRoute.dart';
import 'package:ui_with_fluttrer/routes/MessagersListRoute.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'common/Global.dart';
import 'models/LoginRequest.dart';
import 'models/User.dart';

void main() {
  //连接netty 后台服务端进行长连接
  WidgetsFlutterBinding.ensureInitialized();
//  runApp(new FriendlychatApp());
  WebSocketChannel channel =
  IOWebSocketChannel.connect('ws://111.231.77.71:8081/websocket');

  StreamController<String> sc = StreamController<String>.broadcast();

  channel.stream.listen((data) {
    //将websocket包装为broadcast  （如果有更好的方式可以改进）
    sc.add(data);
  }, onDone: () {
    print("连接断开!!!");
  });


  Global.saveWebSocketChannel(channel);
  Global.saveStreamController(sc);
  judgeAutoLogin().then((canLogin) {
    print(canLogin);
    runApp(new FriendlychatApp(
      canLogin: canLogin,
    ));
  });
}

Future<bool> judgeAutoLogin() async {
  String loginInfoStr = await LoginFileHelper.readLoginInfo();

  //获取本地login信息如果有user，设置Global user 信息 并返回true
  if (loginInfoStr == null) {
    return false;
  }

  List<String> strs = loginInfoStr.split(LoginFileHelper.splitSymbol);
  var user = json.decode(strs[0]);
  Global.saveUser(User.fromJson(user));

  //登陆
  //连接netty 后台服务端进行长连接

  var loginRequest = LoginRequest.wrap(user: User.fromJson(user), password: strs[1]);

  Uint8List bytes = PacketEncode.encode(
      loginRequest, LoginRequest.login, LoginRequest.algorithm);

  Global.getWebSocketChannel().sink.add(bytes);

  return true;
}

final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400],
);

class FriendlychatApp extends StatelessWidget {
  bool canLogin;

  FriendlychatApp({this.canLogin});

  @override
  Widget build(BuildContext context) {
    //自动登陆逻辑
    return new MaterialApp(
        title: "Friendlychat",
        theme: kIOSTheme,
        home: WillPopScope(
          onWillPop: () async {
            //发起请求 删除服务端连接
            print("应用程序退出");
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            Global.getStreamController().close();
          },
          child: Scaffold(
//            body: new LoginRoute(),
            body: canLogin ? new MessagersListRoute() : new LoginRoute(),
          ),
        ));
  }
}
