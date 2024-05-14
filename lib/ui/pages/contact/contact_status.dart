import 'dart:convert';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/call/permissionhandler.dart';
import 'package:chat_app/ui/call/util/callUtil.dart';
import 'package:chat_app/ui/chatroom/chatroom.dart';
import 'package:chat_app/ui/chatroom/model/contact.dart';
import 'package:chat_app/ui/pages/contact/online_status.dart';
import 'package:chat_app/ui/pages/contact/online_text_status.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:chat_app/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



// ignore: must_be_immutable
class ContactStatus extends StatelessWidget {

  final UserModel user;
  final ContactHome contact;
  final int type;
  ContactStatus(this.user,this.contact , this.type);

  UserModel fromMessageSender;

  Future<UserModel> getUserById(String uId) async {
    final String url = BaseUrl.baseUrl("requstUser/$uId");
    final http.Response rs = await http.get(Uri.parse(url),
        headers: { 'test-pass' : ApiRequest.mToken});
    Map data = jsonDecode(rs.body);
    UserModel u = UserModel.fromJson(data);

    return u;
  }


  showUserInfo(parentContext, UserModel toUser){
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              "User details: ",
              style: fldarkgrey15,
            ),
            children: [
              Hero(
                tag: 'img-${toUser.id}',
                child: Container(
                  width: MediaQuery.of(context).size.width*0.5,
                  height: MediaQuery.of(context).size.width*0.5,
                  child: toUser.photo != null ?  cachedNetworkImg(context,toUser.photo) : AssetImage('assets/u3.gif'),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                    Text("${toUser.nName}"),
                    Text("${toUser.number}"),
                  ],
                ),
              ),

              SimpleDialogOption(
                child: Text("Close"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    );
  }


  messageItem(BuildContext context, UserModel toUser){
    return Card(
      margin: EdgeInsets.fromLTRB(0, 5.0,0, 0),
      child: Container(
        child: ListTile (
          onTap: ()  {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatRoom(from: user, toUserId: toUser.id.toString())));
          },
          title: Text("${toUser.nName}",
            style: fldarkHome16,
          ),
          subtitle: OnlineTextStatus(
            uid: toUser.id.toString(),
          ),
          leading: GestureDetector(
            child: Hero(
              tag: 'img-${toUser.id}',
              child: OnlineStatus(
                uid: toUser.id.toString(),
                photo: toUser.photo,
              ),
            ),
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => Sandbox3(user: fromMessageSender,)));
              showUserInfo(context, toUser);
            },
          ),
          trailing: MaterialButton(
            padding: EdgeInsets.all(0),
            minWidth: 35,
            child: Icon(
              Icons.call,
            ),
            onPressed: () async => await PermissionHandlerUser().onJoin() ?
            CallUtils.mdial(
                from: user,
                toUserId: toUser.id.toString(),
                context: context,
                type: 1
            ) : {},

          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUserById(contact.uid.toString()),
        builder: (context, snapshot){
         return snapshot.data != null ? messageItem(context, snapshot.data) : Container();
    });
  }
}
