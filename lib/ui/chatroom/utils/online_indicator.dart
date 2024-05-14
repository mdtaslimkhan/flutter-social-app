import 'package:chat_app/enum/user_state.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/chatroom/chatmethods/chatmethods_personal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class OnlineIndicator extends StatelessWidget {

  final String uid;
  final String photo;
  final UserModel from;
  OnlineIndicator({this.uid, this.photo, this.from});

  final ChatMethodsPersonal _chatMethodsPersonal = ChatMethodsPersonal();

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
                      width: 2,
                      color: getColor(uState),
                    ),
                  ),
                  child: photo != null ? cachedNetworkImageCircular(context, photo) : Icon(Icons.ac_unit),
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
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _chatMethodsPersonal.getUnreadMessage(toUid: uid, fromUid: from.id.toString()),
                      builder: (context, snapshot){

                        var count = 0;
                        if(snapshot.hasData && snapshot.data.docs != null){
                          count = snapshot.data.docs.length;
                        }

                          return Container(
                            child: Text('$count',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 7,
                                  color: Colors.white
                              ),
                            ),
                          );
                      },
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
