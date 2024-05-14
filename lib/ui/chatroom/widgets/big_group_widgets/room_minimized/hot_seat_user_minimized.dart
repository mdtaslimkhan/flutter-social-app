import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:chat_app/ui/chatroom/big_group_widget/groupPersonIcon.dart';
import 'package:chat_app/ui/chatroom/utils/bottom_short_profile.dart';
import 'package:chat_app/ui/chatroom/widgets/big_group_widgets/room_minimized/group_person_icon_minimized.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


final _fireStore = FirebaseFirestore.instance;

class HotSeatUserMinimized extends StatelessWidget {

  final Function onPressed;
  final GroupModel group;
  final String collection;
  final int position;
  final bool active;
  List<AudioVolumeInfo> remoteUserAudioInfo;
  final String fromId;
  int seatPosition;
  final bool isHost;
  HotSeatUserMinimized({this.onPressed,this.group,this.collection, this.position,
  this.active , this.remoteUserAudioInfo, this.fromId, this.seatPosition, this.isHost});



  @override
  Widget build(BuildContext context) {

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
                  return GroupPersonIconMinimized(
                    onPressed: () =>
                        _optionModalBottomSheet(context, 0, dt['userId'], isHost),
                    photo: dt['photo'],
                    name: dt['name'],
                    userId: dt['userId'],
                    mute: dt['mute'],
                    dbposition: dt['position'],
                    active: true,
                    remoteUserAudioInfo: remoteUserAudioInfo,
                    fromId: fromId,
                    seatPosition: seatPosition,
                  );
                } else {
                  return GroupPersonIconMinimized(
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

          return GroupPersonIconMinimized(
            photo: '',
            seatPosition: seatPosition,
            active: false,
            onPressed: onPressed,
          );

        }
    );
  }






  // Hot seat user bottom sheet will see admin only
  void _optionModalBottomSheet(context, int position, String userId, isHost) async {

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
