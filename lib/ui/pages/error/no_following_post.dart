import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/util/constants.dart';
import 'package:flutter/material.dart';

class NoFollowingFound extends StatelessWidget {

  final UserModel user;
  NoFollowingFound({this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("No following post found",style: fldarkgrey18,),
                SizedBox(height: 5),
                Text("No following post found yet to follow user \n click below button", style: TextStyle(
                ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                Image.asset("assets/icon/following.png", width: 250,),
                SizedBox(height: 20),
                MaterialButton(
                    onPressed: (){
                    },
                  child: Text("Follow now", style: TextStyle(
                    color: Colors.white,
                  ),),
                  color: Colors.blue,
                ),
              ],
            )
        )
    );
  }
}
