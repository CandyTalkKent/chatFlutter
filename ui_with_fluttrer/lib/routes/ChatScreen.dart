import 'package:flutter/material.dart';
import 'package:ui_with_fluttrer/routes/ChatMessage.dart';
class ChatScreen extends StatefulWidget {
  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return new Column(
      //modified
      children: <Widget>[
        //new
        new Flexible(
          //new
          child: new ListView.builder(
            //new
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
    );
  }

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

  @override
  void dispose() {
    //new
    for (ChatMessage message in _messages) //new
      message.animationController.dispose(); //new
    super.dispose(); //new
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {                                                    //new
      _isComposing = false;                                          //new
    });
    ChatMessage message = new ChatMessage(
      //new
      text: text,
      animationController: new AnimationController(
        //new
        duration: new Duration(milliseconds: 300), //new
        vsync: this, //new
      ), //new
      selfFlag: true,
    ); //new
    setState(() {
      //new
      _messages.insert(_messages.length, message); //new
    });
    message.animationController.forward();
  }
}
