import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/chatroom/model/message_model.dart';
import 'package:chat_app/ui/chatroom/model/message_model_personal.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/profile.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/sliver_profile.dart';
import 'package:flutter/material.dart';

Widget userImage(BuildContext context, MessageModelPersonal msg, UserModel loggedUser) {
  return GestureDetector(
    onTap: () {
     // Navigator.push(context, MaterialPageRoute(builder: (context) => PersonalProfileSliver(userId: msg.receiverId, currentUser: loggedUser,)));
      Navigator.of(context).pushNamed('/viewProfile', arguments: {
        'userId' : msg.receiverId, 'currentUser' : loggedUser
      });

    },
    child: Container(
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
        border: Border.all(width: 1.5, color: Colors.white),
      ),
      child: cachedNetworkImageCircular(context, msg.uPhoto),
    ),
  );
}