import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/model/crown_model.dart';
import 'package:flutter/material.dart';

Widget topCrownTemplate({BuildContext context, Crown crown}){
  return  Container(
    height: 70,
    child: cachedNetworkImgCrown(context, crown.img),
  );
}



Widget ratingStar(str){
  return Icon(
    Icons.star,
    size: 25,
    color: Color(0xfffde83e),
  );
}



Widget weekCount(str){
  return Icon(
    Icons.check_circle,
    size: 20,
    color: Color(0xff6be32e),
  );
}




Widget badgeEarnedTemplate(data){
  return Image.asset(
    'assets/profile/crown/${data.id}.png',
    height: 18,
    width: 18,
  );
}
