import 'package:chat_app/enum/user_state.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/chatroom/chatmethods/chatmethods_personal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class OnlineStatus extends StatelessWidget {

  final String uid;
  final ChatMethodsPersonal _chatMethodsPersonal = ChatMethodsPersonal();
  final String photo;
  OnlineStatus({this.uid, this.photo});

  @override
  Widget build(BuildContext context) {

    getColor(int state){
      switch(ChatMethodsPersonal.numToState(state)){
        case UserState.Offline:
          return Colors.red;
        case UserState.Online:
          return Colors.blueAccent;
        case UserState.Waiting:
          return Colors.amber;
      }
    }


    return StreamBuilder(
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
            return Stack(
              children: [
                Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 0,
                      color: getColor(uState),
                    ),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 5,
                          offset: Offset(0, 0),
                          color: Colors.black45.withOpacity(0.3),
                          spreadRadius: 1),
                    ],
                  ),
                  child: cachedNetworkImageCircular(context, photo),
                ),
                Positioned(
                  child: Container(
                    height: 14,
                    width: 14,
                    decoration: BoxDecoration(
                        color: getColor(uState),
                        border: Border.all(width: 1.2,color: Colors.white),
                        shape: BoxShape.circle
                    ),
                    child: Text('',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 7,
                          color: Colors.white
                      ),
                    ),
                  ),
                  right: 1,
                  bottom: 1,
                ),
              ],
            );
        }
    );
  }
}
