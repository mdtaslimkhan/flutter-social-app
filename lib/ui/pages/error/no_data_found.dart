import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/util/constants.dart';
import 'package:flutter/material.dart';

class NoDataFound extends StatelessWidget {

  final UserModel user;
  NoDataFound({this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("No data found",style: fldarkgrey18,),
                SizedBox(height: 5),
                Text("Please wait, we are working on \n  marketplace for better experience", style: TextStyle(
                ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                Image.asset("assets/icon/following.jpg", width: 250,),
                SizedBox(height: 20),
                Text("Upcoming features",style: fldarkgrey18,),

              ],
            )
        )
    );
  }
}
