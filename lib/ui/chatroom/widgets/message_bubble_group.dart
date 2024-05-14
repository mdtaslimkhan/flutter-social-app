import 'dart:io';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/chatroom/bottomModal/user_profile_details.dart';
import 'package:chat_app/ui/chatroom/model/message_model.dart';
import 'package:chat_app/ui/chatroom/widgets/audio_player_chat.dart';
import 'package:chat_app/ui/chatroom/widgets/chat_link.dart';
import 'package:chat_app/ui/chatroom/widgets/chat_videoplayer.dart';
import 'package:chat_app/ui/chatroom/widgets/loader_bubble.dart';
import 'package:chat_app/ui/chatroom/widgets/reply_widget.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'chat_file_widget.dart';
import 'chat_image_widget.dart';
import 'chat_notify_widget.dart';
import 'chat_text_widget.dart';


final _fireStore = FirebaseFirestore.instance;


class MessageBubbleGroup extends StatefulWidget {
  final String docId;
  final bool isMe;
  final UserModel loggedUser;
  final String isAdmin;
  final GroupModel group;
  final onPressedReply;
  final MessageModel msg;
  final scrollTo;

  MessageBubbleGroup({this.docId,
    this.isMe,
    this.msg,
    this.loggedUser, this.isAdmin,this.group,
    this.onPressedReply,
    this.scrollTo,
    Key key}) : super(key: key);
  @override
  State<MessageBubbleGroup> createState() => _MessageBubbleGroupState();
}

class _MessageBubbleGroupState extends State<MessageBubbleGroup> {
  CustomPopupMenuController _controller = CustomPopupMenuController();
  String _rootDir;
  PackageInfo _packageInfo;

  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((tmpDir) => {
      _rootDir = tmpDir.path,
    });
    getPackageInfo();
  }
  getPackageInfo(){
    PackageInfo.fromPlatform().then((value) => setState((){_packageInfo = value;}));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: CustomPopupMenu(
        verticalMargin: widget.msg.type == "image" ? -40 : -15,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 1, horizontal: 0),
          padding: EdgeInsets.all(0),
         // constraints: BoxConstraints(maxWidth: 240, minHeight: avatarSize),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: widget.msg.type == "text" ?
          ChatTextWidget(isMe: widget.isMe, docId: widget.docId, loggedUser: widget.loggedUser, msg: widget.msg) :
          widget.msg.type == "notify" ?
          ChatNotificationWidget( loggedUser: widget.loggedUser, msg: widget.msg) :
          widget.msg.type == "image" ?
          ChatImageWidget(isMe: widget.isMe, docId: widget.docId, loggedUser: widget.loggedUser, msg: widget.msg) :
          widget.msg.type == "audio" ?
          PlayAudio(docId: widget.docId, groupId: widget.group.id.toString(), isMe: widget.isMe, msg: widget.msg) :
          widget.msg.type == "loader" ?
          LoaderBubble(isMe: widget.isMe, docId: widget.docId,) :
          widget.msg.type == "video" ?
          ChatVideoPlayer(isMe: widget.isMe,docId: widget.docId, loggedUser: widget.loggedUser, group: widget.group, groupId: widget.group.id.toString(), msg: widget.msg,) :
          widget.msg.type == "link" ?
          ChatLink(isMe: widget.isMe,msg: widget.msg) :
          widget.msg.type == "reply" ?
          ReplyWidget(msg: widget.msg, scrollTo: widget.scrollTo,isMe: widget.isMe, loggedUser: widget.loggedUser) :
          ChatFileWidget(isMe: widget.isMe,docId: widget.docId, loggedUser: widget.loggedUser, group: widget.group,msg: widget.msg)
        ),
        menuBuilder: widget.msg.type == "text" || widget.msg.type == "link"? _buildLongPressMenu : _buildLongPressMenuFile,
        barrierColor: Colors.transparent,
        pressType: PressType.longPress,
        controller: _controller,
       arrowColor: Color(0xFFF5F5F5),
      //  position: PreferredPosition.bottom,
        arrowSize: 15,
      ),
    );



  }

  List<ItemModel> menuItems = [
    ItemModel('1','Copy', Icons.content_copy),
    ItemModel('2','Delete', Icons.delete),
    ItemModel('3','Reply', Icons.reply),
    ItemModel('4','Share', Icons.share),
  ];

  Widget _buildLongPressMenu() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 120,
        color: const Color(0xFFF5F5F5),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: menuItems
              .map((item) =>
                 GestureDetector(
                   behavior: HitTestBehavior.translucent,
                   onTap: (){
                     _controller.hideMenu();
                     linkAction(item);
                   },
                child: Container(
                  margin: EdgeInsets.only(left: 8, bottom: 8, top: 8, right: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        item.icon,
                        size: 22,
                        color: Colors.black87,
                      ),
                      SizedBox(width: 5,),
                      Container(
                        margin: EdgeInsets.only(top: 2),
                        child: Text(
                          item.title,
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Segoe"
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )).toList(),
        ),
      ),
    );
  }

  List<ItemModel> menuItemsFile = [
    ItemModel('1','Download', Icons.content_copy),
    ItemModel('2','Delete', Icons.delete),
    ItemModel('3','Reply', Icons.reply),
    ItemModel('4','Share', Icons.share),
  ];
  Widget _buildLongPressMenuFile() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 120,
        color: const Color(0xFFF5F5F5),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: menuItemsFile
              .map((item) =>
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: (){
                  _controller.hideMenu();
                  linkAction(item);
                },
                child: Container(
                  margin: EdgeInsets.only(left: 8, bottom: 8, top: 8, right: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        item.icon,
                        size: 22,
                        color: Colors.black87,
                      ),
                      SizedBox(width: 5,),
                      Container(
                        margin: EdgeInsets.only(top: 2),
                        child: Text(
                          item.title,
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Segoe"
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )).toList(),
        ),
      ),
    );
  }

  void linkAction(item) {
    if(widget.msg.type == "text") {
      onMenuItemClickAction(widget.msg.text, item.id, widget.docId,1);
    }else if(widget.msg.type == "image"){
      onMenuItemClickAction(widget.msg.fileName, item.id, widget.docId,2);
    }
    else if(widget.msg.type == "file"){
      onMenuItemClickAction(widget.msg.fileName, item.id, widget.docId,3);
    }
    else if(widget.msg.type == "audio"){
      onMenuItemClickAction(widget.msg.fileName, item.id, widget.docId,4);
    }
    else if(widget.msg.type == "video"){
      onMenuItemClickAction(widget.msg.fileName, item.id, widget.docId,5);
    }else if(widget.msg.type == "link"){
      onMenuItemClickAction(widget.msg.text, item.id, widget.docId,6);
    }else if(widget.msg.type == "loader"){
      onMenuItemClickAction(widget.msg.text, item.id, widget.docId,7);
    }else if(widget.msg.type == "reply"){
      onMenuItemClickAction(widget.msg.text, item.id, widget.docId,8);
    }
  }

  void onMenuItemClickAction(val,type,docId,dataType) async {
      switch(type){
        case '1':
          if(dataType == 1) {
            Clipboard.setData(
                ClipboardData(text: val));
          }else if(dataType == 4){
            downloadFilePermanently(_rootDir+ "/audio/" + val,"CR/Audio/",val);
          }else if(dataType == 5){
            downloadFilePermanently(_rootDir+ "/video/" + val, "CR/Video/",val);
          }

          break;
        case '2':
          DocumentReference r = _fireStore
              .collection("bigGroupMessage")
              .doc(widget.group.id.toString())
              .collection("messages")
              .doc(docId);
          r.delete();
          if(dataType == 4) {
            deleteMediaFile("/audio/" + val);
          }else if(dataType == 5){
            deleteMediaFile("/video/" + val);
          }
          break;
        case '3':
           return widget.onPressedReply(val,widget.msg.uPhoto,widget.msg.senderName,docId, widget.msg.url);
          break;
        case '4' :
          return _shareText(val,dataType);

          break;
        default:
          break;
      }

  }

  void _shareText(String val, int dataType) async{

    Directory directory;
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    } else {
      directory = await getApplicationDocumentsDirectory();
    }
    var _filePath = '';
    if(dataType == 1){
      await FlutterShare.share(
          title: '$val',
          text: '$val',
          linkUrl: 'https://play.google.com/store/apps/details?id=${_packageInfo.packageName}',
          chooserTitle: 'Share'
      );
    }else if(dataType == 4){
      final fName = widget.msg.fileName;
      _filePath = directory.path + "/audio/" + fName;
      print('fired ');
      print(_filePath);
      await FlutterShare.shareFile(
          filePath: _filePath,
          title: fName,
          text: fName,
      );
    }else if(dataType == 5){
      final fName = widget.msg.fileName;
      _filePath = directory.path + "/video/" + fName;
      await FlutterShare.shareFile(
          filePath: _filePath,
          title: fName,
          text: fName,
      );
    }else if(dataType == 2){
      final url = Uri.parse(widget.msg.url);
      final response = await http.get(url);
      final bytes = response.bodyBytes;
      final fileName = widget.msg.fileName;
      await Directory(_rootDir+"/images").create(recursive: true);
      String path = _rootDir +"/images/" + fileName;
      File(path).writeAsBytesSync(bytes);
      _filePath = directory.path + "/images/" + fileName;
      print("file paht $_filePath");
      await FlutterShare.shareFile(
        filePath: _filePath,
        title: fileName,
        text: fileName,
      );
    }else if(dataType == 3){
      final fName = widget.msg.fileName;
      _filePath = directory.path + "/files/" + fName;
      print('fired ');
      print(_filePath);
      await FlutterShare.shareFile(
        filePath: _filePath,
        title: fName,
        text: fName,
      );
    }else if(dataType == 6){
      print('link share ${widget.msg.text}');
      print(val);
      await FlutterShare.share(
          title: '${widget.msg.text}',
          text: '${widget.msg.text}',
          linkUrl: '${widget.msg.text}',
          chooserTitle: 'Share'
      );
    }

  }

  // deleting local media file
  deleteMediaFile(String fileName){
    if(fileName != null) {
      File file = File(_rootDir + fileName);
      if(file.existsSync()){
        file.delete();
      }
    }
  }
}


class ItemModel {
  String id;
  String title;
  IconData icon;

  ItemModel(this.id, this.title, this.icon);
}

