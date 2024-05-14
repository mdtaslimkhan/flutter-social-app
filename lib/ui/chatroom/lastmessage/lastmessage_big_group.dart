import 'dart:convert';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/chatroom/chatroom_big_group.dart';
import 'package:chat_app/ui/chatroom/lastmessagecontainer_big_group.dart';
import 'package:chat_app/ui/chatroom/provider/big_group_provider.dart';
import 'package:chat_app/ui/chatroom/utils/online_indicator_biggroup.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:chat_app/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';



class MessageListBigGroup extends StatelessWidget {

  final UserModel user;
  final String contact;
  final int type;
  MessageListBigGroup(this.user,this.contact , this.type);


  Future<GroupModel> getUserById(String uId) async {
    final String url = BaseUrl.baseUrl("getGroupByGroup/$uId");
    final http.Response rs = await http.get(Uri.parse(url),
        headers: { 'test-pass' : ApiRequest.mToken});
    var data = jsonDecode(rs.body);
    var groupData = data["group"];
    GroupModel u = GroupModel.fromJson(groupData);

    return u;
  }

  showUserInfo(parentContext , GroupModel group){
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



  groupContact(BuildContext context,GroupModel group){
    BigGroupProvider _p = Provider.of<BigGroupProvider>(context, listen: false);
    return Container(
      child: Card(
        margin: EdgeInsets.fromLTRB(0, 5.0,0, 0),
        child: ListTile (
          onTap: () async {
            print("navigate to group page");
           await _p.getGroupModelData(groupId: group.id.toString());
            // Navigator.push(context, MaterialPageRoute(builder: (context) =>
            //     ChatRoomBigGroup(from: user, toGroupId: group.id.toString(), floatButton: false)));
            Navigator.of(context).pushNamed("/bigGroupChatRoom", arguments:
            {'from': user,
              'toGroupId': group.id.toString(),
              'floatButton': false,
            });
          },
          title: LastMessageContainerBigGroup(
            name: group.name,
            senderId: user.id.toString(),
            receiverId: group.id.toString(),
          ),
          subtitle: Container(),
          leading: GestureDetector(
            child: Hero(
              tag: 'img-${group.id}',
              child: OnlineIndicatorBigGroup(
                  uid: group.id.toString(),
                  photo: group.photo,
                  contactId: contact
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
              color: Colors.blueAccent,
            ),
            onPressed: () {

            },

          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
     // return Text('checking list');
    return FutureBuilder(
        future: getUserById(contact),
        builder: (context, snapshot){
          return snapshot.data != null ? groupContact(context, snapshot.data) : Container();
        }
    );
  }


}
