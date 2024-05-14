import 'package:flutter/material.dart';


Widget userName(String sender) {
  return Text(
    '$sender',
    style: TextStyle(
        color: Colors.white,
        fontSize: 10,
        fontFamily: "SegoSemiBold"),
  );
}


Widget adminCheckStream(String role){
  return !['',null,'null'].contains(role) ? Container(
    margin: EdgeInsets.only(left: 5, right: 5),
    padding: EdgeInsets.only(top: 0, bottom: 2,left: 3, right: 3),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      color: role == "Owner" ? Colors.orange : Colors.green,
    ),
    child: Text("$role",
      style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.bold,
          color: Colors.white
      ),
    ),
  ) : Container();

}
