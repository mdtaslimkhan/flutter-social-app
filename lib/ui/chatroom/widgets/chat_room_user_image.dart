import 'package:chat_app/tools/cached_network_image.dart';
import 'package:flutter/material.dart';


Widget chatRoomUserImage(BuildContext context, String image){
  return Container(
    height: 33,
    width: 33,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      boxShadow: [
        BoxShadow(
            blurRadius: 9,
            offset: Offset(0, 0),
            color: Colors.black45.withOpacity(0.2),
            spreadRadius: 1),
      ],
      border: Border.all(width: 1, color: Colors.white),
    ),
    child: cachedNetworkImageCircular(context, image),
  );
}