import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/provider/home_provider.dart';
import 'package:chat_app/ui/chatroom/chatroom.dart';
import 'package:chat_app/ui/chatroom/model/contact.dart';
import 'package:chat_app/ui/chatroom/provider/agora_provider_big_group.dart';
import 'package:chat_app/ui/chatroom/provider/big_group_provider.dart';
import 'package:chat_app/ui/pages/home/widgets/messageholder_live.dart';
import 'package:chat_app/ui/pages/home/widgets/messageholdergroup.dart';
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

final _fireStore = FirebaseFirestore.instance;

Widget messageItem(BuildContext context, UserModel user,  ContactHome contact){
  HomeProvider _hp = Provider.of(context, listen: false);

  return GestureDetector (
    onTap: ()  {
      _hp.setShowLoader(isShow: true);
      Navigator.push(context, MaterialPageRoute(builder: (context) =>
          ChatRoom(from: user, toUserId: contact.uid, contact: contact)));
      _hp.setShowLoader(isShow: false);
    },
    child: Container(
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment .center,
        children: [
          Expanded(
            child: MessageHolderLive(
                    message: contact.text != null ? contact.text : "Tap to view",
                    time: DateFormat( "hh:mm a dd/M/yy").format(contact.addedon.toDate()),
                    user: user,
                    contact: contact,
             ),
          ),
        ],
      ),
    ),
  );
}


Widget groupContact(BuildContext context, ContactHome contact, UserModel user){
  BigGroupProvider _p = Provider.of<BigGroupProvider>(context, listen: false);
  AgoraProviderBigGroup _ap = Provider.of<AgoraProviderBigGroup>(context, listen: true);
  HomeProvider _hp = Provider.of(context, listen: false);
  return GestureDetector(
    onTap: () async {
        _hp.setShowLoader(isShow: true);
        await _p.getGroupModelData(groupId: contact.uid);
        // Navigator.push(context, MaterialPageRoute(builder: (_) => ChatRoomBigGroup(
        //   contact: contact, toGroupId: contact.uid, from: user, floatButton: false,
        // )));
        await Navigator.pushNamed(context, "/voiceRoom", arguments: {
          "contact": contact,
          "toGroupId": contact.uid,
          "from": user,
          "floatButton": false
        });
        _hp.setShowLoader(isShow: false);
    },

    child: Card(
      margin: EdgeInsets.fromLTRB(0, 5.0,0, 0),
      child: Row(
        children: [
          Expanded (
            child: MessageHolderGroup(
                      message: contact.text != null ? contact.text : "Tap to view",
                      time: DateFormat( "hh:mm a dd/M/yy").format(contact.addedon.toDate()),
                      id: contact.uid,
                      photo: contact.photo,
                      name: contact.name,
                      contactId: contact.uid,
                      type: 3
                      ),
          ),
        ],
      ),
    ),
  );
}



_optionDialogVoiceRoom(BuildContext buildContext){
  return showDialog(
      context: buildContext,
      builder: (context){
        return SimpleDialog(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 5,),
                  SizedBox(height: 20,),
                  Text("You already joined in a voice room. You need to exit that room first then you can join this room.",style: fldarkHome16,),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          icon: Text("Exit",style: TextStyle(
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w900,
                              color: Colors.green,
                              fontSize: 16
                          )),
                          onPressed: ()  {
                            Navigator.pop(context);
                          }
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      });
}

