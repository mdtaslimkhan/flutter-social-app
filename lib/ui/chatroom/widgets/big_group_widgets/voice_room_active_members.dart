import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/chatroom/big_group_widget/getUserImageByUrl.dart';
import 'package:chat_app/ui/chatroom/function/voice_room_methods.dart';
import 'package:chat_app/ui/chatroom/utils/bottom_active_users.dart';
import 'package:chat_app/ui/chatroom/utils/bottom_waiting_list.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/profile.dart';
import 'package:chat_app/util/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

final VoiceRoomMethods roomMethods = VoiceRoomMethods();

class VoiceRoomActiveMembers extends StatelessWidget {

  final String toGroupId;
  final UserModel from;
  VoiceRoomActiveMembers({this.toGroupId, this.from});




  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: 20,
      child: StreamBuilder(
        stream: roomMethods.getActiveUsersMethod(groupId: toGroupId),
        builder: (BuildContext context, event) {
          if (!event.hasData)
            return Text('');
          var ul = [];
          if(event.data.snapshot.value != null){
            final dt = Map<String, dynamic>.from((event.data).snapshot.value);
            dt.forEach((key, value) {
              final user = Map<String, dynamic>.from(value);
              ul.add(user);
            });
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: ul.length,
            itemBuilder: (context, index) {
              String uid = ul[index]["user_id"];
              String photo = ul[index]["photo"];
              return GestureDetector(
                child: ul[index]["photo"] != null ? UserImageByPhotoUrl(
                  photo: photo,
                ) : Container(),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(userId: uid,currentUser: from)));
                  //  _optionModalBottomSheet(context);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class VoiceroomActiveMemberCounter extends StatelessWidget {

  final String toGroupId;
  final UserModel from;
  VoiceroomActiveMemberCounter({this.toGroupId, this.from});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  EdgeInsets.all(0),
      child: StreamBuilder(
        stream: roomMethods.getActiveUsersMethod(groupId: toGroupId),
        builder: (BuildContext context, event){
          int count = 0;
          var ul = [];
          if(event.hasData && event.data.snapshot.value != null){
            final dt = Map<String, dynamic>.from(event.data.snapshot.value);
            if(dt != null){
              dt.forEach((key, value) {
                final user = Map<String, dynamic>.from(value);
                ul.add(user);
              });
              count = dt.values.length;
            }

          }
          return GestureDetector(
              child: Container(
                  width: 42,
                  height: 22,
                  decoration: BoxDecoration(
                    color: Color(0xffddf0fc).withOpacity(0.4),
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                  ),
                  child: Center(child: Text('$count',style: fldarkgrey10,))
              ),
            onTap: (){
              _activeUsersBottomSheet(context, ul);
            },
          );
        },
      ),
    );
  }

  // Active users bottom sheet
  void _activeUsersBottomSheet(context, List ul) {
    // getHostUser = getHost();
    // getHotSeatList = getHotSeatUserList();
    showModalBottomSheet(
        isScrollControlled: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0))),
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext bc) {
          return StatefulBuilder(
              builder: (BuildContext bc, StateSetter setState) {
                return BottomActiveUsersList(toGroupId: toGroupId, from: from);
              }
          );
        });
  }


}

