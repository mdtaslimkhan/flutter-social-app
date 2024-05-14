import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/chatroom/widgets/big_group_widgets/room_minimized/hot_seat_user_host_minimized.dart';
import 'package:chat_app/ui/chatroom/widgets/big_group_widgets/room_minimized/hot_seat_user_minimized.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:flutter/material.dart';


class VoiceRoomMinimized extends StatelessWidget {

  final String fromId;
  final bool isHost;
  final GroupModel toGroup;
  final UserModel from;
  final ValueSetter<int> usersTapToJoineIntoSpecificHotSeat;
  VoiceRoomMinimized({ this.toGroup, this.fromId, this.isHost, this.from, this.usersTapToJoineIntoSpecificHotSeat});


  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        // top middle host
        HotSeatUserHostMinimized(
          group: toGroup, collection: "hostId",
          position: 0,
          fromId: fromId,
          seatPosition: 1,
          isHost: isHost,
        ),
        // top right

        HotSeatUserMinimized(
          onPressed: () {
            if(!isHost) {
              usersTapToJoineIntoSpecificHotSeat(2);
            }
          },
          group: toGroup, collection: "hotSeat",
          position: 0,
          fromId: fromId,
          seatPosition: 2,
          isHost: isHost,
        ),

        // top left
        HotSeatUserMinimized(
          onPressed: () {
            if(!isHost) {
              usersTapToJoineIntoSpecificHotSeat(3);
            }
          },
          group: toGroup, collection: "hotSeat",
          position: 1,
          fromId: fromId,
          seatPosition: 3,
          isHost: isHost,
        ),
        // right middle
        HotSeatUserMinimized(
          onPressed: () {
            if(!isHost) {
              usersTapToJoineIntoSpecificHotSeat(4);
            }
          },
          group: toGroup, collection: "hotSeat",
          position: 2,
          fromId: fromId,
          seatPosition: 4,
          isHost: isHost,
        ),

        // left middle
        HotSeatUserMinimized(
          onPressed: () {
            if(!isHost) {
              usersTapToJoineIntoSpecificHotSeat(5);
            }
          },
          group: toGroup, collection: "hotSeat", position: 7,
          fromId: fromId,
          seatPosition: 5,
          isHost: isHost,
        ),
        // right bottom
        HotSeatUserMinimized(
          onPressed: () {
            if(!isHost) {
              usersTapToJoineIntoSpecificHotSeat(6);
            }
          },
          group: toGroup, collection: "hotSeat",
          position: 3,
          fromId: fromId,
          seatPosition: 6,
          isHost: isHost,
        ),
        // bottom right
        HotSeatUserMinimized(
          onPressed: () {
            if(!isHost) {
              usersTapToJoineIntoSpecificHotSeat(7);
            }
          },
          group: toGroup, collection: "hotSeat",
          position: 4,
          fromId: fromId,
          seatPosition: 7,
          isHost: isHost,
        ),
        // bottom left
        HotSeatUserMinimized(
          onPressed: () {
            if(!isHost) {
              usersTapToJoineIntoSpecificHotSeat(8);
            }
          },
          group: toGroup, collection: "hotSeat",
          position: 5,
          fromId: fromId,
          seatPosition: 8,
          isHost: isHost,

        ),
        // left bottom
        HotSeatUserMinimized(
          onPressed: () {
            if(!isHost) {
              usersTapToJoineIntoSpecificHotSeat(9);
            }
          },
          group: toGroup, collection: "hotSeat",
          position: 6,
          fromId: fromId,
          seatPosition: 9,
          isHost: isHost,
        ),



      ],
    );
  }
}
