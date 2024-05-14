import 'dart:convert';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/chatroom/chatroom.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class CrContactListTile extends StatefulWidget {
  final String contact;
  final UserModel user;
  CrContactListTile({this.contact,this.user});

  @override
  _CrContactListTileState createState() => _CrContactListTileState();
}

class _CrContactListTileState extends State<CrContactListTile> {


  Future<UserModel> getContactInfo({@required String contact}) async {
    final String url = BaseUrl.baseUrl("ifContactExist");
    final http.Response response = await http.post(Uri.parse(url),
        headers: {'test-pass' : ApiRequest.mToken},
        body: {
          "number" : contact
        }
    );
    Map usr = jsonDecode(response.body);
    UserModel u = UserModel.fromJson(usr);
    try{
      if(response.statusCode == 200) {
        return u;
      }else{
        return null;
      }
    }catch(e){
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getContactInfo(contact: widget.contact),
      builder: (context , snapshot) {
        if(!snapshot.hasData){
          return Icon(
            Icons.call,
            color: Colors.white,
          );
        }
        UserModel u = snapshot.data;


        if(u.exist == 1){
          return GestureDetector(
            child: Icon(
              Icons.call,
              color: Colors.blueAccent,
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChatRoom(from: widget.user, toUserId: u.id.toString())));
            },
          );
        }

        return GestureDetector(
          child: Icon(
            Icons.message,
            color: Colors.white,
          ),
        );

      },

    );
  }
}
