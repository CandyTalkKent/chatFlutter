import 'package:json_annotation/json_annotation.dart';

part 'User.g.dart';

@JsonSerializable()
class User {
    User();

    String userId;
    String userName;
    String password;
    String phone;
    String userNickName;
    String address;
    String email;
    String homeTown;

    
    factory User.fromJson(Map<String,dynamic> json) => _$UserFromJson(json);
    Map<String, dynamic> toJson() => _$UserToJson(this);
}
