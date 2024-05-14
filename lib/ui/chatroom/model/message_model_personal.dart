
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MessageModelPersonal {
  String text;
  String senderName;
  String uPhoto;
  String receiverId;
  String type;
  String url;
  String msgTime;
  String role;
  String fileName;
  String source;
  String replyId;
  String reply;
  String replyName;
  String replyPhoto;
  bool seen;
  MessageModelPersonal({
    this.uPhoto,
    this.fileName,
    this.role,
    this.url,
    this.receiverId,
    this.text,
    this.msgTime,
    this.type,
    this.replyId,
    this.reply,
    this.senderName,
    this.source,
    this.replyName,
    this.replyPhoto,
    this.seen,
  });

  Map<String,dynamic> toMessage(MessageModelPersonal msg){
    Map<String,dynamic> msgMap = Map();
    msgMap['text'] = msg.text;
    msgMap['name'] = msg.senderName;
    msgMap['photo'] = msg.uPhoto;
    msgMap['receiverId'] = msg.receiverId;
    msgMap['type'] = msg.type;
    msgMap['photoUrl'] = msg.url;
    msgMap['timestamp'] = msg.msgTime;
    msgMap['role'] = msg.role;
    msgMap['fileName'] = msg.fileName;
    msgMap['source'] = msg.source;
    msgMap['replyId'] = msg.replyId;
    msgMap['reply'] = msg.reply;
    msgMap['replyName'] = msg.replyName;
    msgMap['replyPhoto'] = msg.replyPhoto;
    msgMap['seen'] = msg.seen;
  }

  MessageModelPersonal.fromMap(Map msgMap){
    this.text = checkNull(msgMap['text']);
    this.senderName = checkNull(msgMap['name']);
    this.uPhoto = checkNull(msgMap['photo']);
    this.receiverId = checkNull(msgMap['receiverId']);
    this.type = checkNull(msgMap['type']);
    this.url = checkNull(msgMap['photoUrl']);
    this.msgTime = customFormat(msgMap['timestamp']);
    this.role = checkNull(msgMap['role']);
    this.fileName = getFileName(msgMap['photoUrl']);
    this.source = checkNull(msgMap['source']);
    this.replyId = checkNull(msgMap['replyId']);
    this.reply = checkNull(msgMap['reply']);
    this.replyName = checkNull(msgMap['replyName']);
    this.replyPhoto = checkNull(msgMap['replyPhoto']);
    this.seen = checkNullBool(msgMap['seen']);
  }


  String getFileName(String url){
    if(url != null)
    return url.split('/').last;
    return '';
  }

}