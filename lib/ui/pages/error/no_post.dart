import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/util/constants.dart';
import 'package:flutter/material.dart';

class NoPostFound extends StatelessWidget {

  final UserModel user;
  NoPostFound({this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("No post found",style: fldarkgrey18,),
                SizedBox(height: 5),
                Text("No post found yet to create post \n click below button", style: TextStyle(
                ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                Image.asset("assets/icon/no_post.png", width: 250,),
                SizedBox(height: 20),
                MaterialButton(
                    onPressed: (){
                    //  Navigator.push(context, MaterialPageRoute(builder: (context) => Userlist(user: user)));
                    },
                  child: Text("Create post", style: TextStyle(
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
