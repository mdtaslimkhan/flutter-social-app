import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/chatroom/function/voice_room_methods.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';



class OnlineIndicatorBigGroup extends StatelessWidget {

  final String uid;
  final String photo;
  final String contactId;
  OnlineIndicatorBigGroup({this.uid, this.photo,this.contactId});

  final VoiceRoomMethods roomMethods = VoiceRoomMethods();

  @override
  Widget build(BuildContext context) {

    getColor(int state){
      if(state !=null && state > 0){
        return Colors.blueAccent;
      }
      return Colors.red;
    }

    return StreamBuilder(
      stream: roomMethods.getActiveUsersMethod(groupId: contactId),
        builder: (context, snapshot) {
        var uState = 0;
            if(snapshot.hasData){
              if(snapshot.data.snapshot.value != null) {
                final dts = Map<String, dynamic>.from((snapshot.data).snapshot.value);
                dts.forEach((key, value) {
                  final nextItems = Map<String, dynamic>.from(value);
                });
                uState = dts.length;
              }

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
                  child: photo != null ? cachedNetworkImageCircular(context, photo) : Icon(Icons.supervised_user_circle_outlined),
                ),
                Positioned(
                  child: Container(
                    height: 18,
                    width: 18,
                    decoration: BoxDecoration(
                        color: getColor(uState),
                        border: Border.all(width: 1.2,color: Colors.white),
                        shape: BoxShape.circle
                    ),
                    child: Center(
                      child: Text('$uState',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 8,
                            color: Colors.white
                        ),
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
