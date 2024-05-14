import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/chatroom/function/voice_room_methods.dart';
import 'package:chat_app/ui/chatroom/widgets/big_group_widgets/voice_room_profile_info_big_badge_button.dart';
import 'package:chat_app/ui/chatroom/widgets/big_group_widgets/voice_room_profile_info_button.dart';
import 'package:chat_app/ui/chatroom/widgets/big_group_widgets/voice_room_profile_info_name.dart';
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

class BoubbleBottomShortProfile extends StatefulWidget {
  final String groupId;
  final String userId;
  final int position;
  final String fromId;
  final bool isHost;

  BoubbleBottomShortProfile({this.userId, this.groupId, this.position, this.fromId, this.isHost});

  @override
  _BoubbleBottomShortProfileState createState() => _BoubbleBottomShortProfileState();
}

class _BoubbleBottomShortProfileState extends State<BoubbleBottomShortProfile> {


  ProfileController _profileController = ProfileController();
  final VoiceRoomMethods roomMethods = VoiceRoomMethods();

  UserModel u;
  UserModel from;
  Follow _follows;
  bool isLoading = true;


  @override
  void initState() {
    getAllProfileInfo();
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
    print(us.id);
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

    return  Container(
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
                                  Clipboard.setData(new ClipboardData(text: widget.groupId));
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

                              widget.fromId != widget.userId ?  Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  VoiceRoomProfileInfoButton(startColor: Color(0xFFfd9c2d),
                                      endColor: Color(0xFFf6bb55), text: "Send Gift",
                                      onPressed: () {
                                        Navigator.pop(context);
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



  final _scafoldKey = GlobalKey<ScaffoldState>();

  void _showToast(BuildContext context) {

    Fluttertoast.showToast(msg: "Id Copied");
  }







}



// Hot seat user bottom sheet will see admin only
void boubbleOptionModalBottomSheet(context, int position, String userId, isHost, groupId, fromId) async {

  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      context: context,
      builder: (BuildContext bc) {
        return BoubbleBottomShortProfile(userId: userId, groupId: groupId, position: position, fromId: fromId, isHost: isHost);
      });
}


