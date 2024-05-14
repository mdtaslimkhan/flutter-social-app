import 'dart:convert';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/chatroom/lastmessagecontainer_group.dart';
import 'package:chat_app/ui/chatroom/model/contact.dart';
import 'package:chat_app/ui/chatroom/chatroom_group.dart';
import 'package:chat_app/ui/chatroom/utils/online_indicator.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:chat_app/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



class MessageListGroup extends StatelessWidget {

  final UserModel user;
  final ContactHome contact;
  final int type;
  MessageListGroup(this.user,this.contact , this.type);


  Future<GroupModel> getUserById(String uId) async {
    final String url = BaseUrl.baseUrl("getGroupByGroup/$uId");
    final http.Response rs = await http.get(Uri.parse(url),
        headers: { 'test-pass' : ApiRequest.mToken});
    var data = jsonDecode(rs.body);
    var groupData = data["group"];
    GroupModel u = GroupModel.fromJson(groupData);
    return u;
  }


  showUserInfo(parentContext, GroupModel group){
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
                tag: 'img-${group.id}',
                child: Container(
                  width: MediaQuery.of(context).size.width*0.5,
                  height: MediaQuery.of(context).size.width*0.5,
                  child: group.photo != null ?  cachedNetworkImg(context,group.photo) : AssetImage('assets/u3.gif'),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                    Text("${group.name}"),
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


  groupMessage(BuildContext context, GroupModel group){
    return Card(
      margin: EdgeInsets.fromLTRB(0, 5.0,0, 0),
      child: ListTile (
        onTap: ()  {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatRoomGroup(from: user, toGroup: group)));
        },
        title: Text("${group.name}",
          style: fldarkHome16,
        ),
        subtitle: LastMessageContainerGroup(
          senderId: user.id.toString(),
          receiverId: group.id.toString(),
        ),
        leading: GestureDetector(
          child: Hero(
            tag: 'img-${group.id}',
            child: OnlineIndicator(
              uid: group.id.toString(),
              photo: group.photo,
            ),
          ),
          onTap: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context) => Sandbox3(user: fromMessageSender,)));
            showUserInfo(context, group);
          },
        ),
        trailing: MaterialButton(
          padding: EdgeInsets.all(0),
          minWidth: 25,
          child: Icon(
            Icons.bar_chart,
            color: Colors.lightGreen,
          ),
          onPressed: () {

          },

        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
     // return Text('checking list');
    return FutureBuilder(
      future: getUserById(contact.uid.toString()),
        builder: (context, snapshot){
          return snapshot.data != null ? groupMessage(context, snapshot.data) : Container();
        }
    );
  }
}
