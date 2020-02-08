import 'package:flutter/material.dart';


class ChatMessage extends StatelessWidget {
  String _name = "王博";
  bool selfFlag = true;  // true 表示本人发出的信息   false 表示他人发出的信息

  ChatMessage({this.text, this.animationController,this.selfFlag=true});

  final AnimationController animationController;
  final String text;

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor:
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: selfFlag ? selfMessageWidget(context) : othersMessageWidget(context),
      ),
    );
  }

  Widget selfMessageWidget(BuildContext context){
    return new Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        new Expanded(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              new Text(_name, style: Theme.of(context).textTheme.subhead),
              new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Text(text),
              ),
            ],
          ),
        ),
        new Container(
          margin: const EdgeInsets.only( left : 16.0),
          child: new CircleAvatar(child: new Text(_name[0])),
        ),
      ],
    );
  }


  Widget othersMessageWidget(BuildContext context){
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Container(
          margin: const EdgeInsets.only(right: 16.0),
          child: new CircleAvatar(child: new Text(_name[0])),
        ),
        new Expanded(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(_name, style: Theme.of(context).textTheme.subhead),
              new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Text(text),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
