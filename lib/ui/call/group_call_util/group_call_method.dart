import 'dart:convert';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/ui/call/model/Call.dart';
import 'package:http/http.dart' as http;

final _fireStore = FirebaseFirestore.instance;

class CallMethodsGroup{
  final CollectionReference collection = FirebaseFirestore.instance.collection(CALL_COLLECTION);

  Stream<DocumentSnapshot> callStream({String uid}) => _fireStore.collection("call").doc(uid).snapshots();

  Future<bool> makeCall({Call call, String groupId}) async {

    try {
      call.hasDialled = true;
      Map<String, dynamic> hasDialledMap = call.toMap(call);

      call.hasDialled = false;
      Map<String, dynamic> hasNotDialledMap = call.toMap(call);

      QuerySnapshot qs = await _fireStore.collection("groups").doc(groupId).collection("members").get();
      for(var m in qs.docs){
        var dt = m.data() as Map;
        if(dt["userId"] == call.callerId) {
          await collection.doc(call.callerId).set(hasDialledMap);
        }else {
          await collection.doc(dt["userId"]).set(hasNotDialledMap);
        }
      }
      return true;
    }catch (e) {
      print(e.message);
      return false;
    }


  }

  Future<bool> endCall({Call call, UserModel user}) async {
    try {
      await _stopCallOtherUser(call);
      if(call.callerId == user.id.toString()) {
        QuerySnapshot qs = await _fireStore.collection("groups").doc(
            call.receiverId).collection("members").get();
        for (var m in qs.docs) {
          var dt = m.data() as Map; 
          if (dt["userId"] == call.callerId) {
            await collection.doc(call.callerId).delete();
          } else {
            await collection.doc(dt["userId"]).delete();
          }
        }
      }else{
        await collection.doc(user.id.toString()).delete();
      }
      return true;
    }catch(e){
      print(e.message);
      return false;
    }
  }

  // stop call notification to the receiver end
  Future<String> _stopCallOtherUser(Call call) async{
    try {
      final String url = BaseUrl.baseUrl("stopNotification");
      final http.Response rs = await http.post(Uri.parse(url), headers: {'test-pass': ApiRequest.mToken},
          body: {'channel': call.channelId,'user_id' : call.callerId, 'receiver_id' : call.receiverId});
      var str = jsonDecode(rs.body);
      var data = str['token'];
      return data;
    }catch (e) {
      print(e.message);
      return null;
    }
  }



}