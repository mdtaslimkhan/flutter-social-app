import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/call/callscreens/callscreenaudio.dart';
import 'package:chat_app/ui/call/permissionhandler.dart';
import 'package:chat_app/ui/call/util/callUtil.dart';
import 'package:chat_app/ui/chatroom/chatmethods/chatmethods_personal.dart';
import 'package:chat_app/ui/chatroom/model/contact.dart';
import 'package:chat_app/ui/chatroom/utils/online_indicator.dart';
import 'package:chat_app/ui/chatroom/utils/personal_profile_iamge.dart';
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageHolderLive extends StatelessWidget {
  final String message;
  final String time;
  final UserModel user;
  final ContactHome contact;

  MessageHolderLive({this.message, this.time, this.user, this.contact});

  final ChatMethodsPersonal _chatMethodsPersonal = ChatMethodsPersonal();
  final _fireStore = FirebaseFirestore.instance;


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
                tag: 'img-${contact.uid}',
                child: PersonalProfileImage(
                  uid: contact.uid,
                  photo: contact.photo,
                  from: user,
                ),
              ),
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => Sandbox3(user: fromMessageSender,)));
                //  showUserInfo(context, toUser);
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
                    '${contact.name}',
                    style: fldarkHome16,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '$message',
                    style: TextStyle(
                      fontFamily: "Segoe",
                      fontWeight: contact.count != null && contact.count > 0 ? FontWeight.w800 : FontWeight.w600,
                      color: contact.count != null && contact.count > 0 ? Color(0xff093a84) : Colors.black87,
                      fontSize: 12
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '$time',
                   // '$time == ${contact.uid} == ${contact.block}',
                    style: fldarkgrey10,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12, top: 14),
            child: Row(
              children: [
                contact.count != null && contact.count > 0 ? Container(
                  padding: EdgeInsets.only(left: 3, right: 3, bottom: 3),
                  height: 19,
                  constraints: BoxConstraints(minWidth: 19),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(new Radius.circular(30.0)),
                    color: Colors.blue,
                    border: Border.all(
                      width: 2,
                      color: Color(0xff3d78d7),
                    ),
                  ),
                  child: Center(
                    child: Text('${contact.count.toString()}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontFamily: "Segoe",
                          fontWeight: FontWeight.w900
                      ),
                    ),
                  ),
                ) : Container(),
                MaterialButton(
                  padding: EdgeInsets.all(0),
                  minWidth: 35,
                  child: Icon(
                      Icons.call,
                      color: Colors.blueAccent
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed("/audioCallScreen", arguments:
                    {'from': user,
                      'toUserId': contact.uid,
                      'toUserPhoto': contact.photo,
                      'role' : ClientRole.Broadcaster,
                      'onReceive' : false,
                    });

                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
