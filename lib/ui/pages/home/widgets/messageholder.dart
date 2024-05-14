import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/call/permissionhandler.dart';
import 'package:chat_app/ui/call/util/callUtil.dart';
import 'package:chat_app/ui/chatroom/utils/online_indicator.dart';
import 'package:chat_app/util/constants.dart';
import 'package:flutter/material.dart';

class MessageHolder extends StatelessWidget {
  final String message;
  final String time;
  final UserModel user;
  final int id;
  final String photo;
  final String name;
  final int type;

  MessageHolder({
    this.message,
    this.time,
    this.user,
    this.id,
    this.photo,
    this.name,
    this.type
  });


  showUserInfo(parentContext){
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
                tag: 'img-$id',
                child: Container(
                  width: MediaQuery.of(context).size.width*0.5,
                  height: MediaQuery.of(context).size.width*0.5,
                  child: photo != null ?  cachedNetworkImg(context,photo) : AssetImage('assets/u3.gif'),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                    Text("$name"),
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



  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: GestureDetector(
              child: Hero(
                tag: 'img-$id',
                child: OnlineIndicator(
                  uid: id.toString(),
                  photo: photo,
                  from: user,
                ),
              ),
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => Sandbox3(user: fromMessageSender,)));
                  showUserInfo(context);
            
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$name',
                    style: fldarkHome16,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '$message',
                    style: fldarkgrey12,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '$time',
                    style: fldarkgrey10,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12, top: 14),
            child: MaterialButton(
              padding: EdgeInsets.all(0),
              minWidth: 35,
              child: Icon(
                  Icons.call,
                  color: Colors.blueAccent
              ),
              onPressed: () async => await PermissionHandlerUser().onJoin() ?
              CallUtils.mdial(
                  from: user,
                  toUserId: id.toString(),
                  context: context,
                  type: 1
              ) : {},
            ),
          ),
        ],
      ),
    );
  }
}
