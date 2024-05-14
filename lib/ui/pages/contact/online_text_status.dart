import 'package:chat_app/ui/chatroom/chatmethods/chatmethods_personal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class OnlineTextStatus extends StatelessWidget {

  final String uid;
  final ChatMethodsPersonal _chatMethodsPersonal = ChatMethodsPersonal();
  OnlineTextStatus({this.uid});

  @override
  Widget build(BuildContext context) {

    getColor(int state){
      if(state == 1){
        return Text('Online',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 14,
              color: Colors.blueAccent,
            fontWeight: FontWeight.bold
          ),
        );
      }else if(state == 0){
        return Text('Offline',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 14,
              color: Colors.red,
              fontWeight: FontWeight.bold
          ),
        );
      }
      return Text('Away',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 14,
            color: Colors.amber,
            fontWeight: FontWeight.bold
        ),
      );
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
            return Row(
              children: [
                getColor(uState),
              ],
            );
        }
    );
  }
}
