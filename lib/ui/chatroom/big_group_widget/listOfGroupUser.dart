
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:chat_app/ui/pages/profile/group_profile/widgets/user_role_widget.dart';
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



class GroupUserListItem extends StatelessWidget {
  final String name;
  final String userId;
  final String userPhoto;
  final UserModel user;
  final GroupModel group;
  final Timestamp time;
  final int role;
  final bool mute;
  GroupUserListItem({this.name,this.userId,this.userPhoto,this.user,this.group, this.time, this.role, this.mute});

  final _fireStore = FirebaseFirestore.instance;


  Widget getMuteStatus(bool isMuted){
    return isMuted ? Container(
      decoration: BoxDecoration(
        color: Color(0xffee0000),
        borderRadius: BorderRadius.circular(2),
        boxShadow: [
          BoxShadow(
              blurRadius: 0,
              offset: Offset(1, 1),
              color: Colors.black45.withOpacity(0.1),
              spreadRadius: 0),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 3),
      child: Text('Muted',
          style: TextStyle(
              fontSize: 8,
              fontFamily: "Roboto",
              fontWeight: FontWeight.w800,
              color: group.admin.toString() == userId  ? Colors.white : Colors.white
          )),
    ) :  Container();
  }




  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(top: 6, left: 8, right: 8),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xffEAEBF3),
        borderRadius: BorderRadius.circular(5),

      ),
      child: Row(
        children: [
          Column(
            children: [
              Container(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed("/viewProfile", arguments: {'userId': userId, 'currentUser' : user});
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 12,left: 8, bottom: 12),
                    width: 35.0,
                    height: 35.0,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.all(new Radius.circular(50.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ],
                    ),
                    child: cachedNetworkImageCircular(context, userPhoto),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    getBadge(role: role, userId: userId, group: group),
                    SizedBox(width: 5,),
                    Flexible(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            EmojiText(text: name, fontSize: 16, color: Colors.black),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      "Member since: ${formatTimestamp(time.seconds)}",
                      style: TextStyle(
                          color: Color(0xff717171),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Roboto"
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(width: 6,),
                    mute != null ? getMuteStatus(mute) : Container(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

  }




}
