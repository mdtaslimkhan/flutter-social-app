import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:chat_app/ui/chatroom/big_group_widget/groupPersonIcon.dart';
import 'package:chat_app/ui/chatroom/function/voice_room_methods.dart';
import 'package:chat_app/ui/chatroom/utils/bottom_short_profile.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

final _fireStore = FirebaseFirestore.instance;

class HotSeatUserHost extends StatelessWidget {

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
  HotSeatUserHost({this.onPressed,this.group,this.collection, this.position,
    this.top, this.right, this.left, this.active , this.remoteUserAudioInfo, this.fromId, this.seatPosition, this.isHost});

  final VoiceRoomMethods roomMethods = VoiceRoomMethods();


  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: roomMethods.getHotSeatUserReal(groupId: group.id.toString(), collection: collection),
      builder: (context, AsyncSnapshot event) {
        if (event.hasData && event.data.snapshot.value is Map) {
          // print("hot seat host user test");
          // print(event.data.snapshot.value);
          Map<dynamic, dynamic> dt = event.data.snapshot.value;
          if (dt != null) {
              if (dt.values.length > position) {
                return GroupPersonIcon(
                  onPressed: () =>
                      _optionModalBottomSheet(context, 0, dt['userId'], isHost),
                  top: top,
                  right: right,
                  left: left,
                  photo: dt['photo'],
                  name: dt['name'],
                  userId: dt['userId'],
                  mute: dt['mute'] != null ? dt['mute'] : false,
                  react: dt['react'],
                  host: dt['host'],
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

      },
    );
  }


  // Hot seat user bottom sheet will see admin only
  void _optionModalBottomSheet(context, int position, String userId, bool isHost) async {

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
