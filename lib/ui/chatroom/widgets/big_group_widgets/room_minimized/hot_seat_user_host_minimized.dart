import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:chat_app/provider/profile_provider.dart';
import 'package:chat_app/ui/chatroom/big_group_widget/groupPersonIcon.dart';
import 'package:chat_app/ui/chatroom/function/voice_room_methods.dart';
import 'package:chat_app/ui/chatroom/utils/bottom_short_profile.dart';
import 'package:chat_app/ui/chatroom/widgets/big_group_widgets/room_minimized/group_person_icon_minimized.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final _fireStore = FirebaseFirestore.instance;

class HotSeatUserHostMinimized extends StatelessWidget {

  final Function onPressed;
  final GroupModel group;
  final String collection;
  final int position;
  final bool active;
  List<AudioVolumeInfo> remoteUserAudioInfo;
  final String fromId;
  int seatPosition;
  final bool isHost;
  HotSeatUserHostMinimized({this.onPressed,this.group,this.collection, this.position,
 this.active , this.remoteUserAudioInfo, this.fromId, this.seatPosition, this.isHost});

  final VoiceRoomMethods roomMethods = VoiceRoomMethods();


  @override
  Widget build(BuildContext context) {
 ProfileProvider _p = Provider.of<ProfileProvider>(context, listen: false);
    return StreamBuilder(
      stream: roomMethods.getHotSeatUserReal(groupId: group.id.toString(), collection: collection),
      builder: (context, AsyncSnapshot event) {
        if (event.hasData) {
          Map<dynamic, dynamic> dt = event.data.snapshot.value;
          if (dt != null) {
          //  print(dt);
            if (dt.values.length > position) {
              return GroupPersonIconMinimized(
                onPressed: () =>
                    _optionModalBottomSheet(context, 0, dt['userId'], isHost),
                photo: dt['photo'],
                name: dt['name'],
                userId: dt['userId'],
                mute: dt['mute'] != null ? dt['mute'] : false,
                host: dt['host'],
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
          }
        }

        return Text('error');

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
