

import 'package:flutter/material.dart';

class AudioIndicationBiggroup extends StatelessWidget {

  final Color nColor;
  final String photo;
  AudioIndicationBiggroup({this.nColor, this.photo});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15,
      width: 15,
      decoration: BoxDecoration(
        color: nColor,
        image: DecorationImage(
          image: AssetImage(photo),
          fit: BoxFit.contain,
        ),
        borderRadius: BorderRadius.all(new Radius.circular(8.0)),
        border: Border.all(
          color: Color(0xfffbfa8b),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
    );
  }
}
