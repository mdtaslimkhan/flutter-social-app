import 'package:flutter/material.dart';


class ChatButtons extends StatelessWidget {
  final IconData icon;
  final Function onPress;

  ChatButtons({this.icon, this.onPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(
        padding: EdgeInsets.all(3),
        onPressed: onPress,
        color: Colors.white,
        icon: Icon(
          icon,
          size: 18,
          color: Colors.black.withOpacity(0.8),
        ),
      ),
    );
  }
}