import 'package:chat_app/tools/cached_network_image.dart';
import 'package:flutter/material.dart';


 class UserImageByPhotoUrl extends StatelessWidget {
   final String photo;
   UserImageByPhotoUrl({this.photo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left:0),
      width: 30.0,
      height: 30.0,

      child: cachedNetworkImageCircular(context, photo),
    );
  }

}

class UserImageByPhotoUrlTyping extends StatelessWidget {
  final String photo;
  UserImageByPhotoUrlTyping({this.photo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5),
      width: 20.0,
      height: 20.0,

      child: cachedNetworkImageCircular(context, photo),
    );
  }

}


