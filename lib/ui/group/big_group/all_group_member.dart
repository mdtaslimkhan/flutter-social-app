import 'dart:async';
import 'dart:convert';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/provider/user_provider.dart';
import 'package:chat_app/ui/chatroom/big_group_widget/listOfGroupUser.dart';
import 'package:chat_app/ui/chatroom/chatmethods/chatmethods_big_group.dart';
import 'package:chat_app/ui/chatroom/provider/big_group_provider.dart';
import 'package:chat_app/ui/group/big_group/bottom_block_list.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:chat_app/ui/group/big_group/util/goup_methods.dart';
import 'package:chat_app/ui/group/widgets/user_group_setting.dart';
import 'package:chat_app/ui/pages/widgets/progress.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';


final _firestore = FirebaseFirestore.instance;


class AllGroupMembers extends StatefulWidget {

  final GroupMethods _groupMethods = GroupMethods();
  final UserModel user;
  final GroupModel groupInfo;
  final bool isAdmin;
  AllGroupMembers({this.user, this.groupInfo,this.isAdmin});

  @override
  _AllGroupMembersState createState() => _AllGroupMembersState();
}


class _AllGroupMembersState extends State<AllGroupMembers> {


  Future getAllUserData;
  final Set _saved = Set();
  int membersCount = 0;
  bool isAdmin = false;

  getUser() async {
    List<UserModel> list;
    final http.Response response = await http.get(
        Uri.parse(BaseUrl.baseUrl("userList/${widget.user.id}")),
        headers: {'test-pass' : ApiRequest.mToken});
    var str = jsonDecode(response.body);
    var data = str['user'] as List;
    list = data.map<UserModel>((data) => UserModel.fromJson(data)).toList();
    try{
      if(response.statusCode == 200) {
        return list;
      }else{
        return null;
      }
    }catch(e){
      return null;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    strSubscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // prevent firing multiple time
    getAllUserData = getUser();
    // add group creator to the group
    _saved.add(widget.user.id);
    addPostFrameCallBack();


  }


  StreamSubscription strSubscription;

  addPostFrameCallBack(){
    strSubscription = ChatMethodsBigGroup().totalMembersStream(groupId: widget.groupInfo.id.toString())
        .listen((QuerySnapshot snapshot) {
          if(snapshot.docs != null && snapshot.docs.length > 0){
            setState(() {
              membersCount = snapshot.docs.length;
            });

          }
    });
  }

  TextEditingController mTextController = TextEditingController();
  clearSearch() {
    mTextController.clear();
    setState(() {
      searchResult = false;
    });
  }

  handleSearch(String result){
  //  UserProvider _u = Provider.of<UserProvider>(context, listen: false);
  }

  bool suffle = false;
  doSuffle(){
    setState(() {
      !suffle ? suffle = true : suffle = false;
    });
    print("sufl");
  }

  bool searchResult = false;
  String queryText = "";
  onTextUpdate(String text){
    if(!searchResult) {
      searchResult = true;
    }
    setState(() {
      queryText = text;
    });
    print(text);
  }


  @override
  Widget build(BuildContext context) {
    BigGroupProvider _bgp = Provider.of<BigGroupProvider>(context);
    print("admin value");
    print(_bgp.toGroup.admin);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Group members",
        style: fldarkgrey18,),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.sort),
            color: Colors.black,
            onPressed: () => doSuffle(),
          ),
         _bgp.toGroup.admin == widget.user.id ? IconButton(
            icon: Icon(Icons.block),
            color: Colors.black,
            onPressed: () => _blockList(context),
          ) : Container(),

        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: 55,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0xffe5e5e5),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 16,
                      offset: Offset(0, 8),
                      color: Colors.green,
                      spreadRadius: -10)
                ],
                border: Border.all(
                  color: Colors.white,
                  width: 2.0,
                ),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection(BIG_GROUP_COLLECTION)
                    .doc(widget.groupInfo.id.toString())
                    .collection("members")
                    .snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    return Center(child: Text("Number of members ${snapshot.data.docs.length} ( Limit 500 )", style: fldarkgrey15,),);
                  }
                  return Center(child: Text("Number of members ( Limit 500 )", style: fldarkgrey15,),);
                }
              ),
            ),
            SizedBox(height: 0,),
            Container(
              height: 45,
              child: TextFormField(
                controller: mTextController..text,
                style: fldarkgrey12,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide( color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide( color: Color(0xffffffff)),
                  ),
                  hintText: 'Search',
                  hintStyle: TextStyle(
                      fontSize: 12,
                      color: Color(0xff7d7d7d)
                  ),
                  labelStyle: TextStyle(
                      fontSize: 12
                  ),
                  prefixIcon: IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onPressed: clearSearch,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.grey,
                      size: 15,
                    ),
                    onPressed: clearSearch,
                  ),
                ),
                onFieldSubmitted: handleSearch,
                onChanged: (val) => onTextUpdate(val),
              ),
            ),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream:  !searchResult ? _firestore
                      .collection(BIG_GROUP_COLLECTION)
                      .doc(widget.groupInfo.id.toString())
                      .collection("members")
                      .orderBy('role', descending: suffle ? true : false)
                     // .orderBy('timestamp', descending: false)
                      .snapshots() : _firestore
                    .collection(BIG_GROUP_COLLECTION)
                    .doc(widget.groupInfo.id.toString())
                    .collection("members")
                    .where("name", isGreaterThanOrEqualTo: queryText)
                    .where("name", isLessThanOrEqualTo: queryText + "\uf7ff")
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
                            String uid = dt['userId'];
                            String uName = dt['name'];
                            String photo = dt['photo'];
                            Timestamp time = dt['timestamp'];
                            int role = dt['role'];
                            bool mute = dt['mute'];
                            print(time.toDate());

                            return GestureDetector(
                              child: GroupUserListItem(
                                  name: uName,
                                  userId: uid,
                                  userPhoto: photo,
                                  time: time,
                                  user: widget.user,
                                  group: widget.groupInfo,
                                  role: role,
                                  mute: mute
                              ),
                              onTap: () {
                                if(widget.isAdmin) {
                                  if(uid != widget.groupInfo.admin.toString()) {
                                    Navigator.push(context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UserGroupSetting(
                                                    userId: uid,
                                                    name: uName,
                                                    photo: photo,
                                                    group: widget.groupInfo,
                                                    admin: widget.user,
                                                )));
                                  }
                                }
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
            SizedBox(height: 10),
          ],
        ),
      ),

    );
  }


  void _blockList(BuildContext context){
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0))),
        backgroundColor: Colors.black87,
        builder: (BuildContext bc){
          return StatefulBuilder(
              builder: (BuildContext bc, StateSetter setState) {
                return BottomBlockList(group: widget.groupInfo, admin: widget.user);
              }
          );
        }
    );
  }

}
