import 'package:chat_app/ui/chatroom/chatroom_big_group.dart';
import 'package:chat_app/ui/chatroom/function/voice_room_methods.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:chat_app/ui/pages/explore/widgets/item_provider.dart';
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../all_time_big_group_gift_status_list.dart';
import '../../big_group_gift_status_list.dart';

class VoiceRoomLastGift extends StatelessWidget {

final String toGroupId;
final GroupModel toGroup;
VoiceRoomLastGift({this.toGroupId, this.toGroup});


  final VoiceRoomMethods roomMethods = VoiceRoomMethods();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: roomMethods.lastGiftSender(
            giftSentCollection: "userGiftSentAll",
            groupId: toGroupId
        ),
        builder:(context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          var dt;
          var qds = snapshot.data.docs;
          qds.map((e) {
            var ds = e.data() as Map;
            dt = ds;
          }).toList();


          return GestureDetector(
            onTap: (){
            },
            child: Container(
              height: 28,
              width: 100,
              decoration: BoxDecoration(
                color: Color(0xff241724).withOpacity(0.8),
                borderRadius: BorderRadius.all(new Radius.circular(15.0)),
              ),
              child: Stack(
                children: [

                  Positioned(
                    left: 10,
                    top: 6,
                    child: Container(
                      width: 15,
                      height: 15,
                      child:  qds.length > 0 && dt['photo'] != null ? CircleAvatar(
                          backgroundImage: NetworkImage(
                              dt['photo'])) : Container(),
                    ),
                  ),
                  Positioned(
                    left: 55,
                    top: 7,
                    child: Container(
                      height: 15,
                      child: Text('x'+' ${ qds.length > 0 ? dt['diamond']['diamond'] : "0"}', style: ftwhite12,),
                    ),
                  ),
                  Positioned(
                    left: 35,
                    top: 6,
                    child: Container(
                      width: 15,
                      height: 15,
                      child: Image.asset("assets/gift/dimond_blue.png",width: 10,),
                    ),
                  ),

                ],
              ),
            ),
          );
        }
    );
  }



}
