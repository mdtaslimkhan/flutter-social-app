import 'dart:async';
import 'dart:io' as IO;
import 'package:chat_app/ui/chatroom/anim/mention_slide.dart';
import 'package:chat_app/ui/chatroom/anim/spine_animation.dart';
import 'package:chat_app/ui/chatroom/bottomModal/background_images.dart';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/provider/file_upload_provider.dart';
import 'package:chat_app/provider/home_provider.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/call/big_group_call_util/big_group_callUtil.dart';
import 'package:chat_app/ui/call/big_group_call_util/big_group_call_method.dart';
import 'package:chat_app/ui/call/permissionhandler.dart';
import 'package:chat_app/ui/chatroom/audio_recoder/timer_recoder_widget.dart';
import 'package:chat_app/ui/chatroom/big_group_widget/getUserInfo.dart';
import 'package:chat_app/ui/chatroom/big_group_widget/gift_selected_user_bottom_sheet.dart';
import 'package:chat_app/ui/chatroom/fileupload/trim_controller.dart';
import 'package:chat_app/ui/chatroom/function/sound_recoder.dart';
import 'package:chat_app/ui/chatroom/provider/agora_provider_big_group.dart';
import 'package:chat_app/ui/chatroom/provider/big_group_provider.dart';
import 'package:chat_app/ui/chatroom/provider/get_dimond_gem_follow_provider.dart';
import 'package:chat_app/ui/chatroom/fileupload/fileuploadmulti.dart';
import 'package:chat_app/ui/chatroom/fileupload/fileuploadsingle.dart';
import 'package:chat_app/ui/chatroom/fileupload/imageupload.dart';
import 'package:chat_app/ui/chatroom/function/voice_room_methods.dart';
import 'package:chat_app/ui/chatroom/chatmethods/chatmethods_big_group.dart';
import 'package:chat_app/ui/chatroom/model/contact.dart';
import 'package:chat_app/ui/chatroom/model/gift.dart';
import 'package:chat_app/ui/chatroom/model/gift_showing_model.dart';
import 'package:chat_app/ui/chatroom/model/group_call.dart';
import 'package:chat_app/ui/chatroom/widgets/big_group_widgets/chat_button_widget.dart';
import 'package:chat_app/ui/chatroom/widgets/big_group_widgets/room_minimized/voice_room_user_seat_minimized.dart';
import 'package:chat_app/ui/chatroom/widgets/big_group_widgets/voice_room_active_members.dart';
import 'package:chat_app/ui/chatroom/widgets/big_group_widgets/voice_room_hot_seat_expand.dart';
import 'package:chat_app/ui/chatroom/widgets/big_group_widgets/voiceroom_dimond_send_status.dart';
import 'package:chat_app/ui/chatroom/widgets/big_group_widgets/voiceroom_last_gift.dart';
import 'package:chat_app/ui/chatroom/widgets/big_group_widgets/voiceroom_trofi.dart';
import 'package:chat_app/ui/chatroom/widgets/big_group_widgets/voiceroom_waiting_list_holder.dart';
import 'package:chat_app/ui/chatroom/widgets/bottomsheet_list_item.dart';
import 'package:chat_app/ui/chatroom/widgets/gift_widget.dart';
import 'package:chat_app/ui/chatroom/widgets/message_stream.dart';
import 'package:chat_app/ui/pages/profile/group_profile/group_profile.dart';
import 'package:chat_app/ui/pages/profile/group_profile/settings/group_functions.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/profile.dart';
import 'package:chat_app/ui/pages/widgets/progress.dart';
import 'package:chat_app/util/constants.dart';
import 'package:chat_app/util/loading/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:spine_flutter/spine_flutter.dart';
import 'package:video_player/video_player.dart';
import 'big_group_widget/getUserImageByUrl.dart';
import 'package:wakelock/wakelock.dart';
import 'fileupload/video_upload_provider.dart';
import 'provider/get_host_hot_seat_user_list_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

const Map<String, String> all = <String, String>{
  'cauldron': 'idle',
  'girl_and_whale_polygons': 'idle',
  'girl_and_whale_rectangles': 'idle',
  'owl': 'idle',
  'raptor': 'walk',
  'spineboy': 'walk'
};

final _fireStore = FirebaseFirestore.instance;

class ChatRoomBigGroup extends StatefulWidget {
  final ChatMethodsBigGroup _chatMethodsBigGroup = ChatMethodsBigGroup();
  final FileUploadMethods _fileUploadMethods = FileUploadMethods();
  final ImageUploadFunction _imageUploadFunction = ImageUploadFunction();
  final UserModel from;
  final String toGroupId;
  final ContactHome contact;
  final bool floatButton;
  ChatRoomBigGroup({this.from, this.toGroupId, this.contact, this.floatButton});

  @override
  _ChatRoomBigGroupState createState() => _ChatRoomBigGroupState();


}

class _ChatRoomBigGroupState extends State<ChatRoomBigGroup> with TickerProviderStateMixin, WidgetsBindingObserver{

  final SingleFileUploadMethods _singlefileUploadMethods = SingleFileUploadMethods();
  final VoiceRoomMethods roomMethods = VoiceRoomMethods();
  final msgTextEditingController = TextEditingController();
  GroupFunctions _groupFunctions = GroupFunctions();
  final CallMethodsBigGroup callMethodsBigGroup = CallMethodsBigGroup();
  final TrimController _trimController = TrimController();
  final ImagePicker _picker = ImagePicker();
  RtcEngine _engine;
  AgoraProviderBigGroup _agoraProviderBigGroup;
  DimondGemFollowProvider _dimondGemFollowProvider;
  GetHostHotSeatUserProvider _getHostHotSeatUserProvider;
  AnimationController animController;
  BigGroupProvider _bgProvider;
  HomeProvider _hp;
  bool showAnnounce = true;
  bool _showMention = false;
  bool showReplay = false;
  bool _isHost = false;
  String _replayText = '';
  String _replyPhoto = '';
  String _replyName = '';
  String _replyFileUrl = '';
  String _replyId = '';
  bool _forceMute = false;
  String name = all.keys.first;
  bool _showSpineAnim = false;
  // create some values
  Color pickerColor = Color(0xff443a49);
  FocusNode _focusNode;

// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
    roomMethods.setBackgroundColors(groupId: widget.toGroupId, user: widget.from, color: pickerColor);
  }

  // Start floating button
  void startAFloatingActionButton({String userId, String groupId}) async{
    if(IO.Platform.isAndroid){
      var methodChannel = MethodChannel("com.floatingActio"
          ""
          "nButton");
      String data = await methodChannel.invokeMethod("showButton",{
        "userId": userId,
        "groupId": groupId,
        "groupImage": _bgProvider.toGroup.photo,
        "name" : _bgProvider.toGroup.name
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch(state){
      case AppLifecycleState.resumed:

        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        // Start floating button
        if(_bgProvider.isCallRunning) {
          startAFloatingActionButton(
              userId: widget.from.id.toString(), groupId: widget.toGroupId);
        }
         // whenLeftTheRoom();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void dispose() {
    // left the user from room
   // isLeaveHotSeat();
    whenLeftTheRoom();
    if(_animationController!=null){
      _animationController.dispose();
    }
    if(_animationControllerB!=null){
      _animationControllerB.dispose();
    }
    if(_sliderAnimationController!=null){
      _sliderAnimationController.dispose();
    }

    if(_sliderAnimationControllerB!=null){
      _sliderAnimationControllerB.dispose();
    }

    if (streamSubscription != null) {
      streamSubscription.cancel();
    }



    // To let the screen turn off again:
    Wakelock.disable(); // or Wakelock.toggle(on: false);
    roomMethods.setNotTypingGroup(groupId: widget.toGroupId, user: widget.from);
    WidgetsBinding.instance.removeObserver(this);
    _recoder.dispose();

    // if(_videoPlayerController != null) {
    //   _videoPlayerController.dispose();
    // }

    super.dispose();




  }


  isTypeing(){
    msgTextEditingController.addListener(() {
      animController.reset();
      animController.forward();
    });
    animController = AnimationController(
        duration: Duration(seconds: 1),
        vsync: this
    );
    animController.addStatusListener((status) {
      roomMethods.setTypingGroup(groupId: widget.toGroupId, user: widget.from);
      if(status == AnimationStatus.completed){
        animController.reset();
        roomMethods.setNotTypingGroup(groupId: widget.toGroupId, user: widget.from);
      }
    });
  }


  whenLeftTheRoom() async {
    if(_bgProvider.toGroup != null && _bgProvider.toGroup.id != null && widget.from != null && widget.from.id != null) {
      await roomMethods.leftTheRoomByUserReal(groupId: _bgProvider.toGroup.id.toString(), userId: widget.from.id.toString());
    }
  }

  // set state only munted data very important to fix error ==== setState after dispose method
  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }
  String _rootDir;

  @override
  void initState() {
    _focusNode = FocusNode();
    Wakelock.enable(); // or Wakelock.toggle(on: true);
    initialData();
    WidgetsBinding.instance.addObserver(this);


    super.initState();
    // To keep the screen on:

    // downlaod code
    getApplicationDocumentsDirectory().then((tmpDir) => {
      _rootDir = tmpDir.parent.path,
    });


  }

  initialData() async {
    addPostFrameCallback();
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
        _bgProvider = Provider.of<BigGroupProvider>(context, listen: false);
        // home page loading gif stop loading
        _hp = Provider.of(context, listen: false);
        _hp.setShowLoader(isShow: false);
        // update experience and other gorup data
        _bgProvider.getGroupModelData(groupId: widget.contact.uid);

        whenEnteredToTheVoiceRoom();
        if (_bgProvider.isCallRunning) {
          // if user go for minimize then an issue arised that
          // after coming back to the screen there is no agora engine available to distroy
          // so this is for extra step to initialize the agora sdk then distroy it so
          // next time it will not create new issue
          // strange hack
          // create a engine again to remove any issue
          _engine = await RtcEngine.create(_bgProvider.callState.appId);
          _engine.setClientRole(ClientRole.Broadcaster);
        } else {
        //  roleSettingForFireStore();
        }


        _bgProvider.getGiftData(userId: widget.from.id.toString());
        // increase group experience
        await _groupFunctions.updateGroup(
            groupId: _bgProvider.toGroup.id.toString(),
            text: (_bgProvider.toGroup.level != null ? _bgProvider.toGroup
                .level + 1 : 1).toString(), field: "level");
      });


      animationFunctions();
      isTypeing();
      _recoder.init();

  }

  // where user entered to the voice room then user show in the voice room seat
  whenEnteredToTheVoiceRoom() async{
   // if(!widget.floatButton) {
      await roomMethods.userWhenReEnteredToTheVoiceRoomReal(
          from: widget.from, group: _bgProvider.toGroup);
   // }

   // check if the user host or not
   roomMethods.getHostSeatListToCheckIfTheLoggedUserIsHostReal(from: widget.from, groupId: widget.toGroupId).listen((event) {
     if(event.snapshot.value is Map) {
       Map<dynamic, dynamic> dt = event.snapshot.value;
       if (dt != null) {
         if (dt["userId"] == widget.from.id.toString()) {
         //  _bgProvider.setUserHost(isHost: true);
           setState(() {
             _isHost = true;
           });
         }else{
           setState(() {
             _isHost = false;
           });
         }
       }
     }

   });



  }

 // animation controller for showing animation
  // animation for gift rotation and scale animation
  AnimationController _animationControllerB;
  // animation stating for 2 second
  AnimationController _animationController;

  // animation for sliding
  AnimationController _sliderAnimationController;
  AnimationController _sliderAnimationControllerB;

  Animation _giftShowAnimation;
  Animation<double> _sliderAnimationElement;
  Animation<double> _sliderAnimationElementB;
  animationFunctions() {

   // animation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);

    _animationControllerB = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _giftShowAnimation = CurvedAnimation(parent: _animationControllerB, curve: Curves.easeInOutExpo);

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _sliderAnimationControllerB = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    _sliderAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3500),
    )..addStatusListener((status) {
      if(status == AnimationStatus.completed){
        // after completion showing animation for 2 second reverse animation
        // _sliderAnimationController.reset();
        // _sliderAnimationController.forward();
      }
    });


    _sliderAnimationElement = Tween(begin: 900.0, end: -80.0).animate(
        CurvedAnimation(parent: _sliderAnimationController,
            curve: Curves.easeOutExpo));

    _sliderAnimationElementB = Tween(begin: 200.0, end: -300.0).animate(
        CurvedAnimation(parent: _sliderAnimationControllerB,
            curve: Curves.easeIn));



    _animationController.addStatusListener((status) {
      // End of the animation of forward status will be completed
      if(status == AnimationStatus.completed){
        // after completion showing animation for 2 second reverse animation
        _animationControllerB.reverse();
      }

    });


  }

  // Big group call functions all start
  StreamSubscription streamSubscription;

  addPostFrameCallback() async {
    streamSubscription = callMethods
        .callStreamReal(uid: widget.from.id.toString(),
        groupId: widget.contact.uid).listen((event) async {
          if(event.snapshot.value is Map) {
            Map<dynamic, dynamic> dts = event.snapshot.value;
            if (dts != null && dts['group_id'] == widget.contact.uid.toString()) {
              GroupCall mCall = GroupCall.fromMap(dts);
              _bgProvider.setGroupCallState(call: mCall);
              // // start voice room
              if (_bgProvider.callState != null &&
                  _bgProvider.callState.mtoken != null &&
                  _bgProvider.callState.channelId != null) {
                // prevent function to run by host
                if (widget.from.id.toString() != _bgProvider.callState.callerId) {
                  await initPlatformState(0);
                  // Important! setIsCallRunning and setShowTable are set after from id and caller id not same check
                  _bgProvider.setIsCallRunning(isRunning: true);
                  _bgProvider.setShowTable(show: true);
                  if (_bgProvider.isCallRunning) {
                    if (_bgProvider.isJoinedToBigGroup) {
                      if (_engine != null) {
                        _engine.setClientRole(ClientRole.Broadcaster);
                      }
                    } else {
                      if (_engine != null) {
                        _engine.setClientRole(ClientRole.Audience);
                      }
                    }
                    // _engine.setClientRole(ClientRole.Audience);
                    if (_engine != null) {
                      _engine.setEnableSpeakerphone(true);
                    }
                  }
                } else {
                  await initPlatformState(1);
                  if (_bgProvider.isCallRunning) {
                    if (_engine != null) {
                      _engine.setClientRole(ClientRole.Broadcaster);
                      _engine.setEnableSpeakerphone(true);
                    }
                  }
                  _bgProvider.setShowSpinner(showSpinner: false);
                }
              }
              // addPostFrameCallback();
            }
          }else{
            print(' voice room data type is other');
          }
    });


    streamSubscription = callMethods.checkAdminOrNotStream(
        groupId: widget.contact.uid.toString(),
        userId: widget.from.id.toString()).listen((DocumentSnapshot snapshot) {
      if(snapshot.data() is Map) {
        var dt = snapshot.data() as Map;
        if (dt['role'] != null && dt['role'] == 1 || dt['role'] == 2) {
          _bgProvider.setAdmin(isAdmin: true);
        } else {
          _bgProvider.setAdmin(isAdmin: false);
        }

        if (dt['role'] != null && dt['role'] == 1) {
          _bgProvider.setRole(role: 1);
        } else if (dt['role'] != null && dt['role'] == 2) {
          _bgProvider.setRole(role: 2);
        } else {
          _bgProvider.setRole(role: 3);
        }
      }else{
        print(' role data type is other');
      }

    });

    streamSubscription = callMethods.checkUserIsMutedOrNot(
        groupId: widget.contact.uid.toString(),
        userId: widget.from.id.toString()).listen((DocumentSnapshot snapshot) {
      if(snapshot.data() is Map) {
        var dt = snapshot.data() as Map;
        if (dt['mute'] != null && dt['mute']) {
          _bgProvider.setUserMuted(isMuted: true);
        } else {
          _bgProvider.setUserMuted(isMuted: false);
        }
      }else{
        print(' Mute data type is other');
      }
    });

    streamSubscription = _fireStore.collection(BIG_GROUP_COLLECTION)
        .doc(widget.contact.uid.toString())
        .collection("showGift")
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      if (snapshot.docs.length > 0) {
        if (!_showMention) {
          var dt = snapshot.docs.last;
          GiftShowingModel gsm = GiftShowingModel.fromMap(dt.data());
          _bgProvider.setGiftShowingModel(model: gsm);
         // _bgProvider.setShowMention(show: true);
          setState(() {
          //  _showMention = true;
          });
          _fireSpineAnim(anim: 'spineboy', action: 'walk', rootPath: _rootDir);

          // call all animation controller so that animation
          // can be shown to voice room after dispose method called
          animationFunctions();
          // slide animation
          _sliderAnimationController.reset();
          _sliderAnimationController.forward();
          // animation forward for rotating and scale
          _animationControllerB.forward();
          _animationControllerB.addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _animationController.reset();
              // animation for showing gift for 2 second start
              _animationController.forward();
            } else if (status == AnimationStatus.dismissed) {
              // after reverse animation completion hide gift container and holder
              _bgProvider.setGiftShowingModel(model: null);
           //   _bgProvider.setShowMention(show: false);
              setState(() {
               // _showMention = false;
                _showSpineAnim = false;
              });
            }
          });
        }
      }
    });

    streamSubscription =  roomMethods.getHostSeatListToCheckIfTheLoggedUserIsHostReal(from: widget.from, groupId: widget.toGroupId).listen((event) {
      Map<dynamic, dynamic> dt = event.snapshot.value;
      if(dt != null){
        if (_engine != null) {
          if (dt["userId"] == widget.from.id.toString() && dt["mute"]) {
            _engine.muteLocalAudioStream(true);
          } else if(dt["userId"] == widget.from.id.toString() && !dt["mute"]) {
            _engine.muteLocalAudioStream(false);
          }
        }
      }

    });



    streamSubscription = _fireStore
        .collection(BIG_GROUP_COLLECTION)
        .doc(widget.contact.uid.toString())
        .collection("hotSeat").doc(widget.from.id.toString())
        .snapshots().listen((DocumentSnapshot ds) {
      if(ds.data() is Map) {
            var dt = ds.data() as Map;
            if (dt != null) {
              if (_bgProvider.isCallRunning) {
                if (_engine != null) {
                  if (dt != null && dt['isMuted'] != null && dt['isMuted'] == 1) {
                    _engine.muteLocalAudioStream(true);
                    if (dt["forceMute"] != null && dt["forceMute"]) {
                      setState(() {
                        _forceMute = true;
                      });
                    }
                  } else {
                    _engine.muteLocalAudioStream(false);
                    if (dt["forceMute"] != null && dt["forceMute"]) {
                      setState(() {
                        _forceMute = false;
                      });
                    }
                  }
                }
              }
            }
          }else{
            print('hot seat user mute action not a map data most likely list data or null');
          }
    });



    // keep track if change in hotseat list
    streamSubscription = roomMethods.hotSeatStatus(groupId: widget.contact.uid)
            .listen((QuerySnapshot snapshot) async {
          // when the length less than 8 take action get data from waiting list
          if (snapshot.docs.length < 8) {
            getWaitingData();
          }
        });

    leaveVoiceRoom();

  }

  @override
  Widget build(BuildContext context) {
    BigGroupProvider _bgp = Provider.of<BigGroupProvider>(context, listen: true);
    FileUploadProvider _fp = Provider.of<FileUploadProvider>(context);
    AudioProvider _ap = Provider.of(context, listen: false);
    VideoUploadProvider _vup = Provider.of(context);
    var currentColor = Color(0xff443a49);
    setState(() {

    });



    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Stack(
        children: [
          StreamBuilder(
          stream: roomMethods.getBackgroundColors(groupId: widget.contact.uid),
            builder: (context, AsyncSnapshot event) {
            if(event.data != null && event.data.snapshot.value is Map) {
              Map<dynamic, dynamic> dt = event.data.snapshot.value;
              if (dt != null) {
                return background(dt: dt, context: context);
              }
            }
             // return Text('hello');
              return background(dt: null , context: context);
            }),
          Padding(
          padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
            child: LoadingImage(
              inAsyncCall: _bgp.showSpinner,
              child: Container(
                  margin: EdgeInsets.only(top: 0),
                  child: Stack(
                    children: [
                      SafeArea(
                        child: Scaffold(
                          resizeToAvoidBottomInset: false,
                          backgroundColor: Colors.transparent,
                          body: WillPopScope(
                            onWillPop: () => getExitPermisison(context, _bgp),
                            child: Stack(
                              children: [
                                Positioned(
                                  right: 3,
                                  top: 7,
                                  child: IconButton(
                                      icon: Image.asset('assets/icon/space.png'),
                                      onPressed: (){
                                        Navigator.of(context).pushNamed('/viewSpace', arguments: {'user': widget.from, 'group': _bgp.toGroup});
                                      }
                                  ),),
                                Positioned(
                                  top: 3,
                                  left: 0,
                                  child: Container(
                                    width: _bgp.showTable ? 170 : 140,
                                    decoration: BoxDecoration(
                                      color: Color(0xffddf0fc).withOpacity(0.4),
                                      borderRadius: BorderRadius.only(topRight: Radius.circular(30.0), bottomRight: Radius.circular(30.0)),
                                    ),
                                    child: Stack(
                                      children: [
                                        GestureDetector(
                                          child: Container(
                                            margin: EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 10),
                                            width: 32.0,
                                            height: 32.0,
                                            decoration: BoxDecoration(
                                              color: Colors.blueGrey,
                                              borderRadius: BorderRadius.all(new Radius.circular(30.0)),
                                            ),
                                            child: widget.contact != null && widget.contact.photo != null ? ClipRRect(
                                                borderRadius: BorderRadius.all(Radius.circular(6.0)),
                                                child: cachedNetworkImg(context, widget.contact.photo)) : Icon(Icons.supervised_user_circle_outlined),
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => GroupProfile(
                                                        user: widget.from, groupInfo: _bgp.toGroup)));
                                          },
                                        ),
                                        Positioned(
                                            top: _bgp.showTable ? 2 : 10,
                                            left: 45,
                                            child: Container(
                                              width: 90,
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                      flex: 1,
                                                      child: SingleChildScrollView(
                                                          scrollDirection: Axis.horizontal,
                                                          child: Text("${widget.contact.uid +" "+ widget.contact.name}")
                                                      )
                                                  ),
                                                ],
                                              ),
                                            )
                                        ),
                                        Positioned(
                                            bottom: 2,
                                            left: 45,
                                            right: 5,
                                            child: _bgp.showTable ? Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 0),
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                    //  color: Color(0xffb4d9ea),
                                                    borderRadius: BorderRadius.all( Radius.circular(30.0)),
                                                  ),
                                                  child: VoiceroomDiamondSend(toGroupId: widget.toGroupId, from: widget.from,collection: "userGiftSent",isDiamond: true,),
                                                ),
                                                SizedBox(width: 5,),
                                                Container(
                                                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 0),
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                      // color: Color(0xffb4d9ea),
                                                      borderRadius: BorderRadius.all( Radius.circular(30.0)),
                                                    ),
                                                    child: Center(
                                                      child: VoiceroomDiamondSend(toGroupId: widget.toGroupId, from: widget.from,collection: "userGiftReceived",isDiamond: false,),
                                                    )
                                                )
                                              ],
                                            ) : Container()
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                Positioned(
                                  right: 50,
                                  top: 18,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      _bgp.showTable ? Container(
                                          width: 80,
                                          child: VoiceRoomActiveMembers(toGroupId: widget.toGroupId,from: widget.from)) : Container(),
                                      VoiceroomActiveMemberCounter(toGroupId: widget.toGroupId,),
                                    ],
                                  ),
                                ),

                                // Voice room active members show when voice room off
                                Container(
                                  margin: EdgeInsets.only(top: 48),
                                  color: Colors.transparent,
                                  //   color: Colors.amberAccent,
                                  child: Column(
                                    children: [
                                      SizedBox(height: 0,),
                                      _bgp.showTable ? Container() : Container(
                                          child: Column(
                                            children: [
                                              _bgp.toGroup != null && !["","null", null, false, 0,"0"].contains(_bgp.toGroup.announce) && showAnnounce ? Container(
                                                decoration: BoxDecoration(
                                                  color: Color(0xffd5d5d5).withOpacity(0.95),
                                                  borderRadius: BorderRadius.all(new Radius.circular(0)),
                                                ),
                                                width: MediaQuery.of(context).size.width,
                                                child: ListTile(
                                                  leading: Icon(Icons.settings_input_antenna_outlined),
                                                  title: Text("${_bgp.toGroup.announce}", style: TextStyle(
                                                      fontSize: 12
                                                  ),),
                                                  trailing: IconButton(
                                                    icon: Icon(Icons.close_sharp),
                                                    onPressed: (){
                                                      setState(() {
                                                        showAnnounce = false;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ) : Container(),
                                              SizedBox(height: 5,),
                                              VoiceRoomActiveMembers(toGroupId: widget.toGroupId,from: widget.from),
                                            ],
                                          )
                                      ),
                                      _bgp.isCallRunning ? Row(
                                        children: [
                                          SizedBox(width: 5,),
                                          VoiceRoomWaitingHolder(toGroupId: widget.toGroupId, toGroup: _bgp.toGroup,),
                                          SizedBox(width: 10,),
                                          VoiceRoomTrofi(toGroupId: widget.toGroupId, toGroup: _bgp.toGroup,),
                                          SizedBox(width: 10,),
                                          VoiceRoomLastGift(toGroupId: widget.toGroupId, toGroup: _bgp.toGroup,),
                                        ],
                                      ) : Container(),
                                      _bgp.isCallRunning && !_bgp.showTable ? SizedBox(
                                        height: 100,
                                        child: VoiceRoomMinimized(
                                          fromId: widget.from.id.toString(),
                                          isHost: _isHost,
                                          toGroup: _bgp.toGroup,
                                          from: widget.from,
                                          usersTapToJoineIntoSpecificHotSeat: (val){
                                            usersTapToJoineIntoSpecificHotSeat(val);
                                          },
                                        ),
                                      ) : Container(),
                                      _bgp.showGroupUsers ? Container(
                                        color: Colors.pinkAccent,
                                        child: StreamBuilder<QuerySnapshot>(
                                          stream: _fireStore
                                              .collection(BIG_GROUP_COLLECTION)
                                              .doc(_bgp.toGroup.id.toString())
                                              .collection(MEMBERS_COLLECTION)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              circularProgress();
                                            }
                                            if (snapshot.hasData) {
                                              if (snapshot.data != null) {
                                                var docList = snapshot.data.docs;
                                                return ListView.builder(
                                                  scrollDirection: Axis.horizontal,
                                                  itemCount: docList.length,
                                                  itemBuilder: (context, index) {
                                                    var dt = docList[index].data() as Map;
                                                    String uid = dt['userId'];

                                                    return UserImageById(
                                                      userId: uid,
                                                    );
                                                  },
                                                );
                                              }
                                            }
                                            return Text("no data");
                                          },
                                        ),
                                      )
                                          : Container(),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          _bgp.showTable
                                              ? Container(
                                              height: 280,
                                              // decoration: BoxDecoration(
                                              //   image: DecorationImage(
                                              //       image: AssetImage(
                                              //           "assets/big_group/conferance_bg2.jpeg"),
                                              //       fit: BoxFit.cover),
                                              // ),
                                              child: Stack(
                                                children: [
                                                  VoiceRoomHotSeatExpand(
                                                    fromId: widget.from.id.toString(),
                                                    isHost: _isHost,
                                                    toGroup: _bgp.toGroup,
                                                    from: widget.from,
                                                    usersTapToJoineIntoSpecificHotSeat: (val){
                                                      usersTapToJoineIntoSpecificHotSeat(val);
                                                    },
                                                  ),
                                                  Positioned(
                                                      bottom: 5,
                                                      left: 0,
                                                      right: 0,
                                                      child: _toolbar(_bgp)
                                                  ),
                                                ],
                                              ))
                                              : Container(),

                                        ],
                                      ),
                                      _bgp.toGroup != null ? MessageStreamGroup(
                                        from: widget.from,
                                        to: _bgp.toGroup,
                                        onPressedReply: (val,uPhoto, name,docId,fileUrl) {
                                          setState(() {
                                            showReplay = true;
                                            _replayText = val;
                                            _replyPhoto = uPhoto;
                                            _replyName = name;
                                            _replyId = docId;
                                            _replyFileUrl = fileUrl;
                                          });
                                        },

                                      ) : Expanded(child: Center(child:
                                      Container(
                                          child: Text("Please check your internet connection",
                                            style: ftwhite15
                                          ),
                                          decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(new Radius.circular(70.0)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black.withOpacity(0.2),
                                                        spreadRadius: 40,
                                                        blurRadius: 50,
                                                        offset: Offset(0, 0), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                      )
                                      )
                                      ),
                                      Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(left: 10, right: 10),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.all(Radius.circular(10))),
                                                    child:  Column(
                                                      children: [
                                                        Container(
                                                          height: _ap.isRecodring ? 48 : 0,
                                                          child: Row(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              SizedBox(width: 10,),
                                                              _ap.isRecodring ? Icon(Icons.mic, color: Colors.blue, size: 20,) : Container(),
                                                              TimerWidget(controller: _timeController),
                                                            ],
                                                          ),
                                                        ),
                                                        _ap.isRecodring ? Container() : Row(
                                                          children: [
                                                            Expanded(
                                                              child: TextFormField(
                                                                focusNode: _focusNode,
                                                                controller: msgTextEditingController,
                                                                keyboardType: TextInputType.multiline,
                                                                minLines: 1,//Normal textInputField will be displayed
                                                                maxLines: 5,// when user presses enter it will adapt to it
                                                                onChanged: (value) {
                                                                  _bgp.setIsWriting(isWriting: true);
                                                                },
                                                                style: TextStyle(
                                                                  fontSize: 10,
                                                                ),
                                                                decoration: ftcustomInputDecoration.copyWith(
                                                                    hintText: "Write message ...",
                                                                    enabledBorder: OutlineInputBorder(
                                                                      borderRadius: BorderRadius.all(
                                                                          Radius.circular(3)),
                                                                      borderSide: BorderSide(
                                                                          color: Colors.transparent),
                                                                    )).copyWith(
                                                                    focusedBorder: OutlineInputBorder(
                                                                      borderRadius: BorderRadius.all(
                                                                          Radius.circular(3)),
                                                                      borderSide: BorderSide(
                                                                          color: Colors.transparent),
                                                                    )),
                                                                onTap: () {
                                                                  //   hideImojiPicker();
                                                                },
                                                              ),
                                                            ),

                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                _bgp.isWriting
                                                    ? Material(
                                                  color: Colors.blue,
                                                  elevation: 5,
                                                  borderRadius:
                                                  BorderRadius.all(Radius.circular(40)),
                                                  child: MaterialButton(
                                                    onPressed: !_bgp.isUserMuted ? () {
                                                      _focusNode.unfocus();
                                                      if(_replayText != null && _replayText != '') {
                                                        widget._chatMethodsBigGroup.replyBigGroupMessage(
                                                          reply: _replayText,
                                                          replyUser: _replyName,
                                                          replyPhoto: _replyPhoto,
                                                          replyId: _replyId,
                                                          msgText: msgTextEditingController.text,
                                                          fromUserId: widget.from.id.toString(),
                                                          name: widget.from.nName,
                                                          userPhoto: widget.from.photo,
                                                          groupId: _bgp.toGroup.id.toString(),
                                                          role: _bgp.role,
                                                        );
                                                        setState(() {
                                                          showReplay = false;
                                                          _replayText = '';
                                                        });
                                                      }else{
                                                        widget._chatMethodsBigGroup.sendBigGroupMessage(
                                                          msgText: msgTextEditingController.text,
                                                          fromUserId: widget.from.id.toString(),
                                                          name: widget.from.nName,
                                                          photo: widget.from.photo,
                                                          groupId: _bgp.toGroup.id.toString(),
                                                          role: _bgp.role,
                                                        );
                                                      }

                                                      _bgp.setIsWriting(isWriting: false);
                                                      msgTextEditingController.clear();
                                                    } : null,
                                                    textColor: Colors.white,
                                                    child: Icon(
                                                      Icons.send,
                                                      size: 13,
                                                    ),
                                                    minWidth: 25,
                                                    height: 25,
                                                  ),
                                                )
                                                    : _recodingWidget(_fp, _bgp, _ap),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              height: 30,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  ChatButtons(
                                                      icon:Icons.attach_file,
                                                      onPress: () {
                                                        widget._fileUploadMethods.getAttachmentAndUpload(
                                                          receiverId: widget.from.id.toString(),
                                                          senderId: _bgp.toGroup.id.toString(),
                                                          name: widget.from.nName,
                                                          userPhoto: widget.from.photo,
                                                          chatType: USER_BIG_GROUP,
                                                          fileUploadProvider: _fp,
                                                          role: _bgp.role,
                                                          context: context,
                                                        );
                                                      }
                                                  ),
                                                  ChatButtons(
                                                    icon:Icons.video_collection_rounded,
                                                    onPress: () {
                                                      widget._fileUploadMethods.pickFile(
                                                        source: ImageSource.gallery,
                                                        receiverId: widget.from.id.toString(),
                                                        senderId: _bgp.toGroup.id.toString(),
                                                        name: widget.from.nName,
                                                        userPhoto: widget.from.photo,
                                                        chatType: USER_BIG_GROUP,
                                                        fp: _fp,
                                                        fileType: 1,
                                                        role: _bgp.role,
                                                        context: context
                                                      );
                                                    },
                                                  ),
                                                  ChatButtons(
                                                    icon: Icons.perm_media,
                                                    onPress: () {
                                                      //  handleChoseFromGallery();
                                                      if(!_bgp.isUserMuted) {
                                                        widget._fileUploadMethods.pickFile(
                                                          source: ImageSource.gallery,
                                                          receiverId: widget.from.id.toString(),
                                                          senderId: _bgp.toGroup.id.toString(),
                                                          name: widget.from.nName,
                                                          userPhoto: widget.from.photo,
                                                          chatType: USER_BIG_GROUP,
                                                          fp: _fp,
                                                          fileType: 2,
                                                          role: _bgp.role,
                                                        );
                                                      }
                                                    },
                                                  ),
                                                  ChatButtons(
                                                    icon: Icons.camera_alt,
                                                    onPress: () {
                                                      if(!_bgp.isUserMuted) {
                                                        // set information for need to file upload to server
                                                        _vup.setVideoModel(
                                                            videoModel: VideoUploadModel(
                                                              receiverId: widget.from.id.toString(),
                                                              senderId: _bgp.toGroup.id.toString(),
                                                              name: widget.from.nName,
                                                              userPhoto: widget.from.photo,
                                                              chatType: USER_BIG_GROUP,
                                                              fp: _fp,
                                                              fileType: 1,
                                                              role: _bgp.role,
                                                            )
                                                        );

                                                        // Navigator.pushReplacementNamed(
                                                        //     context, '/video-recorder');
                                                        //  handleTakePhoto();
                                                        widget._fileUploadMethods.pickFile(
                                                          source: ImageSource.camera,
                                                          receiverId: widget.from.id.toString(),
                                                          senderId: _bgp.toGroup.id.toString(),
                                                          name: widget.from.nName,
                                                          userPhoto: widget.from.photo,
                                                          chatType: USER_BIG_GROUP,
                                                          fp: _fp,
                                                          fileType: 2,
                                                          role: _bgp.role,
                                                        );
                                                      }
                                                    },
                                                  ),
                                                  // This code removed because no more using ffmpeg
                                                  // ChatButtons(
                                                  //   icon: Icons.video_call,
                                                  //   onPress: () async {
                                                  //     if(!_bgp.isUserMuted) {
                                                  //       // set information for need to file upload to server
                                                  //       _vup.setVideoModel(
                                                  //           videoModel: VideoUploadModel(
                                                  //             receiverId: widget.from.id.toString(),
                                                  //             senderId: _bgp.toGroup.id.toString(),
                                                  //             name: widget.from.nName,
                                                  //             userPhoto: widget.from.photo,
                                                  //             chatType: USER_BIG_GROUP,
                                                  //             fp: _fp,
                                                  //             fileType: 1,
                                                  //             role: _bgp.role,
                                                  //           )
                                                  //       );
                                                  //
                                                  //    //   handleChooseFromGalleryVideo();
                                                  //
                                                  //
                                                  //
                                                  //     }
                                                  //   },
                                                  // ),

                                                  SizedBox(
                                                    width: 45,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      _bgp.emojiPicker
                                          ? Container(
                                        child: shwoEmojiContainer(_bgp),
                                      )
                                          : Container(),
                                    ],
                                  ),
                                ),
                                //  animationUrl != null ? Positioned(
                                //      top: 0,
                                //      left: 0,
                                //      right: 0,
                                //      bottom: 0,
                                //      child: Container(
                                //        height: 200,
                                //        width: 200,
                                //        color: Colors.black87,
                                //      )
                                //  ) : Container(),
                                // animationUrl != null ? Positioned(
                                //    top: MediaQuery.of(context).size.height / 3 - 100,
                                //    left: MediaQuery.of(context).size.width / 2 - 100 ,
                                //    child: Container(
                                //      width: 200,
                                //      height: 200,
                                //      child: Lottie.network(
                                //        animationUrl,
                                //        fit: BoxFit.cover,
                                //        repeat: false,
                                //        controller: _animationController,
                                //        onLoaded: (composition) {
                                //
                                //          _animationController.addStatusListener((status) {
                                //            // End of the animation of forward status will be completed
                                //            if(status == AnimationStatus.completed){
                                //              setState(() {
                                //                animationUrl = null;
                                //                showMention = false;
                                //              });
                                //              // End of the animation of reversed status will be dismissed
                                //            }
                                //          });
                                //
                                //            _animationController
                                //              ..duration = composition.duration
                                //              ..forward();
                                //            _animationController.reset();
                                //
                                //        }
                                //      ),
                                //    ),
                                //  ) : Container(),
                                _showMention ? Positioned(
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      height: 200,
                                      width: 200,
                                      color: Colors.black12,
                                    )
                                ) : Container(),
                                _fp.showUploadLayer ? Positioned(
                                    right: 5,
                                    bottom: 95,
                                    left: 5,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          child: Icon(Icons.close),
                                          onTap: () => widget._fileUploadMethods.stopDownload(_fp,_bgp.toGroup.id.toString()),
                                        ),
                                        Container(
                                            height: 60,
                                            width: 60,
                                            child: CircularPercentIndicator(
                                              radius: 20.0,
                                              lineWidth: 3.0,
                                              percent: _fp.uploadSent,
                                              header: Text("${double.parse((_fp.uploadSent*100).toStringAsFixed(0))}"),
                                              center: Icon(Icons.upload_rounded, color: Colors.black,),
                                              progressColor: Colors.green,
                                              backgroundColor: Colors.yellow,
                                            )
                                        ),
                                      ],
                                    )
                                ) : Container(),
                                _fp.showUploadLayerAudio ? Positioned(
                                    left: 5,
                                    bottom: 95,
                                    child: Container(
                                        height: 60,
                                        width: 60,
                                        child: CircularPercentIndicator(
                                          radius: 20.0,
                                          lineWidth: 3.0,
                                          percent: _fp.uploadSentAudio,
                                          header: Text("${double.parse((_fp.uploadSentAudio*100).toStringAsFixed(0))}"),
                                          center: Icon(Icons.upload_rounded, color: Colors.black,),
                                          progressColor: Colors.green,
                                          backgroundColor: Colors.yellow,
                                        )
                                    )
                                ) : Container(),
                                _showMention ? Positioned(
                                    child: Center(
                                      child: AnimatedBuilder(
                                          animation: _animationControllerB.view,
                                          builder: (context, child) {
                                            return Transform.scale(
                                              scale: _giftShowAnimation.value * 1.5,
                                              child: Transform.rotate(
                                                angle: _giftShowAnimation.value * 0 * 3.13159,
                                                child: Container(
                                                  child: giftCachedNetworkImage(context, _bgp.gShowingModel.image),
                                                ),
                                              ),
                                            );
                                          }
                                      ),
                                    )
                                ) : Container(),

                                _showMention ? SlideMention(
                                  gShowingModel: _bgp.gShowingModel,
                                  sliderAnimationElement: _sliderAnimationElement,
                                  sliderAnimationController: _sliderAnimationController,
                                ) : Container(),
                                // SlideMention(
                                //   gShowingModel: gShowingModel,
                                //   sliderAnimationElement: _sliderAnimationElement,
                                //   sliderAnimationController: _sliderAnimationController,
                                // )
                                // GiftSendingButton(),
                                _bgp.showTable
                                    ? Positioned(
                                  top: 62,
                                  right: 10,
                                  child: GestureDetector(
                                    // onTap: isHost ? () => onStopVoiceRoomByAdmin() : () => userLeaveHotSeatAndVoiceRoomByOwn(),
                                    onTap: () => _userPermissionExitBottomsheet(context, _bgp),
                                    child: Container(
                                      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                                      child: Icon(
                                        FontAwesome.power_off,
                                        color: _isHost ? Colors.red : Colors.amber,
                                        size: 23.0,
                                      ),
                                    ),
                                  ),
                                ) : Container(child: SizedBox(width: 40,),),

                              ],
                            ),
                          ),
                        ),
                      ),

                      // Positioned(
                      //   top: AppBar().preferredSize.height + (MediaQuery.of(context).padding.top)+75,
                      //   right: 5,
                      //   child: !_bgp.showTable ? _bgp.isAdmin ? _bgp.isCallRunning ? Container() : GestureDetector(
                      //     onTap: () async => await PermissionHandlerUser().onJoin() ?
                      //     onClickPlusButtonShowPermissionForVoiceRoom(context, _bgp) : {},
                      //     child: Container(
                      //       width: 30,
                      //       height: 30,
                      //       decoration: BoxDecoration(
                      //         color: Color(0xff0064fb),
                      //         borderRadius: BorderRadius.all(new Radius.circular(70.0)),
                      //         // border: Border.all(
                      //         //   color: Colors.white,
                      //         //   width: 1.0,
                      //         // ),
                      //         boxShadow: [
                      //           BoxShadow(
                      //             color: Colors.grey.withOpacity(0.3),
                      //             spreadRadius: 20,
                      //             blurRadius: 0,
                      //             offset: Offset(0, 0), // changes position of shadow
                      //           ),
                      //         ],
                      //       ),
                      //       child: Icon(
                      //         Icons.add,
                      //         color: Colors.white,
                      //         size: 18,
                      //       ),
                      //     ),
                      //   )
                      //       // if isAdmin
                      //       : Container()
                      //       // if showTable
                      //       : Container(),
                      // ),

                      Positioned(
                        top: AppBar().preferredSize.height + (MediaQuery.of(context).padding.top)+75,
                        right: 5,
                        child: !_bgp.showTable ? _bgp.isAdmin ? _bgp.isCallRunning ? Container() :
                        GestureDetector(
                              onTap: () async => await PermissionHandlerUser().onJoin() ?
                              onClickPlusButtonShowPermissionForVoiceRoom(context, _bgp) : {},
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Color(0xff0064fb),
                                  borderRadius: BorderRadius.all(new Radius.circular(70.0)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 20,
                                      blurRadius: 0,
                                      offset: Offset(0, 0), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            )

                        // if isAdmin
                            : Container()
                        // if showTable
                            : Container(),
                      ),

                      _bgp.isCallRunning && !_bgp.showTable ? Positioned(
                        right: 5,
                        top: 108,
                        child: GestureDetector(
                          onTap: () async {
                            _bgp.showTable ? _bgp.setShowTable(show: false) : _bgp.setShowTable(show: true);
                          },
                          child: Icon(
                            Icons.arrow_circle_down_outlined,
                            color: Colors.white,
                            size: 25.0,
                          ),
                        ),
                      ) : Container(),
                      // replay and typing widget
                      Positioned(
                          bottom: 85,
                          left: 0,
                          child: Column(
                            children: [
                              _userTypingStatus(),
                              showReplay ? Container(
                                width:  200,
                                height: 60,
                                margin: EdgeInsets.only(left: 15),
                                decoration: BoxDecoration(
                                  color: Color(0xff4c4c4c),
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(15.0),
                                    topRight: const Radius.circular(15.0),
                                  ),// BorderRadius
                                ),//
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 55,
                                      padding: EdgeInsets.all(5),
                                      margin: EdgeInsets.only(left: 8, top: 5, right: 5),
                                      decoration: BoxDecoration(
                                        color: Color(0xff393939),
                                        borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(13.0),
                                          topRight: const Radius.circular(13.0),
                                        ),// BorderRadius
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.green.withOpacity(1),
                                            spreadRadius: 0,
                                            blurRadius: 0,
                                            offset: Offset(-5, 0), // changes position of shadow
                                          ),
                                        ],
                                        // gradient: new LinearGradient(
                                        //     stops: [0.5, 0.02],
                                        //     colors: [Colors.red, Colors.green]
                                        // ),
                                      ),//
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              _replyPhoto != null ? UserImageByPhotoUrlTyping(
                                                photo: _replyPhoto,
                                              ) : Container(),
                                              SizedBox(width: 5,),
                                              Container(
                                                width: 100,
                                                child: Text('$_replyName' , style: TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight: FontWeight.w800,
                                                    fontFamily: "Segoe",
                                                    fontSize: 15
                                                ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text('$_replayText' , style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800,
                                              fontFamily: "Segoe",
                                              fontSize: 12
                                          ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      child: GestureDetector(
                                        child: Icon(Icons.cancel, size: 20),
                                        onTap: (){
                                          setState(() {
                                            showReplay = false;
                                          });
                                        },
                                      ),
                                      right: 3, top: 3,),
                                  ],
                                ),
                              ) : Container(),
                            ],
                          )

                      ),
                      if(_showSpineAnim)
                        Positioned(
                          child: Container(
                              alignment: Alignment.center,
                              color:Color(0x36000000)
                          ),
                        ),
                      if(_showSpineAnim)
                        Positioned(
                          top: 0,
                          left: 0,
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: MediaQuery.of(context).size.width / 2,
                            width: (MediaQuery.of(context).size.height / 3) * 4,
                            child: _buildScreen(),
                          ),
                        )
                    ],
                  ),
                ),

            ),
          ),
        ],
      ),
    );
  }
  final CallMethodsBigGroup callMethods = CallMethodsBigGroup();
  CallUtilsBigGroup _callUtil = CallUtilsBigGroup();

  onStartVoiceRoom(BigGroupProvider _p) async {

    // increase group experience
    await _groupFunctions.updateGroup(groupId: widget.contact.uid.toString(),
        text: (_p.toGroup.level + 5).toString(), field: "level");
    // update experience and other gorup data
    _p.getGroupModelData(groupId: widget.contact.uid.toString());

    // if already call running then show table
    if (!_p.isCallRunning) {
      if (await PermissionHandlerUser().onJoin()) {
        // remove previous rooms hot seat users
        callMethods.endQuickCall(groupId: widget.toGroupId);
        GroupCall call = await _callUtil.mdialGroup(from: widget.from, group: _p.toGroup, context: context);
        if (call != null) {
          //  Start the voice room and host the voice room add host user to hot seat
          roomMethods.enteredUserIntoHostSeat(from: widget.from, group: _p.toGroup);
          roomMethods.enteredUserIntoHostSeatReal(from: widget.from, group: _p.toGroup);
          _p.setGroupCallState(call: call);
          _p.setIsCallRunning(isRunning: true);
          _p.setShowTable(show: true);
         // _p.setUserHost(isHost: true);
         //  setState(() {
         //    _isHost = true;
         //  });
          _p.setJoinedBigGroup(isJoined: true);
          // start voice room
          if (_bgProvider.callState.mtoken != null && _bgProvider.callState.channelId != null) {
            // check if already rtc engine running . if running then distroy it first

            // await initPlatformState(1);
            // if(_bgProvider.isCallRunning) {
            //   if (_engine != null) {
            //     _engine.setClientRole(ClientRole.Broadcaster);
            //     _engine.setEnableSpeakerphone(true);
            //   }
            // }
            //


            var members = await roomMethods.getGroupMembersList(widget.contact.uid.toString());
            roomMethods.sendUserNotification(userList: members, from: widget.from, group: _p.toGroup);

          }
          _p.setShowSpinner(showSpinner: false);
          //  addPostFrameCallback();
        }
      }
    } else {
      _p.setShowTable(show: true);
    }
  }
  usersTapToJoineIntoHotSeat() async {
    // Fluttertoast.showToast(msg: "Please click on the user plus button to join the meeting.");
    int hotSeatMembersNow = await roomMethods.activeHotSeatMembersCount(group: _bgProvider.toGroup);
    // if hot seat members count less than 9 user can join the group
    if(hotSeatMembersNow < 8) {
      // get sorted list of active users
      fromJoinOrFromWaitingListUserAddition(widget.from, true);
    }else{
      await roomMethods.toast(msg: "Hot seat full now waiting running.");
      await roomMethods.createWaitingList(groupId: _bgProvider.toGroup.id.toString(), from: widget.from);
      _bgProvider.setUserWaiting(isWaiting: true);
    }
  }
  // add user to hot seat randomly from join button or waiting list
  fromJoinOrFromWaitingListUserAddition(UserModel user, bool isOnJoin) async{

    List<int> _allSeat = [];
    QuerySnapshot hotActive = await roomMethods.getHotSeatUserList(_bgProvider.toGroup.id.toString());

    // if hotseat user exist then get first and last item to check position
    if(hotActive.docs.length >= 0) {
      var all = hotActive.docs.toList();

      // add seat to a list
      for(var i = 2; i < 10; i++){
        _allSeat.add(i);
      }

      // remove seat from list already exist
      for(var id in all){
        QueryDocumentSnapshot qs = id;
        var dt = qs.data() as Map;
        if(dt["position"] != null) {
          // remove seat from list already exist
          _allSeat.remove(dt["position"]);
        }
      }

      if(_allSeat.isNotEmpty) {
        var _randomPosition = (_allSeat..shuffle()).first;
        // add user to the next seat
        await roomMethods.userTapAndJoinedToHotSeat(from: user,
            group: _bgProvider.toGroup,
            position: _randomPosition);
        // start voice rtc engine to speak
        if(_bgProvider.isCallRunning) {
          if (_engine != null) {
            _engine.setClientRole(ClientRole.Broadcaster);
          }
        }

        if(isOnJoin) {
          _bgProvider.setJoinedBigGroup(isJoined: true);
        }
      }

    }
  }
  usersTapToJoineIntoSpecificHotSeat(int position) async {
    int hotSeatMembersNow = await roomMethods.activeHotSeatMembersCount(group: _bgProvider.toGroup);
    // if hot seat members count less than 9 user can join the group
    if(hotSeatMembersNow < 9) {
      bool seatUpdate = await roomMethods.userTapAndJoinedToHotSeat(from: widget.from, group: _bgProvider.toGroup, position: position);
      if(seatUpdate) {
        if (_bgProvider.isCallRunning) {
          if (_engine != null) {
            _engine.setClientRole(ClientRole.Broadcaster);
          }
        }
        _bgProvider.setJoinedBigGroup(isJoined: true);
      }

    }else{
      await roomMethods.toast(msg: "Hot seat full.");
    }
  }
  getWaitingData() async {
    // get last item from waiting list
    var list = await roomMethods.getWaitingListAll(groupId: widget.contact.uid);
    QuerySnapshot wlist = list;
    var ds = wlist.docs;
      if(ds.isNotEmpty) {
        QueryDocumentSnapshot dts = ds.first;
        var dt = dts.data() as Map;
        // push user to hotseat
        // change the state of the user
        if (dt['userId'] == widget.from.id.toString()) {
        fromJoinOrFromWaitingListUserAddition(UserModel(
            id: int.parse(dt['userId']),
            photo: dt['photo'],
            nName: dt['name']
        ), false);
         _bgProvider.setUserWaiting(isWaiting: false);
          await roomMethods.removeWaitingUser(
              userId: dt['userId'], groupId: _bgProvider.toGroup.id.toString());
        }
      }
  }
  leaveFromWaiting() async {
    _bgProvider.setUserWaiting(isWaiting: false);
    await roomMethods.removeWaitingUser(userId: widget.from.id.toString(), groupId: _bgProvider.toGroup.id.toString());
  }
   roleSettingForFireStore(){
    // check if hot seat user removed by host
    streamSubscription =  _fireStore.collection(BIG_GROUP_COLLECTION)
        .doc(_bgProvider.toGroup.id.toString())
        .collection("hotSeat")
        .doc(widget.from.id.toString()).snapshots().listen((DocumentSnapshot ds) {
      if(!ds.exists) {
        _bgProvider.setJoinedBigGroup(isJoined: false);
        if(_bgProvider.isCallRunning) {
          if (_engine != null) {
            _engine.setClientRole(ClientRole.Audience);
          }
        }
      }else{
        _bgProvider.setJoinedBigGroup(isJoined: true);
        if(_bgProvider.isCallRunning) {
          if (_engine != null) {
            _engine.setClientRole(ClientRole.Broadcaster);
          }
        }
      }
    });
  }

  leaveVoiceRoom(){
    streamSubscription = callMethods.callStreamReal(uid: widget.from.id.toString(),
        groupId: widget.contact.uid).listen((event) async {
      if (event.snapshot == null || event.snapshot.value == null) {
          _bgProvider.setIsCallRunning(isRunning: false);
          _bgProvider.setShowTable(show: false);
          _bgProvider.setMuteVoice(mute: false);
          _bgProvider.setGroupCallState(call: null);
          if (_engine != null) {
            _engine.leaveChannel();
            _engine.destroy();
          }
          setState(() { });
      }
    });
  }

  onClickPlusButtonShowPermissionForVoiceRoom(parentContext, BigGroupProvider _p)  {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(height: 5,),
                    Image.asset("assets/meeting.png"),
                    SizedBox(height: 20,),
                    Text("You are trying to open voice room.",style: fldarkHome16,),
                    Text("Are you sure?",style: fldarkgrey15,),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            icon: Text("Yes",style: TextStyle(
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w900,
                              color: Colors.green,
                                fontSize: 16
                            )),
                            onPressed: ()  {
                              _p.setShowSpinner(showSpinner: true);
                              Navigator.pop(context);
                              onStartVoiceRoom(_p);
                            }
                        ),
                        IconButton(
                            icon: Text("No",style: TextStyle(
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.w900,
                                color: Colors.red,
                                fontSize: 16
                            )),
                          onPressed: () {
                              Navigator.pop(context);


                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),

            ],
          );
        },
    );

  }

  onStopVoiceRoomByAdmin(BigGroupProvider _p) async {
    _p.setShowSpinner(showSpinner: true);
    Navigator.pop(context);
    bool endCall = await callMethodsBigGroup.endQuickCallReal(call: _bgProvider.callState, user: widget.from);
    if (endCall) {
      // if (_engine != null) {
      //   _engine.leaveChannel();
      //   _engine.destroy();
      // }
      // delete host by ending call by host
     await roomMethods.deleteHostId(from: widget.from, group: _p.toGroup);
     await roomMethods.deleteHostIdReal(from: widget.from, group: _p.toGroup);
      _p.setIsCallRunning(isRunning: false);
      _p.setShowTable(show: false);
     // _p.setUserHost(isHost: false);
      setState(() {
        _isHost = false;
      });
      removeAllHostSeat();
      await roomMethods.deleteCollection(groupId: widget.toGroupId, collection: "userGiftSent");
      await roomMethods.deleteCollection(groupId: widget.toGroupId, collection: "userGiftReceived");
      await roomMethods.deleteCollection(groupId: widget.toGroupId, collection: "hotGift");
      await roomMethods.deleteCollection(groupId: widget.toGroupId, collection: "waitingList");
      _p.setShowSpinner(showSpinner: false);
      _p.setMuteVoice(mute: false);

    }
  }

  // remove all host seat by admin by ending voice call
  removeAllHostSeat() async {
    await roomMethods.removeAllHotSeatUsers(group: _bgProvider.toGroup);
    _bgProvider.setJoinedBigGroup(isJoined: false);
  }

  userRemoveHotSeatAndExit() async {
    await roomMethods.removeHotSeatAndExitByUserSelf(from: widget.from, group: _bgProvider.toGroup);
      _bgProvider.setJoinedBigGroup(isJoined: false);
    if(_bgProvider.isCallRunning) {
      if (_engine != null) {
        _engine.setClientRole(ClientRole.Audience);
      }
    }
  }

  userLeaveHotSeatAndVoiceRoomByOwn(BigGroupProvider _p) async{
    _p.setShowSpinner(showSpinner: true);
    Navigator.pop(context);
    await roomMethods.removeHotSeatAndExitByUserSelf(from: widget.from, group: _p.toGroup);
      if (_engine != null) {
        _engine.leaveChannel();
        _engine.destroy();
      }
    _bgProvider.setJoinedBigGroup(isJoined: false);
      // setGroupRunning means user wont see the start button
    // To avoid overriding voice room running if one voice room running
    _p.setGroupRunning(isRunning: false);
    _p.setIsCallRunning(isRunning: false);
    _p.setShowTable(show: false);
   // _p.setUserHost(isHost: false);
    _p.setMuteVoice(mute: false);
    setState(() {
      _isHost = false;
    });
    _p.setShowSpinner(showSpinner: false);
    Navigator.pop(context);
  }



  // Initialize the app
  Future<void> initPlatformState(int voiceRoomOnByAdmin) async {
    // set group running status false so that yellow button can be shown
    _bgProvider.setGroupRunning(isRunning: false);
    // Get microphone permission
    Map<Permission, PermissionStatus> ps = await [
      Permission.microphone,
    ].request();

    try {
      // Create RTC client instance
      _engine = await RtcEngine.create(_bgProvider.callState.appId);
      _agoraProviderBigGroup = Provider.of<AgoraProviderBigGroup>(context, listen: false);
      _agoraProviderBigGroup.setHandlerAgoraBigGroup(engine: _engine);

      // setting channel profile as live broad casting
      _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
      await _engine.joinChannel(
          _bgProvider.callState.mtoken, _bgProvider.callState.channelId, null,
          widget.from.id);
      await _engine.enableAudioVolumeIndication(400, 3, true);
    }catch (e) {
      print(e);
    }


  }

  bool muted = false;

  ValueNotifier<bool> _muteMic = ValueNotifier(false);

  /// Toolbar layout
  Widget _toolbar(BigGroupProvider _p) {
   // if (callState.role == ClientRole.Audience) return Container();
    return Container(
      padding: const EdgeInsets.only(bottom: 0, left: 8, right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: 30,
            width: 30,
            child: IconButton(
              icon: Image.asset(
                "assets/big_group/menu.png",
                height: 20,
                width: 20,
              ),
              onPressed: (){
                _settingBottomSheet(context, _p);
              },
            ),
          ),
          Container(
            height: 40,
            width: 40,
            child: IconButton(
              icon: giftReactCachedNetworkImage(context,
                  "$APP_ASSETS_URL/react/thumb/think.png"),
              onPressed: (){
                _reactBottomSheet(context, _p);
              },
            ),
          ),
          Container(
            height: 25,
            width: 25,
            child: IconButton(
              icon : giftReactCachedNetworkImage(context,
                  "$APP_ASSETS_URL/big_group/gift.png"),
              onPressed: () {
                _dimondGemFollowProvider = Provider.of<DimondGemFollowProvider>(context, listen: false);
                _dimondGemFollowProvider.getDimondGemFollow(widget.from.id.toString());
                _giftModalBottomSheet(context, 1);
              },
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
            ),
          ),
         _p.isJoinedToBigGroup ? Container(
           height: 30,
           width: 33,
           child: !_forceMute ? IconButton(
            icon : _p.muted ? Icon(Icons.mic_off) : Icon(Icons.mic),
             color: _p.muted ? Colors.white : Colors.blueAccent,
             iconSize: 20,
             onPressed: _onToggleMute,
             padding: EdgeInsets.symmetric(vertical: 4, horizontal: 7),
           ) : Container(),
         ) : Container(),
          _isHost ? Container() : GestureDetector(
                  onTap: !_p.isJoinedToBigGroup
                      ? !_p.userWaiting ? usersTapToJoineIntoHotSeat : leaveFromWaiting
                      : userRemoveHotSeatAndExit,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.cyanAccent,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          FontAwesome.users,
                          color: Colors.black,
                          size: 10,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        !_p.isJoinedToBigGroup ? !_p.userWaiting ? Text("Join", style: fldarkgrey12,) : Text("Exit wait", style: fldarkgrey12,)  : Text("Exit", style: fldarkgrey12,),
                      ],
                    ),
                  ),
                ),
          GestureDetector(
            onTap: () async {
              _p.showTable ? _p.setShowTable(show: false) : _p.setShowTable(show: true);
            },
            child: Icon(
              Icons.arrow_circle_up,
              color: Colors.white,
              size: 25.0,
            ),
          ),
        ],
      ),
    );
  }



  void _onToggleMute(){
        if(_bgProvider.muted){
          if(_isHost) {
            roomMethods.setMuteHotSeatUserReal(collection: "hostId", groupId: _bgProvider.toGroup.id.toString(), isMute: false);
          }else{
            roomMethods.setMuteHotSeat(userId: widget.from.id.toString(), group: _bgProvider.toGroup,mute: false, forceMute: false);
          }
        }else{
          if(_isHost) {
            roomMethods.setMuteHotSeatUserReal(collection: "hostId", groupId: _bgProvider.toGroup.id.toString(), isMute: true);
          }else {
             roomMethods.setMuteHotSeat(userId: widget.from.id.toString(), group: _bgProvider.toGroup,mute: true, forceMute: false);
          }
        }
     _bgProvider.setMuteVoice(mute: !_bgProvider.muted);

  }

  // Big group call functions all end
  Future<bool> getExitPermisison(BuildContext context, BigGroupProvider _p) async {
    if(_p.showTable) {
    bool exit =  await _userPermissionExitBottomsheet(context, _p);
    return Future.value(false);
    }
    // Just make group running false when exit the group
    // so that next time when user will entered into the group
    // User can see start button of the group
    _p.setGroupRunning(isRunning: false);
    return Future.value(true);
  }

  SpineAnimation _spineAnimation = SpineAnimation();

  Widget _buildScreen() {
    return SkeletonRenderObjectWidget(
      skeleton: _spineAnimation.skeleton,
      alignment: Alignment.center,
      fit: BoxFit.contain,
      playState: PlayState.playing,
      debugRendering: false,
      triangleRendering: true,
    );
  }

  _fireSpineAnim({String anim, String action, String rootPath}) async {
    await _spineAnimation.load(name: anim, path: rootPath);
    final String defaultAnimation = action;
    _spineAnimation.skeleton.state.setAnimation(0, defaultAnimation, true);
    setState(() {
      _showSpineAnim = true;
    });

  }

  final _recoder = SoundRecorder();
  final _timeController = TimerController();

  _recodingWidget(FileUploadProvider fp, BigGroupProvider _bg, AudioProvider _audioProvider) {
    return Column(
      children: [
        GestureDetector(
          onLongPressStart: (_) async {
            await _recoder.toggleRecording(rootDir: _rootDir, senderId: _bg.toGroup.id.toString(),
                user: widget.from, chatType: USER_BIG_GROUP, fp: fp, role: _bg.role, ap: _audioProvider);
            if(_audioProvider.isRecodring){
              _timeController.startTimer();
            }else{
              _timeController.stopTimer();
            }
            setState(() {});
          },
          onLongPressEnd: (_) async {
            await _recoder.toggleRecording(rootDir: _rootDir, senderId: _bg.toGroup.id.toString(),
                user: widget.from, chatType: USER_BIG_GROUP, fp: fp, role: _bg.role, ap: _audioProvider);
            if(_audioProvider.isRecodring){
              _timeController.startTimer();
            }else{
              _timeController.stopTimer();
            }
            setState(() {});
          },

          child: Material(
            color: Colors.blue,
            elevation: 5,
            borderRadius:
            BorderRadius.all(Radius.circular(40)),
            child: Container(
              child: Icon(!_audioProvider.isRecodring ? Icons.mic : Icons.stop, size: 20, color: Colors.white),
              width: 40,
              height: 40,
            ),
          ),
        ),
      ],
    );
  }

  shwoEmojiContainer(BigGroupProvider _p) {
    // return EmojiPicker(
    //   onEmojiSelected: (emoji, category) {
    //     _p.setIsWriting(isWriting: true);
    //     msgTextEditingController.text =
    //         msgTextEditingController.text + emoji.emoji;
    //   },
    //   bgColor: Colors.grey.withOpacity(0.3),
    //   rows: 3,
    //   columns: 7,
    //   recommendKeywords: ["face", "happy", "party", "sad"],
    //   numRecommended: 20,
    // );
  }

  final _scafoldKey = GlobalKey<ScaffoldState>();

  void _showToast(BuildContext context) {

    Fluttertoast.showToast(msg: "Id Copied");
  }

  // react  bottom sheet
  void _reactBottomSheet(context , BigGroupProvider _p) {
    // getHostUser = getHost();
    // getHotSeatList = getHotSeatUserList();
    showModalBottomSheet(
        isScrollControlled: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0))),
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext bc) {
          return StatefulBuilder(
              builder: (BuildContext bc, StateSetter setState) {
                return Container(
                  height: 300,
                  child: Column(
                    children: [
                      SizedBox(height: 25,),
                      SingleChildScrollView(
                        child: Wrap(
                            direction: Axis.horizontal,
                            children: _bgProvider.react.map((data) =>
                                Container(
                                  height: MediaQuery.of(context).size.width / 4 - 10,
                                  width: MediaQuery.of(context).size.width / 4 - 10,
                                  child: IconButton(
                                    icon: giftReactCachedNetworkImage(context,
                                        "$APP_ASSETS_URL/react/thumb/$data.png"),
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      if(!_isHost) {
                                        await roomMethods.setImojiUserHotSeat(
                                            group: _bgProvider.toGroup,
                                            hotSeatUser: widget.from.id
                                                .toString(), imoji: data,
                                            collection: "hotSeat");
                                      }else{
                                        await roomMethods.setImojiForHostSeat(
                                            group: _bgProvider.toGroup,
                                            hotSeatUser: widget.from.id
                                                .toString(), imoji: data,
                                            collection: "hostId");
                                        Fluttertoast.showToast(msg: "is admin");
                                      }
                                    },
                                  ),
                                ),
                            ).toList(),
                        )
                      ),
                    ],
                  ),
                );
              }
          );
        });
  }

  // Setting  bottom sheet
  void _settingBottomSheet(context , BigGroupProvider _p) {
    // getHostUser = getHost();
    // getHotSeatList = getHotSeatUserList();
    showModalBottomSheet(
        isScrollControlled: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0))),
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext bc) {
          return StatefulBuilder(
              builder: (BuildContext bc, StateSetter setState) {
                return Container(
                  height: 300,
                  child: Column(
                    children: [
                      SizedBox(height: 25,),
                      Text("Setting",style: fldarkgrey18,),
                       ListTile(
                           title: Text("Tap to set background color"),
                           leading: Icon(Icons.color_lens_outlined),
                           onTap: _isHost ? () {
                             Navigator.of(context).pop();
                             showDialog(
                               context: context,
                               builder: (BuildContext context) {
                                 return AlertDialog(
                                   titlePadding: const EdgeInsets.all(0.0),
                                   contentPadding: const EdgeInsets.all(0.0),
                                   shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(25.0),
                                   ),
                                   content: SingleChildScrollView(
                                       child: ColorPicker(
                                         pickerColor: pickerColor,
                                         onColorChanged: changeColor,
                                         showLabel: true,
                                         pickerAreaHeightPercent: 0.8,
                                       )
                                   ),
                                   actions: <Widget>[
                                     TextButton(
                                       child: const Text('Confirm'),
                                       onPressed: () {
                                         // setState(() => currentColor = pickerColor);
                                         Navigator.of(context).pop();
                                       },
                                     ),
                                   ],
                                 );
                               },
                             );
                           } : null,
                       ),
                      ListTile(
                        title: Text("Change background picture"),
                        leading: Icon(Icons.image),
                        onTap: () async {
                         Map<Permission, PermissionStatus> ps = await [
                           Permission.storage,
                           Permission.phone,
                           Permission.mediaLibrary
                         ].request();
                         Navigator.of(context).pop();
                         _changeBackgroundImage(context);


                          },
                      ),
                      ListTile(
                        title: Text("Play audio"),
                        leading: Icon(Icons.audiotrack),
                        onTap: () async {
                          Map<Permission, PermissionStatus> ps = await [
                            Permission.storage,
                            Permission.phone,
                            Permission.mediaLibrary
                          ].request();

                          Navigator.of(context).pop();
                          _audioPlayingOptions(context);

                        },
                      ),
                    ],
                  ),
                );

              }
          );
        });
  }

  // change voice room image
  void _changeBackgroundImage(context) {

    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0))),
        builder: (BuildContext bc){
          return Container(
              height: MediaQuery.of(context).size.height / 3 *2,
              child: BackgroundImagesWidget(toGroupId: widget.toGroupId, from: widget.from,)
          );
        }
    );
  }

  // audio playing options
  void _audioPlayingOptions(context) async{
    FileUploadProvider _fp = Provider.of<FileUploadProvider>(context, listen: false);
   String urls = "http://quickchatting.gumoti.com/images/audios/beep.mp3";
   int getVolume = await _engine.getAudioMixingPlayoutVolume();
   double rating = getVolume.toDouble();
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0))),
        builder: (BuildContext bc){
          return StatefulBuilder(
              builder: (BuildContext bc, StateSetter setState) {
                return Container(
                  height: 300,
                  child: Column(
                    children: [
                      SizedBox(height: 25,),
                      Text("Play audio", style: fldarkgrey18,),
                      ListTile(
                        title: Text("Upload file"),
                        leading: Icon(Icons.multiline_chart),
                        onTap: () async {

                          String url = await _singlefileUploadMethods
                              .getAttachmentAndUpload(
                              receiverId: widget.from.id.toString(),
                              senderId: _bgProvider.toGroup.id.toString(),
                              name: widget.from.nName,
                              userPhoto: widget.from.photo,
                              chatType: USER_BIG_GROUP,
                              fileUploadProvider: _fp
                          );

                          

                          if (_engine != null) {
                            await _engine.startAudioMixing(
                                url, false, false, 100);
                          }

                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.multiline_chart),
                        title: Slider(
                          value: rating,
                          onChanged: (newVal) async {
                            setState(() => rating = newVal);
                          },
                          min: 0,
                          max: 100,
                          divisions: 10,
                          label: "$rating",
                          onChangeEnd: (val) async{
                            if (_engine != null) {
                              await _engine.adjustAudioMixingVolume(val.toInt());
                            //  await _engine.adjustAudioMixingPlayoutVolume(val.toInt());
                            //  await _engine.adjustAudioMixingPublishVolume(val.toInt());

                            }
                          },
                        ),

                      ),
                      ListTile(
                        title: Text("Start audio"),
                        leading: Icon(Icons.music_note),
                        onTap: () async {
                          Navigator.of(context).pop();
                          if (_engine != null) {
                            await _engine.startAudioMixing(
                                urls, false, false, 100);
                          }

                        },
                      ),
                      ListTile(
                        title: Text("Stop audio"),
                        leading: Icon(Icons.music_off),
                        onTap: () async {
                          Navigator.of(context).pop();
                          if (_engine != null) {
                            await _engine.stopAudioMixing();
                          }
                        },
                      ),
                    ],
                  ),
                );
              }
          );
        }
    );
  }

  // Gift list bottom sheet
  void _giftModalBottomSheet(context, int position) {
    // get new gift data
    _bgProvider.getGiftData(userId: widget.from.id.toString());
    showModalBottomSheet(
        isScrollControlled: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0))),
        backgroundColor: Colors.black87,
        context: context,
        builder: (BuildContext bc) {
          return Container(
         //   color: Colors.black87,
            height: 280,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12,top: 15, bottom: 5),
                  child: Text('Gift list',
                  style: ftwhite12),
                ),
                Container(
                  height: 220,
                  child: SingleChildScrollView(
                    child: Wrap(
                      direction: Axis.horizontal,
                      children: _bgProvider.gift.map((data) =>
                          Container(
                            width: MediaQuery.of(context).size.width / 4,
                            child: GiftWidget(
                                chattroom: true,
                                gift: data,
                                user: widget.from,
                                group: _bgProvider.toGroup,
                                onPressed: (){
                                  Navigator.of(context).pop();
                                  _userModalBottomSheet(context, data);

                                  _getHostHotSeatUserProvider = Provider.of<GetHostHotSeatUserProvider>(context, listen: false);
                                  _getHostHotSeatUserProvider.getHostHotSeatUserListProvider(toGroupId: widget.toGroupId.toString(), fromUserId: widget.from.id.toString());

                                  //  Navigator.push(context, MaterialPageRoute(builder: (context) => ShareGiftUserList(user: user, group: group, gift: gift,)));
                                },
                            ),
                          ),
                        //  Container(child: Text("hello"),),
                      ).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }


  Future<bool> _userPermissionExitBottomsheet(context, BigGroupProvider _p){
    showModalBottomSheet(
        isScrollControlled: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0))),
        backgroundColor: Colors.black87,
        context: context,
        builder: (BuildContext bc){
          return Container(
            height: 200,
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  BottomListItem(
                      icon: Icons.home,
                      color: Colors.white,
                      name: "Minimize and home screen" ,
                      fn: (){
                        // pop
                 //   Navigator.of(context)..pop()..pop();
                    int count = 0;

                          Navigator.of(context).popUntil((route) =>
                          count++ >= 2);

                    // start floating button call

                      // startAFloatingActionButton(
                      //     userId: widget.from.id.toString(),
                      //     groupId: widget.toGroupId);


                  }),
                  BottomListItem(
                      color: Colors.red,
                      icon: FontAwesome.power_off,
                      name: "Close voice room" ,
                    fn: _isHost ? () => onStopVoiceRoomByAdmin(_p) : () => userLeaveHotSeatAndVoiceRoomByOwn(_p),
                  ),
                  BottomListItem(
                      icon: Icons.local_fire_department,
                      color: Colors.white,
                      name: "Cancel" , fn: (){
                    Navigator.pop(context);
                  }),

                ],
              )
          );
        }
    );
  }


  // User list  bottom sheet
  void _userModalBottomSheet(context, Gift gift) {
    // getHostUser = getHost();
    // getHotSeatList = getHotSeatUserList();
    showModalBottomSheet(
        isScrollControlled: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0))),
        backgroundColor: Colors.black87,
        context: context,
        builder: (BuildContext bc) {
          return StatefulBuilder(
            builder: (BuildContext bc, StateSetter setState) {
              return GiftSelectedUserListBottomSheetContent(
                gift: gift,
                from: widget.from,
                toGroup: _bgProvider.toGroup,
              );

            }
          );
        });
  }

  _userTypingStatus(){
   return Container(
     padding: EdgeInsets.only(left: 10),
     height: 25,
     child: StreamBuilder(
          stream: roomMethods.getUserOnlineStateGroup(groupId: widget.contact.uid),
          builder: (context, AsyncSnapshot event) {
            if(!event.hasData){
              return Container();
            }
            if(event.data.snapshot.value is Map){
              Map<dynamic, dynamic> dt = event.data.snapshot.value ;

            if(dt != null) {
              var dts = dt.values.first;
              return widget.from.id.toString() != dts['user_id']
                  ? dts['isTyping'] == true ? Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: dts["photo"] != null ? UserImageByPhotoUrlTyping(
                        photo: dts["photo"],
                      ) : Container(),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                Profile(userId: dts['user_id'],
                                    currentUser: widget.from)));
                        //  _optionModalBottomSheet(context);
                      },
                    ),
                    SizedBox(width: 5),
                    Container(
                      width: 130,
                      child: Text('${dts['name']}',
                        style: TextStyle(
                            fontSize: 13
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text('is typing...',
                        style: TextStyle(
                            fontSize: 13
                        )),
                  ],
                ),)
                  : Container()
                  : Container();
            }
            }
            return Container();
          }
      ),
   );
  }


//   final Trimmer _trimmer = Trimmer();
//    ImagePicker _imagePicker = ImagePicker();
//   final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
//   IO.File _file;
//
//   VideoPlayerController _videoPlayerController;
//   IO.File _returnedFile;
//
//   handleChooseFromGalleryVideo() async {
//
//     XFile pickedFile = await _imagePicker.pickVideo(
//       source: ImageSource.gallery,
//     );
//     IO.File _fileToTrim = IO.File(pickedFile.path);
//     setState(() {
//       _file = IO.File(_fileToTrim.path);
//     });
//
//     if (_fileToTrim != null) {
//       // await compressVideo();
//       await _trimmer.loadVideo(videoFile: _file);
//
//       String _trimmedPath = await Navigator.push(
//           context,
//           MaterialPageRoute<String>(
//               fullscreenDialog: true,
//               builder: (BuildContext context) {
//                 return TrimmerViewWidget(_trimmer);
//               }));
//
//       if (_trimmedPath == null) {
//         setState(() {
//           _file = null;
//         });
//       } else if (_file == null) {
//         setState(() {
// //          _videoPlayerController.dispose();
//           _videoPlayerController.pause();
//         });
//       } else {
//         setState(() {
//           _returnedFile = IO.File(_trimmedPath);
//         });
//       }
//     }
//
//
//   }


  createRtcEngineForIssue() async {
    // if user go for minimize then an issue arised that
    // after coming back to the screen there is no agora engine available to distroy
    // so this is for extra step to initialize the agora sdk then distroy it so
    // next time it will not create new issue
    // strange hack
    // create a engine again to remove any issue
    _engine = await RtcEngine.create(_bgProvider.callState.appId);
  }

}







