import 'package:chat_app/enum/user_state.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/chatroom/chatmethods/chatmethods_personal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class PersonalProfileImage extends StatelessWidget {

  final String uid;
  final String photo;
  final UserModel from;

  PersonalProfileImage({this.uid, this.photo, this.from});

  final ChatMethodsPersonal _chatMethodsPersonal = ChatMethodsPersonal();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      width: 52,
      child: Stack(
        children: [
          Positioned(
            left: 0,
             top: 0,
            child: Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 2,
                  color: Colors.red,
                ),
              ),
              child: photo != null
                  ? cachedNetworkImageCircular(context, photo)
                  : Icon(Icons.ac_unit),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: StreamBuilder(
                stream: _chatMethodsPersonal.getUserOnlineState(userId: uid),
                builder: (context, AsyncSnapshot event) {
                  var uState = 0;
                  if(!event.hasData){
                    return Container();
                  }
                  Map<dynamic, dynamic> dts = event.data.snapshot.value;
                  if(dts != null) {
                    uState = dts['userState'];
                  }
                  return Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 2,
                      color: uState == 0 ? Colors.red : Colors.blue,
                    ),
                  ),
                );
              }
            ),
          ),


        ],
      ),
    );
  }

}