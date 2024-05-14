import 'dart:async';
import 'dart:io';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:chat_app/media_player/media_player.dart';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/src/utils/settings.dart';
import 'package:chat_app/ui/call/call_method.dart';
import 'package:chat_app/ui/call/model/Call.dart';
import 'package:chat_app/ui/call/permissionhandler.dart';
import 'package:chat_app/ui/call/util/callUtil.dart';
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';
import 'callscreenaudio.dart';


class CallScreen extends StatefulWidget {

  final CallMethods callMethods = CallMethods();
  final UserModel from;
  final String toUserId;
  final String toUserPhoto;
  final UserModel to;
  final bool onReceive;
  CallScreen({
    @required this.from, this.to,
    this.toUserId,
    this.toUserPhoto,
    this.role,
    this.onReceive
  });


  /// non-modifiable client role of the page
  final ClientRole role;


  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {


  final DatabaseReference _database = FirebaseDatabase.instance.reference();

  StreamSubscription callStreamSubscription;
  MediaPlayer mPlayer = MediaPlayer();
  final _fireStore = FirebaseFirestore.instance;
  CallMethods _callMethods = CallMethods();

  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  RtcEngine _engine;
  bool _isSpeaker = false;
  bool isConneted = false;
  bool isCamerOn = false;
  bool connectionStatus = false;
  String networkStatus = "";
  String remoteStatus = "";
  bool showRemoteStatus = false;
  bool isVideoExchanged = false;
  Call call;
  bool isCallInitiated = false;
  bool otherCall = false;




  // call time section
  bool isShowTimer = false;
  String stopwatchtime = "00:00:00";
  var sWatch = Stopwatch();
  final dur = Duration(seconds: 1);
  void startTimer(){
    Timer(dur, keepRunning);
  }


  void keepRunning() {
    if(sWatch.isRunning){
      startTimer();
    }
    setState(() {
      stopwatchtime = sWatch.elapsed.inHours.toString().padLeft(2,'0') + ":"+
          (sWatch.elapsed.inMinutes%60).toString().padLeft(2,"0") +":"+
          (sWatch.elapsed.inSeconds%60).toString().padLeft(2,"0");
    });
  }
  startStopwatch(){
    sWatch.start();
    startTimer();
  }
  stopStopwatch(){
    sWatch.stop();
    sWatch.reset();
  }
  // call time section end


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  // or Wakelock.toggle(on: true);
    runMethodAnotherCallNotification();
    callScreenMethods();

  }

  startCallerSound() async {
    mPlayer.initPlayer();
    await mPlayer.audioCache.loop("audios/call_progress.wav");
  }

  callScreenMethods() async {


    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      var inCall = await checkIfInAnotherCallOrNot();


      if(widget.onReceive) {
        DocumentReference r = _fireStore
            .collection("call")
            .doc(widget.from.id.toString());
        r.update({"on_call_received": true});

        DocumentReference caller = _fireStore
            .collection("call")
            .doc(widget.toUserId);
        caller.update({"on_call_received": true});

        _fireStore.collection("call").doc(widget.from.id.toString())
            .get()
            .then((value) async {
          DocumentSnapshot ds = value;
          var dt = ds.data() as Map;
          if (ds.data() != null && dt['caller_id'] == widget.from.id.toString() ||
              ds.data() != null && dt['receiver_id'] == widget.from.id.toString()) {
            var calls = Call.fromMap(ds.data());
            setState(() {
              call = calls;
              isCallInitiated = true;
            });
            await PermissionHandlerUser().onJoin();
          }
        });
        await initializeAgora();
        addPostFrameCallback();

      }




    });



  }

 Stream ringingAtReceiverEnd(){
    var dbref = _database.child("ringing");
    return dbref.orderByChild("userId").equalTo(widget.toUserId).onValue;
  }


  // another call notification
  runMethodAnotherCallNotification(){
    try {
      var dbref = _database.child("inAnotherCall");
      dbref.push().set({
        "userId": widget.from.id.toString(),
      });
      dbref.orderByChild("userId")
          .equalTo(widget.from.id.toString())
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

// another call notification remove
  removeRemoteAnotherCallNotification(){
    try {
      var dbref = _database.child("inAnotherCall");
      dbref.orderByChild("userId")
          .equalTo(widget.from.id.toString())
          .once()
          .then((value) {
        final dt = Map<String, dynamic>.from(value.snapshot.value);
        dt.forEach((key, value) {
          dbref.child(key).remove();
        });
      });
    }catch(e){
      print(e);
    }
  }


  checkIfInAnotherCallOrNot() async {
    bool inCall = false;
    try {
      await _database.child("inAnotherCall").orderByChild("userId").equalTo(widget.toUserId).once().then((value) {
        if (value.snapshot.value != null) {
          final dt = Map<String, dynamic>.from(value.snapshot.value);
          dt.forEach((key, value) {
            print("======================================================= bool value ");
            print(value);
            print(widget.toUserId);
            if (value["userId"] == widget.toUserId) {
              print("user in another call ");
              inCall = true;
              setState(() {
                otherCall = true;
              });
            }
            print(inCall);
          });
        }
      });
    }catch(e){
      print(e);
    }


    if(!inCall) {
      if (!widget.onReceive) {
        Call calls = await CallUtils.mdial(
            from: widget.from,
            toUserId: widget.toUserId,
            context: context,
            type: 2
        );
        print(calls.mtoken);
        print(calls.hasDialled);

        setState(() {
          call = calls;
          isCallInitiated = true;
        });


        Future.delayed(Duration(seconds: 60), () {
          if (call.hasDialled) {
            // call will be dropped when user not connected
            if (!isConneted) {
              widget.callMethods.endCall(call: call);
              print("function fired on call screen");
            }
          }
        });

        await initializeAgora();
        addPostFrameCallback();
      }

    }




    // To keep the screen on:
    Wakelock.enable();

  }


  endVideoCall() {
    stopStopwatch();
    if(mPlayer != null && mPlayer.advancedPlayer != null) {
      mPlayer.advancedPlayer.stop();
    }
    // clear users
    _users.clear();
    // destroy sdk
    if(_engine != null) {
      _engine.leaveChannel();
      _engine.destroy();
    }
    if(callStreamSubscription != null) {
      callStreamSubscription.cancel();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
   endVideoCall();
   removeRemoteAnotherCallNotification();
    super.dispose();
  }



  addPostFrameCallback(){
    callStreamSubscription = CallUtils.callMethods.callStream(uid: widget.from.id.toString())
        .listen((DocumentSnapshot snapshot) {
          print(snapshot);
      switch(snapshot.data()) {
        case null:
          endVideoCall();
          Navigator.pop(context);

          break;

        default:
          break;
      }

    });
  }




  Future<void> initializeAgora() async {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await _engine.enableWebSdkInteroperability(true);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = VideoDimensions(height: 1920, width:1080);
    await _engine.setVideoEncoderConfiguration(configuration);
    await _engine.joinChannel(call.mtoken, call.channelId, null, 0);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(call.appId);
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(widget.role);
  }


  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    }, joinChannelSuccess: (channel, uid, elapsed) async {
      final info = 'onJoinChannel: $channel, uid: $uid';
      setState(() {
        _infoStrings.add(info);
      });
      await startCallerSound();
      if(widget.onReceive){
        // stop beep when user come from pickup layout
       await mPlayer.advancedPlayer.stop();
        print("you are thinking why it is firings1??");
      }
    }, leaveChannel: (stats) {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    }, userJoined: (uid, elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
        isShowTimer = true;
        // call will not drop when user connected
        isConneted = true;
      });
      // stop beep after user receive the call
        // stop beep after user receive the call
        mPlayer.advancedPlayer.stop();
      // start time
      startStopwatch();


    }, userOffline: (uid, elapsed) {
      widget.callMethods.endCall(call: call);
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
      });
    }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    },
      userMuteVideo: (num, bool){
       setState(() {
         remoteStatus = bool ? "User muted video" : "User un muted video";
         showRemoteStatus = true;
       });
       if(!bool){
         Future.delayed(Duration(seconds: 2), () {
           setState(() {
             showRemoteStatus = false;
           });
         });
       }
      },

      userMuteAudio: (num, bool){
        setState(() {
          remoteStatus = bool ? "User muted audio" : "User un muted audio";
          showRemoteStatus = true;
        });
        if(!bool){
          Future.delayed(Duration(seconds: 2), () {
            setState(() {
              showRemoteStatus = false;
            });
          });
        }
      },
      userEnableVideo: (num, bool){
      },
      userEnableLocalVideo: (num, bool){
      },
      networkQuality: (n, n2, n3){
        switch(n2){
          case NetworkQuality.Bad:
            setState(() {
              networkStatus = "Network bad";
            });
            break;
          case NetworkQuality.Detecting:
            setState(() {
              networkStatus = "Network detecting";
            });
            break;
          case NetworkQuality.Down:
            setState(() {
              networkStatus = "Network down";
            });
            break;
          case NetworkQuality.Excellent:
            setState(() {
              networkStatus = "Network excellent";
            });
            break;
          case NetworkQuality.Good:
            setState(() {
              networkStatus = "Network good";
            });
            break;
          case NetworkQuality.Poor:
            setState(() {
              networkStatus = "Network poor";
            });
            break;
          case NetworkQuality.Unsupported:
            setState(() {
              networkStatus = "Network unsupported";
            });
            break;
          case NetworkQuality.VBad:
            setState(() {
              networkStatus = "Network very bad";
            });
            break;

          default:
        }
      },
      connectionLost: () {
        setState(() {
          networkStatus = "Connection lost";
        });
      },
      microphoneEnabled: (bool) {
      },


    ));
  }





  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 2:
        if(!isVideoExchanged) {
          return videoHolder(views, 1, 0);
        }else{
          return videoHolder(views, 0, 1);
        }
        break;

      default:
    }
    return Container();
  }

  videoHolder(List<Widget> views, large, small){
   return Container(
        child: Stack(
          children: <Widget>[
            _expandedVideoRow([views[large]]),
            Positioned(
              bottom: 90,
              right: 20,
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    isVideoExchanged = !isVideoExchanged;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  width: 95,
                  height: 115,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: _expandedVideoRow([views[small]])
                  ),
                ),
              ),
            ),

          ],
        ));
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(
        child: Container(
          child: view,
        )
    );
  }


  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Container(
      child: Row(
        children: wrappedViews,
      ),
    );
  }



  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    if (widget.role == ClientRole.Broadcaster) {
      list.add(RtcLocalView.SurfaceView());
    }
    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
    return list;
  }

  Widget _topToolbar() {
     if (widget.role == ClientRole.Audience) return Container();
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CallIcons(
            icon: Icon(
              isCamerOn ? Icons.videocam_off_outlined : Icons.videocam_outlined,
              color: Colors.white,
              size: 25.0,
            ),
            onTap: _onToggleCameraOnOff,
          ),
          SizedBox(height: 20,),
          CallIcons(
            icon: Icon(
              Icons.flip_camera_ios_outlined,
              color: Colors.white,
              size: 25.0,
            ),
            onTap: _onSwitchCamera,
          ),

        ],
      ),
    );
  }





  Widget _toolbar() {
     if (widget.role == ClientRole.Audience) return Container();
    return Container(
      padding: EdgeInsets.only(top: 15,left: 30, right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CallIcons(
            icon: Icon(
              !muted ? Icons.mic : Icons.mic_off,
              color: Colors.white,
              size: 25.0,
            ),
            onTap: _onToggleMute,
          ),
          CallIcons(
            icon: Icon(
              _isSpeaker ? Icons.volume_up : Icons.volume_off,
              color: Colors.white,
              size: 25.0,
            ),
            onTap: _onToggleSpeaker,
          ),
        ],
      ),
    );
  }

  void _onToggleSpeaker() {
    setState(() {
      _isSpeaker = !_isSpeaker;
    });
    _engine.setEnableSpeakerphone(_isSpeaker);
  }

  void _onToggleCameraOnOff() {
    setState(() {
      isCamerOn = !isCamerOn;
    });
    _engine.muteLocalVideoStream(isCamerOn);

  }


  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }


  void _onSwitchCamera() {
    _engine.switchCamera();
  }


  // Start floating button
  void startAFloatingActionButton({String fromId, String receiverId, String receiverImage, String receiverName}) async{
    if(Platform.isAndroid){
      var methodChannel = MethodChannel("com.floatingActionButton");
      String data = await methodChannel.invokeMethod("showCallFloatElement",{
        "fromId": fromId,
        "receiverId": receiverId,
        "receiverImage": receiverImage,
        "receiverName" : receiverName
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    String status = "Calling";
    return isCallInitiated ?  Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            _viewRows(),
            Positioned(
              top: 30,
              left: 10,
              child: IconButton(
                color: Colors.black,
                icon: Icon(Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                ),
                onPressed: (){
                  //  Navigator.pop(context);
                  startAFloatingActionButton(
                    fromId: widget.from.id.toString(),
                    receiverId: call.receiverId,
                    receiverImage: call.receiverPic,
                    receiverName: call.receiverName,
                  );
                  Navigator.pop(context);
                },
              ),
            ),
            Positioned(
              top: 50,
              left: MediaQuery.of(context).size.width / 2 - 100,
              child: Container(
                width: 200,
                padding: EdgeInsets.symmetric(vertical: 3, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.all(new Radius.circular(10.0)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10,),
                    StreamBuilder(
                    stream: ringingAtReceiverEnd(),
                    builder: (BuildContext context, event) {
                      if (!event.hasData)
                        return Text(status);
                      if (event.data.snapshot.value != null) {
                        final dt = Map<String, dynamic>.from((event.data).snapshot.value);
                        dt.forEach((key, value) {
                          final user = Map<String, dynamic>.from(value);
                          if(user["userId"] == widget.toUserId){
                            status = "Ringing";
                          }
                        });
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            isConneted ? "Connected" : call.hasDialled == false
                                ? "Incoming call"
                                : status,
                            style: ftwhite14,
                          ),
                          SizedBox(width: 5,),
                          isConneted ? Icon(Icons.lock, size: 13,color: Colors.white,) : Container(),
                        ],
                      );
                    }),
                    SizedBox(height: 3),
                    isShowTimer ? Container(
                        child: Text('$stopwatchtime',style: TextStyle(
                          fontSize: 12,
                          color: Colors.white
                        ),)
                    ) : Container(),
                    SizedBox(height: 3,),
                    Text(
                      call.hasDialled ? call.receiverName : call.callerName,
                      style: ftwhite15,
                    ),
                    SizedBox(height: 3,),
                    Text(networkStatus, style: TextStyle(
                      color: Colors.white,
                    ),
                      textAlign: TextAlign.center,
                    ),
                   showRemoteStatus ? SizedBox(height: 3,) : SizedBox(height: 0,),
                   showRemoteStatus ? Text(remoteStatus, style: TextStyle(
                      color: Colors.white,
                    ),
                      textAlign: TextAlign.center,
                    ) : Container(),
                    SizedBox(height: 10,),
                  ],
                ),
              ),
            ),
            Positioned(
              child: _topToolbar(),
              bottom: 85,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 150,
                child: Stack(
                  children: [

                    Positioned(
                      left: 0,
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 71,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/call/call_bg.png"),
                              fit: BoxFit.cover
                          ),
                        ),
                        child: _toolbar(),
                      ),
                    ),
                    Positioned(
                      top: 35,
                      left: MediaQuery.of(context).size.width / 2 - 44,
                      child: RawMaterialButton(
                        onPressed: () {
                          endVideoCall();
                          widget.callMethods.endCall(call: call);
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.call,
                          color: Colors.white,
                          size: 35.0,
                        ),
                        shape: CircleBorder(),
                        elevation: 2.0,
                        fillColor: Colors.redAccent,
                        padding: const EdgeInsets.all(15.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ) : Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Positioned(
              left: MediaQuery.of(context).size.width / 2 - 40,
              top: 150,
              child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(new Radius.circular(75.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.all(Radius.circular(150)),
                  // ),
                  child: CircleAvatar(backgroundImage: NetworkImage(widget.toUserPhoto))),
            ),
            Positioned(
              top: 50,
              left: MediaQuery.of(context).size.width / 2 - 100,
              child: Container(
                width: 200,
                padding: EdgeInsets.symmetric(vertical: 3, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.all(new Radius.circular(10.0)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        !otherCall ? Text("Call initializing",
                          style: ftwhite14,
                        ) : Text("In another call",
                          style: ftwhite14,
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                  ],
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 140,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 71,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/call/call_bg.png"),
                              fit: BoxFit.cover
                          ),
                        ),
                        child: _toolbar(),
                      ),
                    ),
                    Positioned(
                      top: 23,
                      left: MediaQuery.of(context).size.width / 2 - 33,
                      child: Container(
                        width: 67,
                        height: 67,
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.call,
                            color: Colors.white,
                            size: 32.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
