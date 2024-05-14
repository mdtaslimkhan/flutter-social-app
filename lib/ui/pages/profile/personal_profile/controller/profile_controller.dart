

import 'dart:convert';

import 'package:chat_app/model/quotes.dart';
import 'package:chat_app/ui/pages/home/tophorizontalscroller.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/model/follower_model.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileController{

  // badges list
  List<Topseconscroller> topBadges = [
    Topseconscroller(1,10,'img','text'),
    Topseconscroller(2,10,'img','text'),
    Topseconscroller(3,10,'img','text'),
    Topseconscroller(4,10,'img','text'),
    Topseconscroller(5,10,'img','text'),
    Topseconscroller(6,10,'img','text'),
    Topseconscroller(7,10,'img','text'),
    Topseconscroller(8,10,'img','text'),
    Topseconscroller(9,10,'img','text'),
    Topseconscroller(10,10,'img','text'),
    Topseconscroller(11,10,'img','text'),
  ];

  // ratings star
  List<Topseconscroller> rateStar = [
    Topseconscroller(1,10,'img','text'),
    Topseconscroller(2,10,'img','text'),
    Topseconscroller(3,10,'img','text'),
    Topseconscroller(2,10,'img','text'),
    Topseconscroller(3,10,'img','text'),
  ];

  // week duration
  List<Topseconscroller> weekStart = [
    Topseconscroller(1,10,'img','text'),
    Topseconscroller(2,10,'img','text'),
    Topseconscroller(3,10,'img','text'),
    Topseconscroller(2,10,'img','text'),
    Topseconscroller(3,10,'img','text'),
    Topseconscroller(2,10,'img','text'),
  ];


  List<Quotes> groupDetails = [
    Quotes(5, 'Own page' , 'Hello, Assalamualikum, Kemon asen?'),
    Quotes(6, 'Favorite local group' , 'Hello, Assalamualikum, Kemon asen?'),
    Quotes(7, 'Favorite community' , 'Hello, Assalamualikum, Kemon asen?'),
    Quotes(8, 'Own group' , 'Hello, Assalamualikum, Kemon asen?'),
    Quotes(9, 'Vip center' , 'Hello, Assalamualikum, Kemon asen?'),
    Quotes(2, 'Find friends' , 'Hello, Assalamualikum, Kemon asen?'),
  ];


  // badges earned
  List<Quotes> badgeEarned = [
    Quotes(1, 'Gifts' , 'Hello, Assalamualikum, Kemon asen?'),
    Quotes(2, 'Visitors' , 'Hello, Assalamualikum, Kemon asen?'),
    Quotes(3, 'Groups' , 'Hello, Assalamualikum, Kemon asen?'),
  ];

  getPorfileData(String uid) async {
    try {
      final String url = BaseUrl.baseUrl('requstUser/$uid');
      final http.Response rs = await http.get(
          Uri.parse(url), headers: { 'test-pass': ApiRequest.mToken});
      if(rs.statusCode == 200) {
        Map data = jsonDecode(rs.body);
        return data;
      }else{
        return null;
      }
    }catch(e){
      print(e);
    }
  }

  getCrownListDataGroup(String uid) async {
    final String url = BaseUrl.baseUrl('getCrownGroup/$uid');
    final http.Response rs = await http.get(Uri.parse(url), headers: { 'test-pass' : ApiRequest.mToken } );
    Map data = jsonDecode(rs.body);
    return data['crown'];
  }

  getCrownListData(String uid) async {
    final String url = BaseUrl.baseUrl('getCrown/$uid');
    final http.Response rs = await http.get(Uri.parse(url), headers: { 'test-pass' : ApiRequest.mToken } );
    Map data = jsonDecode(rs.body);
    return data['crown'];
  }

  getBadgeListData(String uid) async {
    final String url = BaseUrl.baseUrl('getBadge/$uid');
    final http.Response rs = await http.get(Uri.parse(url), headers: { 'test-pass' : ApiRequest.mToken } );
    Map data = jsonDecode(rs.body);
    return data['badge'];
  }

  getGiftListData(String uid) async {
    final String url = BaseUrl.baseUrl('getUserGift/$uid');
    final http.Response rs = await http.get(Uri.parse(url), headers: { 'test-pass' : ApiRequest.mToken } );
    Map data = jsonDecode(rs.body);
    var mlist = data['usergift'];
    return mlist;
  }

  getFollowrFollowing(String uid) async {
    try {
      final String url = BaseUrl.baseUrl('getFollowrFollowing/$uid');
      final http.Response rs = await http.get(
          Uri.parse(url), headers: { 'test-pass': ApiRequest.mToken});
      Map data = jsonDecode(rs.body);
      var flo = Follow.fromJson(data);
      return flo;
    }catch(e){
      print(e);
    }
  }

  followRequest({String followerId, String userId}) async{
    final String url = BaseUrl.baseUrl('followUser');
    final response = await http.post(Uri.parse(url),
        headers: {'test-pass' : ApiRequest.mToken},
        body: {
          'follower_id' : followerId,
          'post_id' : '',
          'user_id': userId,
        });
    Map data = jsonDecode(response.body);
    print(data);


  }


  blockRequest({String blockedId, String userId}) async{
    final String url = BaseUrl.baseUrl('blockUser');
    final response = await http.post(Uri.parse(url),
        headers: {'test-pass' : ApiRequest.mToken},
        body: {
          'user_id' : userId,
          'blocked_id' : blockedId,
        });
    Map data = jsonDecode(response.body);
    print(data);
    return data;
    }

  unfollowUser({String followerId, String userId}) async{
    final String url = BaseUrl.baseUrl('unFollowUser');
    final response = await http.post(Uri.parse(url),
        headers: {'test-pass' : ApiRequest.mToken},
        body: {
          'follower_id' : userId,
          'post_id' : '',
          'user_id': followerId,
        });
    Map data = jsonDecode(response.body);
    print(data);


  }





}