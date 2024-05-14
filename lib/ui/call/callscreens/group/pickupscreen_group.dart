
import 'dart:io';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/call/callscreens/callscreen.dart';
import 'package:chat_app/ui/call/callscreens/group/callscreenaudio_group.dart';
import 'package:chat_app/ui/call/group_call_util/group_call_method.dart';
import 'package:chat_app/ui/call/model/Call.dart';
import 'package:chat_app/ui/call/permissionhandler.dart';
import 'package:chat_app/ui/chatroom/model/agora_token_model.dart';
import 'package:chat_app/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PickupScreenGrooup extends StatefulWidget {

  final CallMethodsGroup callMethods = CallMethodsGroup();
  final Call call;
  final UserModel userModel;
  final int callType;
  PickupScreenGrooup({this.call,this.userModel, this.callType});

  @override
  _PickupScreenGrooupState createState() => _PickupScreenGrooupState();
}

class _PickupScreenGrooupState extends State<PickupScreenGrooup> with SingleTickerProviderStateMixin {

  AnimationController controller;
  Animation animation;

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


  }


  @override
  void dispose() {
    controller.dispose();
    super.dispose();

  }

  void startServiceInPlatform() async{
    if(Platform.isAndroid){
      var methodChannel = MethodChannel("com.callService");
      String data = await methodChannel.invokeMethod("startService");
      print(data);
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Incoming...Group',
              style: ftwhite10,
            ),
            SizedBox(height: 20,),
            Container(
              width: 150, height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(150)),
                ),
                child: cachedNetworkImg(context, widget.call.callerPic)
            ),
            SizedBox(height: 20,),
            Text(
              widget.call.callerName,
              style: ftwhite20,
            ),
            SizedBox(height: 75,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 110,
                  width: 70,
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
                          await widget.callMethods.endCall(call: widget.call, user: widget.userModel);
                          startServiceInPlatform();
                        },
                      ),
                    ),
                    ],
                  ),
                ),
                SizedBox(width: 50,),
                Container(
                  height: 110,
                  width: 70,
                  child: Stack(
                    children: [
                    Positioned(
                      left: 15,
                        bottom: animation.value * 85,
                        child: Icon(
                            Icons.ring_volume,
                          color: Colors.white,
                        ),
                    ),
                    Positioned(
                      bottom: animation.value * 30,
                      child: GestureDetector(
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.lightGreen,
                          ),
                          child: Icon(
                            Icons.call,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () async {
                          if(await PermissionHandlerUser().onJoin()) {
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) =>
                               widget.callType == 1 ? CallVoiceGroup(
                                  call: widget.call,
                                  from: widget.userModel,
                                  role: ClientRole.Broadcaster,
                                  appIdToken: AppIdToken(appId: widget.call.appId, token: widget.call.mtoken),

                                ) : CallScreen(
                                // call: widget.call,
                                 from: widget.userModel,
                                 role: ClientRole.Broadcaster,
                               //  token: widget.call.mtoken,

                               )
                            ));
                            startServiceInPlatform();
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
          ],
        ),
      ),
    );
  }
}

