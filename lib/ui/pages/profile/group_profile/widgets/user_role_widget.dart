import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:flutter/material.dart';


Widget getBadge({int role, String userId, GroupModel group}){
  return role == 1 ? Container(
    decoration: BoxDecoration(
      color: Color(0xffee7e00),
      borderRadius: BorderRadius.circular(2),
      boxShadow: [
        BoxShadow(
            blurRadius: 0,
            offset: Offset(1, 1),
            color: Colors.black45.withOpacity(0.1),
            spreadRadius: 0),
      ],
    ),
    padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 3),
    child: Text('Owner',
        style: TextStyle(
            fontSize: 8,
            fontFamily: "Roboto",
            fontWeight: FontWeight.w800,
            color: group.admin.toString() == userId  ? Colors.white : Colors.white
        )),
  ) : role == 2 ? Container(
    decoration: BoxDecoration(
      color: Color(0xff598cf3),
      borderRadius: BorderRadius.circular(2),
      boxShadow: [
        BoxShadow(
            blurRadius: 0,
            offset: Offset(1, 1),
            color: Colors.black45.withOpacity(0.1),
            spreadRadius: 0),
      ],
    ),
    padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 2),
    child: Text("Admin",
      style: TextStyle(
          fontSize: 8,
          fontFamily: "Roboto",
          fontWeight: FontWeight.w800,
          color: group.admin.toString() == userId  ? Colors.white : Colors.white
      ),
    ),
  ) : Container();
}