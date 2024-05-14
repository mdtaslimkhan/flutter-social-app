import 'dart:convert';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/chatroom/big_group_widget/getUserImageByUrl.dart';
import 'package:chat_app/ui/chatroom/function/voice_room_methods.dart';
import 'package:chat_app/ui/chatroom/model/contact.dart';
import 'package:chat_app/ui/chatroom/provider/big_group_provider.dart';
import 'package:chat_app/ui/group/big_group/util/goup_methods.dart';
import 'package:chat_app/ui/pages/widgets/progress.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:chat_app/ui/pages/error/no_notification.dart';
import 'package:provider/provider.dart';

final _firestore = FirebaseFirestore.instance;
class UserNotification extends StatefulWidget {

  final UserModel user;
  UserNotification({this.user});

  @override
  _UserNotificationState createState() => _UserNotificationState();
}

class _UserNotificationState extends State<UserNotification> with SingleTickerProviderStateMixin {
  final GroupMethods _groupMethods = GroupMethods();

  final VoiceRoomMethods roomMethods = VoiceRoomMethods();

  Box boxGroup;
  List gList = [];

  Future getGroupData() async {
    final String url = BaseUrl.baseUrl("getAllNotification/${widget.user.id.toString()}");
    final http.Response response = await http.get(Uri.parse(url),
      headers: {'test-pass' : ApiRequest.mToken},
    );
    var str = jsonDecode(response.body)['notification'];
    print(widget.user.id.toString());
    return str;
  }

  Future openBox() async{
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    boxGroup = await Hive.openBox("dataNotification");
    return;
  }

  Future getAllData() async {
    await openBox();
    try {
      // api request for getting data
      var gData = await getGroupData();
      // after getting data put into the box
      await putData(gData);

    } catch (SocketException) {
      Fluttertoast.showToast(msg: "No internet available");
    }
    var gMap = boxGroup.toMap().values.toList();
    gList = gMap;
    return gMap;
  }

  putData(data) async{
    await boxGroup.clear();
    // insert data
    for(var dt in data){
      boxGroup.add(dt);
    }
  }


  groupListHolder(BuildContext context) {
      return gList.isNotEmpty ? ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: gList.length,
        itemBuilder: (context, index) {
          return groupItem(context, gList[index]);
        }
    ) : NoNotification();
  }

  groupItem(BuildContext context, var gm){
    return Container(
      child: ListTile(
        leading: Container(
          margin: EdgeInsets.only(left: 0),
          width: 45.0,
          height: 45.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 1.0,
            ),
            //  borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 4,
                offset: Offset(0, 0), // changes position of shadow
              ),

            ],
          ),
          child: CircleAvatar(
            child: cachedNetworkImageCircular(context, gm['photo']),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height:5,),
            Text(gm['title'],style: fldarkHome16,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Text("${gm['description']}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text("${gm['date']}",
              maxLines: 1,
              style: TextStyle(
                fontSize: 10
              ),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height:5,),
          ],
        ),

        onTap: (){
         // Navigator.push(context, MaterialPageRoute(builder: (context) => GroupProfile(user: widget.user, groupInfo: gm)));
        },
      ),
    );
  }

  @override
  void initState() {
    setPreviousData();
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }




  setPreviousData() async{
    await openBox();
    var gMap = boxGroup.toMap().values.toList();
    setState(() {
      gList = gMap;
    });
  }

  removeFromGroup({String id}){
    _firestore.collection("feed")
        .doc(widget.user.id.toString())
        .collection("notification")
        .doc(id)
        .delete();
  }

  TabController _tabController;

  @override
  Widget build(BuildContext context) {
    BigGroupProvider _bgp = Provider.of<BigGroupProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        title: Text("Notification", style: fldarkgrey18,),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(child: Text("All", style: fldarkgrey15,)),
            Tab(child: Text("Group", style: fldarkgrey15,)),
          ],
        ),
      ),
      body: Column(
        children: [

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                RefreshIndicator(
                  onRefresh: () => getAllData(),
                  child: FutureBuilder(
                      future: getAllData(),
                      builder: (context, snapshot) {
                        if(snapshot != null){
                          return gList != null ? groupListHolder(context) : circularProgress();
                        }
                        return Text("No data");
                      }
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: _firestore
                              .collection("feed")
                              .doc(widget.user.id.toString())
                              .collection("notification")
                              .orderBy("timestamp", descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              circularProgress();
                            }

                            if (snapshot.hasData) {
                              if (snapshot.data != null) {
                                var docList = snapshot.data.docs;
                                return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: docList.length,
                                  itemBuilder: (context, index) {
                                    var dt = docList[index].data() as Map;
                                    String guid = dt['groupId'];
                                    String name = dt['name'];
                                    String photo = dt['photo'];
                                    String uid = dt['userId'];
                                    String uName = dt['userName'];
                                    String uPhoto = dt['userPhoto'];
                                    String adminId = dt['adminId'];
                                    Timestamp time = dt['timestamp'];
                                    String mtime = formatTimestamp(time.seconds);
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 10, right: 10, top: 14),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                                Stack(
                                                  children: [
                                                    Positioned(
                                                      child: Container(
                                                        width: 55,
                                                          height: 55,
                                                          child: photo != null ? cachedNetworkImageCircular(context, photo,) : Container()
                                                      ),
                                                    ),
                                                    Positioned(
                                                      bottom: 0,
                                                      right: 0,
                                                      child: Container(
                                                          width: 25,
                                                          height:25,
                                                          decoration: BoxDecoration(
                                                            color: Color(0xff0064fb),
                                                            borderRadius: BorderRadius.all(new Radius.circular(70.0)),
                                                            border: Border.all(
                                                              color: Colors.white,
                                                              width: 1.0,
                                                            ),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors.black.withOpacity(0.3),
                                                                spreadRadius: 2,
                                                                blurRadius: 2,
                                                                offset: Offset(0, 0), // changes position of shadow
                                                              ),
                                                            ],
                                                          ),
                                                          child: uPhoto != null ? cachedNetworkImageCircular(context, uPhoto,) : Container()
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(width: 12,),
                                                Expanded(
                                                //  width: MediaQuery.of(context).size.width - 70,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      uName != null ? Text('$uName',
                                                        style: TextStyle(
                                                        fontSize: 15,
                                                        fontFamily: "Segoe",
                                                        fontWeight: FontWeight.w800,
                                                        color: textColor,
                                                      ),) : Container(),
                                                      Text("invite you to join the $name group and to stay with the group.",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontFamily: "Roboto",
                                                          fontWeight: FontWeight.w600,
                                                          color: textColor
                                                        ),
                                                      ),
                                                      mtime != null ? Text('$mtime', style: TextStyle(
                                                        fontSize: 10,
                                                        fontFamily: "Segoe",
                                                        fontWeight: FontWeight.w800,
                                                        color: textColor,
                                                      ),) : Container(),
                                                    ],
                                                  ),
                                                ),
                                              SizedBox(width: 8,),
                                              Container(
                                                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    GestureDetector(
                                                      child: Container(
                                                        height: 25.0,
                                                        width: 60.0,
                                                        alignment: Alignment.center,
                                                        decoration: const BoxDecoration(
                                                          color: Colors.blueAccent,
                                                          borderRadius: BorderRadius.all(Radius.circular(14.0)),
                                                        ),
                                                        child: Text(
                                                          "Accept",
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 10
                                                          ),
                                                        ),
                                                      ),
                                                      onTap: () async {
                                                        _showPermissionDialog(buildContext: context, bgp: _bgp, guid: guid, uid: uid, adminId: adminId, name: name, photo: photo);
                                                      },
                                                    ),
                                                    SizedBox(height: 10,),
                                                    GestureDetector(
                                                      child: Container(
                                                        height: 25.0,
                                                        width: 60.0,
                                                        alignment: Alignment.center,
                                                        decoration: const BoxDecoration(
                                                          color: Colors.red,
                                                          borderRadius: BorderRadius.all(Radius.circular(14.0)),
                                                        ),
                                                        child: Text(
                                                          "Decline",
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 10
                                                          ),
                                                        ),
                                                      ),
                                                      onTap:  () async {
                                                        removeFromGroup(id: guid);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }
                            }
                            return Text("no data");
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _showPermissionDialog({BuildContext buildContext, BigGroupProvider bgp, String guid, String uid, String adminId, String name, String photo}){
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
                    Image.asset("assets/meeting.png"),
                    SizedBox(height: 20,),
                    Text("If you want to join the group then click Yes. "
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
                              _joinTheGroupRoom(bgp: bgp, guid: guid, uid: uid, adminId: adminId, name: name, photo: photo );
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

  _joinTheGroupRoom({BigGroupProvider bgp, String guid, String uid, String adminId, String name, String photo}) async {
    _firestore.collection(BIG_GROUP_COLLECTION)
        .doc(guid)
        .collection(MEMBERS_COLLECTION)
        .doc(uid)
        .set({
      "role": 3,
      "name" : widget.user.fName + " " +widget.user.nName,
      "groupId": guid,
      "userId": widget.user.id.toString(),
      "photo" : widget.user.photo,
      "adminId" : adminId,
      "timestamp": Timestamp.now(),
    });
    // Contact will be added when user confirem the member ship
    _groupMethods.addGroupContactsToUserHomePage(
        groupId: guid,
        userId: uid,
        adminId: adminId,
        name: name,
        photo: photo
    );
    removeFromGroup(id: guid);

    // leave a message to notify members of joining to the group
    roomMethods.messageForJoiningTheGroup(msgText:"Join the group",
        user: widget.user,
        groupId: guid);

    ContactHome contact = ContactHome(name: name,
        photo: photo, uid: guid,type: "bigGroup");

    // navigate to the running group or chat room
    await bgp.getGroupModelData(groupId: guid);
    // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatRoomBigGroup(from: widget.user,
    //   toGroupId: widget.groupInfo.id.toString(),
    //   contact: contact , floatButton: false,)));

    Navigator.of(context).pushNamed("/bigGroupChatRoom", arguments:
    {'from': widget.user,
      'toGroupId': guid,
      'contact': contact,
      'floatButton': false,
    });

  }
}
