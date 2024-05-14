import 'dart:convert';
import 'dart:io';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/call/group_call_util/group_callUtil.dart';
import 'package:chat_app/ui/call/permissionhandler.dart';
import 'package:chat_app/ui/chatroom/big_group_widget/getUserInfo.dart';
import 'package:chat_app/ui/chatroom/fileupload/fileuploadmulti.dart';
import 'package:chat_app/ui/chatroom/fileupload/imageupload.dart';
import 'package:chat_app/ui/chatroom/provider/big_group_provider.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:chat_app/ui/pages/feed/widgets/single_post_image_page.dart';
import 'package:chat_app/ui/pages/profile/group_profile/group_profile.dart';
import 'package:chat_app/ui/pages/widgets/progress.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../provider/file_upload_provider.dart';
import 'chatmethods/chatmethods_big_group.dart';


final _fireStore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;



class ChatRoomGroup extends StatefulWidget {

  final ImageUploadFunction _imageUploadFunction = ImageUploadFunction();
  final UserModel from;
  final GroupModel toGroup;
  ChatRoomGroup({this.from, this.toGroup});

  final FileUploadMethods _fileUploadMethods = FileUploadMethods();



  @override
  _ChatRoomGroupState createState() => _ChatRoomGroupState();
}

class _ChatRoomGroupState extends State<ChatRoomGroup> {

  final msgTextEditingController = TextEditingController();
  final ChatMethodsBigGroup _chatMethodsBigGroup = ChatMethodsBigGroup();

  FocusNode focusNode = FocusNode();

  bool showSpinner = false;
  String msgText;
  User loggedInUser;
  bool isWriting = false;
  File file;
  bool isUploading = false;

  bool emojiPicker = false;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser () {
    try{
      final crntUser = _auth.currentUser;
      if(crntUser != null){
        loggedInUser = crntUser;
      }
    }catch (e) {
      print(e);
    }
  }

  showKeyboard() => focusNode.requestFocus();
  hideKeyboard() => focusNode.unfocus();

  hideImojiPicker() {
    setState(() {
      emojiPicker = false;
    });
  }

  showEmojiPicker() {
    setState(() {
      emojiPicker = true;
    });
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
    BigGroupProvider _bgp = Provider.of<BigGroupProvider>(context);
    FileUploadProvider _fp = Provider.of<FileUploadProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child:Container(
            margin: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
            width: 30.0,
            height: 30.0,
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              image: DecorationImage(
                image: NetworkImage(widget.toGroup.photo),
                fit: BoxFit.cover,
              ),
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

          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => GroupProfile(user: widget.from,groupInfo: widget.toGroup)));
          },
        ),
        title: Text('${widget.toGroup.name}'),
        actions: [
          IconButton(
              icon: Icon(Icons.call),
              onPressed: () async => await PermissionHandlerUser().onJoin() ?
              CallUtilsGroup.mdialGroup(
                  from: widget.from,
                  to: widget.toGroup,
                  context: context,
                  type: 1,
              ) : {},
          ),
          IconButton(
            icon: Icon(Icons.video_call),
            onPressed: () async => await PermissionHandlerUser().onJoin() ?
            CallUtilsGroup.mdialGroup(
                from: widget.from,
                to: widget.toGroup,
                context: context,
                type: 2
            ) : {},
          ),
        ],
      ),
      body: Container(
        color: Color(0xffeaebf3),
        child: Column(
          children: [
            MessageStream(from: widget.from, to: widget.toGroup),
            Container(
              child: Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            child: Row(
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
                                    onTap: () {
                                      hideImojiPicker();
                                    },
                                  ),
                                ),
                                ChatButtons(
                                  icon: Icons.face,
                                  onPress: () {
                                    if(!emojiPicker){
                                        hideKeyboard();
                                        showEmojiPicker();
                                    }else{
                                      showKeyboard();
                                      hideImojiPicker();
                                    }
                                  },
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
                                _chatMethodsBigGroup.sendBigGroupMessage(
                                  msgText: msgTextEditingController.text,
                                  fromUserId: widget.from.id.toString(),
                                  name: widget.from.nName,
                                  photo: widget.from.photo,
                                  groupId: widget.toGroup.id.toString(),
                                  role: _bgp.role,
                                );
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

                        ) : Material(
                         color: Colors.blue,
                         elevation: 5,
                         borderRadius:BorderRadius.all(Radius.circular(40)),
                         child: MaterialButton(
                           onPressed: () async {

                           },
                           textColor: Colors.white,
                           child: Icon(
                             Icons.mic,
                             size: 15,
                           ),
                           minWidth: 30,
                           height: 30,
                         ),

                       ),
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
                          },
                        ),
                        ChatButtons(
                          icon:Icons.location_on,
                          onPress: () {
                          },
                        ),
                        ChatButtons(
                          icon: Icons.perm_media,
                          onPress: () {
                          //  handleChoseFromGallery();
                            widget._fileUploadMethods.pickFile(
                              source: ImageSource.gallery,
                              receiverId: widget.from.id.toString(),
                              senderId: widget.toGroup.id.toString(),
                              name: widget.from.nName,
                              userPhoto: widget.from.photo,
                              chatType: USER_BIG_GROUP,
                              fp: _fp,
                              fileType: 1,
                              role: _bgp.role,
                            );
                          },
                        ),
                        ChatButtons(
                          icon: Icons.camera_alt,
                          onPress: () {
                          //  handleTakePhoto();
                            widget._fileUploadMethods.pickFile(
                              source: ImageSource.gallery,
                              receiverId: widget.from.id.toString(),
                              senderId: widget.toGroup.id.toString(),
                              name: widget.from.nName,
                              userPhoto: widget.from.photo,
                              chatType: USER_BIG_GROUP,
                              fp: _fp,
                              fileType: 2,
                              role: _bgp.role,
                            );
                          },
                        ),
                        ChatButtons(
                          icon: Icons.star_border,
                          onPress: () {
                          },
                        ),
                        ChatButtons(
                          icon: Icons.gif,
                          onPress: () {
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
    );
  }


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





class MessageStream extends StatelessWidget {

  final UserModel from;
  final GroupModel to;
  MessageStream({this.from, this.to});

  @override
  Widget build(BuildContext context) {
    return  Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: _fireStore.collection(GROUP_MESSAGE_COLLECTION)
            .doc(to.id.toString())
            .collection("messages")
            .orderBy("timestamp",descending: true)
            .snapshots(),
        builder: (context, snapshot){

          if(!snapshot.hasData){
            circularProgress();
          }

          if(snapshot.hasData) {
            final List<MessageBubbleMiniGroup> messagesData = [];
            final messages = snapshot.data.docs;

            for (var message in messages) {
              var dt = message.data() as Map;
              final msgText = dt['text'];
              final senderName = dt['name'];
              final msgSender = dt['receiverId'];
              final msgType = dt['type'];
              final msgPhoto = dt['photoUrl'];
              final msgTime = dt['timestamp'].toDate();

              final allText = MessageBubbleMiniGroup(
                text: msgText,
                sender: senderName,
                isMe: from.id.toString() == msgSender,
                type: msgType,
                photo: msgPhoto,
                senderId: msgSender,
                time: msgTime
              );
              messagesData.add(allText);
            }
            return ListView(
              reverse: true,
              children: messagesData,
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
            );
          }

          return circularProgress();


        },
      ),
    );
  }
}




class MessageBubbleMiniGroup extends StatelessWidget {
  final String text;
  final String sender;
  final bool isMe;
  final String type;
  final String photo;
  final String senderId;
  final DateTime time;

  MessageBubbleMiniGroup({this.text, this.sender,this.isMe,this.type,this.photo,this.senderId,this.time});

  @override
  Widget build(BuildContext context) {
    return type != "image" ? Padding(
      padding: EdgeInsets.all(2.0),
      child: Row(
        children: [
         isMe ? Text("") : UserImageById(userId: senderId,),
          SizedBox(width: 5,),
          Expanded(
            child: Column(
              crossAxisAlignment: !isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                isMe ? Text("Me") : Text('$sender',style: TextStyle(
                    fontSize: 10,
                    color: Colors.black54
                ),),
                Material(
                  color: isMe ? Colors.white : Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: isMe ? Radius.circular(10) : Radius.circular(0),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      topRight: !isMe ? Radius.circular(10) : Radius.circular(0)
                  ),
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [

                        SizedBox(height: 4,),
                        Text('$text',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: "SegoSemiBold"
                          ),
                        ),
                        SizedBox(height: 4,),
                        Text(
                          "${timeago.format(time)}",
                          style: fldarkgrey10,
                        ),
                        SizedBox(height: 4,),
                        //  Container(
                        //   padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                        //   decoration: BoxDecoration(
                        //     color: Color(0xfff3cc03),
                        //     borderRadius: BorderRadius.all(Radius.circular(5)),
                        //   ),
                        //   child: Text(
                        //     "${timeago.format(time)}",
                        //     style: ftwhite10,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    ) : Column(
      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8,),
        isMe ? Text("Me") : Text('$sender',style: TextStyle(
            fontSize: 12,
            color: Colors.black54
        ),),
        GestureDetector(
          child: Material(
            borderRadius: BorderRadius.only(
                topLeft: isMe ? Radius.circular(3) : Radius.circular(0),
                bottomLeft: Radius.circular(3),
                bottomRight: Radius.circular(3),
                topRight: !isMe ? Radius.circular(3) : Radius.circular(0)
            ),
            elevation: 5,
            child: Container(
              margin: EdgeInsets.all(3),
              width: 100,
                child: cachedNetworkImg(context, photo),
            ),
          ),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Singleimagepage(photo: photo,))),
        ),
        SizedBox(height: 4,),
        Text("${timeago.format(time)}"),

      ],
    );
  }
}


