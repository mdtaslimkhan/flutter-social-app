import 'dart:convert';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class UserImageById extends StatefulWidget {
  final String userId;
  UserImageById({this.userId});

  @override
  _UserImageByIdState createState() => _UserImageByIdState();
}

class _UserImageByIdState extends State<UserImageById> {

  @override
  void initState() {
    super.initState();
    getUserById(widget.userId);
  }

  UserModel um;

  Future getUserById(String uid) async {
    try {
      final String url = BaseUrl.baseUrl("requstUser/$uid");
      final http.Response rs = await http.get(Uri.parse(url),
          headers: { 'test-pass': ApiRequest.mToken});
      Map data = jsonDecode(rs.body);
      UserModel u = UserModel.fromJson(data);

      setState(() {
          um = u;
      });

    }catch(e){
      print(e);
    }

  }



  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(left: 8),
      width: 25.0,
      height: 25.0,
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.all(new Radius.circular(50.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: cachedNetworkImageCircular(context, um.photo),
    );
  }




}
