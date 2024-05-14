import 'dart:async';

import 'package:chat_app/util/constants.dart';
import 'package:flutter/material.dart';


class TimerController extends ValueNotifier<bool> {
  TimerController({bool isPlaying = false}) : super(isPlaying);

  void startTimer() => value = true;
  void stopTimer() => value = false;

}


class TimerWidget extends StatefulWidget {
  final TimerController controller;
  TimerWidget({this.controller});

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {

  @override
  void initState() {

    super.initState();
    widget.controller.addListener(() {
      if(widget.controller.value){
        startTimer();
      }else{
        stopTimer();
      }
    });
  }


  Duration duration = Duration();
  Timer timer;

  void reset() => setState(() => duration = Duration());

  void addTime(){
   final addSecond = 1;
   setState(() {
     final second = duration.inSeconds + addSecond;
     if(second < 0){
       if(timer != null){
         timer.cancel();
       }
     }else{
       duration = Duration(seconds: second);
     }
   });
  }

  void startTimer({bool resets = true}){
    if (!mounted) return;
    if(resets){
      reset();
    }
    timer = Timer.periodic(Duration(seconds: 1), (timer) => addTime());
  }

  void stopTimer({bool resets = true}){
    if (!mounted) return;
    if(resets){
      reset();
    }
    setState(() {
      if(timer != null){
        timer.cancel();
      }
    });
  }



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String toDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = toDigits(duration.inMinutes.remainder(60));
    final seconds = toDigits(duration.inSeconds.remainder(60));


    return widget.controller.value ? Container(
      width: 100,
      child: Center(
        child: Text('$minutes : $seconds', style: TextStyle(
          fontSize: 20,
          fontFamily: "Roboto",
          fontWeight: FontWeight.w600
        )),
      ),
    ) : Container();
  }
}
