
import 'package:chat_app/ui/chatroom/function/voice_room_methods.dart';
import 'package:chat_app/ui/chatroom/model/contact.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoadingImage extends StatelessWidget {
  final inAsyncCall;
  final Widget child;
  LoadingImage({this.inAsyncCall, this.child});

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: inAsyncCall,
      color: Color(0xFF0D0D10),
      opacity: 0.7,
      progressIndicator: Center(
          child: Container(
            child: Image.asset(
              'assets/icon/loading.gif',
              height: 125.0,
              width: 125.0,
            ),
          )
      ),
      child: child,
    );
  }
}

final VoiceRoomMethods roomMethods = VoiceRoomMethods();

class ColorPickerWiget extends StatelessWidget {
  final ContactHome contact;
  final Widget body;
  ColorPickerWiget({this.contact,this.body});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: roomMethods.getBackgroundColors(groupId: contact.uid),
        builder: (context, AsyncSnapshot event) {
          if (!event.hasData) {
            return Scaffold(
              backgroundColor: Colors.grey,
              body: body,
            );
          }
          Map<dynamic, dynamic> dt = event.data.snapshot.value;
          if (dt != null) {
            print("selected color");
            print(dt["color"]);
            if(dt["color"] != null) {
              int value = int.parse(dt["color"], radix: 16);
              Color otherColor = new Color(value);
              return Scaffold(
                backgroundColor: otherColor ,
                body: body,
              );
            }
          }
          return Scaffold(
            backgroundColor: Colors.grey,
            body: body,
          );
        });
  }
}

