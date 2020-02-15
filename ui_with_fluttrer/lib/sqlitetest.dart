import 'package:flutter/foundation.dart';
import 'package:ui_with_fluttrer/sqlite/MessageSqliteProvider.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'WebSocket Demo';
    return MaterialApp(
      title: title,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: RaisedButton(
              onPressed: () {
                setState(() {
//                  TodoProvider todoProvider = new TodoProvider(dbName: "tood.db");
//                  todoProvider.open();
//
////                  todoProvider
////                      .insert(Todo.fromMap({"id": "1", "title": "goingdown"}));
//
//                  Future<Todo> todo = todoProvider.getTodo(1);
//
//                  todo.then(print);
                });
              },
            ),
          )),
    );
  }
}
