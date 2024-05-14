
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/chatroom/big_group_widget/getUserImageByUrl.dart';
import 'package:chat_app/ui/chatroom/function/voice_room_methods.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/profile.dart';
import 'package:chat_app/util/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class VoiceroomMemberCounter extends StatelessWidget {

  final String toGroupId;
  VoiceroomMemberCounter({this.toGroupId});
  final VoiceRoomMethods roomMethods = VoiceRoomMethods();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 20,
      margin:  EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
      child: StreamBuilder(
        stream: roomMethods.getActiveUsersMethod(groupId: toGroupId),
        builder: (BuildContext context, event){
          int count = 0;
          if(event.hasData && event.data.snapshot.value != null){
            final dt = Map<String, dynamic>.from(event.data.snapshot.value);
            if(dt != null){
              count = dt.values.length;
            }
          }
          return Center(child: Text('${count > 9 ? "+9" : "$count"}',style: ftwhite15,));
        },
      ),
    );
  }
}