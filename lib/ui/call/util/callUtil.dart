import 'dart:convert';
import 'dart:math';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/call/call_method.dart';
import 'package:chat_app/ui/call/callscreens/callscreen.dart';
import 'package:chat_app/ui/call/callscreens/callscreenaudio.dart';
import 'package:chat_app/ui/call/model/Call.dart';
import 'package:chat_app/ui/chatroom/model/agora_token_model.dart';
import 'package:chat_app/ui/pages/home/controller/homeController.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class CallUtils{
  static final CallMethods callMethods = CallMethods();
  static final HomeController _hController = HomeController();

  static mdial({UserModel from, String toUserId, context, int type}) async {

    UserModel toUser = await _hController.getUserById(toUserId);

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
           body: {
              'channelId': randNum,
             'user_id' : from.id.toString(),
             'receiver_id' : toUserId.toString(),
             'is_call' : '1',
             'call_type' : type.toString()
       });
       var str = jsonDecode(rs.body);
       AppIdToken _appIdToken = AppIdToken.fromMap(str);
       return _appIdToken;
     }catch (e) {
       print(e.message);
       return null;
     }
   }

    AppIdToken _appidtoken = await getToken();

   // if token not null then create call
   if(_appidtoken != null) {

    Call call = Call(
      callerId: from.id.toString(),
      callerName: from.nName,
      callerPic: from.photo,
      receiverId: toUser.id.toString(),
      receiverName: toUser.nName,
      receiverPic: toUser.photo,
     // channelId: "crapp",
      channelId: randNum,
      mtoken: _appidtoken.token,
      appId: _appidtoken.appId,
      type: type,
      isGroup: false,
      onCallReceived: false,
    );


      bool callMade = await callMethods.makeCall(call: call);
      call.hasDialled = true;

      // after crating firebase call return to Callscreen
      if (callMade) {

        return call;
        // Navigator.push(context, MaterialPageRoute(builder: (context) =>
        //     VoiceOrVideoCall(call: call,
        //         from: from,
        //         to: to,
        //         role: ClientRole.Broadcaster,
        //         token: token,
        //         callType : type
        //     )));

        // if(type == 1) {
        //   Navigator.push(context, MaterialPageRoute(builder: (context) =>
        //       CallVoice(
        //          // call: call,
        //           from: from,
        //           role: ClientRole.Broadcaster,
        //          // token: token,
        //          // type: type
        //       )));
        // }else {
        //   Navigator.push(context, MaterialPageRoute(builder: (context) =>
        //       CallScreen(
        //          // call: call,
        //           from: from,
        //           role: ClientRole.Broadcaster,
        //         //  token: token,
        //         //  type: type
        //       )));
        // }
      }
    }

  }
}