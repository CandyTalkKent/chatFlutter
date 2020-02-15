import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

final String tableTodo = 't_message';
final String columnId = '_id';
final String columnFromUserId = '_from_userid';
final String columnFromUserInfo = '_from_userinfo';
final String columnToUserId = '_to_userid';
final String columnText = '_text';
final String columnTime = "_time";
class Message {
  int id;
  int fromUserId;
  String fromUserInfo;
  int toUserId;
  String time;
  String text;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnText: text,
      columnFromUserId: fromUserId,
      columnFromUserInfo:fromUserInfo,
      columnToUserId: toUserId,
      columnTime: time,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Message({this.fromUserId,this.fromUserInfo,this.toUserId,this.text,this.time,});

  Message.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    toUserId = map[columnToUserId];
    fromUserId = map[columnFromUserId];
    fromUserInfo=map[columnFromUserInfo];
    text = map[columnText];
    time = map[columnTime] ?? "";
  }
}

class MessageSqliteProvider {
  static Database db;
  static String dbName = "chat.db";

  static Future<String> getPath() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
//    String path = join(databasesPath, 'demo.db');

    String path = databasesPath + dbName;

    try {
      await Directory(databasesPath).create(recursive: true);
    } catch (_) {}
    return path;
  }

  static Future open() async {
    String path = await getPath();

    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
create table $tableTodo ( 
  $columnId integer primary key autoincrement, 
  $columnText text not null,
  $columnFromUserInfo text not null,
  $columnToUserId integer not null,
  $columnFromUserId integer not null,
  $columnTime text not null)
''');
        });
  }

  static Future<Message> insert(Message message) async {
    if (db == null) {
      await open();
    }

    message.id = await db.insert(tableTodo, message.toMap());
    return message;
  }

  static Future<Message> getMessage(int id) async {
    if (db == null) {
      await open();
    }
    List<Map> maps = await db.query(tableTodo,
        columns: [
          columnId,
          columnFromUserId,
          columnFromUserInfo,
          columnToUserId,
          columnText,
          columnTime
        ],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Message.fromMap(maps.first);
    }
    return null;
  }

  static Future<List<Message>> getMessageListByFromUserId(int fromUserId) async {
    if (db == null) {
      await open();
    }

    List<Message> res = new List<Message>();
    List<Map> maps = await db.query(tableTodo,
        columns: [
          columnId,
          columnFromUserId,
          columnToUserId,
          columnFromUserInfo,
          columnText,
          columnTime
        ],
        where: '$columnToUserId = ?',
        whereArgs: [fromUserId]);
    if (maps.length > 0) {
//      return Message.fromMap(maps.first);

        maps.forEach((map){
          res.add(Message.fromMap(map));
        });

        return res;

    }
    return null;
  }

  static Future<List<Message>> getMessageListByToUserId(int toUserId) async {
    if (db == null) {
      await open();
    }

    List<Message> res = new List<Message>();
    List<Map> maps = await db.query(tableTodo,
        columns: [
          columnId,
          columnFromUserId,
          columnFromUserInfo,
          columnToUserId,
          columnText,
          columnTime
        ],
        where: '$columnToUserId = ?',
        whereArgs: [toUserId]);
    if (maps.length > 0) {
//      return Message.fromMap(maps.first);

        maps.forEach((map){
          res.add(Message.fromMap(map));
        });

        return res;

    }
    return null;
  }

//
  static Future<int> delete(int id) async {
    if (db == null) {
      await open();
    }
    return await db.delete(tableTodo, where: '$columnId = ?', whereArgs: [id]);
  }

  static Future<int> update(Message todo) async {
    if (db == null) {
      await open();
    }
    return await db.update(tableTodo, todo.toMap(),
        where: '$columnId = ?', whereArgs: [todo.id]);
  }

  Future close() async {
    if (db == null) {
      await open();
    }
    db.close();
  }


}
