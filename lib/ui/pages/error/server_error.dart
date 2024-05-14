import 'package:chat_app/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ServerError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Server error ",style: fldarkgrey18,),
                SizedBox(height: 5),
                Text("Please contact with the Circle of rectitude", style: TextStyle(
                  
                ),),
                Image.asset("assets/icon/404.jpg", width: 300,),
                SizedBox(height: 55,),
              ],
            )
        )
    );
  }
}
