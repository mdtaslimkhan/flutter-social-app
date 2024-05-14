
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/chatroom/model/message_model.dart';
import 'package:chat_app/ui/chatroom/widgets/name_admin_owner.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:chat_app/ui/pages/feed/widgets/single_post_image_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
final _fireStore = FirebaseFirestore.instance;

class ChatImageWidget extends StatelessWidget {

  final bool isMe;
  final String docId;
  final UserModel loggedUser;
  final MessageModel msg;
   ChatImageWidget({
    this.isMe,this.docId,
    this.loggedUser,
     this.msg,
    Key key
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return !isMe ? Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              userImage(context),
              SizedBox(width: 5,),
              Container(
                width: MediaQuery.of(context).size.width * .5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    userName(msg.senderName),
                    adminCheckStream(msg.role),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 5,),
          imageWidget(context, msg.msgTime, isMe),
        ],
      ),
    ) : Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          imageWidget(context, msg.msgTime, isMe),
        ],
      ),
    );
  }


  Widget imageWidget(BuildContext context, String time, bool isMe){
    return  GestureDetector(
      child: Stack(
        children: [
          Hero(
            tag: "img_${msg.url}",
            child: Material(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
                topLeft: Radius.circular(isMe ? 15 : 0),
                topRight: Radius.circular(isMe ? 0 : 15),
              ),
              elevation: 1,
              child: Container(
                margin: EdgeInsets.all(1),
                width: MediaQuery.of(context).size.width * .65,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                    topLeft: Radius.circular(isMe ? 15 : 0),
                    topRight: Radius.circular(isMe ? 0 : 15),
                  ),
                  child: cachedNetworkImg(context, msg.url),
                ), // cachedNetworkImg(context, photo),
              ),
            ),
          ),
          Positioned(
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 15,
                          offset: Offset(-3, 0),
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 1),
                    ],
                  ),
                  padding: EdgeInsets.all(5),
                  child: Text(time, style: TextStyle(
                    fontSize: 10,
                    fontFamily: "Segoe",
                    color: Colors.white,
                    fontWeight: FontWeight.w600
                  ))
              ),
              right: 3,
              bottom: 3,
          ),
        ],
      ),
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Singleimagepage(
                photo: msg.url,
              ))),
    );
  }

 Widget userImage(BuildContext context) {
    return Container(
      height: 33,
      width: 33,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              blurRadius: 9,
              offset: Offset(0, 0),
              color: Colors.black45.withOpacity(0.2),
              spreadRadius: 1),
        ],
        border: Border.all(width: 1, color: Colors.white),
      ),
      child: msg.uPhoto != null ? cachedNetworkImageCircular(context, msg.uPhoto) : Container(),

    );
  }

}

