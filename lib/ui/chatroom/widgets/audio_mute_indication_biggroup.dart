

import 'package:chat_app/ui/chatroom/model/mute_model.dart';
import 'package:flutter/material.dart';

class AudioMuteIndicationBiggroup extends StatelessWidget{

  final Color nColor;
  final bool mute;
  int dbposition;
  int seatPosition;
  AudioMuteIndicationBiggroup({this.nColor, this.mute, this.dbposition, this.seatPosition});

  @override
  Widget build(BuildContext context) {

    return mute != null && mute && dbposition == seatPosition ? Container(
      height: 18,
      width: 18,
      decoration: BoxDecoration(
        color: nColor,
        image: DecorationImage(
          image: AssetImage("assets/icon/mute_2.png"),
          fit: BoxFit.contain,
        ),
        borderRadius: BorderRadius.all(new Radius.circular(8.0)),
      ),
    ) : Container();
  }
}
