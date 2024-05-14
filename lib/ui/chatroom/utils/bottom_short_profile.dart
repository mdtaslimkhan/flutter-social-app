import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/chatroom/controller/chat_room_controller.dart';
import 'package:chat_app/ui/chatroom/function/send_gift_big_group.dart';
import 'package:chat_app/ui/chatroom/function/voice_room_methods.dart';
import 'package:chat_app/ui/chatroom/model/gift.dart';
import 'package:chat_app/ui/chatroom/widgets/big_group_widgets/voice_room_profile_info_big_badge_button.dart';
import 'package:chat_app/ui/chatroom/widgets/big_group_widgets/voice_room_profile_info_button.dart';
import 'package:chat_app/ui/chatroom/widgets/big_group_widgets/voice_room_profile_info_name.dart';
import 'package:chat_app/ui/chatroom/widgets/gift_widget.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/controller/profile_controller.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/model/follower_model.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/profile.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/profile_material.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/widget/user_gift_page.dart';
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

final _fireStore = FirebaseFirestore.instance;

class BottomShortProfile extends StatefulWidget {
  GroupModel group;
  final String userId;
  final int position;
  final String fromId;
  final bool isHost;

  BottomShortProfile({this.userId, this.group, this.position, this.fromId, this.isHost});

  @override
  _BottomShortProfileState createState() => _BottomShortProfileState();
}

class _BottomShortProfileState extends State<BottomShortProfile> {


  ProfileController _profileController = ProfileController();
  final VoiceRoomMethods roomMethods = VoiceRoomMethods();

  UserModel u;
  UserModel from;
  Follow _follows;
  bool isLoading = true;


  @override
  void initState() {
    getAllProfileInfo();
    initData();
    super.initState();


  }

  getAllProfileInfo() async {
    await getUserInfo(widget.userId);
    await getDiamondFollow(widget.userId);
    await getUserInfoFrom(widget.fromId);
    setState(() {
      isLoading = false;
    });
  }

  getUserInfo(String userId) async{
    var usr = await _profileController.getPorfileData(userId);
    UserModel us = UserModel.fromJson(usr);
     u = us;
  }

  getUserInfoFrom(String fromId) async{
    var usr = await _profileController.getPorfileData(fromId);
    UserModel us = UserModel.fromJson(usr);
      from = us;
  }

  getDiamondFollow(String userId) async {
    var fl  = await _profileController.getFollowrFollowing(userId);
      _follows = fl;
  }


  @override
  void dispose() {
    super.dispose();

  }



  @override
  Widget build(BuildContext context) {

    return  !isLoading ? StreamBuilder<QuerySnapshot>(
      stream: _fireStore
          .collection(BIG_GROUP_COLLECTION)
          .doc(widget.group.id.toString())
          .collection("hotSeat")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            if (snapshot.data.docs.length > widget.position) {
              var dt = snapshot.data.docs[widget.position]
                  .data() as Map;
              return Container(
                height: 580,
                child: Stack(
                  children: [
                    Positioned(
                      top: 80,
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Container(
                          height: 300,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
                              image: DecorationImage(
                                image: AssetImage("assets/room_profile/room_profile.png"),
                                fit: BoxFit.cover,

                              )
                            // border: Border.all(
                            //   color: Colors.white,
                            //   width: 1.0,
                            // ),
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.grey.withOpacity(0.5),
                            //     spreadRadius: 1,
                            //     blurRadius: 4,
                            //     offset: Offset(0, 1), // changes position of shadow
                            //   ),
                            // ],
                          ),
                          child: Column(
                            children: [

                              Container(
                                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 100,
                                      child: IconButton(
                                        icon: Text('@Manage',style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300,
                                            fontFamily: "Roboto",
                                            fontSize: 14
                                        )),
                                        onPressed: (){},
                                      ),
                                    ),
                                    Container(
                                      width: 100,
                                      child: IconButton(
                                        icon: Text('@Mention',style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300,
                                            fontFamily: "Roboto",
                                            fontSize: 14
                                        )),
                                        onPressed: (){},
                                      ),
                                    ),
                                  ],
                                ),
                              ),


                              VoiceRoomProfileInfoUserNameRow(user: u,),

                              GestureDetector(
                                child: Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "CR ID ${u.id}",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 9,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                                onTap: () {
                                  _showToast(context);
                                  //  share(widget.groupInfo.name);
                                  Clipboard.setData(new ClipboardData(text: widget.group.id.toString()));
                                },
                              ),




                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    StatusButton(icon: Image.asset('assets/room_profile/following.png'), nName: "Following", fCount: _follows.following, sColor: Color(0xa1278c87), sndColor: Color(0xff6be32e),),
                                    StatusButton(icon: Image.asset('assets/room_profile/followers.png') , nName: "Follower", fCount: _follows.follower, sColor: Color(0x85D778EE), sndColor: Color(0xFFAD5ADC),),
                                    StatusButton(icon: Image.asset('assets/room_profile/diamond.png'), nName: "Diamond", fCount: _follows.diamond, sColor: Color(0xa4e2ab40), sndColor: Color(0xbaa77307),),
                                    StatusButton(icon: Image.asset('assets/room_profile/gems.png'), nName: "Gems", fCount: _follows.gems, sColor: Color(
                                        0x8D80E755), sndColor: Color(0x9927610E),),
                                  ],
                                ),
                              ),

                              // VoiceRoomProfileInfoBigButton(user: widget.from,color: Color(0xfff2c578),),
                              VoiceRoomProfileInfoBigBadgeButton(user: u,color: Color(0xfff2c578), text: "Gift list", onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => UserGiftList(userId: u.id.toString())));
                              }),
                              SizedBox(height: 6,),
                              VoiceRoomProfileInfoBigBadgeButton(user: u,color: Color(0xffecebea), text: "Badges",onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(userId: widget.userId, currentUser: from,)));
                              }),
                              SizedBox(height: 10,),
                              Expanded(child: Container()),
                             widget.isHost != null && widget.isHost ? Column(
                               children: [

                                 Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      VoiceRoomProfileInfoButton(startColor: Color(0xFFfd7c2f),
                                          endColor: Color(0xFFf2c131),text: dt['mute'] != null  && dt['mute'] == false ? "Mute" : "Un mute",
                                          onPressed: () {
                                            dt['mute'] != null && dt['mute'] == false ?
                                            muteHotSeatUser(hotSeatUser: dt['userId']) :
                                            unMuteHotSeatUser(hotSeatUser: dt['userId']);

                                          }),
                                      VoiceRoomProfileInfoButton(startColor: Color(0xFFff2020),
                                          endColor: Color(0xFFff2020),text: "Put down", onPressed: () {
                                            removeFromHotSeat(hotSeatUser: dt['userId']);

                                          }
                                      ),

                                    ],
                                  ),
                                 SizedBox(height: 15,),
                               ],
                             ) : Container(),

                            widget.fromId != widget.userId ?  Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  // VoiceRoomProfileInfoButton(startColor: Color(0xFF2eaac1),
                                  //   endColor: Color(0xFF31dbf4),text: "Follow",onPressed: (){
                                  //
                                  //   },),
                                  // VoiceRoomProfileInfoButton(startColor: Color(0xfd7c2f),
                                  //   endColor: Color(0xf2c131),text: "Chat",onPressed: () {
                                  //
                                  //   },),
                                  VoiceRoomProfileInfoButton(startColor: Color(0xFFfd9c2d),
                                      endColor: Color(0xFFf6bb55), text: "Send Gift",
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _giftModalBottomSheet(context, 1);
                                      }),
                                ],
                              ) : Container(),
                              SizedBox(height: 16,),


                            ],
                          )
                      ),
                    ),
                    Positioned(
                      top: 40,
                      left: MediaQuery.of(context).size.width / 2 - 35,
                      child: Container(
                          height: 70,
                          width: 70,
                          child: cachedNetworkImageCircular(context, u.photo)
                      ),

                    ),
                    Positioned(
                      top: 10,
                      left: MediaQuery.of(context).size.width / 2 - 50,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(userId: widget.userId, currentUser: from,)));
                        },
                        child: Container(
                          padding: EdgeInsets.all(0),
                          height: 100,
                          width: 100,
                          margin: EdgeInsets.only(top: 20, bottom: 20),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/big_group/crown_ring.png')
                              )
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          }
        }
        return Container();
      },
    ) : Container(
      width: MediaQuery.of(context).size.width,
        height: 100,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
            image: DecorationImage(
              image: AssetImage("assets/room_profile/room_profile.png"),
              fit: BoxFit.cover,
            )
        ),
        child: Center(child: CircularProgressIndicator())
    );
  }

  removeFromHotSeat({String hotSeatUser}) async{
    await roomMethods.removeUserFromHotSeat(group: widget.group, hotSeatUser: hotSeatUser);
  }

  muteHotSeatUser({String hotSeatUser}) async {
    await roomMethods.setMuteHotSeat(group: widget.group, userId: hotSeatUser, mute: true , forceMute: true);
  }

  unMuteHotSeatUser({String hotSeatUser}) async {
    await roomMethods.setMuteHotSeat(group: widget.group, userId: hotSeatUser, mute: false, forceMute: true);
  }

  final _scafoldKey = GlobalKey<ScaffoldState>();

  void _showToast(BuildContext context) {


    Fluttertoast.showToast(msg: "Id Copied");
  }


  ChatRoomController _chatRoomController = ChatRoomController();

  final SendGiftBigGroup _sendGiftBigGroup = SendGiftBigGroup();




  List<Gift> gift = [];
  initData() async {
    var dtbdg = await _chatRoomController.getChatRoomGiftListData(widget.fromId.toString());
    if(dtbdg != null){
      dtbdg.forEach((val) {
        gift.add(Gift.fromJson(val));
      });
      // initial load widgets
      setState(() {
      });
    }



  }

  final Set _saved = Set();

  // Gift list bottom sheet
  void _giftModalBottomSheet(context, int position) {
    showModalBottomSheet(
        isScrollControlled: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0))),
        backgroundColor: Colors.black87,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            //   color: Colors.black87,
            height: 280,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12,top: 15, bottom: 5),
                  child: Text('Gift list',
                      style: ftwhite12),
                ),
                Container(
                  height: 220,
                  child: SingleChildScrollView(
                    child: Wrap(
                      direction: Axis.horizontal,
                      children: gift.map((data) =>
                          Container(
                            width: MediaQuery.of(context).size.width / 4,
                            child: GiftWidget(
                              chattroom: true,
                              gift: data,
                              user: u,
                              group: widget.group,
                              onPressed: () async {
                                Navigator.of(bc, rootNavigator: true).pop();
                                _saved.add(widget.userId);
                               await _sendGiftBigGroup.sendGiftToUser(
                                    gift: data,
                                    saved: _saved,
                                    from: from,
                                    toGroup: widget.group
                                );

                                _saved.clear();
                              },
                            ),
                          ),
                        //  Container(child: Text("hello"),),
                      ).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }




}
