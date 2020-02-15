import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:ui_with_fluttrer/models/User.dart';

class LoginFileHelper{

static final splitSymbol = "%%%";


  static Future<File> getLoginInfoFile() async {
    // get the path to the document directory.
    String dir = (await getApplicationDocumentsDirectory()).path;
    return new File('$dir/mylogininfo');
  }

  static Future<String> readLoginInfo() async {
    try {
      File file = await getLoginInfoFile();
      String content = await file.readAsString();

      return content;
    } on FileSystemException {}
  }

  static Future<Null> saveLoginInfo(User user,String password) async{
    File file = await getLoginInfoFile();
   Map userMap =  user.toJson();
   String encode = json.encode(userMap);
   String contents = encode +splitSymbol +password;
   await file.writeAsString(contents);
  }
}