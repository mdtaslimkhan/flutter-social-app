import 'package:chat_app/ui/chatroom/function/voice_room_methods.dart';
import 'package:chat_app/ui/chatroom/utils/bottom_waiting_list.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



class VoiceRoomWaitingHolder extends StatelessWidget {

final String toGroupId;
final GroupModel toGroup;
VoiceRoomWaitingHolder({this.toGroupId, this.toGroup});


  final VoiceRoomMethods roomMethods = VoiceRoomMethods();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: roomMethods.getWaitingUser(
            giftSentCollection: "waitingList",
            groupId: toGroupId
        ),
        builder:(context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          var qds = snapshot.data.docs;
          List<WaitingUserImage> item = [];
          item.add(WaitingUserImage(left: 5, top: 7,photo: "assets/gift/winner.png", imageType: 1, count: qds.length, widgetType: 1,));
          qds.map((e) {
            var dt = e.data() as Map;
            int ln = e.id.length;
            item.add(WaitingUserImage(left: ln == 1 ? 71 : ln == 2 ? 65 : ln == 3 ? 55 : 10 , top: 6 ,photo: dt['photo'], imageType: 2,));
          }).toList();

          item.add(WaitingUserImage(left: 5, top: 7,photo: "assets/gift/winner.png", imageType: 1, count: qds.length, widgetType: 2,));

          return GestureDetector(
            onTap: (){
              _waitingListUserList(context);
            },
            child: Container(
              height: 28,
              width: 110,
              decoration: BoxDecoration(
                color: Colors.black87.withOpacity(0.4),
                borderRadius: BorderRadius.all(new Radius.circular(15.0)),

              ),
              child: Stack(
                children: item,
                // children: [
                //   Positioned(
                //     left: 5,
                //     top: 7,
                //     child: Text("Waiting",style: ftwhite12,),
                //   ),
                //
                //   Positioned(
                //     left: 55,
                //     top: 6,
                //     child: Container(
                //       width: 15,
                //       height: 15,
                //       child:  qds.length > 0 && dt['photo'] != null ? CircleAvatar(
                //           backgroundImage: NetworkImage(
                //               dt['photo'])) : Container(),
                //     ),
                //   ),
                //   Positioned(
                //     left: 65,
                //     top: 6,
                //     child: Container(
                //       width: 15,
                //       height: 15,
                //       child:  qds.length > 1 && dt2['photo'] != null ? CircleAvatar(
                //           backgroundImage: NetworkImage(
                //               dt2['photo'])) : Container(),
                //     ),
                //   ),
                //
                //   Positioned(
                //     left: 75,
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
                //     right: 0,
                //     top: 2,
                //     child: Container(
                //       width: 22,
                //       height: 22,
                //       margin: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
                //       decoration: BoxDecoration(
                //         color: Colors.black12,
                //         borderRadius: BorderRadius.all(Radius.circular(18)),
                //       ),
                //       child: Center(child: Text('${qds.length > 99 ? "99+" : "${qds.length}"}',style: ftwhite12,))
                //
                //
                //     ),
                //
                //   ),
                //
                // ],
              ),
            ),
          );
        }
    );
  }


void _waitingListUserList(BuildContext context){
  showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15.0))),
      backgroundColor: Colors.black87,
      builder: (BuildContext bc){
        return StatefulBuilder(
            builder: (BuildContext bc, StateSetter setState) {
              return BottomWaitingList(group: toGroup);
            }
        );
      }
  );
}







}

class WaitingUserImage extends StatelessWidget {
  int count;
  String photo;
  double left;
  double top;
  int imageType;
  int widgetType;
  WaitingUserImage({this.count, this.photo, this.left, this.top, this.imageType, this.widgetType});
  @override
  Widget build(BuildContext context) {
    return widgetType == 1 ? Positioned(
      left: left,
      top: top,
      child: imageType == 1 ? Text("Waiting",style: ftwhite12,) : Container(
        width: 15,
        height: 15,
        child: photo != null ? CircleAvatar(
            backgroundImage: NetworkImage(
                photo)) : Container(),
      ),
    ) : Positioned(
      right: 0,
      top: 2,
      child: Container(
          width: 22,
          height: 22,
          margin: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.all(Radius.circular(18)),
          ),
          child: Center(child: Text('${count > 99 ? "99+" : "$count"}',style: ftwhite12,))


      ),

    );
  }
}
