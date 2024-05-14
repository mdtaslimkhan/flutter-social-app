import 'dart:async';

import 'package:chat_app/model/quotes.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/chatroom/big_group_widget/getUserImageByUrl.dart';
import 'package:chat_app/ui/chatroom/function/voice_room_methods.dart';
import 'package:chat_app/ui/chatroom/chatmethods/chatmethods_big_group.dart';
import 'package:chat_app/ui/chatroom/model/contact.dart';
import 'package:chat_app/ui/chatroom/provider/big_group_provider.dart';
import 'package:chat_app/ui/group/big_group/add_group_members.dart';
import 'package:chat_app/ui/group/big_group/all_group_member.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:chat_app/ui/group/big_group/util/goup_methods.dart';
import 'package:chat_app/ui/index.dart';
import 'package:chat_app/ui/pages/home/controller/homeController.dart';
import 'package:chat_app/ui/pages/home/utils/home_methods.dart';
import 'package:chat_app/ui/pages/profile/group_profile/flugGroup.dart';
import 'package:chat_app/ui/pages/profile/group_profile/settings/group_functions.dart';
import 'package:chat_app/ui/pages/profile/group_profile/widgets/group_header_images.dart';
import 'package:chat_app/ui/pages/profile/group_profile/widgets/group_options_items.dart';
import 'package:chat_app/ui/pages/profile/group_profile/widgets/user_role_widget.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/controller/profile_controller.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/model/crown_model.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/widget/crown_widget.dart';
import 'package:chat_app/ui/pages/widgets/progress.dart';
import 'package:chat_app/util/constants.dart';
import 'package:chat_app/util/loading/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';


final _fireStore = FirebaseFirestore.instance;

// ignore: must_be_immutable
class GroupProfile extends StatefulWidget {
  final UserModel user;
  GroupModel groupInfo;
  GroupProfile({this.user, this.groupInfo});


  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<GroupProfile> {
  GroupFunctions _groupFunctions = GroupFunctions();
  ChatMethodsBigGroup _bgMethods = ChatMethodsBigGroup();
  final VoiceRoomMethods roomMethods = VoiceRoomMethods();
  final HomeController _homeController = HomeController();
  bool showDetails = true;
  final _scafoldKey = GlobalKey<ScaffoldState>();
  ProfileController _profileController = ProfileController();

  bool showLoader = false;
  bool alreadyJoined = false;
  bool inBlackList = false;


  Widget ratingStar(str){
    return Icon(
      Icons.star,
      size: 25,
      color: Color(0xfffde83e),
    );
  }


  // badges earned
  List<Quotes> badgeEarned = [
    Quotes(1, 'Gifts' , 'Hello, Assalamualikum, Kemon asen?'),
    Quotes(2, 'Visitors' , 'Hello, Assalamualikum, Kemon asen?'),
    Quotes(3, 'Groups' , 'Hello, Assalamualikum, Kemon asen?'),
  ];

  Widget badgeEarnedTemplate(Quotes data){
    return Container(
      width: 18,
      height: 18,
      child: giftReactCachedNetworkImage(context,
          "$APP_ASSETS_URL/profile/crown/crown${data.id}.png"
      ),
    );
  }

  // color second primary for group profile
  // blue 0xff3d8cf3
  // gray 0xff9e9fa4
  // red 0xffdc3730
  // dark gray 0xff9b9a9c


  Future<void> share(String name) async {
    String _packageInfo;
    PackageInfo.fromPlatform().then((PackageInfo p) {
      _packageInfo = p.packageName;
    });
    await FlutterShare.share(
        title: 'Download CR ',
        text: 'Social media app to join with me.',
        linkUrl: 'https://play.google.com/store/apps/details?id=$_packageInfo',
        chooserTitle: 'Share $name'
    );
  }



  void _showToast(BuildContext context) {

     Fluttertoast.showToast(msg: "Group tracking id copied");
  }

  @override
  void dispose() {
    strSubscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    addPostFrameCallBack();

    super.initState();
  }




  checkHost(String id) async {


  }

  BigGroupProvider _bigGroupProvider;

  StreamSubscription strSubscription;

  addPostFrameCallBack() async {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      _bigGroupProvider = Provider.of<BigGroupProvider>(context, listen: false);
      if(widget.user.id.toString() != widget.groupInfo.admin.toString()){
        await _groupFunctions.updateGroup(groupId: _bigGroupProvider.toGroup.id.toString(),
            text: (_bigGroupProvider.toGroup.view != null ? _bigGroupProvider.toGroup.view + 1 : 0).toString(), field: "view");
      }
      _bigGroupProvider.getGroupModelData(groupId: _bigGroupProvider.toGroup.id.toString());
    });


    strSubscription = ChatMethodsBigGroup().ifAlreadyAnUser(groupId: widget.groupInfo.id.toString(), userId: widget.user.id.toString())
    .listen((QuerySnapshot snapshot) {
      snapshot.docs.forEach((data) {
        var dt = data.data() as Map;
        if(data != null && data.data() != null && dt['userId'] == widget.user.id.toString()){
          setState(() {
            alreadyJoined = true;
          });
        }
      });
    });

    strSubscription = ChatMethodsBigGroup().ifAlreadyInBlackList(groupId: widget.groupInfo.id.toString(), userId: widget.user.id.toString())
        .listen((QuerySnapshot snapshot) {
      snapshot.docs.forEach((data) {
        var dt = data.data() as Map;
        if(data != null && data.data() != null && dt['userId'] == widget.user.id.toString()){
          setState(() {
            inBlackList = true;
          });
        }
      });
    });



  }




  @override
  Widget build(BuildContext context) {
    BigGroupProvider _p = Provider.of<BigGroupProvider>(context, listen: true);
    return LoadingImage(
      inAsyncCall: showLoader,
      child: Scaffold(
        backgroundColor: mainBg,
        key: _scafoldKey,
      // backgroundColor: Color(0xff0000ff),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
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
                            color: Colors.grey,
                            image: DecorationImage(
                              image: _p.toGroup?.cover != null ? NetworkImage(_p.toGroup.cover) : AssetImage('assets/no_image.jpg'),
                              fit: BoxFit.cover,
                              alignment: Alignment.bottomCenter
                            ),
                            borderRadius: BorderRadius.vertical(bottom: Radius.circular(250))
                          ),
                          child: Text(''),
                      ),
                        ),
                        GroupHeaderImages(profileImage: _p.toGroup?.photo,),
                        Positioned(
                          left: 0,
                          top:0,
                          right: 0,
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
                                _p.toGroup?.admin == widget.user.id ? IconButton(
                                icon: Icon(
                                  Icons.settings,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                 //
                                 // GroupModel result = await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                 //     BigGroupEdit(user: widget.user, group: widget.groupInfo)));

                                  setState(() {
                                    showLoader = true;
                                  });
                                  await _p.getGroupModelData(groupId: widget.groupInfo.id.toString());
                                  var chek = await Navigator.of(context).pushNamed('/settingNavGroup',
                                      arguments: {'user': widget.user, 'group' : widget.groupInfo});
                                  setState(() {
                                    showLoader = false;
                                  });
                                  if(chek != null){
                                    setState(() {
                                      showLoader = false;
                                    });
                                  }



                                },
                              ) : Container(),
                            ],
                          ),
                        ),
                    ],
                    ),
                  ),
                  // name, tag , follow, and id holder buttns
                  Container(
                    width: MediaQuery.of(context).size.width,
                  //  transform: Matrix4.translationValues(0, -90, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width / 5 * 4,
                                        child: Text(
                                            "${_p.toGroup?.name} ",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontFamily: '',
                                            fontWeight: FontWeight.w800
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      _p.toGroup?.isVerified != null ? Image.asset(
                                          'assets/profile/check2.png',
                                        width: 12,
                                      ) : Text(''),
                                    ],
                                  ),

                            Container(
                              margin: EdgeInsets.all(5),
                              child: FutureBuilder(
                                future: _profileController.getCrownListDataGroup(_p.toGroup?.id.toString()),
                                builder: (index, snap){
                                  if(snap.hasData) {
                                    List<CrownWidget> crownList = [];
                                    if (snap != null) {
                                      snap.data.forEach((val) {
                                        var v = Crown.fromJson(val);
                                        crownList.add(CrownWidget(crown: v,));
                                      });
                                    }
                                    return Wrap(
                                      children: crownList.map((data) =>
                                          Container(
                                            width: 25, height: 25,
                                              child: CrownWidget(crown: data.crown)),
                                      ).toList(),
                                    );
                                  }else{
                                    return Container();
                                  }
                              }
                              ),
                            ),



                          ],
                        ),
                        SizedBox(height: 15),
                        GestureDetector(
                          onTap: (){

                          },
                          child: Center(
                            child: GestureDetector(
                              child: Container(
                                width: 100,
                                padding: EdgeInsets.fromLTRB(10,0,10,0),
                                decoration: BoxDecoration(
                                  color: btnBg,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 0,
                                        offset: Offset(1, 1),
                                        color: btnShadow.withOpacity(0.3),
                                        spreadRadius: 1),
                                  ],
                                  border: Border.all(
                                    color: btnBorder,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0,5,0,6),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          "ID ${_p.toGroup?.groupId}",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 9,
                                            color: Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w900
                                          ),
                                        ),

                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {
                                _showToast(context);
                                //  share(widget.groupInfo.name);
                                Clipboard.setData(new ClipboardData(text: _p.toGroup.groupId.toString()));
                              },
                            ),
                            ),

                        ),

                      ],
                    ),
                  ),


                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        !["", null, false, 0, "0"].contains(_p.toGroup?.location) ? Container(
                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: btnBg,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 0,
                                  offset: Offset(1, 1),
                                  color: btnShadow.withOpacity(0.3),
                                  spreadRadius: 1),
                            ],
                            border: Border.all(
                              color: btnBorder,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.location_on, size: 15,color: Colors.green,),
                              Text('${_p.toGroup.location}', style: TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                                fontFamily: "Segoe",
                                fontWeight: FontWeight.w800
                              )),
                            ],
                          ),
                        ) : Container(),
                        SizedBox(width: 5,),
                       !["", null, false, 0,"0"].contains(_p.toGroup?.tag) ? Container(
                            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                           decoration: BoxDecoration(
                             color: btnBg,
                             borderRadius: BorderRadius.circular(5),
                             boxShadow: [
                               BoxShadow(
                                   blurRadius: 0,
                                   offset: Offset(1, 1),
                                   color: btnShadow.withOpacity(0.3),
                                   spreadRadius: 1),
                             ],
                             border: Border.all(
                               color: btnBorder,
                             ),
                           ),
                            child: Text('${_p.toGroup.tag}',style: fldarkgrey12,)
                        ) : Container(),
                        SizedBox(width: 5,),
                        !["", null, false, 0, "0"].contains(_p.toGroup?.language) ? Container(
                            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                              color: btnBg,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 0,
                                    offset: Offset(1, 1),
                                    color: btnShadow.withOpacity(0.3),
                                    spreadRadius: 1),
                              ],
                              border: Border.all(
                                color: btnBorder,
                              ),
                            ),
                            child: Text('${_p.toGroup.language}',style: fldarkgrey12,)
                        ) : Container(),
                      ],
                    ),
                  ),

                  // Join holder
                  _p.toGroup?.admin != widget.user.id ? Container() : Container(
                    child: SizedBox(height: 20,),
                  ),
                  // following , posts status

                  // container for ratings

                  // about group
                 !["", null, false, 0].contains(_p.toGroup?.about) ? Container(
                    margin: EdgeInsets.all(15),
                    padding: EdgeInsets.fromLTRB(5,0,5,0),
                    width: MediaQuery.of(context).size.width,
                   decoration: BoxDecoration(
                     color: btnBg,
                     borderRadius: BorderRadius.circular(5),
                     boxShadow: [
                       BoxShadow(
                           blurRadius: 0,
                           offset: Offset(1, 1),
                           color: btnShadow.withOpacity(0.3),
                           spreadRadius: 1),
                     ],
                     border: Border.all(
                       color: btnBorder,
                     ),
                   ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(3,4,3,4),
                      child: Column(
                        children: [
                          Text(
                            "About",
                            style: TextStyle(
                              fontSize: 15,
                              color: headingColor,
                              fontWeight: FontWeight.w800
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "${_p.toGroup.about}",
                            style: TextStyle(
                              fontSize: 14,
                              color: textColor,
                              fontFamily: '',
                              fontWeight: FontWeight.w800
                            ),
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.end,
                          //   children: [
                          //     GestureDetector(
                          //       onTap: (){},
                          //        child: Text(
                          //         "More...",
                          //         style: TextStyle(
                          //           fontSize: 10,
                          //           color: Colors.blue,
                          //         ),
                          //          textAlign: TextAlign.right,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ) : Container(),
                  // Participants joined status
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        showLoader = true;
                      });
                      await _p.getGroupModelData(groupId: widget.groupInfo.id.toString());
                      // DocumentSnapshot ref = await _homeMethods.getContactByGroupId(userId: widget.user.id.toString(), groupId: widget.groupInfo.id.toString());
                      // ContactHome ch = ContactHome.fromMap(ref.data());
                      ContactHome contact = ContactHome(name: widget.groupInfo.name,
                          photo: widget.groupInfo.photo, uid: widget.groupInfo.id.toString(),type: "bigGroup");
                      Navigator.of(context).pushNamed("/bigGroupChatRoom", arguments:
                      {'from': widget.user,
                        'toGroupId': widget.groupInfo.id.toString(),
                        'contact': contact,
                        'floatButton': false,
                      });
                      setState(() {
                        showLoader = false;
                      });
                    },
                    child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    decoration: BoxDecoration(
                      color: Color(0xff9b9a9c),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: 25),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Participants joined',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Roboto'
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        Container(
                            height: 25,
                            width: 100,
                            child: StreamBuilder<QuerySnapshot>(
                              stream: _fireStore
                                  .collection(BIG_GROUP_COLLECTION)
                                  .doc(widget.groupInfo?.id.toString())
                                  .collection("activeMembers")
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  circularProgress();
                                }
                                if (snapshot.hasData) {
                                  if (snapshot.data != null) {
                                    var docList = snapshot.data.docs;
                                    return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: docList.length,
                                      itemBuilder: (context, index) {
                                        var dt = docList[index].data() as Map;
                                        String photo = dt['photo'];
                                        return GestureDetector(
                                          child: UserImageByPhotoUrl(
                                            photo: photo,
                                          ),
                                          onTap: () {
                                            // _optionModalBottomSheet(context);
                                          },
                                        );
                                      },
                                    );
                                  }
                                }
                                return Text("no data");
                              },
                            ),
                          ),
                        SizedBox(width: 25),
                        GestureDetector(
                          onTap: (){},
                          child: Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 15),


                      ],
                    ),
                  ),
          ),
                  // Conference room blue button
                  GestureDetector(
                    onTap: () {
                   //   Navigator.push(context, MaterialPageRoute(builder: (context) => AddGroupMembers(user: widget.user, groupInfo: widget.groupInfo)));

                    },
                    child: alreadyJoined ? Container() : GestureDetector(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(15,10,15,5),
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                        decoration: BoxDecoration(
                          color: Color(0xff3d8cf3),
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 0,
                                offset: Offset(1, 1),
                                color: Colors.black45.withOpacity(0.3),
                                spreadRadius: 1),
                          ],
                          border: Border.all(
                            color: Colors.white,
                            //  width: 2,
                          ),
                        ),
                        child: Container(
                          child: Row(
                            children: [
                              SizedBox(width: 25),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Join',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                  Icons.chevron_right,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: !inBlackList ? () async {
                        GroupModel _gm = await _homeController.getGroupById(widget.groupInfo.id.toString());
                        if(["", null, false, 0,"0","Public"].contains(_gm.isPublic)) {
                          _showPermissionDialog(context, _p);
                        }else if(["Private"].contains(_gm.isPublic)){
                          _showDialogForPrivate(context, _p);
                        }
                      } : () {
                        _showDialogInblackList(context, _p);
                      },
                    ),
                  ),
                  // formal group members
                  Container(
                    margin: EdgeInsets.fromLTRB(15,10,15,5),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: btnBg,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 0,
                            offset: Offset(1, 1),
                            color: btnShadow.withOpacity(0.3),
                            spreadRadius: 1),
                      ],
                      border: Border.all(
                        color: btnBorder,
                      ),
                    ),
                    child: Column(
                      children: [
                        // blue button
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AllGroupMembers(
                              user: widget.user,
                              groupInfo: _p.toGroup,
                              isAdmin: _p.toGroup.admin == widget.user.id,
                            )));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                    'Formal group Members',
                                  style: TextStyle(
                                    color: Color(0xff3d8cf3),
                                    fontWeight: FontWeight.w800
                                  )
                                ),
                                Row(
                                  children: <Widget>[
                                    StreamBuilder<QuerySnapshot>(
                                        stream: _bgMethods.totalMembersStream(groupId: widget.groupInfo?.id.toString()),
                                        builder: (context, snapshot) {
                                          if(snapshot.hasData){
                                            return Text("${snapshot.data.docs.length} people", style: fldarkgrey15,);
                                          }
                                          return Text("0 people",style: fldarkgrey15,);
                                        }
                                    ),
                                    SizedBox(width: 7),
                                    Icon(
                                        Icons.supervised_user_circle,
                                      color: Color(0xff9e9fa4),
                                    ),
                                  ],
                                ),

                              ],
                            ),
                          ),
                        ),

                        StreamBuilder<QuerySnapshot>(
                          stream: _fireStore.collection(BIG_GROUP_COLLECTION)
                               .doc(widget.groupInfo?.id.toString())
                               .collection("members")
                               .orderBy("role", descending: false)
                               .limit(5)
                               .snapshots(),
                          builder: (context, snapshot) {
                            if(snapshot.hasData){
                              var dt = snapshot.data.docs;
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AllGroupMembers(
                                    user: widget.user,
                                    groupInfo: _p.toGroup,
                                    isAdmin: _p.toGroup.admin == widget.user.id,
                                  )));
                                },
                                child: Container(
                                  height: 42 * double.parse(dt.length.toString()),
                                  child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: dt.length,
                                    itemBuilder: (context, index){
                                      var ds = dt[index].data() as Map;
                                      String name = ds['name'];
                                      String uid = ds['userId'];
                                      String photo = ds['photo'];
                                      int role = ds['role'];
                                      print(name);
                                      return Container(
                                        margin: EdgeInsets.only(top: 0, left: 0, right: 0),
                                        width: MediaQuery.of(context).size.width,
                                        child: Row(
                                          children: [
                                            Column(
                                              children: [
                                                Container(
                                                  child: Container(
                                                    margin: EdgeInsets.only(top: 8,left: 8, bottom: 8),
                                                    width: 25.0,
                                                    height: 25.0,
                                                    child: cachedNetworkImageCircular(context, photo),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 8),
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  getBadge(role: role, userId: uid, group: widget.groupInfo),
                                                  SizedBox(width: 5,),
                                                  Flexible(
                                                    child: Text(name,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Color(0xff494949),
                                                          fontWeight: FontWeight.w700,
                                                          fontFamily: ""
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            }
                            return Container();

                          }
                        ),


                        //  add members button
                        _p.toGroup?.admin == widget.user.id ? GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AddGroupMembers(user: widget.user, groupInfo: widget.groupInfo)));
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(15,10,15,5),
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                            decoration: BoxDecoration(
                              color: Color(0xffEAEBF3),
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 0,
                                    offset: Offset(1, 1),
                                    color: Colors.black45.withOpacity(0.3),
                                    spreadRadius: 1),
                              ],
                              border: Border.all(
                                color: Colors.white,
                                //  width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 5),
                                GestureDetector(
                                  onTap: (){},
                                  child: Icon(
                                    Icons.add_circle,
                                    color: Color(0xff9e9fa4),
                                    size: 42,
                                  ),
                                ),
                                SizedBox(width: 25),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Add members ',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),




                              ],
                            ),
                          ),
                        ) : Container(),
                      ],
                    ),
                  ),

                  !["",null, false, 0].contains(_p.toGroup?.announce) ? group_options_items(label: "Announcement",
                    iconImage: Icons.record_voice_over,
                    isHide: showDetails,
                    onPress: () {
                      setState(() {
                        if(showDetails == false) {
                          showDetails = true;
                        }else{
                          showDetails = false;
                        }
                      });
                    },
                    icon: showDetails ? Icons.keyboard_arrow_down : Icons.chevron_right,
                    descrip: _p.toGroup.announce,
                  ) : Container(),



                 !["",null, false, 0].contains(_p.toGroup?.description) ? group_options_items(label: "Description",
                   iconImage: Icons.textsms_outlined,
                    isHide: showDetails,
                    onPress: () {
                      setState(() {
                        if(showDetails == false) {
                          showDetails = true;
                        }else{
                          showDetails = false;
                        }
                      });
                    },
                    icon: showDetails ? Icons.keyboard_arrow_down : Icons.chevron_right,
                    descrip: _p.toGroup.description,
                  ) : Container(),

                  // Rules
                  !["", null, false, 0].contains(_p.toGroup?.rules1) ? group_options_items(label: "Rules 1",
                    iconImage: Icons.language,
                    isHide: showDetails,
                    onPress: () {
                      setState(() {
                        if(showDetails == false) {
                          showDetails = true;
                        }else{
                          showDetails = false;
                        }
                      });
                    },
                    icon: showDetails ? Icons.keyboard_arrow_down : Icons.chevron_right,
                    descrip: _p.toGroup.rules1,
                  ) : Container(),

                  // Rules
                  !["", null, false, 0].contains(_p.toGroup?.rules2) ? group_options_items(label: "Rules 2",
                    iconImage: Icons.language,
                    isHide: showDetails,
                    onPress: () {
                      setState(() {
                        if(showDetails == false) {
                          showDetails = true;
                        }else{
                          showDetails = false;
                        }
                      });
                    },
                    icon: showDetails ? Icons.keyboard_arrow_down : Icons.chevron_right,
                    descrip: _p.toGroup.rules2,
                  ) : Container(),
                  // Rules
                  !["", null, false, 0].contains(_p.toGroup?.rules3) ? group_options_items(label: "Rules 3",
                    iconImage: Icons.language,
                    isHide: showDetails,
                    onPress: () {
                      setState(() {
                        if(showDetails == false) {
                          showDetails = true;
                        }else{
                          showDetails = false;
                        }
                      });
                    },
                    icon: showDetails ? Icons.keyboard_arrow_down : Icons.chevron_right,
                    descrip: _p.toGroup.rules3,
                  ) : Container(),
                  // Rules
                 !["", null, false, 0].contains(_p.toGroup?.rules4) ? group_options_items(label: "Rules 4",
                   iconImage: Icons.language,
                    isHide: showDetails,
                    onPress: () {
                      setState(() {
                        if(showDetails == false) {
                          showDetails = true;
                        }else{
                          showDetails = false;
                        }
                      });
                    },
                    icon: showDetails ? Icons.keyboard_arrow_down : Icons.chevron_right,
                    descrip: _p.toGroup.rules4,
                  ) : Container(),





                  // Leave this group
                _p.toGroup?.admin != widget.user.id ? alreadyJoined ? group_options_items(bgColor: Color(0xffdc3730) ,label: "Leave the group",
                  iconImage: Icons.logout,
                  isHide: false,
                  onPress: () async {
                   DocumentSnapshot dt = await roomMethods.checkIfUserInHotSeat(widget.groupInfo.id.toString(), widget.user.id.toString());
                   var ds = dt.data() as Map;
                   if(dt != null && dt.data() != null && ds['userId'] == widget.user.id.toString() ){
                     _leaveFromHotSeatFirst(context, _bigGroupProvider);
                   }else{
                     _permissionForLeavingGroup(context, _bigGroupProvider);
                   }
                  },) : Container()  : Container(),

                  SizedBox(height: 5,),

                  Container(
                    child: TextButton.icon(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => FlagGroup(profileId: widget.groupInfo.id.toString(), userId: widget.user.id.toString())));
                        },
                        icon: Icon(Icons.flag),
                        label: Text("Report this")
                    ),
                  ),

                  SizedBox(height: 45,),

                ],
              ),
            ),
          ),
        )
      ),
    );
  }


  _showDialogForPrivate(BuildContext buildContext, BigGroupProvider _p){
    return showDialog(
        context: buildContext,
        builder: (context) {
          return SimpleDialog(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(height: 15,),
                    Image.asset("assets/images/private.png", width: 150,),
                    SizedBox(height: 15),
                    Text("This group is private you cant join the group. "
                        "If you want to join this group then You have to "
                        "request owner to send you an invitation to you.",style: fldarkHome16, textAlign: TextAlign.center,),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            icon: Text("Ok",style: TextStyle(
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.w900,
                                color: Colors.green,
                                fontSize: 16
                            )),
                            onPressed: ()  {
                              Navigator.pop(context);
                              // _joinTheGroupRoom(_p);
                            }
                        ),

                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }
    );
  }

  _showPermissionDialog(BuildContext buildContext, BigGroupProvider _p){
    return showDialog(
        context: buildContext,
        builder: (context) {
          return SimpleDialog(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(height: 5,),
                    Image.asset("assets/images/trophy.png", width: 200,),
                    SizedBox(height: 20,),
                    Text("You are welcome to join the group. If you want to join the group then click Yes. "
                        "After clicking Yes you are agree all of the terms and conditions of the group and "
                        "you will get all of group notifications.",style: fldarkHome16,),
                    Text("Are you sure?",style: fldarkgrey15,),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            icon: Text("Yes",style: TextStyle(
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.w900,
                                color: Colors.green,
                                fontSize: 16
                            )),
                            onPressed: ()  {

                              Navigator.pop(context);
                              _joinTheGroupRoom(_p);
                            }
                        ),
                        IconButton(
                          icon: Text("No",style: TextStyle(
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w900,
                              color: Colors.red,
                              fontSize: 16
                          )),
                          onPressed: () {
                            Navigator.pop(context);


                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }
    );
  }


  _showDialogInblackList(BuildContext buildContext, BigGroupProvider _p){
    return showDialog(
        context: buildContext,
        builder: (context) {
          return SimpleDialog(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    Image.asset("assets/images/error.png", width: 140,),
                    SizedBox(height: 15),
                    Text("You are blocked. No longer you will be able to join this group again until you are unblocked by admin",style: fldarkHome16,),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            icon: Text("Exit",style: TextStyle(
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.w900,
                                color: Colors.green,
                                fontSize: 16
                            )),
                            onPressed: ()  {
                              Navigator.pop(context);
                            }
                        ),

                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }
    );
  }


  _leaveFromHotSeatFirst(BuildContext buildContext, BigGroupProvider _p){
    return showDialog(
        context: buildContext,
        builder: (context) {
          return SimpleDialog(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(height: 5,),
                    Image.asset("assets/images/error.png", width: 140,),
                    SizedBox(height: 20,),
                    Text("You have to leave hot seat first then you can leave this group.",style: fldarkHome16,),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            icon: Text("Ok",style: TextStyle(
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.w900,
                                color: Colors.green,
                                fontSize: 16
                            )),
                            onPressed: ()  {
                              Navigator.pop(context);
                            }
                        ),

                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }
    );
  }


  _permissionForLeavingGroup(BuildContext buildContext, BigGroupProvider _p){
    return showDialog(
        context: buildContext,
        builder: (context) {
          return SimpleDialog(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(height: 5,),
                    Image.asset("assets/images/error.png", width: 140,),
                    SizedBox(height: 20,),
                    Text("If you leave this group no longer you will be able to get notification of activities and you will not be able to join voice room untill you join the group again.",style: fldarkHome16,),
                    Text("Are you sure?",style: fldarkgrey15,),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            icon: Text("No",style: TextStyle(
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.w900,
                                color: Colors.green,
                                fontSize: 16
                            )),
                            onPressed: ()  {
                              Navigator.pop(context);
                            }
                        ),
                        IconButton(
                          icon: Text("Yes",style: TextStyle(
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w900,
                              color: Colors.red,
                              fontSize: 16
                          )),
                          onPressed: () {
                            GroupMethods().deleteGroupMembers(groupId: widget
                                .groupInfo.id.toString(),
                                userId: widget.user.id.toString());

                            roomMethods.messageForJoiningTheGroup(msgText:"Leave the group",
                                user: widget.user, groupId: widget.groupInfo.id.toString());
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Index(user: widget.user,)));

                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }
    );
  }



  _joinTheGroupRoom(BigGroupProvider _p) async {
    // add to group member
    // and add to the contact list
    GroupMethods().userJoinedToGroup(
        user: widget.user,
        group: widget.groupInfo,
        role: 3
    );

    // leave a message to notify members of joining to the group
    roomMethods.messageForJoiningTheGroup(msgText:"Join the group",
        user: widget.user,
        groupId: widget.groupInfo.id.toString());

    ContactHome contact = ContactHome(name: widget.groupInfo.name,
        photo: widget.groupInfo.photo, uid: widget.groupInfo.id.toString(),type: "bigGroup");

    // navigate to the running group or chat room
    await _p.getGroupModelData(groupId: widget.groupInfo.id.toString());
    // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatRoomBigGroup(from: widget.user,
    //   toGroupId: widget.groupInfo.id.toString(),
    //   contact: contact , floatButton: false,)));
    Navigator.of(context).pushNamed("/bigGroupChatRoom", arguments:
    {'from': widget.user,
      'toGroupId': widget.groupInfo.id.toString(),
      'contact': contact,
      'floatButton': false,
    });

  }
}




