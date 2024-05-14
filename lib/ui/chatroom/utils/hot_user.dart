import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:chat_app/ui/chatroom/big_group_widget/groupPersonIcon.dart';
import 'package:chat_app/ui/chatroom/bottomModal/user_profile_details.dart';
import 'package:chat_app/ui/chatroom/utils/bottom_short_profile.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


final _fireStore = FirebaseFirestore.instance;

class HotSeatUser extends StatelessWidget {

  final Function onPressed;
  final GroupModel group;
  final String collection;
  final int position;
  final double top;
  final double right;
  final double left;
  final bool active;
  List<AudioVolumeInfo> remoteUserAudioInfo;
  final String fromId;
   int seatPosition;
   final bool isHost;
  HotSeatUser({this.onPressed,this.group,this.collection, this.position,
    this.top, this.right, this.left, this.active , this.remoteUserAudioInfo, this.fromId, this.seatPosition, this.isHost});


  @override
  Widget build(BuildContext context) {

   // return Text('hello');
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore
          .collection(BIG_GROUP_COLLECTION)
          .doc(group.id.toString())
          .collection("hotSeat")
          .where("position", isEqualTo: seatPosition)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            if (snapshot.data.docs.length > 0) {
              var dt = snapshot.data.docs.first.data() as Map;

              if(dt != null){
                return GroupPersonIcon(
                  onPressed: () =>
                      optionModalBottomSheet(context, 0, dt['userId'], isHost, group, fromId),
                  top: top,
                  right: right,
                  left: left,
                  photo: dt['photo'],
                  name: dt['name'],
                  userId: dt['userId'],
                  host: isHost,
                  mute: dt['mute'] != null ? dt['mute'] : false,
                  dbposition: dt['position'],
                  react: dt['react'],
                  active: true,
                  remoteUserAudioInfo: remoteUserAudioInfo,
                  fromId: fromId,
                  seatPosition: seatPosition,
                );
              } else {
                return GroupPersonIcon(
                  top: top,
                  right: right,
                  left: left,
                  photo: '',
                  seatPosition: seatPosition,
                  active: false,
                  onPressed: onPressed,
                );
              }

              return Text('');
            }
          }
        }

        return GroupPersonIcon(
          top: top,
          right: right,
          left: left,
          photo: '',
          seatPosition: seatPosition,
          active: false,
          onPressed: onPressed,
        );

      }
    );
  }

  // Hot seat user bottom sheet will see admin only
  void optionModalBottomSheet(context, int position, String userId, isHost, group, fromId) async {

    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        builder: (BuildContext bc) {
          return BottomShortProfile(userId: userId, group: group, position: position, fromId: fromId, isHost: isHost);
        });
  }




}
