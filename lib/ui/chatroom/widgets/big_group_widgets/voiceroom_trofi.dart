import 'package:chat_app/ui/chatroom/function/voice_room_methods.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:chat_app/ui/pages/explore/widgets/item_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../all_time_big_group_gift_status_list.dart';
import '../../big_group_gift_status_list.dart';

class VoiceRoomTrofi extends StatelessWidget {

final String toGroupId;
final GroupModel toGroup;
  VoiceRoomTrofi({this.toGroupId, this.toGroup});


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
            item.add(ItemProvider(left: ln == 1 ? 50 : ln == 2 ? 40 : ln == 3 ? 30 : 10 , top: 5 ,photo: dt['photo'], imageType: 2,));
          }).toList();

          return GestureDetector(
            onTap: (){
              _userGiftListStatusBottomSheet(context, toGroup);
            },
            child: Container(
              height: 28,
              width: 80,
              decoration: BoxDecoration(
                color: Color(0xfff5e1b8).withOpacity(0.8),
                borderRadius: BorderRadius.all(new Radius.circular(15.0)),

              ),
              child: Stack(
                children: item,
                // children: [
                //   Positioned(
                //     left: 10,
                //     top: 4,
                //     child: Image.asset("assets/gift/winner.png",width: 20,),
                //
                //   ),
                //
                //
                //   Positioned(
                //     right: 15,
                //     top: 6,
                //     child: Container(
                //       width: 15,
                //       height: 15,
                //       child: qds.length > 2 && dt3['photo'] != null ? CircleAvatar(
                //           backgroundImage: NetworkImage(
                //               dt3['photo'])) : Container(),
                //     ),
                //   ),
                //   Positioned(
                //     right: 27,
                //     top: 6,
                //     child: Container(
                //       width: 15,
                //       height: 15,
                //       child:  qds.length > 1 && dt2['photo'] != null ? CircleAvatar(
                //           backgroundImage: NetworkImage(
                //               dt2['photo'])) : Container(),
                //     ),
                //   ),
                //   Positioned(
                //     right: 38,
                //     top: 6,
                //     child: Container(
                //       width: 15,
                //       height: 15,
                //       child:  qds.length > 0 && dt['photo'] != null ? CircleAvatar(
                //           backgroundImage: NetworkImage(
                //               dt['photo'])) : Container(),
                //     ),
                //   ),
                // ],
              ),
            ),
          );
        }
    );
  }


  _userGiftListStatusBottomSheet(BuildContext context, GroupModel toGroup){
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      context: context,
      builder: (BuildContext bc) {
        return Container(
            child: DefaultTabController(
              length: 2,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  toolbarHeight: 40,
                  backgroundColor: Color(0xEB000000),
                  automaticallyImplyLeading: false,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  title: TabBar(
                    tabs: [
                      Tab(text: "Running room",),
                      Tab(text: "All times",),
                    ],
                  ),

                ),
                body: TabBarView(
                  children: [
                    BigGroupGiftStatusList(toGroup: toGroup,),
                    AllTimeBigGroupGiftStatusList(toGroup: toGroup,),
                  ],
                ),
              ),
            )
        );
      },

    );
  }
}
