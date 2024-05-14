

import 'dart:convert';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:chat_app/ui/pages/home/tophorizontalscroller.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:move_to_background/move_to_background.dart';
final _fireStore = FirebaseFirestore.instance;

class HomeController{

  List<Topseconscroller> topsecondscroller = [
    Topseconscroller(1,10,'img','text'),
    Topseconscroller(2,10,'img','text'),
    Topseconscroller(3,10,'img','text'),
    Topseconscroller(4,10,'img','text'),
    Topseconscroller(1,10,'img','text'),
    Topseconscroller(2,10,'img','text'),
    Topseconscroller(3,10,'img','text'),
    Topseconscroller(4,10,'img','text'),
    Topseconscroller(1,10,'img','text'),
  ];











  Future<String> submitDeviceToken({String userid, String token}) async{
    try {
      final String url = BaseUrl.baseUrl("nDeviceToken");
      final http.Response rs = await http.post(Uri.parse(url), headers: {'test-pass': ApiRequest.mToken},
          body: {'user_id' : userid , 'token': token,});
      var str = jsonDecode(rs.body);
      var data = str['message'];
      return data;

    }catch (e) {
      print(e.message);
      return null;
    }
  }


  Future<GroupModel> getGroupById(String uId) async {
    try {
      final String url = BaseUrl.baseUrl("getGroupByGroup/$uId");
      final http.Response rs = await http.get(Uri.parse(url),
          headers: { 'test-pass': ApiRequest.mToken});
      var data = jsonDecode(rs.body);
      var groupData = data["group"];
      print("prgdata");
      print(groupData);
      // first check if group data exist or not
      if (!groupData.isEmpty) {
        GroupModel u = GroupModel.fromJson(groupData);
        return u;
      } else {
        return null;
      }
    }catch (e) {
      print(e);
    }

  }

  DateTime currentBackPressTime;
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Tap again to exit");
      return Future.value(false);
    }
    MoveToBackground.moveTaskToBack();
    return Future.value(false);
  }

  // data for personal messages
  Future<UserModel> getUserById(String uId) async {
    try {
      final String url = BaseUrl.baseUrl("requstUser/$uId");
      final http.Response rs = await http.get(Uri.parse(url),
          headers: { 'test-pass': ApiRequest.mToken});
      Map data = jsonDecode(rs.body);
      UserModel u = UserModel.fromJson(data);
      return u;
    }catch(e){
      print(e);
    }
  }

  void getStreamMessage({UserModel user}) async {
    await for (var msg in _fireStore.collection(CONTACTS_COLLECTION)
        .doc(user.id.toString())
        .collection(CONTACT_COLLECTION)
        .orderBy('added_on', descending: true)
        .snapshots()) {
      for (var m in msg.docs) {
   
      }
    }
  }



















}