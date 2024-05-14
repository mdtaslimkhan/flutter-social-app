

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';

class AudioIndicationBiggroupMic extends StatefulWidget {

  final Color nColor;
  List<AudioVolumeInfo> remoteUserAudioInfo;
  final String userId;
  final String fromId;
  AudioIndicationBiggroupMic({this.nColor, this.remoteUserAudioInfo, this.userId, this.fromId});

  @override
  _AudioIndicationBiggroupMicState createState() => _AudioIndicationBiggroupMicState();
}

class _AudioIndicationBiggroupMicState extends State<AudioIndicationBiggroupMic> with SingleTickerProviderStateMixin {


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
        height: 15,
        width: 15,
        decoration: BoxDecoration(
        //  color: Colors.pinkAccent,
         // color: nColor,
          image: DecorationImage(
            image: AssetImage("assets/icon/mic_2.png"),
            fit: BoxFit.contain,
          ),
        ),
      ) : Container(
      height: 15,
      width: 15,
      decoration: BoxDecoration(
        //  color: Colors.pinkAccent,
        // color: nColor,
        image: DecorationImage(
          image: AssetImage("assets/icon/mic_4.png"),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
