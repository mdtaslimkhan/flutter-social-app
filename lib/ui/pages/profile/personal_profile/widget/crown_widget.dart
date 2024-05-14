

import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/model/crown_model.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/widget/honor_veiw.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/widget/honor_video_veiw.dart';
import 'package:flutter/material.dart';

class CrownWidget extends StatelessWidget {
  final Crown crown;
  final String type;
  CrownWidget({
    this.crown,
    this.type
  });


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(type == "badge") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HonorVideoView(crown: crown)));
        }else{
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HonorView(crown: crown)));
        }
      },
      child: Container(
        width: 40,
        child: giftReactCachedNetworkImage(context, crown.img),
      ),
    );
  }
}
