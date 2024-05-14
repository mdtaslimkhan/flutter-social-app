import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/util/constants.dart';
import 'package:flutter/material.dart';

class NoGroupFound extends StatelessWidget {

  final UserModel user;
  NoGroupFound({this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("No group found",style: fldarkgrey18,),
                SizedBox(height: 5),
                Text("No group found yet to create group \n click below button", style: TextStyle(
                ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                Image.asset("assets/icon/group.jpg", width: 250,),
                SizedBox(height: 20),
                MaterialButton(
                    onPressed: (){
                    //  Navigator.push(context, MaterialPageRoute(builder: (context) => Userlist(user: user)));
                    },
                  child: Text("Create group", style: TextStyle(
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
