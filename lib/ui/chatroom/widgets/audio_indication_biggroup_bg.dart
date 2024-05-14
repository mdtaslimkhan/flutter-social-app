

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';

class AudioIndicationBiggroupBg extends StatefulWidget {

  final Color nColor;
  List<AudioVolumeInfo> remoteUserAudioInfo;
  final String userId;
  final String fromId;
  AudioIndicationBiggroupBg({this.nColor, this.remoteUserAudioInfo, this.userId, this.fromId});

  @override
  _AudioIndicationBiggroupBgState createState() => _AudioIndicationBiggroupBgState();
}

class _AudioIndicationBiggroupBgState extends State<AudioIndicationBiggroupBg> with SingleTickerProviderStateMixin {


  AnimationController _animationController;
  bool showIndication = false;

  @override
  void initState() {

    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    _animationController.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        _animationController.reset();
        setState(() {
          showIndication = false;
        });
      }
    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    if(_animationController != null){
      _animationController.dispose();
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    for(var dt in widget.remoteUserAudioInfo)
      if(dt.uid.toString() == widget.userId && dt.volume > 0){
        _animationController.forward();
        setState(() {
          showIndication = true;
        });
      }else if(dt.uid == 0 && dt.volume > 0 && widget.fromId != null && widget.fromId == widget.userId){
      _animationController.forward();
      setState(() {
        showIndication = true;
      });
    }

    
    return showIndication ? Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
        //  color: Colors.pinkAccent,
         // color: nColor,
          image: DecorationImage(
            image: AssetImage("assets/big_group/voice_room/far_thick2.gif"),
            fit: BoxFit.cover,
          ),
         // borderRadius: BorderRadius.all(new Radius.circular(8.0)),
          // border: Border.all(
          //   color: Color(0xfffbfa8b),
          //   width: 0.5,
          // ),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.withOpacity(0.5),
          //     spreadRadius: 1,
          //     blurRadius: 4,
          //     offset: Offset(0, 1), // changes position of shadow
          //   ),
          // ],
        ),
      ) : Container(height: 100, width: 100,);
  }
}
