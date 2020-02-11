import 'dart:async';

import 'package:ui_with_fluttrer/models/User.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Global {
  static User user;

  static StreamController streamController;

  static WebSocketChannel webSocketChannel;
  static void saveWebSocketChannel(WebSocketChannel webSocketChannel) =>
      Global.webSocketChannel = webSocketChannel;

  static WebSocketChannel getWebSocketChannel() => Global.webSocketChannel;

  static void saveUser(User user) => Global.user = user;

  static User getUser() => Global.user;

  static void saveStreamController(StreamController streamController) =>
      Global.streamController = streamController;

  static StreamController getStreamController() => Global.streamController;
}
