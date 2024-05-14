
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:chat_app/ui/chatroom/big_group_widget/voice_room_images.dart';
import 'package:chat_app/ui/chatroom/provider/agora_provider_big_group.dart';
import 'package:chat_app/ui/chatroom/widgets/audio_indication_biggroup_bg.dart';
import 'package:chat_app/ui/chatroom/widgets/audio_indication_biggroup_mic.dart';
import 'package:chat_app/ui/chatroom/widgets/audio_mute_indication_biggroup.dart';
import 'package:chat_app/ui/chatroom/widgets/big_group_widgets/voice_room_user_seat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupPersonIconMinimized extends StatelessWidget {

  final Function onPressed;
  final String photo;
  final String name;
  final bool active;
  final String userId;
  final bool mute;
  List<AudioVolumeInfo> remoteUserAudioInfo;
  final String fromId;
  int seatPosition;
  final bool host;
  int dbposition;

  GroupPersonIconMinimized({this.onPressed,
    this.photo,this.name,this.active, this.userId,this.mute, this.remoteUserAudioInfo,
    this.fromId, this.seatPosition, this.host, this.dbposition
  });


  @override
  Widget build(BuildContext context) {


    final AgoraProviderBigGroup agoraBiggroup = Provider.of<AgoraProviderBigGroup>(context);
    return VoiceRoomUserHotSeat(
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
        host: host
    );
  }
}
