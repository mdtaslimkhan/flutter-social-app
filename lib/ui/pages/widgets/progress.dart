import 'package:flutter/material.dart';


Container circularProgress(){
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 10),
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
    ),
  );
}

 Container linearProgressBar(){
   return Container(
     padding: EdgeInsets.only(bottom: 5),
     child: LinearProgressIndicator(
       valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
     ),
   );
}
Container circularProgressCupertino(){
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 10),
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
    ),
  );
}