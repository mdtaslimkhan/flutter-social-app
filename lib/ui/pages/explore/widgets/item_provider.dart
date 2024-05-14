import 'package:flutter/material.dart';

class ItemProvider extends StatelessWidget {
  String photo;
  double left;
  double top;
  int imageType;
  ItemProvider({this.photo, this.left, this.top, this.imageType});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: imageType == 1 ? Image.asset(photo,width: 18,) : Container(
        width: 15,
        height: 15,
        child: photo != null ? CircleAvatar(
            backgroundImage: NetworkImage(
                photo)) : Container(),
      ),
    );
  }
}