import 'package:flutter/material.dart';
class VoiceRoomProfileInfoButton extends StatelessWidget {
  final Color startColor;
  final Color endColor;
  final String text;
  final Function onPressed;
  VoiceRoomProfileInfoButton({this.startColor, this.endColor, this.text, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 110,
        height: 35,
        padding: EdgeInsets.fromLTRB(0,0,0,0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(48),
          border: Border.all(
            color: Colors.white,
            width: 1.0,
          ),
          gradient: LinearGradient(
              colors: [
                startColor,
                endColor
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Icon(Icons.spa_sharp,size: 10,color: Colors.green,),
            SizedBox(width: 5,),
            Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFFffffff),
                fontFamily: "Roboto",
                fontWeight: FontWeight.w100,
              ),
              ),
          ],
        ),
    ));
  }
}
