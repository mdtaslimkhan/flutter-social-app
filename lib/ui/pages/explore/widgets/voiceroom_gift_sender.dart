import 'package:chat_app/ui/chatroom/function/voice_room_methods.dart';
import 'package:chat_app/ui/pages/explore/widgets/item_provider.dart';
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VoiceRoomGiftSender extends StatelessWidget {

final String toGroupId;
VoiceRoomGiftSender({this.toGroupId});
  final VoiceRoomMethods roomMethods = VoiceRoomMethods();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: roomMethods.topGiftSender(
            giftSentCollection: "userGiftSent",
            groupId: toGroupId
        ),
        builder:(context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          var qds = snapshot.data.docs;
          List<ItemProvider> item = [];
          item.add(ItemProvider(left: 10, top: 4,photo: "assets/gift/winner.png", imageType: 1,));
          qds.map((e) {
            var dt = e.data() as Map;
            int ln = e.id.length;
            item.add(ItemProvider(left: ln == 1 ? 27 : ln == 2 ? 37 : ln == 3 ? 47 : 10 , top: 5 ,photo: dt['photo'], imageType: 2,));
          }).toList();
              return Container(
                height: 25,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.all(new Radius.circular(15.0)),
                ),
                child: Stack(
                  children: item,
                ),
              );
        }
    );
  }


}



