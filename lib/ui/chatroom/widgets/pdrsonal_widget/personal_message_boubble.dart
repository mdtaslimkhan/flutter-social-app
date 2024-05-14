
import 'dart:io';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/chatroom/model/message_model_personal.dart';
import 'package:chat_app/ui/chatroom/widgets/loader_bubble.dart';
import 'package:chat_app/ui/chatroom/widgets/pdrsonal_widget/audio_player_chat_personal.dart';
import 'package:chat_app/ui/chatroom/widgets/pdrsonal_widget/chat_file_widget_personal.dart';
import 'package:chat_app/ui/chatroom/widgets/pdrsonal_widget/chat_image_widget_personal.dart';
import 'package:chat_app/ui/chatroom/widgets/pdrsonal_widget/chat_link_personal.dart';
import 'package:chat_app/ui/chatroom/widgets/pdrsonal_widget/chat_notify_widget_personal.dart';
import 'package:chat_app/ui/chatroom/widgets/pdrsonal_widget/chat_text_widget_personal.dart';
import 'package:chat_app/ui/chatroom/widgets/pdrsonal_widget/chat_videoplayer_personal.dart';
import 'package:chat_app/ui/chatroom/widgets/pdrsonal_widget/reply_widget_personal.dart';
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
final _fireStore = FirebaseFirestore.instance;


class MessageBubble extends StatefulWidget {
  final MessageModelPersonal msg;
  final String docId;
  final String text;
  final UserModel to;
  final String myPhoto;
  final bool isMe;
  final String photo;
  final String time;
  final UserModel loggedUser;
  final String id;
  final bool seen;
  final scrollTo;
  final onPressedReply;

  MessageBubble({
    this.msg,
    this.docId,
    this.text,
    this.to,
    this.myPhoto,
    this.isMe,
    this.photo,
    this.time,
    this.loggedUser,
    this.id,
    this.seen = false,
    this.scrollTo,
    this.onPressedReply,
  });

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {

  CustomPopupMenuController _controller = CustomPopupMenuController();
  String _rootDir;
  PackageInfo _packageInfo;

  @override
  void initState() {
    initMethod();
    super.initState();
  }


  initMethod(){
    getApplicationDocumentsDirectory().then((tmpDir) => {
      _rootDir = tmpDir.path,
    });
    getPackageInfo();
  }
  getPackageInfo(){
    PackageInfo.fromPlatform().then((value) => setState((){_packageInfo = value;}));
  }

  @override
  void dispose() {
    // streamSubscription.cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return CustomPopupMenu(
        child: Container(
          child: widget.msg.type == "text" ?
          ChatTextWidget(isMe: widget.isMe, docId: widget.docId, loggedUser: widget.loggedUser, msg: widget.msg,) :
          widget.msg.type == "notify" ?
          ChatNotificationPersonal( loggedUser: widget.loggedUser, msg: widget.msg) :
          widget.msg.type == "image" ?
          ChatImageWidgetPersonal(isMe: widget.isMe, docId: widget.docId, loggedUser: widget.loggedUser, msg: widget.msg) :
          widget.msg.type == "audio" ?
          PlayAudioPersonal(docId: widget.docId, isMe: widget.isMe, msg: widget.msg) :
          widget.msg.type == "loader" ?
          LoaderBubble(isMe: widget.isMe, docId: widget.docId,) :
          widget.msg.type == "video" ?
          ChatVideoPlayerPersonal(isMe: widget.isMe,docId: widget.docId, loggedUser: widget.loggedUser, msg: widget.msg,) :
          widget.msg.type == "link" ?
          ChatLinkPersonal(isMe: widget.isMe,msg: widget.msg) :
          widget.msg.type == "reply" ?
          ReplyWidgetPersonal(msg: widget.msg, scrollTo: widget.scrollTo,isMe: widget.isMe, loggedUser: widget.loggedUser) :
          ChatFileWidgetPersonal(isMe: widget.isMe,docId: widget.docId, loggedUser: widget.loggedUser, msg: widget.msg),
        ),
        menuBuilder: widget.msg.type == "text" || widget.msg.type == "link"? _buildLongPressMenu : _buildLongPressMenuFile,
        barrierColor: Colors.transparent,
        pressType: PressType.longPress,
        controller: _controller,
        arrowColor: Color(0xFFF5F5F5),
        //  position: PreferredPosition.bottom,
        arrowSize: 15,
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
            .collection("messages")
            .doc(widget.loggedUser.id.toString())
            .collection(widget.to.toString())
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
