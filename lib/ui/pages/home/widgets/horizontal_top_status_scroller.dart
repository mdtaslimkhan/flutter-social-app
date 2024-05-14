

import 'package:flutter/material.dart';

Widget topsecondhorizontalscrollertemplate(topsecondscroller){
  return  Container(
    width: 50.0,
    margin: EdgeInsets.fromLTRB(15.0, 0, 0, .0),
    decoration: BoxDecoration(
      color: Colors.transparent,
      image: DecorationImage(
        image: AssetImage('assets/b${topsecondscroller.id}.gif'),
        fit: BoxFit.contain,
      ),
    ),
  );
}