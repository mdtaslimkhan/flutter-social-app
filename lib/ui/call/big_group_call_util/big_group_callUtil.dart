import 'dart:convert';
import 'dart:math';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/call/big_group_call_util/big_group_call_method.dart';
import 'package:chat_app/ui/call/model/Call.dart';
import 'package:chat_app/ui/chatroom/model/agora_token_model.dart';
import 'package:chat_app/ui/chatroom/model/group_call.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

final fireStore = FirebaseFirestore.instance;



class CallUtilsBigGroup{
   final CallMethodsBigGroup callMethods = CallMethodsBigGroup();

   mdialGroup({UserModel from, GroupModel group, context}) async {

    // generate channel id
  // String randNum = Random().nextInt(10000000).toString();
   String getRandString(int len) {
     var random = Random.secure();
     var values = List<int>.generate(len, (i) =>  random.nextInt(255));
     return base64UrlEncode(values);
   }

   String randNum = getRandString(30);
   // get server token with channel and user id

   AppIdToken _appIdToken = await getToken(randNum: randNum, fromId: from.id.toString(),groupId: group.id.toString());

   // if token not null then create call
   if(_appIdToken != null) {

    GroupCall call = GroupCall(
      callerId: from.id.toString(),
      callerName: from.nName,
      callerPic: from.photo,
      groupId: group.id.toString(),
      groupName: group.name,
      groupPic: group.photo,
     // channelId: "crapp",
      channelId: randNum,
      mtoken: _appIdToken.token,
      appId: _appIdToken.appId,
      isGroup: true,
      role: ClientRole.Broadcaster,
      isPrivate: group.isPublic != null && ["", null, false, 0, "0", "Private"].contains(group.isPublic)
          ? true : false
     );


      bool callMade = await callMethods.makeQuickCallReal(call: call, groupId: group.id.toString());
      call.hasDialled = true;



      // after crating firebase call return to Callscreen
      if (callMade) {

          return call;

      }
     // dont know why this is null returned previously
    //  return null;

    }

  }

  Future<AppIdToken> getToken({String randNum, String fromId, String groupId}) async{
    try {
      final String url = BaseUrl.baseUrl("aToken");
      final http.Response rs = await http.post(Uri.parse(url), headers: {'test-pass': ApiRequest.mToken},
          body: {
            'channelId': randNum,
            'user_id' : fromId,
            'receiver_id' : groupId,
            'is_call' : '0',
          });
      var str = jsonDecode(rs.body);
      AppIdToken _apidtoken = AppIdToken.fromMap(str);
      return _apidtoken;
    }catch (e) {
      print(e.message);
      return null;
    }
  }

}

