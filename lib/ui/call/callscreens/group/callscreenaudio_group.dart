import 'dart:async';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/src/utils/settings.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/call/group_call_util/group_callUtil.dart';
import 'package:chat_app/ui/call/group_call_util/group_call_method.dart';
import 'package:chat_app/ui/call/model/Call.dart';
import 'package:chat_app/ui/chatroom/model/agora_token_model.dart';
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


class CallVoiceGroup extends StatefulWidget {

  final CallMethodsGroup callMethods = CallMethodsGroup();
  final Call call;
  final UserModel from;
  final UserModel to;
  final AppIdToken appIdToken;
  final int type;
  CallVoiceGroup({@required this.call, @required this.from, this.to, this.role, this.appIdToken, this.type});



  /// non-modifiable client role of the page
  final ClientRole role;

  @override
  _CallVoiceGroupState createState() => _CallVoiceGroupState();
}

class _CallVoiceGroupState extends State<CallVoiceGroup> {

  StreamSubscription streamSubscription;

  bool muted = false;
  bool _joined = false;
  int _remoteUid = null;
  bool _switch = false;
  RtcEngine _engine;
  bool _isSpeaker = false;

  @override
  void initState() {
    super.initState();


    initPlatformState();

    addPostFrameCallback();
  }

  addPostFrameCallback(){
    streamSubscription = CallUtilsGroup.callMethods.callStream(uid: widget.from.id.toString())
        .listen((DocumentSnapshot snapshot) {
      switch(snapshot.data()){
        case null:
          Navigator.pop(context);
          break;

        default:
          break;
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // clear users
    // destroy sdk
    _engine.leaveChannel();
    _engine.destroy();
    streamSubscription.cancel();
    super.dispose();
  }





  // Initialize the app
  Future<void> initPlatformState() async {
    // Get microphone permission

    Map<Permission, PermissionStatus> status = await [
      Permission.microphone
    ].request();

    // Create RTC client instance
    _engine = await RtcEngine.create(APP_ID);
    // Define event handler
    _engine.setEventHandler(RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          print('joinChannelSuccess $channel $uid');
          setState(() {
            _joined = true;
          });
        }, userJoined: (int uid, int elapsed) {
      print('userJoined $uid');
      setState(() {
        _remoteUid = uid;
      });
    }, userOffline: (int uid, UserOfflineReason reason) {
      print('userOffline $uid');
      setState(() {
        _remoteUid = null;
      });
    }));
    // Join channel 123
    await _engine.joinChannel(widget.appIdToken.token, widget.call.channelId, null, 0);
  }



  Widget _topToolbar() {
    // if (widget.role == ClientRole.Audience) return Container();
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30),
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
          CallIcons(
            icon: Icon(
              Icons.add,
              color: Colors.white,
              size: 25.0,
            ),
            onTap: _onToggleMute,
          ),
          CallIcons(
            icon: Icon(
              Icons.video_call,
              color: Colors.white,
              size: 25.0,
            ),
            onTap: _onToggleMute,
          ),
          CallIcons(
            icon: Icon(
              Icons.note_add,
              color: Colors.white,
              size: 25.0,
            ),
            onTap: _onToggleMute,
          ),
        ],
      ),
    );
  }


  Widget _toolbar() {
    // if (widget.role == ClientRole.Audience) return Container();
    return Container(
      padding: EdgeInsets.only(top: 22,left: 30, right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CallIcons(
            icon: Icon(
              Icons.message,
              color: Colors.white,
              size: 25.0,
            ),
            onTap: _onToggleMute,
            text: "Message",
          ),
          CallIcons(
            icon: Icon(
              Icons.star,
              color: Colors.white,
              size: 25.0,
            ),
            onTap: _onToggleMute,
            text: "Text",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Positioned(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(150)),
                  ),
                  child: cachedNetworkImg(context, widget.call.hasDialled ? widget.call.receiverPic : widget.call.callerPic)),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 70,),
                    Text(
                      widget.call.hasDialled == false
                          ? "Incoming call..."
                          : "Calling...",
                      style: ftwhite12,
                    ),
                    SizedBox(height: 5,),
                    Text(
                      widget.call.hasDialled ? widget.call.receiverName : widget.call.callerName,
                      style: ftwhite20,
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 190,
                child: Stack(
                  children: [
                    Positioned(
                      child: _topToolbar(),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 91,
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
                      top: 65,
                      left: MediaQuery.of(context).size.width / 2 - 45,
                      child: RawMaterialButton(
                        onPressed: () => widget.callMethods.endCall(call: widget.call, user: widget.from),
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
    );
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
              color: Colors.white.withOpacity(0.4),
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




