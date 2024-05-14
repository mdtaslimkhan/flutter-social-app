

import 'package:flutter/material.dart';

class VoiceRoomImageHolder extends StatelessWidget {

  final Color color;
  final String image;
  final double height;
  final double width;
  VoiceRoomImageHolder({this.color,this.image, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
