import 'dart:convert';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/chatroom/function/voice_room_methods.dart';
import 'package:chat_app/ui/chatroom/model/gift.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class SendGiftBigGroup{


  final VoiceRoomMethods roomMethods = VoiceRoomMethods();


  sendGiftToUser({Gift gift , Set saved, UserModel from, GroupModel toGroup}) async {
    if(saved != null) {
      try {
        final String url = BaseUrl.baseUrl('mShareGift');
        final response = await http.post(Uri.parse(url),
            headers: {'test-pass': ApiRequest.mToken},
            body: {
              'aList': "${saved.toString()}",
              'diamond_value': "${gift.diamond}",
              'who_sharing': "${from.id}",
              'img': "${gift.img}",
              'title': "${gift.title}",
            });
        Map data = jsonDecode(response.body);

        if (data != null && data['error'] != true) {
          if (gift.video != null) {
            // setState(() {
            //   animationUrl = gift.video;
            //   _animationController.forward(from: 500);
            // });
            // roomMethods.setGiftType(from: from,
            //     groupId: toGroup.id.toString(),
            //     gift: gift);

            for(var id in saved ) {
              roomMethods.setGiftList(from: from,
                  groupId: toGroup.id.toString(),
                  gift: gift, toId: id);
            }

          }
        } else {
          Fluttertoast.showToast(
            msg: data['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      }catch(e){
        print(e);
      }

      // mention list will be sent to this active member list
      // final uList = await roomMethods.getAllActiveMembersList(toGroup.id.toString());
      // for(var  u in uList.docs){
      //   try {
      //     if(u.data()['user_id'] != null)
      //       await roomMethods.usersGiftMention(from: widget.from,
      //           group: toGroup,
      //           toId: u.data()['user_id']);
      //   }catch(e){
      //     print(e);
      //   }

      // }






    }
  }


  //
  // _sendGiftToUser({Gift gift}) async {
  //   if(_saved != null) {
  //
  //     print("====================>>>>>>>>>>>>>>>>>>>>gift list");
  //     print(_saved);
  //     try {
  //       final String url = BaseUrl.baseUrl('mShareGift');
  //       final response = await http.post(url,
  //           headers: {'test-pass': ApiRequest.mToken},
  //           body: {
  //             'aList': "${_saved.toString()}",
  //             'diamond_value': "${gift.diamond}",
  //             'who_sharing': "${widget.from.id}",
  //             'img': "${gift.img}",
  //             'title': "${gift.title}",
  //           });
  //       Map data = jsonDecode(response.body);
  //
  //       if (data != null && data['error'] != true) {
  //         if (gift.video != null) {
  //           // setState(() {
  //           //   animationUrl = gift.video;
  //           //   _animationController.forward(from: 500);
  //           // });
  //           roomMethods.setGiftType(from: widget.from,
  //               groupId: toGroup.id.toString(),
  //               video: gift.video, image: gift.img);
  //
  //           for(var id in _saved ) {
  //             roomMethods.setGiftList(from: widget.from,
  //                 groupId: toGroup.id.toString(),
  //                 video: gift.video, toId: id);
  //           }
  //
  //
  //
  //         }
  //       } else {
  //         Fluttertoast.showToast(
  //           msg: data['message'],
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.BOTTOM,
  //         );
  //       }
  //     }catch(e){
  //       print(e);
  //     }
  //
  //     // mention list will be sent to this active member list
  //     // final uList = await roomMethods.getAllActiveMembersList(toGroup.id.toString());
  //     // for(var  u in uList.docs){
  //     //   try {
  //     //     if(u.data()['user_id'] != null)
  //     //       await roomMethods.usersGiftMention(from: widget.from,
  //     //           group: toGroup,
  //     //           toId: u.data()['user_id']);
  //     //   }catch(e){
  //     //     print(e);
  //     //   }
  //
  //     // }
  //
  //
  //
  //
  //
  //
  //   }
  // }




}