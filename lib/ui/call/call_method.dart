import 'dart:convert';

import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/ui/call/model/Call.dart';
import 'package:http/http.dart' as http;

final _fireStore = FirebaseFirestore.instance;

class CallMethods{
  final CollectionReference collection = FirebaseFirestore.instance.collection(CALL_COLLECTION);

  Stream<DocumentSnapshot> callStream({String uid}) => _fireStore.collection("call").doc(uid).snapshots();
  Future<DocumentSnapshot> getCallData({String uid}) { _fireStore.collection("call").doc(uid).get();}

  Future<bool> makeCall({Call call}) async {
    try {
      call.hasDialled = true;
      Map<String, dynamic> hasDialledMap = call.toMap(call);

      call.hasDialled = false;
      Map<String, dynamic> hasNotDialledMap = call.toMap(call);

      await collection.doc(call.callerId).set(hasDialledMap);
      await collection.doc(call.receiverId).set(hasNotDialledMap);
      return true;
    }catch (e) {
      print(e.message);
      return false;
    }


  }

  Future<bool> endCall({Call call}) async {
    try {
      await _stopCallOtherUser(call);
      await collection.doc(call.callerId).delete();
      await collection.doc(call.receiverId).delete();
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