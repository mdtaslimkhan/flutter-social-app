import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/chatroom/big_group_widget/getUserImageByUrl.dart';
import 'package:chat_app/ui/chatroom/model/message_model_personal.dart';
import 'package:chat_app/ui/chatroom/widgets/pdrsonal_widget/user_image_widget_personal.dart';
import 'package:chat_app/util/constants.dart';
import 'package:flutter/material.dart';

class ReplyWidgetPersonal extends StatelessWidget {


  final String photo;
  final MessageModelPersonal msg;
  final scrollTo;
  final bool isMe;
  final UserModel loggedUser;
  ReplyWidgetPersonal({this.isMe, this.photo, this.msg,this.scrollTo, this.loggedUser});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => scrollTo(),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(!isMe)
          userImage(context, msg, loggedUser),
          Container(
            width: MediaQuery.of(context).size.width * .65,
            margin: EdgeInsets.symmetric(horizontal: 5),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Color(0xff4c4c4c),
              borderRadius: BorderRadius.only(
                topLeft: isMe ? const Radius.circular(10.0) : const Radius.circular(0.0),
                topRight: isMe ? const Radius.circular(0.0) : const Radius.circular(10.0),
                bottomLeft: const Radius.circular(10.0),
                bottomRight: const Radius.circular(10.0),
              ),// BorderRadius
            ),//
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 55,
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Color(0xff393939),
                    borderRadius: BorderRadius.only(
                      topLeft: isMe ? const Radius.circular(10.0) : const Radius.circular(0.0),
                      topRight: isMe ? const Radius.circular(0.0) : const Radius.circular(10.0),
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
                          msg.replyPhoto != null ? UserImageByPhotoUrlTyping(
                            photo: msg.replyPhoto,
                          ) : Container(),
                          SizedBox(width: 5,),
                          Container(
                            width: 100,
                            child: Text('${msg.replyName}' , style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w800,
                                fontFamily: "Segoe",
                                fontSize: 12
                            ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Text('${letterLimit(msg.reply)}' , style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontFamily: "Segoe",
                          fontSize: 10
                      ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 5),
                  child: Text('${msg.text}', style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontFamily: "Segoe",
                      fontSize: 10
                  ),),
                ),
                Row(
                  mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Text('${msg.msgTime}' , style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontFamily: "Segoe",
                        fontSize: 10
                    ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if(isMe)
          userImage(context, msg, loggedUser),
        ],
      ),
    );
  }
}
