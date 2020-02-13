import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:ui_with_fluttrer/common/DioUtil.dart';
import 'package:ui_with_fluttrer/common/Global.dart';
import 'package:ui_with_fluttrer/models/User.dart';
import 'package:ui_with_fluttrer/routes/ChatScreenRoute.dart';

class ContactInfoSelectRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _ContactInfoSelectRouteState();
  }
}

class _ContactInfoSelectRouteState extends State<ContactInfoSelectRoute> {
  List<ContactInfo> _contactItemList = List();
  List<ContactInfo> _hotcontactItemList = List();
  int _suspensionHeight = 40;
  int _itemHeight = 80;
  String _suspensionTag = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  void loadData() async {
    _hotcontactItemList.add(new ContactInfo(
        userName: Global.user.userName, tagIndex: "★", user: Global.user));

    //从服务器获取联系人列表
    var future = DioUtil.get("http://111.231.77.71:8083/contact/list",
        {"userId": Global.user.userId});
    future.then((response) {
      var list = response.data["data"];
      for (var json in list) {
        User user = User.fromJson(json);
        _contactItemList
            .add(new ContactInfo(userName: user.userName, user: user));
      }
      _handleList(_contactItemList);
    });

    setState(() {
      _suspensionTag = _hotcontactItemList[0].getSuspensionTag();
    });
  }

  void _handleList(List<ContactInfo> list) {
    if (list == null || list.isEmpty) return;
    for (int i = 0, length = list.length; i < length; i++) {
      String pinyin = PinyinHelper.getPinyinE(list[i].userName);
      String tag = pinyin.substring(0, 1).toUpperCase();
      list[i].userNamePinyin = pinyin;
      if (RegExp("[A-Z]").hasMatch(tag)) {
        list[i].tagIndex = tag;
      } else {
        list[i].tagIndex = "#";
      }
    }
    //根据A-Z排序
    SuspensionUtil.sortListBySuspensionTag(_contactItemList);
    setState(() {});
  }

  void _onSusTagChanged(String tag) {
    setState(() {
      _suspensionTag = tag;
    });
  }

  Widget _buildSusWidget(String susTag) {
    susTag = (susTag == "★" ? "最近联系人" : susTag);
    return Container(
      height: _suspensionHeight.toDouble(),
      padding: const EdgeInsets.only(left: 15.0),
      color: Color(0xfff3f4f5),
      alignment: Alignment.centerLeft,
      child: Text(
        '$susTag',
        softWrap: false,
        style: TextStyle(
          fontSize: 14.0,
          color: Color(0xff999999),
        ),
      ),
    );
  }

  Widget _buildListItem(ContactInfo model) {
    String susTag = model.getSuspensionTag();
    susTag = (susTag == "★" ? "最近联系人" : susTag);
    return Column(
      children: <Widget>[
        Offstage(
          offstage: model.isShowSuspension != true,
          child: _buildSusWidget(susTag),
        ),
        SizedBox(
          height: _itemHeight.toDouble(),
          child: GestureDetector(
            onTap: () {
              print("OnItemClick: $model");
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => ChatScreenRoute(
                            user: model.user,
                          )));
            },
            child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Image.asset(
                        "images/timg.jpeg",
                        height: 50,
                        width: 50,
                      )),
                  Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(model.userName)),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

//  onTap: () {
//  print("OnItemClick: $model");
////              Navigator.pop(context, model);
//
//  Navigator.push(context, new MaterialPageRoute(builder: (context)=>ChatScreenRoute(user: model.user,)));
//  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 15.0),
          height: 50.0,
          child: Text("通讯录"),
        ),
        Expanded(
            flex: 1,
            child: AzListView(
              data: _contactItemList,
              topData: _hotcontactItemList,
              itemBuilder: (context, model) => _buildListItem(model),
              suspensionWidget: _buildSusWidget(_suspensionTag),
              isUseRealIndex: true,
              itemHeight: _itemHeight,
              suspensionHeight: _suspensionHeight,
              onSusTagChanged: _onSusTagChanged,
              //showCenterTip: false,
            )),
      ],
    );
  }

//  Widget _buildContactInfoItem(ContactInfo model) {
//    return Container(
//      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
//      decoration: BoxDecoration(//todo
//
//          ),
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.start,
//        children: <Widget>[
//          Image.asset("",height: 50,width: 50,),
//          Pa
//
//        ],
//      ),
//    );
//  }
}

class ContactInfo extends ISuspensionBean {
  User user;
  String userName;
  String tagIndex;
  String userNamePinyin;

  ContactInfo({this.userName, this.tagIndex, this.userNamePinyin, this.user});

  ContactInfo.fromJson(Map<String, dynamic> json)
      : userName = json['userName'] == null ? "" : json['userName'];

  Map<String, dynamic> toJson() => {
        'name': userName,
        'tagIndex': tagIndex,
        'namePinyin': userNamePinyin,
        'isShowSuspension': isShowSuspension
      };

  @override
  String getSuspensionTag() => tagIndex;

  @override
  String toString() =>
      "ContactInfoBean {" + " \"userName\":\"" + userName + "\"" + '}';
}
