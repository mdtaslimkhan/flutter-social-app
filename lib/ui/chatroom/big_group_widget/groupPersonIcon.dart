
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:chat_app/ui/chatroom/big_group_widget/voice_room_images.dart';
import 'package:chat_app/ui/chatroom/provider/agora_provider_big_group.dart';
import 'package:chat_app/ui/chatroom/widgets/audio_indication_biggroup_bg.dart';
import 'package:chat_app/ui/chatroom/widgets/audio_indication_biggroup_mic.dart';
import 'package:chat_app/ui/chatroom/widgets/audio_mute_indication_biggroup.dart';
import 'package:chat_app/ui/chatroom/widgets/big_group_widgets/voice_room_user_seat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupPersonIcon extends StatelessWidget {

  final Function onPressed;
  final double top;
  final double right;
  final double bottom;
  final double left;
  final String photo;
  final String name;
  final bool active;
  final String userId;
   int dbposition;
  final bool mute;
  final bool host;
  List<AudioVolumeInfo> remoteUserAudioInfo;
  final String fromId;
   int seatPosition;
   final String react;

  GroupPersonIcon({this.onPressed,this.top,this.right,this.bottom,this.left,
    this.photo,this.name,this.active, this.userId,this.dbposition, this.mute, this.remoteUserAudioInfo,
    this.host,
    this.fromId, this.seatPosition,
    this.react,
  });


  @override
  Widget build(BuildContext context) {

   final AgoraProviderBigGroup agoraBiggroup = Provider.of<AgoraProviderBigGroup>(context);
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: VoiceRoomUserHotSeat(
        onPressed: onPressed,
        name: name,
        audioInfo: agoraBiggroup.remoteUserAudioInfo,
        userId: userId,
        fromId: fromId,
        active: active,
        seatPosition: seatPosition,
        dbposition: dbposition,
        photo: photo,
        mute: mute,
        host: host,
        react: react,
      ),
    );
  }
}
