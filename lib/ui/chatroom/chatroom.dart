import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:chat_app/ui/chatroom/audio_recoder/timer_recoder_widget.dart';
import 'package:chat_app/ui/chatroom/fileupload/video_upload_provider.dart';
import 'package:chat_app/ui/chatroom/function/sound_recoder.dart';
import 'package:chat_app/ui/chatroom/function/sound_recoder_personal.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/sliver_profile.dart';
import 'package:intl/intl.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/call/permissionhandler.dart';
import 'package:chat_app/ui/chatroom/chatmethods/chatmethods_personal.dart';
import 'package:chat_app/ui/chatroom/fileupload/fileuploadmulti.dart';
import 'package:chat_app/ui/chatroom/fileupload/imageupload.dart';
import 'package:chat_app/ui/chatroom/model/contact.dart';
import 'package:chat_app/ui/chatroom/widgets/message_stream_personal.dart';
import 'package:chat_app/ui/pages/home/controller/homeController.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/profile.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_player/video_player.dart';

import '../../provider/file_upload_provider.dart';
import 'package:path_provider/path_provider.dart';




final _fireStore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;


class ChatRoom extends StatefulWidget {
  final ChatMethodsPersonal _chatMethodsPersonal = ChatMethodsPersonal();
  final FileUploadMethods _fileUploadMethods = FileUploadMethods();
  final ImageUploadFunction _imageUploadFunction = ImageUploadFunction();
  final UserModel from;
  final String toUserId;
  final ContactHome contact;
  ChatRoom({this.from, this.toUserId, this.contact});

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> with SingleTickerProviderStateMixin {

  final msgTextEditingController = TextEditingController();
  final HomeController _hController = HomeController();

  FocusNode focusNode;
  bool showSpinner = false;
  String msgText;
  User loggedInUser;
  bool isWriting = false;
  File file;
  bool isUploading = false;
  bool emojiPicker = false;
  UserModel to;
  bool showReplay = false;
  String _replayText = '';
  String _replyPhoto = '';
  String _replyName = '';
  String _replyFileUrl = '';
  String _replyId = '';
  String _rootDir;

  AnimationController animController;
  ChatMethodsPersonal _chatMethodsPersonal = ChatMethodsPersonal();

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    if(widget.contact != null) {
      _chatMethodsPersonal.setMessageCountZero(
          toUid: widget.contact.uid.toString(),
          fromUid: widget.from.id.toString());
    }
    getCurrentUser();

    msgTextEditingController.addListener(() {
      animController.reset();
      animController.forward();
    });

    animController = AnimationController(
        duration: Duration(seconds: 1),
        vsync: this
    );
    animController.addStatusListener((status) {
      _chatMethodsPersonal.setTyping(userId: widget.from.id.toString());
      if(status == AnimationStatus.completed){
        animController.reset();
        _chatMethodsPersonal.setNotTyping(userId: widget.from.id.toString());
      }
    });

    // downlaod code
    getApplicationDocumentsDirectory().then((tmpDir) => {
      _rootDir = tmpDir.parent.path,
    });




  }

  // set state only munted data very important to fix error ==== setState after dispose method
  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if(animController != null){
      animController.dispose();
    }
    _chatMethodsPersonal.setNotTyping(userId: widget.from.id.toString());
    super.dispose();
  }

  void getCurrentUser () async {

    UserModel toUser = await _hController.getUserById(widget.toUserId);

    setState(() {
      to = toUser;
    });

    try{
      final crntUser = _auth.currentUser;
      if(crntUser != null){
        loggedInUser = crntUser;
      }
    }catch (e) {
      print(e);
    }
  }


  Future getUserById(int uId) async {
    final String url = BaseUrl.baseUrl("requstUser/$uId");
    final http.Response rs = await http.get(Uri.parse(url),
        headers: { 'test-pass' : ApiRequest.mToken});
    Map data = jsonDecode(rs.body);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    FileUploadProvider _fp = Provider.of<FileUploadProvider>(context);
    VideoUploadProvider _vup = Provider.of(context);
    AudioProviderPersonal _ap = Provider.of(context, listen: false);


    String uId = widget.contact != null && widget.contact.uid != null ? widget.contact.uid : widget.toUserId;
    String name = widget.contact != null && widget.contact.name != null ? widget.contact.name : widget.toUserId;

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            child:Container(
              margin: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
              width: 30.0,
              height: 30.0,
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.all(new Radius.circular(70.0)),
                border: Border.all(
                  color: Colors.white,
                  width: 1.0,
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
              child: widget.contact != null && widget.contact.photo != null ? cachedNetworkImageCircular(context, widget.contact.photo) : Icon(Icons.umbrella_rounded),
            ),
            onTap: () {
            //  Navigator.push(context, MaterialPageRoute(builder: (context) => PersonalProfileSliver(userId: widget.contact.uid, currentUser: widget.from,)));
              Navigator.of(context).pushNamed('/viewProfile', arguments: {
                'userId' : widget.contact.uid, 'currentUser' : widget.from
              });

            },
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$name $uId - ${widget.from.id}',
                style: ftwhite14,),
              StreamBuilder(
                  stream: _chatMethodsPersonal.getUserOnlineState(userId: uId),
                  builder: (context, AsyncSnapshot event) {
                    if(!event.hasData){
                      return Container();
                    }
                    Map<dynamic, dynamic> dts = event.data.snapshot.value;
                    if(dts != null) {
                      var timeServer = DateTime.fromMillisecondsSinceEpoch(dts['timeStamp']);
                      var time;
                      if(timeServer.minute > 30 ){
                        time = DateFormat('hh:mm a, dd-MM-yyyy').format(timeServer);
                      }else{
                        time = timeago.format(timeServer);
                      }
                      return dts['isTyping'] == true ? Container(
                        child: Text('is typing...',
                            style: ftwhite14),)
                          : Container(
                            child: dts['timeStamp'] != null ? Text('${dts['userState'] == 1
                                ? "Online" : time}', style: ftwhite14,)
                                : Text(''),
                      );
                    }
                    return Container();
                  }
              ),

            ],
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.call),
                onPressed: () async => await PermissionHandlerUser().onJoin() ?
                Navigator.of(context).pushNamed("/audioCallScreen", arguments:
                {'from': widget.from,
                  'toUserId': widget.contact.uid,
                  'toUserPhoto': widget.contact.photo,
                  'role' : ClientRole.Broadcaster,
                  'onReceive' : false,
                }) : {},
            ),
            IconButton(
              icon: Icon(Icons.video_call),
              onPressed: () async => await PermissionHandlerUser().onJoin() ?
              Navigator.of(context).pushNamed("/videoCallScreen", arguments:
              {'from': widget.from,
                'toUserId': widget.contact.uid,
                'toUserPhoto': widget.contact.photo,
                'role' : ClientRole.Broadcaster,
                'onReceive' : false,
              }) : {},
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                userSettingsSampleModal(context);
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            Container(
              child: Column(
                children: [
                 to != null ? MessageStreamPersonal(
                      from: widget.from,
                      to: to,
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
                  ) : Expanded(child: Container()),

                  Container(
                    child: Column(
                      children: [
                        SizedBox(height: 10,),
                        Container(
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(.2),
                                    borderRadius: BorderRadius.all(Radius.circular(30))
                                  ),
                                  child: Column(
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
                                              focusNode: focusNode,
                                              controller: msgTextEditingController,
                                              onChanged: (value) {
                                                  setState(() {
                                                    isWriting = true;
                                                  });
                                              },
                                              decoration: ftcustomInputDecoration.copyWith(
                                                hintText: "Enter message...",
                                                  enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(3)),
                                                    borderSide: BorderSide(color: Colors.transparent),
                                              )).copyWith(focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(3)),
                                                borderSide: BorderSide(color: Colors.transparent),
                                              )),
                                            ),
                                          ),

                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                             isWriting ? Material(
                                color: Colors.blue,
                                elevation: 5,
                                borderRadius:BorderRadius.all(Radius.circular(40)),
                                child: MaterialButton(
                                  onPressed: () {
                                    focusNode.unfocus();
                                      widget._chatMethodsPersonal.sendMessage(msgTextEditingController.text,
                                          widget.from,
                                          to.id.toString());
                                     setState(() {
                                       isWriting = false;
                                     });
                                     msgTextEditingController.clear();

                                  },
                                  textColor: Colors.white,
                                  child: Icon(
                                    Icons.send,
                                    size: 15,
                                  ),
                                  minWidth: 30,
                                  height: 30,
                                ),

                              ) : _recodingWidget(_fp, _ap),
                              SizedBox(width: 10,),
                            ],
                          ),
                        ),
                        SizedBox(height: 5,),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ChatButtons(
                                icon:Icons.attach_file,
                                onPress: () {
                                  widget._fileUploadMethods.getAttachmentAndUpload(
                                      receiverId: widget.from.id.toString(),
                                      senderId: to.id.toString(),
                                      name: widget.from.nName,
                                      userPhoto: widget.from.photo,
                                      chatType: USER_PERSONAL,
                                      fileUploadProvider: _fp,
                                  );
                                }
                              ),
                              // ChatButtons(
                              //   icon:Icons.video_collection_rounded,
                              //   onPress: () {
                              //     widget._fileUploadMethods.pickFile(
                              //       source: ImageSource.gallery,
                              //       receiverId: widget.from.id.toString(),
                              //       senderId: to.id.toString(),
                              //       name: widget.from.nName,
                              //       userPhoto: widget.from.photo,
                              //       chatType: USER_PERSONAL,
                              //       fp: _fp,
                              //       fileType: 1,
                              //       role: 0
                              //     );
                              //
                              //   },
                              // ),

                              ChatButtons(
                                icon: Icons.perm_media,
                                onPress: () {
                                //  handleChoseFromGallery();
                                  widget._fileUploadMethods.pickFile(
                                    source: ImageSource.gallery,
                                    receiverId: widget.from.id.toString(),
                                    senderId: to.id.toString(),
                                    name: widget.from.nName,
                                    userPhoto: widget.from.photo,
                                    chatType: USER_PERSONAL,
                                    fp: _fp,
                                    fileType: 2,
                                  );
                                 // pickImage(source: ImageSource.gallery);
                                },
                              ),
                              ChatButtons(
                                icon: Icons.camera_alt,
                                onPress: () {
                                //  handleTakePhoto();
                                  widget._fileUploadMethods.pickFile(
                                    source: ImageSource.gallery,
                                    receiverId: widget.from.id.toString(),
                                    senderId: to.id.toString(),
                                    name: widget.from.nName,
                                    userPhoto: widget.from.photo,
                                    chatType: USER_PERSONAL,
                                    fp: _fp,
                                    fileType: 3,
                                    role: 0
                                  );
                                //  pickImage(source: ImageSource.camera);
                                },
                              ),
                              ChatButtons(
                                icon: Icons.video_collection_rounded,
                                onPress: () async {
                                    // set information for need to file upload to server
                                    _vup.setVideoModel(
                                        videoModel: VideoUploadModel(
                                          receiverId: widget.from.id.toString(),
                                          senderId: widget.toUserId,
                                          name: widget.from.nName,
                                          userPhoto: widget.from.photo,
                                          chatType: USER_PERSONAL,
                                          fp: _fp,
                                          fileType: 1,
                                        )
                                    );

                                   // handleChooseFromGalleryVideo();

                                },
                              ),
                              SizedBox(width: 45,)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  emojiPicker ? Container(child: shwoEmojiContainer(),) : Container(),
                ],
              ),
            ),
            _fp.showUploadLayerPersonal ? Positioned(
                right: 5,
                bottom: 105,
                child: Container(
                    height: 60,
                    width: 60,
                    child: CircularPercentIndicator(
                      radius: 20.0,
                      lineWidth: 3.0,
                      percent: _fp.uploadSentPersonal,
                      header: Text("${double.parse((_fp.uploadSentPersonal*100).toStringAsFixed(0))}"),
                      center: Icon(Icons.upload_rounded, color: Colors.black,),
                      progressColor: Colors.green,
                      backgroundColor: Colors.yellow,
                    )
                )
            ) : Container(),
          ],
        ),
      ),
    );
  }

  final _recoder = SoundRecorderPersonal();
  final _timeController = TimerController();

  _recodingWidget(FileUploadProvider fp, AudioProviderPersonal _audioProvider) {

    return Column(
      children: [
        GestureDetector(

          onLongPressStart: (_) async {
            print("hello --======");
            await _recoder.toggleRecording(rootDir: _rootDir, senderId: widget.toUserId,
                user: widget.from, chatType: USER_PERSONAL, fp: fp, ap: _audioProvider);
            if(_audioProvider.isRecodring){
              _timeController.startTimer();
            }else{
              _timeController.stopTimer();
            }
            setState(() {});
          },
          onLongPressEnd: (_) async {
           print("hello --======<<<<<");
            await _recoder.toggleRecording(rootDir: _rootDir, senderId: widget.toUserId,
                user: widget.from, chatType: USER_PERSONAL, fp: fp, ap: _audioProvider);
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






  static final _firestore = FirebaseFirestore.instance;



  Future blockContactById({String receiverId, String userId}) {
     DocumentReference r =
     _firestore.collection(CONTACTS_COLLECTION)
        .doc(userId)
        .collection(CONTACT_COLLECTION)
        .doc(receiverId);
     r.set({"block": userId}, SetOptions(merge: true));

     DocumentReference rr =
     _firestore.collection(CONTACTS_COLLECTION)
         .doc(receiverId)
         .collection(CONTACT_COLLECTION)
         .doc(userId);
     rr.set({"block": userId}, SetOptions(merge: true));

  }


  userSettingsSampleModal(parentContext)  {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
              child: Column(
                children: [
                  Text("Settings",style: fldarkgrey18,),
                  ListTile(
                    minLeadingWidth: 5.0,
                    minVerticalPadding: 0.0,
                    horizontalTitleGap: 5.0,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    leading: Icon(Icons.stop_circle, color: Colors.red,),
                    title: Text("Block user",style: fldarkHome16,),
                    onTap: (){
                      Navigator.pop(context);
                      onClickPlusButtonShowPermissionForVoiceRoom(parentContext);
                    },
                  ),
                  SizedBox(height: 5,),

                ],
              ),
            ),

          ],
        );
      },
    );

  }

  onClickPlusButtonShowPermissionForVoiceRoom(parentContext)  {
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
                  Container(
                      width: 80,
                      child: Image.asset("assets/images/error.png")
                  ),
                  SizedBox(height: 20,),
                  Text("Are you sure?",style: fldarkgrey18,),
                  SizedBox(height: 10,),
                  Text("You are trying to block this user.",style: fldarkHome16,),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          icon: Text("Yes",style: TextStyle(
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w900,
                              color: Colors.red,
                              fontSize: 16
                          )),
                          onPressed: () async {
                            Navigator.pop(context);
                            loaderPopup(context);
                           await blockContactById(receiverId: widget.contact.uid, userId: widget.from.id.toString());
                            Navigator.pop(context);
                            Navigator.pop(context);
                            print('printed');
                            print("useri id : " + widget.contact.uid + " " + widget.from.id.toString());
                            //Navigator.pop(context);
                          }
                      ),
                      IconButton(
                        icon: Text("No",style: TextStyle(
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w900,
                            color: Colors.green,
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

  loaderPopup(parentContext)  {
    return showDialog(
      barrierDismissible: false,
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
              child: Column(
                children: [
                  Text("Please wait...",style: fldarkgrey15,),
                  SizedBox(height: 5,),
                  Container(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator()
                  ),

                ],
              ),
            ),

          ],
        );
      },
    );

  }


  // list file upload methods


  shwoEmojiContainer(){
    // return EmojiPicker(
    //   onEmojiSelected: (emoji, category) {
    //    setState(() {
    //      isWriting = true;
    //    });
    //    msgTextEditingController.text = msgTextEditingController.text + emoji.emoji;
    //   },
    //   bgColor: Colors.grey.withOpacity(0.3),
    //   rows: 3,
    //   columns: 7,
    //   recommendKeywords: ["face","happy","party","sad"],
    //   numRecommended: 20,
    // );
  }


//   final Trimmer _trimmer = Trimmer();
//   ImagePicker _imagePicker = ImagePicker();
//   final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
//   File _file;
//
//   VideoPlayerController _videoPlayerController;
//   File _returnedFile;
//
//   handleChooseFromGalleryVideo() async {
//
//     XFile pickedFile = await _imagePicker.pickVideo(
//       source: ImageSource.gallery,
//     );
//     File _fileToTrim = File(pickedFile.path);
//     setState(() {
//       _file = File(_fileToTrim.path);
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
//           _returnedFile = File(_trimmedPath);
//         });
//       }
//     }
//
//
//   }
//




}

class ChatButtons extends StatelessWidget {
  final IconData icon;
  final Function onPress;
  ChatButtons({this.icon,this.onPress});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPress,
      color: Colors.white,
      icon: Icon(
        icon,
        size: 25,
        color: Colors.black.withOpacity(0.6),
      ),
    );
  }
}




void getMessages () async {
  final messages = await _fireStore.collection("messages").get();
  for(var msg in messages.docs){
  }
}

void getStreamMessage () async {
  await for (var msg in _fireStore.collection("messages").snapshots()){
    for(var m in msg.docs){
    }
  }
}








