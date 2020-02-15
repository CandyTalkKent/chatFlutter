import 'package:json_annotation/json_annotation.dart';
import 'package:ui_with_fluttrer/models/Serializable.dart';
import "User.dart";
part 'LoginRequest.g.dart';

@JsonSerializable()
class LoginRequest extends Serializable{

    static int login = 1;
    static int algorithm = 1;
    LoginRequest();

    User user;
    String password;

    LoginRequest.wrap({this.user,this.password});

    
    factory LoginRequest.fromJson(Map<String,dynamic> json) => _$LoginRequestFromJson(json);
    Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
