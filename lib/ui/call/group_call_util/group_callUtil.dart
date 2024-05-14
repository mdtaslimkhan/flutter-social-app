import 'dart:convert';
import 'dart:math';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/call/callscreens/callscreen.dart';
import 'package:chat_app/ui/call/callscreens/group/callscreenaudio_group.dart';
import 'package:chat_app/ui/call/group_call_util/group_call_method.dart';
import 'package:chat_app/ui/call/model/Call.dart';
import 'package:chat_app/ui/chatroom/model/agora_token_model.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final fireStore = FirebaseFirestore.instance;



class CallUtilsGroup{
  static final CallMethodsGroup callMethods = CallMethodsGroup();

  static mdialGroup({UserModel from, GroupModel to, context, int type}) async {

    // generate channel id
  // String randNum = Random().nextInt(10000000).toString();
   String getRandString(int len) {
     var random = Random.secure();
     var values = List<int>.generate(len, (i) =>  random.nextInt(255));
     return base64UrlEncode(values);
   }

   String randNum = getRandString(30);
   // get server token with channel and user id
   Future<AppIdToken> getToken() async{
     try {
       final String url = BaseUrl.baseUrl("aToken");
       final http.Response rs = await http.post(Uri.parse(url), headers: {'test-pass': ApiRequest.mToken},
           body: {'channelId': randNum,'user_id' : from.id.toString(), 'receiver_id' : to.id.toString()});
       var str = jsonDecode(rs.body);
       AppIdToken _apidtoken = AppIdToken.fromMap(str);
       return _apidtoken;
     }catch (e) {
       print(e.message);
       return null;
     }
   }

   AppIdToken _appIdToken = await getToken();

   // if token not null then create call
   if(_appIdToken != null) {

    Call call = Call(
      callerId: from.id.toString(),
      callerName: from.nName,
      callerPic: from.photo,
      receiverId: to.id.toString(),
      receiverName: to.name,
      receiverPic: to.photo,
     // channelId: "crapp",
      channelId: randNum,
      mtoken: _appIdToken.token,
      type: type,
      isGroup: true
    );



      bool callMade = await callMethods.makeCall(call: call, groupId: to.id.toString());
      call.hasDialled = true;

      // after crating firebase call return to Callscreen
      if (callMade) {
        // Navigator.push(context, MaterialPageRoute(builder: (context) =>
        //     VoiceOrVideoCall(call: call,
        //         from: from,
        //         to: to,
        //         role: ClientRole.Broadcaster,
        //         token: token,
        //         callType : type
        //     )));

        if(type == 1) {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              CallVoiceGroup(
                  call: call,
                  from: from,
                 // to: to,
                  role: ClientRole.Broadcaster,
                  appIdToken: _appIdToken,
                  type: type
              )));
        }else {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              CallScreen(
                 // call: call,
                  from: from,
                //  to: to,
                  role: ClientRole.Broadcaster,
                 // token: token,
                 // type: type
              )));
        }
      }
    }

  }

}