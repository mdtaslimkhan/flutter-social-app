import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/util/constants.dart';
import 'package:flutter/material.dart';

class NoNotification extends StatelessWidget {

  final UserModel user;
  NoNotification({this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Notification list empty",style: fldarkgrey18,),
                SizedBox(height: 5),
                Text("You don't have any notification yet.", style: TextStyle(
                ),
                  textAlign: TextAlign.center,
                ),
                Image.asset("assets/icon/no_notification.jpg", width: 300,),


              ],
            )
        )
    );
  }
}
