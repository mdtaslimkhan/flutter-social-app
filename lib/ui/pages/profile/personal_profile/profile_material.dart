
import 'package:chat_app/model/quotes.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/pages/feed/widgets/postmaterial.dart';
import 'package:chat_app/ui/pages/home/tophorizontalscroller.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/controller/profile_controller.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/model/crown_model.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/pages/block_list.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/pages/following_list.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/pages/groups_list.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/widget/crown_widget.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/widget/user_gift_page.dart';
import 'package:chat_app/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'pages/follower_list.dart';

class Socialbutton extends StatelessWidget {

  final String sName;
  final Color sColor;
  final Function onPressed;
  Socialbutton({@required this.sName, @required this.sColor, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: onPressed,
      child: Container(
        width: 55,
        height: 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: sColor,
        ),
        child:  Center(
          child: Text('$sName',
            style: flwhite8,
          ),
        ),
      ),
    );
  }
}

class Profilelistitem extends StatelessWidget {

  final String userId;
  final UserModel user;
  final flagProfile;
  Profilelistitem({this.userId, this.user, this.flagProfile});

  ProfileController _profileController = ProfileController();



  List<Quotes> quotes = [
    Quotes(1, 'Gifts' , ''),
    Quotes(2, 'Groups' , ''),
    Quotes(3, 'Flag' , ''),
    //  Quotes(3, 'Flag' , ''),

  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        children: <Widget>[
            getListTile(title: "Group", icon: 'assets/icons/hashtag.png', onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => GroupList(user: user, userId: userId)));
            }),
            getListTile(title: "Gift", icon: 'assets/icons/hashtag.png', onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UserGiftList(userId: userId)));
            }),
            userId == user.id.toString() ? getListTile(title: "Block list", icon: 'assets/icons/hashtag.png', onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => BlockList(user: user, userId: userId)));
            }) : Container(),

            userId == user.id.toString() ? getListTile(title: "Follower list", icon: 'assets/icons/hashtag.png', onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => FollowerList(user: user, userId: userId)));
            }) : Container(),

          userId == user.id.toString() ? getListTile(title: "Following list", icon: 'assets/icons/hashtag.png', onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => FollowingList(user: user, userId: userId)));
          }) : Container(),

            userId != user.id.toString() ? getListTile(title: "Flag", icon: 'assets/icons/hashtag.png', onPressed: (){
              flagProfile();
            }) : Container(),
            userId != user.id.toString() ? getListTile(title: "Block", icon: 'assets/icons/hashtag.png', onPressed: (){
              showConfirm(context);
            }) : Container(),
            SizedBox(height: 20,),
        ],
      ),
    );
  }

  Widget getListTile({String title, String icon, Function onPressed}){
    return ListTile(
      minLeadingWidth: 10,
      onTap: onPressed,
      title: Text(title,
          style: TextStyle(
              color: pTextColor,
              fontSize: 18
          )
      ),
      leading: Image.asset(
        icon,
        width: 25,
        height: 25,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: pTextColor,
        size: 14,
      ),
    );
  }

  showConfirm(BuildContext context){
    return showDialog(
        context: context,
        builder: (context){
          return SimpleDialog(
            title: Text('Are you sure you want to block ?',
              style: fldarkgrey15,),
            children: [
              SimpleDialogOption(
                child: Text('Yes', style: fldarkgrey18,),
                onPressed: () async {
                  Navigator.pop(context);
                  var dt = await _profileController.blockRequest(blockedId: userId, userId: user.id.toString());
                  Fluttertoast.showToast(msg: dt["message"]);
                },
              ),
              SimpleDialogOption(
                child: Text('No', style: fldarkgrey18,),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    );
  }

}



// badges max 24
List<Topseconscroller> badges24 = [
  Topseconscroller(1,10,'img','text'),
  Topseconscroller(2,10,'img','text'),
  Topseconscroller(3,10,'img','text'),
  Topseconscroller(4,10,'img','text'),
  Topseconscroller(5,10,'img','text'),
  Topseconscroller(6,10,'img','text'),
  Topseconscroller(1,10,'img','text'),
  Topseconscroller(2,10,'img','text'),
  Topseconscroller(3,10,'img','text'),
  Topseconscroller(4,10,'img','text'),
  Topseconscroller(5,10,'img','text'),
  Topseconscroller(6,10,'img','text'),
  Topseconscroller(1,10,'img','text'),
  Topseconscroller(2,10,'img','text'),
  Topseconscroller(3,10,'img','text'),
  Topseconscroller(4,10,'img','text'),
  Topseconscroller(5,10,'img','text'),
  Topseconscroller(6,10,'img','text'),
  Topseconscroller(1,10,'img','text'),
  Topseconscroller(2,10,'img','text'),
  Topseconscroller(3,10,'img','text'),
  Topseconscroller(4,10,'img','text'),
  Topseconscroller(5,10,'img','text'),
  Topseconscroller(6,10,'img','text'),

];



class BadgesTwentyFour extends StatelessWidget {

  final List<Crown> badgesList;
  BadgesTwentyFour({this.badgesList});

  @override
  Widget build(BuildContext context) {
    return
      Container(
        margin: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Badges',
                style: ftwhite18,
              ),
            ),
            SizedBox(height: 5,),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Color(0xff114ea7),
                  borderRadius: BorderRadius.circular(20)
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Wrap(
                  children: badgesList.map((data) =>
                      CrownWidget(type: "badge",crown: data),
                  ).toList(),
                ),
              ),
            ),
          ],
        ),

      );
  }
}


Widget badges24Template(badge){
  return  Container(
    width: 40.0,
    height: 40.0,
    child: Image.asset(
      'assets/profile/badgs/badgs${badge.id}.png',
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
    ),
  );
}

class StatusButton extends StatelessWidget {

  final Color sndColor;
  final int fCount;
  final String nName;
  final Color sColor;
  final Widget icon;
  StatusButton({this.sColor, this.nName, this.fCount, this.sndColor,this.icon});

  @override
  Widget build(BuildContext context) {
    return
      Container(
        width: (MediaQuery.of(context).size.width - 40 ) / 4,
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: sColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(width:12,child: icon),
            SizedBox(width: 5),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('$nName',
                    style: TextStyle(
                      fontSize: 10,
                      color: sndColor,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w800
                    ),
                  ),
                  Text('$fCount',
                    style: TextStyle(
                      fontSize: 12,
                      color: sndColor,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w900
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      );
  }
}


class Profileflag extends StatelessWidget {


  final String mLevel;
  final String imgUrl;
  Profileflag({this.mLevel, this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(48),
            boxShadow: [
              BoxShadow(
                  blurRadius: 16,
                  offset: Offset(0, 8),
                  color: Colors.green,
                  spreadRadius: -10)
            ],
            border: Border.all(
              color: Theme.of(context).accentColor,
              width: 2.0,
            ),
          ),
          child: IconButton(
            icon: Image.asset(imgUrl),
            onPressed: null,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10,0,10,0),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(48),
            border: Border.all(
              color: Theme.of(context).accentColor,
              width: 2.0,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(3,2,3,2),
            child: Text(
              "$mLevel",
              style: flwhite8,
            ),
          ),
        ),
      ],
    );
  }
}

class ProfileFlagRight extends StatelessWidget {

  final int mValue;
  ProfileFlagRight({this.mValue});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(48),
              boxShadow: [
                BoxShadow(
                    blurRadius: 16,
                    offset: Offset(0, 8),
                    color: Colors.green,
                    spreadRadius: -10)
              ],
              border: Border.all(
                color: Theme.of(context).accentColor,
                width: 2,
              )
          ),
          child: IconButton(
            icon: Image.asset('assets/profile/flag_bd.png'),
            onPressed: null,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Container(
          padding: EdgeInsets.fromLTRB(3,0,3,0),
          decoration: BoxDecoration(
            color: Color(0xFFfbc81e),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(3,2,3,2),
            child: Row(
              children: [
                Icon(
                  Icons.remove_red_eye,
                  size: 12,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "$mValue",
                  style: ftblack8,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class NameAndIdFollowButton extends StatelessWidget {

  final UserModel u;
  final bool isFollowing;
  final Function onPress;
  NameAndIdFollowButton({this.u, this.isFollowing, this.onPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      //  transform: Matrix4.translationValues(0, -90, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.fromLTRB(20,0,20,10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(10,0,10,0),
                      decoration: BoxDecoration(
                        color: Color(0xff716111),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          "CRID: ${u.crUserId != null ? u.crUserId : "${u.id}"}",
                          style: flwhite8,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 8,),
                Expanded(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Text(
                        '${u.fName} ${u.nName}',
                        style: TextStyle(
                            color: pTextColor,
                            fontSize: 18,
                            fontFamily: "Segoe",
                            fontWeight: FontWeight.w800
                        ),
                        maxLines: 5,
                        softWrap: true,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(width: 5),
                      u.isVerified == '1' || 1== 1 ? Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Image.asset(
                          'assets/profile/check2.png',
                          width: 12,
                        ),
                      ) : Container(),
                    ],
                  ),
                ),
                SizedBox(width: 8,),
                u.location != null ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 15,
                    ),
                    SizedBox(width: 3),
                    Text(
                      "${u.location}",
                      style: ftwhite12,
                    ),

                  ],
                ) : Container(),

                FollowingButton(
                  onPressed: onPress,
                  isFollowing: isFollowing,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}






