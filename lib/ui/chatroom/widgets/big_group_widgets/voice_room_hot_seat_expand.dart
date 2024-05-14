import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/chatroom/function/voice_room_methods.dart';
import 'package:chat_app/ui/chatroom/utils/host_seat_user.dart';
import 'package:chat_app/ui/chatroom/utils/hot_user.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:chat_app/util/constants.dart';
import 'package:flutter/material.dart';

final VoiceRoomMethods roomMethods = VoiceRoomMethods();


class VoiceRoomHotSeatExpand extends StatelessWidget {

  final String fromId;
  final bool isHost;
  final GroupModel toGroup;
  final UserModel from;
  final ValueSetter<int> usersTapToJoineIntoSpecificHotSeat;
  VoiceRoomHotSeatExpand({ this.toGroup, this.fromId, this.isHost, this.from, this.usersTapToJoineIntoSpecificHotSeat});

  @override
  Widget build(BuildContext context) {
    return
      Positioned(
        top: 0,
        bottom: 10,
        right: 0,
        left: 0,
        child: Stack(
          children: [

            Positioned(
              left: MediaQuery.of(context).size.width / 2 - 135,
              top: 65,
              child: Container(
                child: Container(
                  width: 280,
                  height: 150,
                  margin: EdgeInsets.only(top: 0),
                  child: giftReactCachedNetworkImage(context,
                      "$APP_ASSETS_URL/big_group/table3.png"),
                ),
              ),
            ),

            // top middle host
            HotSeatUserHost(
              group: toGroup,
              collection: "hostId",
              position: 0, top: 0,
              left: MediaQuery.of(context).size.width / 2 - 45,
              fromId: fromId,
              seatPosition: 1,
              isHost: isHost,
            ),
            // top right

            HotSeatUser(
              onPressed: () {
                if(!isHost) {
                  usersTapToJoineIntoSpecificHotSeat(2);
                }
              },
              group: toGroup, collection: "hotSeat",
              position: 0, top: 5, left: MediaQuery.of(context).size.width / 4 * 2.9 - 40,
              fromId: fromId,
              seatPosition: 2,
              isHost: isHost,
            ),

            // top left
            HotSeatUser(
              onPressed: () {
                if(!isHost) {
                  usersTapToJoineIntoSpecificHotSeat(3);
                }
              },
              group: toGroup, collection: "hotSeat",
              position: 1, top: 5, left: MediaQuery.of(context).size.width / 4 * 1.1- 50,
              fromId: fromId,
              seatPosition: 3,
              isHost: isHost,
            ),
            // right middle
            HotSeatUser(
              onPressed: () {
                if(!isHost) {
                  usersTapToJoineIntoSpecificHotSeat(4);
                }
              },
              group: toGroup, collection: "hotSeat",
              position: 2, top: 70,
              left: MediaQuery.of(context).size.width / 7 * 6 - 35,
              fromId: fromId,
              seatPosition: 4,
              isHost: isHost,
            ),

            // left middle
            HotSeatUser(
              onPressed: () {
                if(!isHost) {
                  usersTapToJoineIntoSpecificHotSeat(5);
                }
              },
              group: toGroup, collection: "hotSeat", position: 7,
              top: 70,
              left: MediaQuery.of(context).size.width / 7 * 1 - 55,
              fromId: fromId,
              seatPosition: 5,
              isHost: isHost,
            ),
            // right bottom
            HotSeatUser(
              onPressed: () {
                if(!isHost) {
                  usersTapToJoineIntoSpecificHotSeat(6);
                }
              },
              group: toGroup, collection: "hotSeat",
              position: 3, top: 150,
              left: MediaQuery.of(context).size.width / 7 * 6 - 40,
              fromId: fromId,
              seatPosition: 6,
              isHost: isHost,
            ),
            // bottom right
            HotSeatUser(
              onPressed: () {
                if(!isHost) {
                  usersTapToJoineIntoSpecificHotSeat(7);
                }
              },
              group: toGroup, collection: "hotSeat",
              position: 4, top: 150,
              left: MediaQuery.of(context).size.width / 7 * 4.4 - 40,
              fromId: fromId,
              seatPosition: 7,
              isHost: isHost,
            ),
            // bottom left
            HotSeatUser(
              onPressed: () {
                if(!isHost) {
                  usersTapToJoineIntoSpecificHotSeat(8);
                }
              },
              group: toGroup, collection: "hotSeat",
              position: 5, top: 150,
              left: MediaQuery.of(context).size.width / 7 * 2.7 - 40,
              fromId: fromId,
              seatPosition: 8,
              isHost: isHost,

            ),
            // left bottom
            HotSeatUser(
              onPressed: () {
                if(!isHost) {
                  usersTapToJoineIntoSpecificHotSeat(9);
                }
              },
              group: toGroup, collection: "hotSeat",
              position: 6, top: 150,
              left: MediaQuery.of(context).size.width / 7 * 1 - 40,
              fromId: fromId,
              seatPosition: 9,
              isHost: isHost,
            ),



          ],
        ),
      );
  }

}


