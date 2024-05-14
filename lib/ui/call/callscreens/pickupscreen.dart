
import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/call/call_method.dart';
import 'package:chat_app/ui/call/callscreens/callscreen.dart';
import 'package:chat_app/ui/call/callscreens/callscreenaudio.dart';
import 'package:chat_app/ui/call/model/Call.dart';
import 'package:chat_app/ui/call/permissionhandler.dart';
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

class PickupScreen extends StatefulWidget {

  final CallMethods callMethods = CallMethods();
 // final Call call;
  final UserModel userModel;
  final Call call ;
  PickupScreen({this.userModel, this.call});

  @override
  _PickupScreenState createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> with SingleTickerProviderStateMixin {

  final _fireStore = FirebaseFirestore.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  AnimationController controller;
  Animation animation;
  CallMethods _callMethods = CallMethods();
  Call call;
  bool isCallInitiated = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    animation = CurvedAnimation(parent: controller, curve: Curves.bounceInOut);
  //  animation = ColorTween(begin: Colors.grey, end: Colors.black).animate(controller);

    controller.forward();

    animation.addStatusListener((status) {
      if(status == AnimationStatus.completed){
         controller.reverse(from: 1);
      }else if(status == AnimationStatus.dismissed) {
         controller.forward();
      }
    });

    controller.addListener(() {
    // print(animation.value);
      setState(() {

      });
    });

    print("pickup layout initiated =================================>>>>>>>>>>>>>>>>>>>>>>");

    initialMethods();

  }

  StreamSubscription streamSubscription;

  initialMethods(){

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      streamSubscription = CallMethods().callStream(uid: widget.userModel.id.toString())
          .listen((DocumentSnapshot ds) {
            var dt = ds.data() as Map;
        if (dt != null && dt['caller_id'] == widget.userModel.id.toString() ||
            dt != null && dt['receiver_id'] == widget.userModel.id.toString()
        && dt['on_call_received'] == false
        ) {
          setState(() {
            isCallInitiated = true;
            call = Call.fromMap(ds.data());
          });
          runMethodRemoteNotification(call: call);
          print(" fire time ==============================================>>>>>>>>>> >>>>>>");
        }else{
          setState(() {
            isCallInitiated = false;
          });
        }
      });
    });
  }


  // ringing notification
  runMethodRemoteNotification({Call call}){
    try {
      var dbref = _database.child("ringing");
      dbref.push().set({
        "userId": widget.userModel.id.toString(),
      });
      dbref.orderByChild("userId")
          .equalTo(widget.userModel.id.toString())
          .once()
          .then((value) {
        final dt = Map<String, dynamic>.from(value.snapshot.value);
        dt.forEach((key, value) {
          dbref.child(key).onDisconnect().remove();
        });
      });
    }catch(e){
      print(e);
    }
  }

// ringing notification remove
  removeRemoteNotification(){
    try {
      var dbref = _database.child("ringing");
      dbref.orderByChild("userId")
          .equalTo(widget.userModel.id.toString())
          .once()
          .then((value) {
            if(value.snapshot.value != null) {
              final dt = Map<String, dynamic>.from(value.snapshot.value);
              dt.forEach((key, value) {
                dbref.child(key).remove();
              });
            }
      });
    }catch(e){
      print(e);
    }

  }




  @override
  void dispose() {
    controller.dispose();
    streamSubscription.cancel();
    removeRemoteNotification();
    super.dispose();


  }


  void startServiceInPlatform() async{
    if(Platform.isAndroid){
      var methodChannel = MethodChannel("com.callService");
      String data = await methodChannel.invokeMethod("startService");
    }
  }

  // remove incoming call notification when pickup screen showing
  void removeIncomingCallNotification() async{
    if(Platform.isAndroid){
      var methodChannel = MethodChannel("com.floatingActionButton");
      String data = await methodChannel.invokeMethod("incomingNotifyClose");
    }
  }



  @override
  Widget build(BuildContext context) {
    return isCallInitiated ? Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            bottom: 0,
            child: Container(
                child: cachedNetworkImg(context, call.callerPic)),
          ),
          ClipRRect( // Clip it cleanly.
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.grey.withOpacity(0.1),
                alignment: Alignment.center,
                child: Text(
                  '',
                  style: TextStyle(
                      fontSize: 28,
                      fontFamily: 'Segoe',
                      fontWeight: FontWeight.w600,
                      color: Colors.white
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(height: 130,),
                    Text(
                     widget.call.type == 1 ? 'Incoming audio call' : "Incoming video call",
                      style: ftwhite14,
                    ),
                    SizedBox(height: 20,),
                    Container(
                        width: 80, height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(150)),
                        ),
                        child: cachedNetworkImageCircular(context, call.callerPic)
                    ),
                    SizedBox(height: 20,),
                    Text(
                      call.callerName,
                      style: ftwhite20,
                    ),
                  ],
                ),

                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 110,
                          width: 70,
                          margin: EdgeInsets.only(left: 50),
                          child: Stack(
                            children: [
                            Positioned(
                              top: 55,
                              child: GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.redAccent,
                                  ),
                                  child: Icon(
                                    Icons.call,
                                    size: 30,
                                    color: Colors.white,
                                  ),

                                ),
                                onTap: () async {
                                  removeIncomingCallNotification();
                                  await widget.callMethods.endCall(call: call);
                                  startServiceInPlatform();
                                  removeRemoteNotification();
                                },
                              ),
                            ),
                            ],
                          ),
                        ),

                        Container(
                          height: 110,
                          width: 70,
                          margin: EdgeInsets.only(right: 50),
                          child: Stack(
                            children: [
                            Positioned(
                              right: 15,
                                bottom: animation.value * 85,
                                child: Icon(
                                  Icons.ring_volume,
                                  color: Colors.white,
                                ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: animation.value * 30,
                              child: GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: widget.call.type == 1 ? Colors.lightGreen : Colors.lightBlueAccent,
                                  ),
                                  child: Icon(
                                    widget.call.type == 1 ? Icons.call : Icons.video_call,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                                onTap: () async {
                                  if(await PermissionHandlerUser().onJoin()) {
                                    removeIncomingCallNotification();
                                    startServiceInPlatform();
                                       widget.call.type == 1 ?
                                       Navigator.of(context).pushNamed("/audioCallScreen", arguments:
                                       {'from': widget.userModel,
                                         'toUserId': call.callerId,
                                         'toUserPhoto': call.callerPic,
                                         'role' : ClientRole.Broadcaster,
                                         'onReceive' : true,
                                       }) : Navigator.of(context).pushNamed("/videoCallScreen", arguments:
                                       {'from': widget.userModel,
                                         'toUserId': call.callerId,
                                         'toUserPhoto': call.callerPic,
                                         'role' : ClientRole.Broadcaster,
                                         'onReceive' : true,
                                       });

                                    removeRemoteNotification();

                                    DocumentReference r = _fireStore
                                        .collection("call")
                                        .doc(widget.userModel.id.toString());
                                    r.update({"on_call_received" : true});


                                  }
                                },
                                  // Navigator.push(context,
                                  //     MaterialPageRoute(builder: (context) => CallScreen(call: widget.call)));


                              ),
                            ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 65,),
                  ],
                ),

              ],
            ),
          ),
        ],
      ),
    ) : Container();
  }
}

