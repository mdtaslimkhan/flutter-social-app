import 'dart:async';
import 'dart:convert';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/chatroom/big_group_widget/getUserImageByUrl.dart';
import 'package:chat_app/ui/chatroom/chatmethods/chatmethods_big_group.dart';
import 'package:chat_app/ui/chatroom/function/voice_room_methods.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:chat_app/ui/group/big_group/util/goup_methods.dart';
import 'package:chat_app/ui/index.dart';
import 'package:chat_app/ui/pages/feed/controller/feed_controller.dart';
import 'package:chat_app/ui/pages/widgets/progress.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


final _firestore = FirebaseFirestore.instance;


class AddGroupMembers extends StatefulWidget {

  final VoiceRoomMethods roomMethods = VoiceRoomMethods();
  final GroupMethods _groupMethods = GroupMethods();
  final UserModel user;
  final GroupModel groupInfo;
  AddGroupMembers({this.user, this.groupInfo});

  @override
  _AddGroupMembersState createState() => _AddGroupMembersState();
}


class _AddGroupMembersState extends State<AddGroupMembers> {


  Future getAllUserData;
  final Set _saved = Set();
  int membersCount = 0;
  ScrollController _scrollController = ScrollController();
  FeedController _feedController = FeedController();
  bool showLoading = true;


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

    // add group creator to the group
    _saved.add(widget.user.id);

    initfunction();


  }


  StreamSubscription strSubscription;

  initfunction(){

    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        getMorePeople();
      }
    });

    requestAppUser();

    strSubscription = ChatMethodsBigGroup().totalMembersStream(groupId: widget.groupInfo.id.toString())
        .listen((QuerySnapshot snapshot) {
          if(snapshot.docs != null && snapshot.docs.length > 0){
            setState(() {
              membersCount = snapshot.docs.length;
            });

          }
    });
  }



  List<UserModel> peopleList = [];
  int _addPageTopScroll = 2;
  bool tiggredOnceTopScroll = true;
  bool _isBottomLoaderPeople = true;

  requestAppUser() async {
    List<UserModel> uList = await _feedController.getUser(userId: widget.user.id);
    if(uList != null){
      setState(() {
        peopleList = uList;
      });
    }
  }

  getMorePeople() async{
    final http.Response response = await http.get(
        Uri.parse(BaseUrl.baseUrl("userList/${widget.user.id}?page=$_addPageTopScroll")),
        headers: {'test-pass' : ApiRequest.mToken});
    var str = jsonDecode(response.body);
    var data = str['user'];
    var lPages = str['last_page'];
    // add data to list every time when at the and end
    data.forEach((val) {
      peopleList.add(UserModel.fromJson(val));
    });
    // increase page number after fetching data finished
    _addPageTopScroll >= lPages ? _isBottomLoaderPeople = false : _isBottomLoaderPeople = true;
    _addPageTopScroll = _addPageTopScroll + 1;
    // rebuild state when finished loading data
    setState(() {
      // Future getPostItem() will stop adding data when  tiggredOnce = false
      tiggredOnceTopScroll = false;
      // bottom loader will stop showing when data view completed
    });
  }


  checkExist({String id}) async {
   DocumentSnapshot user = await _firestore.collection(BIG_GROUP_COLLECTION)
        .doc(widget.groupInfo.id.toString())
        .collection("members")
        .doc(id)
        .get();
   var dt = user.data() as Map;
   return dt['userId'];
  }

  removeFromGroup({String id}){
    _firestore.collection(BIG_GROUP_COLLECTION)
        .doc(widget.groupInfo.id.toString())
        .collection("members")
        .doc(id)
        .delete();

    _firestore.collection("feed")
        .doc(id)
        .collection("notification")
        .doc(widget.groupInfo.id.toString())
        .delete();
    widget._groupMethods.deleteGroupContactsFromUserHomePage(groupId: widget.groupInfo.id.toString(), userId: id);
  }




  TextEditingController mTextController = TextEditingController();
  clearSearch() async {
    List<UserModel> uList = await _feedController.getUser(userId: widget.user.id);

    mTextController.clear();
    setState(() {
      peopleList = uList;
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
  onTextUpdate(String text) async {
    List<UserModel> gm = await widget._groupMethods.getSearchedUser(uid: widget.user.id.toString(), query: text);

    if(!searchResult) {
      searchResult = true;
    }
    setState(() {
      showLoading = false;
      peopleList = gm;
      queryText = text;
    });
    print(text);
  }

  List<String> _request = [];

  Widget listViewData(List<UserModel> udata){
    return Container(
        child: Column(
          children: [

            Container(
              height: 35,
              margin: EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _request.length,
                              itemBuilder: (context, index) {
                                String photo = _request[index];
                                return Container(
                                  margin: EdgeInsets.only(right: 2),
                                  width: 35,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top:5,
                                        child: GestureDetector(
                                          child: UserImageByPhotoUrl(
                                            photo: photo,
                                          ),
                                          onTap: () {
                                            // _optionModalBottomSheet(context);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                  ),
                  membersCount > 1 ? Container(
                    padding: EdgeInsets.all(5),
                    height: 30,
                    margin: EdgeInsets.only(right: 0,left: 5),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                    child: Text('+${membersCount-1}',style: fldarkgrey10,),
                  ) : Container(),
                ],
              ),
            ),
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
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: udata.length + 1,
                controller: _scrollController,
                itemBuilder: (context, index){
                  if(index == udata.length){
                    if(_isBottomLoaderPeople) {
                      // list.length + 1 the 1 st position for loader
                      return showLoading ? Center(child: CircularProgressIndicator()) : Container();
                    }else{
                      // to stop showing error the loader will replaced by text('') widget
                      return Container();
                    }
                  }

                  return Card(
                    shadowColor: Colors.transparent,
                    margin: EdgeInsets.only(top: 5),
                    child: FutureBuilder<dynamic>(
                      future: checkExist(id: udata[index].id.toString()),
                      builder: (context, snapshot) {
                        return CheckboxListTile(
                          value: udata[index].nValue,
                          onChanged: snapshot.data != udata[index].id.toString() ? (value){
                            setState(() {
                              final newVal = !udata[index].nValue;
                              udata[index].nValue = newVal;
                              if(value){
                                _saved.add(udata[index].id);
                              }else{
                                _saved.remove(udata[index].id);
                              }
                            });

                            if(value) {
                              widget._groupMethods.addGroupMembers(
                                  group: widget.groupInfo,
                                  user: udata[index],
                                  admin: widget.user,
                                  role: 3
                              );
                              _request.add(udata[index].photo);
                            }else{
                              _request.remove(udata[index].photo);
                            }

                          } : null,

                          title: Container(child: Text(udata[index].nName)),
                  //    subtitle: Text(udata[index].number),

                          secondary: CircleAvatar(
                            backgroundImage: udata[index].photo != null ?  NetworkImage(udata[index].photo) : AssetImage('assets/u3.gif'),
                          ),
                        );
                      }
                    ),
                  );
                },
              ),
            ),
          ],
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Add group members",
          style: fldarkgrey18,),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.sort),
            color: Colors.black,
         //   onPressed: () => doSuffle(),
          ),

        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
                child: listViewData(peopleList),
                ),
            SizedBox(height: 10),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
        onPressed: () async {
          for(var ui in _saved){
          //    widget._groupMethods.addGroupMembers(groupId: widget.groupInfo.id.toString(),
          //        userId: ui.toString(), adminId: widget.user.id.toString());
          //    widget._groupMethods.addGroupContactsToUserHomePage(groupId: widget.groupInfo.id.toString(),
          //        userId: ui.toString(), adminId: widget.user.id.toString());
          }

            Navigator.push(context, MaterialPageRoute(builder: (context) => Index(user: widget.user,)));

        },
      ),
    );
  }
}
