import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ui_with_fluttrer/common/Global.dart';
import 'package:ui_with_fluttrer/common/PacketEncode.dart';
import 'package:ui_with_fluttrer/components/ChatMessage.dart';
import 'package:ui_with_fluttrer/models/User.dart';
import 'package:ui_with_fluttrer/models/index.dart';
import 'package:path_provider/path_provider.dart';

class ChatScreenRoute extends StatelessWidget {
  User user;

  ChatScreenRoute({this.user});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(user.userName),
        backgroundColor: Colors.amberAccent,
      ),
      body: new ChatScreen(
        user: user,
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  User user;

  ChatScreen({@required this.user}) : assert(user != null);

  @override
  ChatScreenState createState() => ChatScreenState(user);
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;
  User user;
  StreamSubscription streamSubscription;

  FocusNode _focusTextFieldComposer= new FocusNode();

  ScrollController scrollController = new ScrollController();


  ChatScreenState(User user) {
    this.user = user;
  }

  Future<Null> _focusNodeListener() async {
    if(_focusTextFieldComposer.hasFocus){
      Timer(Duration(milliseconds: 200), () => scrollController.jumpTo(scrollController.position.maxScrollExtent));
    }
  }

  @override
  void initState() {
    //消息从库里面拉 （本地）todo
    Future readMessagesFuture = _readMessages();
    _focusTextFieldComposer.addListener(_focusNodeListener);

    //对本地存储消息的处理
    readMessagesFuture.then((string) {
      if(string == null){
        return;
      }
      List<dynamic> list = json.decode(string);
      for(String s in list){
        Map jsonObj = json.decode(s);
        ChatMessage message = new ChatMessage(
          user: User.fromJson(jsonObj["user"]),
          //new
          text: jsonObj["text"],
          animationController: new AnimationController(
            //new
            duration: new Duration(milliseconds: 300), //new
            vsync: this, //new
          ), //new
          selfFlag: jsonObj["selfFlag"],
        ); //new

        _messages.add(message);
        message.animationController.forward();
      }
      setState(() {
        //do nothing just refresh view
      });



    });

    streamSubscription = Global.getStreamController().stream.listen((data) {
      Map<String, dynamic> jsonObject = json.decode(data);
      if (jsonObject["resCode"] == "200" && jsonObject["type"] == "2") {
        //说明是来信
        Map fromUserJson = jsonObject["data"]["fromUser"];
        String text = jsonObject["data"]["message"];
        insertMessageToList(text, User.fromJson(fromUserJson), false);
      }
    });
  }



  @override
  Widget build(BuildContext context) {

    //打开界面自动到底部
    Timer(Duration(milliseconds: 200), () => scrollController.jumpTo(scrollController.position.maxScrollExtent));

    return GestureDetector(
      onTap: (){
        _focusTextFieldComposer.unfocus();
      },
      child: new Column(
        //modified
        children: <Widget>[
          //new
          new Flexible(
            //new
            child: new ListView.builder(
              //new
              controller :scrollController,
              padding: new EdgeInsets.all(8.0), //new
              reverse: false, //new
              itemBuilder: (_, int index) => _messages[index], //new
              itemCount: _messages.length, //new
            ), //new
          ), //new
          new Divider(height: 1.0), //new
          new Container(
            //new
            decoration:
                new BoxDecoration(color: Theme.of(context).cardColor), //new
            child: _buildTextComposer(), //modified
          ), //new
        ], //new
      ),
    );
  }


  //构造底部发送栏
  Widget _buildTextComposer() {
    return new IconTheme(
        data: IconThemeData(color: Theme.of(context).accentColor),
        child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(
            //new
            children: <Widget>[
              //new
              new Flexible(
                //new
                child: new TextField(
                  focusNode: _focusTextFieldComposer,
                  controller: _textController,
                  onChanged: (String text) => {
                    setState(() {
                      _isComposing = text.length > 0;
                    })
                  },
                  decoration:
                      new InputDecoration.collapsed(hintText: "Send a message"),
                ),
              ),
              new Container(
                //new
                margin: new EdgeInsets.symmetric(horizontal: 4.0), //new
                child: new IconButton(
                  //new
                  icon: new Icon(Icons.send), //new
                  onPressed: _isComposing
                      ? () => _handleSubmitted(_textController.text)
                      : null,
                ), //new
              ), //new
            ], //new
          ),
        ));
  }



  void _handleSubmitted(String text) {
    int sendMessage = 2;
    int algorithm = 1;
    _textController.clear();
    setState(() {
      //new
      _isComposing = false; //new
    });

    //发送消息
    var messagePacket = MessagePacket.wrap(
        command: "2", message: text, fromUser: Global.user, toUser: user);
    Uint8List bytes =
        PacketEncode.encode(messagePacket, sendMessage, algorithm);

    Global.getWebSocketChannel().sink.add(bytes);

    insertMessageToList(text, Global.user, true);
  }

  Future<File> _getLocalFile() async {
    // get the path to the document directory.
    String dir = (await getApplicationDocumentsDirectory()).path;
    String idStr = user.userId.toString();
    return new File('$dir/messages_$idStr');
  }

  Future<String> _readMessages() async {
    try {
      File file = await _getLocalFile();

      String contents = await file.readAsString();
//      List<ChatMessage> res = new List<ChatMessage>();
//
//
//      List<String> messageList = json.decode(contents);
      return contents;
    } on FileSystemException {}
  }

  Future<Null> _saveMessages() async {
    File file = await _getLocalFile();
    List<String> res = new List<String>();
    for (ChatMessage chatMessage in _messages) {
      MessageWrap messageWrap = new MessageWrap(
          user: chatMessage.user,
          text: chatMessage.text,
          selfFlag: chatMessage.selfFlag);
//     res.add(messageWrap);
      Map jsonObject = MessageWrap.toJson(messageWrap);
      String str = json.encode(jsonObject);
      res.add(str);
    }

    String content = json.encode(res);

    await file.writeAsString(content);
  }
  void insertMessageToList(String text, User user, bool flag) {
    ChatMessage message = new ChatMessage(
      user: user,
      //new
      text: text,
      animationController: new AnimationController(
        //new
        duration: new Duration(milliseconds: 300), //new
        vsync: this, //new
      ), //new
      selfFlag: flag,
    ); //new
    setState(() {
      //new
      _messages.insert(_messages.length, message); //new
    });
    message.animationController.forward();
  }
  @override
  void dispose() {
    //消息落库（本地）todo
    _saveMessages();

    scrollController.removeListener(_focusNodeListener);

    for (ChatMessage message in _messages) //new
      message.animationController.dispose(); //new

    //取消对流的监听
    streamSubscription.cancel();
    super.dispose(); //new
  }
}

class MessageWrap {
  User user;
  String text;
  bool selfFlag;

  MessageWrap({this.user, this.text, this.selfFlag});

  static MessageWrap fromJson(Map<String, dynamic> json) {
    return MessageWrap()
      ..user = json['user'] as User
      ..text = json['text'] as String
      ..selfFlag = json['selfFlag'] as bool;
  }

  static Map<String, dynamic> toJson(MessageWrap instance) => <String, dynamic>{
        'user': instance.user,
        'text': instance.text,
        'selfFlag': instance.selfFlag,
      };
}
