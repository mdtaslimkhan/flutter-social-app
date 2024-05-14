import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/chatroom/model/message_model_personal.dart';
import 'package:chat_app/ui/chatroom/widgets/name_admin_owner.dart';
import 'package:chat_app/ui/chatroom/widgets/pdrsonal_widget/user_image_widget_personal.dart';
import 'package:flutter/material.dart';

class ChatTextWidget extends StatelessWidget {

  final bool isMe;
  final String docId;
  final UserModel loggedUser;
  final MessageModelPersonal msg;
  ChatTextWidget({
    this.isMe,this.docId,
    this.loggedUser,
    this.msg
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 0, bottom: 0),
      child: !isMe ? Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            userImage(context, msg, loggedUser),
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * .65,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        userName(msg.senderName),
                      adminCheckStream(msg.role),
                      ],
                    ),
                  ),
                 textBouble(context, isMe),
                ],
              ),
            ),
          ],
        ) : Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              textBouble(context, isMe),
            ],
          ),
        ),
      );
  }

  Widget textBouble(BuildContext context, bool isMe) {
    return  Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      width: MediaQuery.of(context).size.width * .65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
          topLeft: Radius.circular(isMe ? 15 : 0),
          topRight: Radius.circular(isMe ? 0 : 15),
        ),
        color: isMe ? Color(0xFF3B3C49) : Color(0xFFDCDCDC) ,
        border: Border.all(width: 1, color: isMe ? Color(0xFF3B3C49) : Color(
            0xFFDCDCDC) ),
      ),
      child: Text('${msg.text}   ${msg.msgTime}',
          style: TextStyle(
              color: isMe ? Colors.white : Colors.black87,
              fontFamily: "Roboto",
              fontSize: 12,
              fontWeight: FontWeight.w600
          )),

    );
  }


}
