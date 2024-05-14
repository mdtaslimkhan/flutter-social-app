import 'dart:convert';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/provider/profile_provider.dart';
import 'package:chat_app/ui/pages/feed/widgets/single_post_image_page.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/controller/profile_controller.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/profile_material.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/sliver_profile.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/widget/crown_widget.dart';
import 'package:chat_app/ui/pages/settings/profile_settings.dart';
import 'package:chat_app/ui/pages/widgets/progress.dart';
import 'package:chat_app/util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';


class Profile extends StatefulWidget {

  final UserModel currentUser;
  final String userId;

  Profile({this.userId, this.currentUser});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  ScrollController _scrollController = ScrollController();
  ProfileController _profileController = ProfileController();

  bool _isBottomLoader = true;
  bool tiggredOnce = true;
  UserModel u;
  bool _isFollowing = false;


  @override
  void initState() {
    super.initState();
    // initiate listening scrolling
    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        // at the end point load data from server
        print(widget.userId +" "+ widget.currentUser.id.toString());
        _pp.getMorePostData(userId: widget.userId);
      }
    });
    initData();
  }

  void _followUser() {
    setState(() {
      _isFollowing ? _isFollowing = false : _isFollowing = true;
    });
    _profileController.followRequest(followerId: widget.userId, userId: widget.currentUser.id.toString());
  }



  ProfileProvider _pp;

  initData() async {

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _pp = Provider.of<ProfileProvider>(context, listen: false);
      _pp.getProfileCrown(userId: widget.userId);
      _pp.getProfileBadgeList(userId: widget.userId);
      _pp.getFoloingUsers(userId: widget.userId);
      _pp.getPostItem(userId: widget.userId);
    });


  }




  profileFutureBuilder(ProfileProvider _p) {
    return FutureBuilder(
      future: _profileController.getPorfileData(widget.userId),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
           return circularProgress();
        }
        u = UserModel.fromJson(snapshot.data);
        if(snapshot.hasData){
          return Column(
            children: [
              // container for top banner and rounded 3 icons

              Container(
                width: MediaQuery.of(context).size.width,
                height: 260,
                child: Stack(
                  children : [
                    Positioned(
                      width: MediaQuery.of(context).size.width+40,
                      left: -20,
                      child: Container(
                        height: 220,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                            image: DecorationImage(
                                image: u != null && u.cover != null ? NetworkImage(u.cover) : AssetImage('assets/profile/bg.png'),
                                fit: BoxFit.cover,
                                alignment: Alignment.bottomCenter
                            ),
                            borderRadius: BorderRadius.vertical(bottom: Radius.circular(250))
                        ),
                        child: Text(''),
                      ),
                    ),
                    Positioned(
                      top: 5,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                           widget.currentUser.id.toString() == widget.userId ? IconButton(
                            icon: Icon(
                              Icons.settings,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              await Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileSettings(userId: widget.userId)));
                              setState(() {
                                // widget.userId = uid;
                              });
                            },
                          ) : Container(),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 110,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Profileflag(mLevel: "Level ${_p.follows != null ? _p.follows.level.toString() : ''}", imgUrl: 'assets/profile/crown_main.png',),

                          Column(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Singleimagepage(photo: u.photo,)));
                                },
                                child: Container(
                                  height: 150,
                                  width: 150,
                                  child: Stack(
                                    children:[
                                      Positioned(
                                        top: 60,
                                        left: 40,
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(3,4,0,0),
                                          height: 65,
                                          width: 65,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: u.photo != null ? NetworkImage(u.photo) : AssetImage("assets/no_image.jpg"),
                                              fit: BoxFit.cover,
                                              alignment: Alignment.center,
                                            ),
                                            borderRadius: BorderRadius.circular(48),
                                          ),
                                          child: Text(''),
                                        ),),
                                      Positioned(
                                        top:20,
                                        child: Container(
                                          height: 150,
                                          width: 150,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage('assets/profile/crown_main3.png'),
                                                fit: BoxFit.cover,
                                                alignment: Alignment.center,
                                              ),
                                              borderRadius: BorderRadius.circular(48),
                                              boxShadow: [
                                                BoxShadow(
                                                    blurRadius: 16,
                                                    offset: Offset(0, 8),
                                                    color: Color(0xffd5d63),
                                                    spreadRadius: -10),
                                              ]),
                                          child: Text(''),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          ProfileFlagRight(mValue: _p.follows != null ? _p.follows.follower : 0),


                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // name and id and follow buttns
              NameAndIdFollowButton(
                u: u,
                isFollowing: _isFollowing,
                onPress: _followUser,
              ),

              // Crown holder
             _p.crownList.length > 0 ? Container(
                margin: EdgeInsets.fromLTRB(10,0,10,5),
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Wrap(
                    children: _p.crownList.map((data) =>
                        CrownWidget(crown: data.crown),
                    ).toList(),
                  ),
                ),
              ) : Container(),
              // Button of following , followers, diomonds, gems
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                width: MediaQuery.of(context).size.width,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 5,
                 // runSpacing: 5,
                  children: <Widget>[
                    StatusButton(icon: Image.asset('assets/room_profile/following.png'),
                      nName: "Following", fCount: _p.follows != null ? _p.follows.following : 0, sColor: pBodyColor, sndColor: pTextColor),
                    StatusButton(icon: Image.asset('assets/room_profile/followers.png') ,
                      nName: "Follower", fCount: _p.follows != null ? _p.follows.follower : 0,
                        sColor: pBodyColor, sndColor: pTextColor),
                    StatusButton(icon: Image.asset('assets/room_profile/diamond.png'),
                      nName: "Diamond", fCount: _p.follows != null ? _p.follows.diamond : 0, sColor: pBodyColor, sndColor: pTextColor,),
                    StatusButton(icon: Image.asset('assets/room_profile/gems.png'),
                      nName: "Gems", fCount: _p.follows != null ? _p.follows.gems : 0, sColor: pBodyColor, sndColor: pTextColor,),
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                width: MediaQuery.of(context).size.width,
                child: u.number != null || u.number != null || u.number != null ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                      child: Text('General',
                        style: TextStyle(
                            color: pTextColor,
                            fontSize: 18,
                          fontWeight: FontWeight.w800,
                          fontFamily: "Segoe"
                        ),
                      ),
                    ),
                    Wrap(
                      runSpacing: 0,
                      spacing: 5,
                      children: [
                        u.number != null ? TextButton.icon(
                          onPressed: null,
                          icon: Icon(
                            Icons.call,
                            color: pTextColor,
                            size: 16,
                          ),
                          label: u.showContact == 1 && u.number != null ? Text(
                            '${u.number}',
                            style: ftwhite12,
                          ) : u.number == null ? Text('')
                            : Text('Hidden',
                              style: TextStyle(
                                color: pTextColor,
                                fontSize: 12
                              )),
                        ) : Text(''),
                         u.email != null ? TextButton.icon(
                          onPressed: null,
                          icon: Icon(
                            Icons.markunread,
                            color: pTextColor,
                            size: 16,
                          ),
                          label: Text(
                            '${u.email}',
                            style: TextStyle(
                                color: pTextColor,
                                fontSize: 12
                            ),
                          ),
                        ) : Text(''),
                         u.address != null ? TextButton.icon(
                          onPressed: null,
                          icon: Icon(
                            Icons.home,
                            color: pTextColor,
                            size: 16,
                          ),
                          label: Text(
                            '${u.address}',
                            style: TextStyle(
                                color: pTextColor,
                                fontSize: 12
                            ),
                          ),
                        ) : Text(''),
                      ],
                    ),
                  ],
                ) : Text(''),
              ),
              // About section
              u.about != null ? Container(
                margin: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text('About',
                      style: TextStyle(
                          color: pTextColor,
                          fontSize: 18,
                          fontFamily: "Segoe",
                          fontWeight: FontWeight.w800
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('${u.about}',
                      style: TextStyle(
                          color: pTextColor,
                          fontSize: 12
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text('Mores...',
                          style: TextStyle(
                            color: pTextColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ) : Container(),
              // badges max 24
             _p.badge.length > 0 ? BadgesTwentyFour(badgesList: _p.badge,) : Container(),

              // Gift, visitor, group list
              Profilelistitem(userId: widget.userId, user: widget.currentUser),

            ],
          );
        }

        return Container();

      },
    );
  }




  @override
  Widget build(BuildContext context) {
    ProfileProvider _p = Provider.of<ProfileProvider>(context, listen: true);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 20,
                    child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PersonalProfileSliver(
                        currentUser: widget.currentUser, userId: widget.userId,
                      )));
                  },
                   child: Text("sliver profile"),
              ),
              ),

            ],
          ),
        ),
      )
    );
  }


}


