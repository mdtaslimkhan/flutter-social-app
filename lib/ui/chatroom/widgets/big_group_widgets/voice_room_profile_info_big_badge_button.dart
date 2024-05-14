import 'package:chat_app/model/quotes.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/pages/feed/widgets/postmaterial.dart';
import 'package:flutter/material.dart';

class VoiceRoomProfileInfoBigBadgeButton extends StatelessWidget {

  final UserModel user;
  final Color color;
  final Function onPressed;
  final String text;
  VoiceRoomProfileInfoBigBadgeButton({this.user, this.color, this.onPressed, this.text});


  // badges earned
  List<Quotes> badgeEarned = [
    Quotes(0, 'Gifts' , 'Hello, Assalamualikum, Kemon asen?'),
    Quotes(1, 'Visitors' , 'Hello, Assalamualikum, Kemon asen?'),
    Quotes(2, 'Groups' , 'Hello, Assalamualikum, Kemon asen?'),
  ];


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 60,
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black87,
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w900
                        ),
                      ),
                      Text(
                        "(1 / 26)",
                        style: TextStyle(
                          fontSize: 15,
                            color: Colors.black87,
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w300
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios_rounded, color: Colors.black87,),
                        onPressed: (){

                        },
                      ),
                    ],
                  ),



                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
