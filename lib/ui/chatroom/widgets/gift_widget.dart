
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/chatroom/model/gift.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:flutter/material.dart';

class GiftWidget extends StatelessWidget {
  final UserModel user;
  final GroupModel group;
  final Gift gift;
  final String type;
  final Function onPressed;
  final bool chattroom;
  GiftWidget({
    this.user,
    this.group,
    this.gift,
    this.type,
    this.onPressed,
    this.chattroom,
  });


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(0),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              child: cachedNetworkImgCrown(context, gift.img),
            ),
            Text(gift.title != null ? gift.title : "Gift",
            style: TextStyle(
              fontSize: 10,
              color: chattroom ? Colors.white : Color(0xFFD5D2D2),
            ),
            overflow: TextOverflow.ellipsis,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon(FontAwesome5.gem,
                //   size: 8,
                //     color: chattroom ? Colors.white : Colors.black
                // ),
                Container(
                    width: 15,
                    child: Image.asset('assets/gift/dimond_blue.png')
                ),
                SizedBox(width: 4,),
                Text(gift.diamond != null ? gift.diamond : "0",
                  style: TextStyle(
                      fontSize: 12,
                      color: chattroom ? Colors.white : Color(0xFFD5D2D2),
                  ),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
