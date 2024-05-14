import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/chatroom/big_group_widget/voice_room_images.dart';
import 'package:chat_app/ui/chatroom/model/mute_model.dart';
import 'package:chat_app/ui/chatroom/provider/agora_provider_big_group.dart';
import 'package:chat_app/ui/chatroom/widgets/audio_indication_biggroup_bg.dart';
import 'package:chat_app/ui/chatroom/widgets/audio_indication_biggroup_mic.dart';
import 'package:chat_app/ui/chatroom/widgets/audio_mute_indication_biggroup.dart';
import 'package:chat_app/ui/chatroom/widgets/audio_mute_indication_biggroup_host.dart';
import 'package:chat_app/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VoiceRoomUserHotSeat extends StatelessWidget {


  final Function onPressed;
  final List<AudioVolumeInfo> audioInfo;
  final String userId;
  final bool mute;
  final String fromId;
  final bool active;
  final bool host;
  final String photo;
  final String name;
  int seatPosition;
  int dbposition;
  final String react;
  VoiceRoomUserHotSeat({this.onPressed, this.audioInfo, this.fromId, this.userId,this.mute, this.active,
    this.host,
    this.photo, this.name, this.seatPosition, this.dbposition,
    this.react
  });


  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        // color: Colors.amberAccent,
        width: 99,
        height: 100,
        child: Stack(
          children: [
            Positioned(
              left: -15,
              bottom: -5,
              right: -15,
              top: -3,
              child: audioInfo != null ?  Column(
                children: [
                  AudioIndicationBiggroupBg(
                    remoteUserAudioInfo: audioInfo,
                    userId: userId,
                    fromId: fromId,
                    //   nColor: Colors.pinkAccent,
                  )
                ],
              ) : Container(),
            ),
            Container(
              // color: Colors.indigo,
              margin: EdgeInsets.only(left: 5,top: 12),
              width: 90,
              height: 80,
              child: Stack(
                children: [
                  active ? Stack(
                    children: [
                      Positioned(
                          left:24,
                          top: 14,
                          child: photo != "" ? Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(photo),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.all(new Radius.circular(20.0)),
                            ),
                          ) : VoiceRoomImageHolder(
                            height: 40,
                            width: 40,
                            image: "assets/u1.gif",
                          )
                      ),
                      Positioned(
                        top: 0,
                        left: 8,
                        child: VoiceRoomImageHolder(
                          height: 74,
                          width: 74,
                          image: 'assets/big_group/crown_ring.png',
                        ),
                      ),
                    ],
                  ) : Positioned(
                    top: 5,
                    left: 15,
                    child: VoiceRoomImageHolder(
                      width: 60,
                      height: 60,
                      image: "assets/big_group/add_person.png",
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 20,
              top: active ? 72 : 72,
              width: 60,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xff595959),
                  // image: DecorationImage(
                  //   image: NetworkImage(widget.toGroup.photo),
                  //   fit: BoxFit.cover,
                  // ),
                  borderRadius: BorderRadius.all(new Radius.circular(4.0)),
                  border: Border.all(
                    color: Color(0xfffbfa8b),
                    width: 0.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Container(
                        padding: new EdgeInsets.only(left: name != null && name.length > 10 ? 5.0 : 0),
                        child: Text(
                          name != null ? '$name' : 'No user $seatPosition',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xfffbfa8b),
                            fontSize: 8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),


            Positioned(
              left: 25,
              top: active ? 55 : 47,
              child: audioInfo != null ?  Column(
                children: [
                  AudioIndicationBiggroupMic(
                    remoteUserAudioInfo: audioInfo,
                    userId: userId,
                    fromId: fromId,
                    //   nColor: Colors.pinkAccent,
                  )
                ],
              ) : Container(),
            ),
            Positioned(
              left: 24,
              top: 40,
              bottom: active ? 10 : 17,
              child:
              host != null && host ?
              AudioMuteIndicationBiggroupHost(mute: mute, host: host) :
              AudioMuteIndicationBiggroup(mute: mute, dbposition: dbposition, seatPosition: seatPosition)
            ),

            Positioned(
                right: 5,
                top: 0,
                child: Container(
                  height: 30,
                  width: 30,
                  child: react != null ? giftReactCachedNetworkImage(context,
                      "$APP_ASSETS_URL/react/$react.gif")
                      : Container(),
                ),

            ),
          ],
        ),
      ),
    );
  }
}
