
import 'package:chat_app/model/quotes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class Localfunction {


  // badges earned
  static List<Quotes> badgeEarned = [
    Quotes(1, 'Gifts' , 'Hello, Assalamualikum, Kemon asen?'),
    Quotes(2, 'Visitors' , 'Hello, Assalamualikum, Kemon asen?'),
    Quotes(3, 'Groups' , 'Hello, Assalamualikum, Kemon asen?'),
  ];

  static Widget badgeEarnedTemplate(data){
    return Image.asset(
      'assets/profile/crown/crown${data.id}.png',
      height: 15,
      width: 15,
    );
  }






 static CircleAvatar userPhoto(String photo){
    return  CircleAvatar(
      backgroundImage: photo != null ? NetworkImage(photo) : Image.asset('assets/u3.gif'),
    );
  }











}


