import 'package:flutter/foundation.dart';
//import 'package:ui_with_fluttrer/models/index.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:typed_data';
import 'dart:convert';

//void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'WebSocket Demo';
    return MaterialApp(
      title: title,
      home: MyHomePage(
        title: title,
        channel:
            IOWebSocketChannel.connect('ws://111.231.77.71:8081/websocket'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final WebSocketChannel channel;

  MyHomePage({Key key, @required this.title, @required this.channel})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(labelText: 'Send a message'),
              ),
            ),
            StreamBuilder(
              stream: widget.channel.stream,
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Text(
                      snapshot.hasData ? _showServerData(snapshot.data) : ''),
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _sendMessage() {
//    if (_controller.text.isNotEmpty) {
//      var messagePacket = new MessagePacket(command: "1", message: _controller.text);
//      var packet = messagePacket.toJson();
//      String res = json.encode(packet);
//
//      List<int> byteslist = new List<int>();
//      List<int> packetbytes = utf8.encode(res);
//
//      // request Type
//      byteslist.add(2);
//
//      //serialize algorithm
//      byteslist.add(1);
//
//      byteslist.addAll(packetbytes);
//
//      var uint8list = Uint8List.fromList(byteslist);
//
////      widget.channel.sink.add(res);
//      widget.channel.sink.add(uint8list);
//    }
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }

//
//  private static byte[] intToByte(int i) {
//    byte[] result = new byte[4];
//    result[0] = (byte) ((i >> 24) & 0xFF);
//    result[1] = (byte) ((i >> 16) & 0xFF);
//    result[2] = (byte) ((i >> 8) & 0xFF);
//    result[3] = (byte) (i & 0xFF);
//    return result;
//  }
//
//  List<int> intToByte(int i) {
//    List<int> list = new List<int>();
//    Uint8 b1 = ((i >> 24) & 0xFF) as Uint8;
//    Uint8 b2 = ((i >> 16) & 0xFF) as Uint8;
//    Uint8 b3 = ((i >> 8) & 0xFF) as Uint8;
//    Uint8 b4 = i & 0xFF as Uint8;
//    list.add(b1);
//    list.add(b2);
//    list.add(b3);
//    list.add(b4);
//
//    return list;
//  }

  String _showServerData(data) {
    return data;
  }
}
