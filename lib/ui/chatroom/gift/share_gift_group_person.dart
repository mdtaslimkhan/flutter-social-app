import 'dart:convert';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/chatroom/gift/gift_user_model.dart';
import 'package:chat_app/ui/chatroom/model/gift.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final _fireStore = FirebaseFirestore.instance;


class ShareGiftUserList extends StatefulWidget {

  final Gift gift;
  final GroupModel group;
  final UserModel user;
  ShareGiftUserList({this.gift, this.group,this.user});

  @override
  _ShareGiftUserListState createState() => _ShareGiftUserListState();
}

class _ShareGiftUserListState extends State<ShareGiftUserList> {

  final Set _saved = Set();
  List<GiftUserModel> uList = [];
  Future getHotSeatList;
  Future getHostUser;

  @override
  void initState() {
    super.initState();
    getHostUser = getHost();
    getHotSeatList = getHotSeatUserList();
  }
  getHost() async {
    var data = await _fireStore
        .collection(BIG_GROUP_COLLECTION)
        .doc(widget.group.id.toString())
        .collection("hostId")
        .get();
    data.docs.forEach((val) {
      // replace hostId with hostId to marge hostId and hotSeat
      uList.add(GiftUserModel(name: val.data()['name'], photo: val.data()['photo'], userId: val.data()['hostId']));
    });
    setState(() {});
  }

  getHotSeatUserList() async {
   var data = await _fireStore
        .collection(BIG_GROUP_COLLECTION)
        .doc(widget.group.id.toString())
        .collection("hotSeat")
        .get();
   data.docs.forEach((val) {
     uList.add(GiftUserModel.fromJson(val.data()));
   });
   setState(() {});
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select to share with people"),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
                child: ListView.builder(
                        itemCount: uList.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: EdgeInsets.fromLTRB(0, 5.0,0, 0),
                            child: CheckboxListTile(
                              value: uList[index].nValue,
                              onChanged: (value){
                                setState(() {
                                  final newVal = !uList[index].nValue;
                                  uList[index].nValue = newVal;
                                  if(value){
                                    _saved.add(uList[index].userId);
                                  }else{
                                    _saved.remove(uList[index].userId);
                                  }
                                });
                              
                              },
                              title: Container(child: Text("${uList[index].name}")),
                              secondary: CircleAvatar(
                                backgroundImage: uList[index].photo != null ?  NetworkImage(uList[index].photo) : AssetImage('assets/u3.gif'),
                              ),
                            ),
                          );
                        },
            ),
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

          if(_saved != null) {
            final String url = BaseUrl.baseUrl('mShareGift');
            final response = await http.post(Uri.parse(url),
                headers: {'test-pass': ApiRequest.mToken},
                body: {
                  'aList': "${_saved.toString()}",
                  'diamond_value': "${widget.gift.diamond}",
                  'who_sharing': "${widget.user.id}",
                  'img': "${widget.gift.img}",
                  'title': "${widget.gift.title}",
                });
            Map data = jsonDecode(response.body);

          
          }


         var count = 0;
          Navigator.popUntil(context, (route) {
            return count++ == 2;
          });
          //  Navigator.pop(context, [_saved, widget.diamond]);
          //  var st = await getUser();
          

        },
      ),
    );
  }
}
