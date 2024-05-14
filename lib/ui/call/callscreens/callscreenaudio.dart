import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:chat_app/media_player/media_player.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/src/utils/settings.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/call/call_method.dart';
import 'package:chat_app/ui/call/model/Call.dart';
import 'package:chat_app/ui/call/permissionhandler.dart';
import 'package:chat_app/ui/call/provider/call_provider.dart';
import 'package:chat_app/ui/call/util/callUtil.dart';
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class CallVoice extends StatefulWidget {
  final CallMethods callMethods = CallMethods();
  final UserModel from;
  final String toUserId;
  final String toUserPhoto;
  final ClientRole role;
  final bool onReceive;

  CallVoice({@required this.from, this.toUserId, this.toUserPhoto, this.role, this.onReceive});


  @override
  _CallVoiceState createState() => _CallVoiceState();
}

class _CallVoiceState extends State<CallVoice> with WidgetsBindingObserver {

  CallMethods _callMethods = CallMethods();
  MediaPlayer mPlayer = MediaPlayer();
  final _fireStore = FirebaseFirestore.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.reference();

  StreamSubscription streamSubscription;

  bool muted = false;
  RtcEngine _engine;
  bool _isSpeaker = false;
  bool otherCall = false;
 // bool isCallRunning = false;

  PersonalCallProvider _personalCallProvider;


  // call time section


  var sWatch = Stopwatch();
  final dur = Duration(seconds: 1);
  void startTimer(){
    Timer(dur, keepRunning);
  }
  void keepRunning() {
    if(sWatch.isRunning){
      startTimer();
    }

  _personalCallProvider.setNewTime(nNewTime: sWatch.elapsed.inHours.toString().padLeft(2,'0') + ":"+
      (sWatch.elapsed.inMinutes%60).toString().padLeft(2,"0") +":"+
      (sWatch.elapsed.inSeconds%60).toString().padLeft(2,"0"));

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

  // set state only munted data very important to fix error ==== setState after dispose method
  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }




  @override
  void initState() {
    super.initState();
    checkIfCallRunning();
    WidgetsBinding.instance.addObserver(this);
  }

  checkIfCallRunning(){
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      _personalCallProvider = Provider.of<PersonalCallProvider>(context, listen: false);
      if (!_personalCallProvider.callRunning) {
        runMethodAnotherCallNotification();
        callScreenMethods();
      } else {
        // if user go for minimize then an issue arised that
        // after coming back to the screen there is no agora engine available to distroy
        // so this is for extra step to initialize the agora sdk then distroy it so
        // next time it will not create new issue
        // strange hack
        // create a engine again to remove any issue
        _engine = await RtcEngine.createWithConfig(RtcEngineConfig(_personalCallProvider.callData.appId));
        addPostFrameCallback();

      }
    });
  }

  startCallerSound() async {
   mPlayer.initPlayer();
   await mPlayer.audioCache.loop("audios/call_progress.wav");
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
        if(dt != null) {
          dt.forEach((key, value) {
            dbref.child(key).remove();
          });
        }
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
            if (value["userId"] == widget.toUserId) {
              inCall = true;
              setState(() {
                otherCall = true;
              });
            }
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
            type: 1
        );
        // set call data to provider to get into after minimized screen
        _personalCallProvider.getCallDataProvider(call: calls);

        Future.delayed(Duration(seconds: 60), () {
          if (_personalCallProvider.callData.hasDialled) {
            // call will be dropped when user not connected
            if (!_personalCallProvider.isConneted) {
              widget.callMethods.endCall(call: _personalCallProvider.callData);
            }
          }
        });
        await initPlatformState();
        addPostFrameCallback();
      }
    }
  }


  callScreenMethods() async {

      var inCall = await checkIfInAnotherCallOrNot();
      await PermissionHandlerUser().onJoin();

      if(widget.onReceive) {
        DocumentReference r = _fireStore
            .collection("call")
            .doc(widget.from.id.toString());
        r.update({"on_call_received": true});
        DocumentReference caller = _fireStore
            .collection("call")
            .doc(widget.toUserId);
        caller.update({"on_call_received": true});


      await _fireStore.collection("call").doc(widget.from.id.toString()).get().then((value) async {

        DocumentSnapshot ds = value;
        var dt = ds.data() as Map;
        if (ds.data() != null && dt['caller_id'] == widget.from.id.toString() ||
            ds.data() != null && dt['receiver_id'] == widget.from.id.toString()) {
          var calls = Call.fromMap(ds.data());
          // set call data to provider to get into after minimized screen
          _personalCallProvider.getCallDataProvider(call: calls);

        }
      });

      await initPlatformState();

        addPostFrameCallback();

      }

  }

  addPostFrameCallback() {
    streamSubscription = CallUtils.callMethods
        .callStream(uid: widget.from.id.toString())
        .listen((DocumentSnapshot snapshot) {
      switch (snapshot.data()) {
        case null:
          endVoiceCall();
          _personalCallProvider.setCallStatus(callRunning: false);
          Navigator.pop(context);
          break;
        default:
          break;
      }
    });
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch(state){
      case AppLifecycleState.resumed:
          startAFloatingActionButtonRemove(
              userId: widget.from.id.toString(), groupId: widget.toUserId);
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
      // Start floating button
        if(_personalCallProvider.callRunning) {
          startAFloatingActionButton(
            fromId: widget.from.id.toString(),
            receiverId: _personalCallProvider.callData.receiverId,
            receiverImage: _personalCallProvider.callData.receiverPic,
            receiverName: _personalCallProvider.callData.receiverName,
          );


        }
        // whenLeftTheRoom();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }




  @override
  void dispose() {
  //  endVoiceCall();
    WidgetsBinding.instance.removeObserver(this);
    if(streamSubscription != null) {
      streamSubscription.cancel();
    }
    super.dispose();
  }

  endVoiceCall() async {
    stopStopwatch();
    _personalCallProvider.setConnectedState(isConnected: false);
    _personalCallProvider.setNewTime(nNewTime: "00:00:00");
    _personalCallProvider.setShowTimer(isShown: false);
    if(mPlayer != null && mPlayer.advancedPlayer != null) {
      mPlayer.advancedPlayer.stop();
    }

    // if user go for minimize then an issue arised that
    // after coming back to the screen there is no agora engine available to distroy
    // so this is for extra step to initialize the agora sdk then distroy it so
    // next time it will not create new issue
    // strange hack
    // create a engine again to remove any issue
    //  _engine = await RtcEngine.createWithConfig(RtcEngineConfig(APP_ID));

    if(_engine != null) {
      _engine.leaveChannel();
      _engine.destroy();

    }

    if(streamSubscription != null) {
      streamSubscription.cancel();
    }

    removeRemoteAnotherCallNotification();

    // set value to provider

  }


  // Initialize the app
  Future<void> initPlatformState() async {

    Map<Permission, PermissionStatus> status = await [
      Permission.microphone
    ].request();


    // Create RTC client instance
    _engine = await RtcEngine.createWithConfig(RtcEngineConfig(_personalCallProvider.callData.appId));
    // Define event handler
    _engine.setEventHandler(RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) async {
      await startCallerSound();
      if(widget.onReceive){
        // stop beep when user come from pickup layout
          await mPlayer.advancedPlayer.stop();
      }
      // add call status to provider
          _personalCallProvider.setCallStatus(callRunning: true);
    }, userJoined: (int uid, int elapsed) {

      // call will not drop when user connected
      _personalCallProvider.setConnectedState(isConnected: true);
      _personalCallProvider.setShowTimer(isShown: true);
       // stop beep after user receive the call
        mPlayer.advancedPlayer.stop();
      // start time
      startStopwatch();
    }, userOffline: (int uid, UserOfflineReason reason) {
    },

      userMuteAudio: (num, bool){
        _personalCallProvider.setRemoteStatusBool(status: true);
        _personalCallProvider.setRemoteStatusText(
            status: bool ? "User muted audio" : "User un muted audio"
        );
        if(!bool){
          Future.delayed(Duration(seconds: 2), () {
            _personalCallProvider.setRemoteStatusBool(status: false);
          });
        }
      },
      networkQuality: (n, n2, n3){
          _personalCallProvider.getNetwrokStatus(state: n2);
      },
      connectionLost: () {
          _personalCallProvider.setConnectionLost();
      },




    ));
    // Join channel 123
    // setting channel profile as live broad casting
    _engine.setChannelProfile(ChannelProfile.Communication);

    await _engine.joinChannel(_personalCallProvider.callData.mtoken, _personalCallProvider.callData.channelId, null, widget.from.id);
  }

  Widget _topToolbar() {
    // if (widget.role == ClientRole.Audience) return Container();
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
        ],
      ),
    );
  }


  Widget _toolbar() {
    // if (widget.role == ClientRole.Audience) return Container();
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


  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onToggleSpeaker() {
    setState(() {
      _isSpeaker = !_isSpeaker;
    });
    _engine.setEnableSpeakerphone(_isSpeaker);
  }


  Future<bool> getExitPermisison(BuildContext context) async {
    startAFloatingActionButton(
      fromId: widget.from.id.toString(),
      receiverId: _personalCallProvider.callData.receiverId,
      receiverImage: _personalCallProvider.callData.receiverPic,
      receiverName: _personalCallProvider.callData.receiverName,
    );

    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
     PersonalCallProvider _pcp = Provider.of<PersonalCallProvider>(context, listen: true);

    String status = "Calling";
    return _pcp.isCallInitiated ? Scaffold(
      backgroundColor: Colors.black,
      body: WillPopScope(
        onWillPop: () => getExitPermisison(context),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                left: 0,
                top: 0,
                right: 0,
                bottom: 0,
                child: Container(
                    child: cachedNetworkImg(context, _pcp.callData.hasDialled ? _pcp.callData.receiverPic : _pcp.callData.callerPic)),
              ),
              ClipRRect( // Clip it cleanly.
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: Colors.grey.withOpacity(0.1),
                    alignment: Alignment.center,
                    child: Text(
                      _pcp.callData.hasDialled ? _pcp.callData.receiverName : _pcp.callData.callerName,
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
              Positioned(
                left: MediaQuery.of(context).size.width / 2 - 40,
                top: 180,
                child: Container(
                    width: 80,
                    height: 80,
                    child: cachedNetworkImageCircular(context, _pcp.callData.hasDialled ? _pcp.callData.receiverPic : _pcp.callData.callerPic)),
              ),
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
                      receiverId: _pcp.callData.receiverId,
                      receiverImage: _pcp.callData.receiverPic,
                      receiverName: _pcp.callData.receiverName,
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
                              final dts = (event.data as DatabaseEvent)
                                  .snapshot
                                  .value as Map<Object, dynamic>;
                              print(dts);
                              dts.forEach((key, value) {
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
                                  _pcp.isConneted ? "Connected" : _pcp.callData.hasDialled == false
                                      ? "Incoming call"
                                      : status,
                                  style: ftwhite14,
                                ),
                                SizedBox(width: 5,),
                                _pcp.isConneted ? Icon(Icons.lock, size: 13,color: Colors.white,) : Container(),
                              ],
                            );
                          }),

                      SizedBox(height: 3),
                      _pcp.isShowTimer ? Container(
                          child: Text('${_pcp.stopwatchtime}',style: TextStyle(
                              fontSize: 12,
                              color: Colors.white
                          ),)
                      ) : Container(),
                      SizedBox(height: 3,),

                      Text(_pcp.networkStatus, style: TextStyle(
                        color: Colors.green,
                        fontSize: 10
                      ),
                        textAlign: TextAlign.center,
                      ),
                      _pcp.showRemoteStatus ? SizedBox(height: 3,) : SizedBox(height: 0,),
                      _pcp.showRemoteStatus ? Text(_pcp.remoteStatus, style: TextStyle(
                        color: Colors.white,
                      ),
                        textAlign: TextAlign.center,
                      ) : Container(),
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
                          child: _topToolbar(),
                        bottom: 80,
                      ),
                      Positioned(
                        left: 0,
                        bottom:30,
                        right: 0,
                        child: _toolbar(),
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
                              endVoiceCall();
                              if(_pcp.callData != null) {
                                widget.callMethods.endCall(call: _pcp.callData);
                              }
                              // set call status to provider false
                              _pcp.setCallStatus(callRunning: false);
                              _pcp.setInitializationFalse();
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
      ),
    )
        : Scaffold(
          backgroundColor: Colors.black,
          body: WillPopScope(
              onWillPop: () => getExitPermisison(context),
            child: Container(
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
                                  endVoiceCall();
                                  if(_pcp.callData != null) {
                                    widget.callMethods.endCall(
                                        call: _pcp.callData);
                                  }
                                  // set call status to provider false
                                  _pcp.setCallStatus(callRunning: false);
                                  _pcp.setInitializationFalse();
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
          ),
    );
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


  // remove floating button
  void startAFloatingActionButtonRemove({String userId, String groupId}) async{
    if(Platform.isAndroid){
      var methodChannel = MethodChannel("com.floatingActionButton");
      String data = await methodChannel.invokeMethod("incomingNotifyClose",{"userId": userId, "groupId": groupId});
    }
  }



}

class CallIcons extends StatelessWidget {

  final Icon icon;
  final Function onTap;
  final String text;
  CallIcons({this.icon,this.onTap, this.text});

  @override
  Widget build(BuildContext context) {
     return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.6),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: icon,
          ),
          SizedBox(height: 4,),
          text != null ? Text("$text",
            style: flwhite8
          ) : Container(),
        ],
      ),

    );
  }
}

