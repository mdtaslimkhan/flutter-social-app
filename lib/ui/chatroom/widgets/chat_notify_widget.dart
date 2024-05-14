
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/chatroom/model/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/profile.dart';
final _fireStore = FirebaseFirestore.instance;

class ChatNotificationWidget extends StatelessWidget {

  final UserModel loggedUser;
  final MessageModel msg;
  ChatNotificationWidget({
    this.loggedUser,
    this.msg
  });


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          margin: EdgeInsets.only(top: 10,bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Row(
            children: [
              GestureDetector(
                child: Container(
                  width: 100,
                  child: Text(' ${msg.senderName}',style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(userId: msg.senderId,currentUser: loggedUser,)));
                },
              ),
              Text(' ${msg.text}',
                style: TextStyle(
                    fontSize: 10
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

}
