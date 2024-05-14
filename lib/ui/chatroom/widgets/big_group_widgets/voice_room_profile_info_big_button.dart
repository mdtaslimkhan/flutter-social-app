import 'package:chat_app/model/user_model.dart';
import 'package:flutter/material.dart';

class VoiceRoomProfileInfoBigButton extends StatelessWidget {

  final UserModel user;
  final Color color;
  VoiceRoomProfileInfoBigButton({this.user, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      padding: EdgeInsets.fromLTRB(5,0,5,0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
              blurRadius: 0,
              offset: Offset(1, 1),
              color: Colors.black45.withOpacity(0.3),
              spreadRadius: 1),
        ],
       
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/room_profile/all_about.png"),
                    SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "All About CR",
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w400
                          ),
                        ),
                        Text(
                          "Administrator of group",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w300
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                IconButton(
                  icon: Icon(Icons.arrow_forward_ios_rounded, color: Colors.white,),
                  onPressed: (){

                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
