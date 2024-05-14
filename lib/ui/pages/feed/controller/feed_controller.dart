

import 'dart:convert';

import 'package:chat_app/model/post/post.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/pages/home/tophorizontalscroller.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;


class PostList{
  PostList();
  List<Post> list = [];
  List<Post> offlineList = [];
}

class FeedController{

  ValueNotifier<PostList> posts = ValueNotifier(PostList());
  ValueNotifier<bool> isOffline = ValueNotifier(false);

  // post getting from server
  Future getPostItemTxt({String userId}) async{
    print("nojglahkfjsj $userId");
    try {
      final http.Response response = await http.get(
          Uri.parse(BaseUrl.baseUrl("getFeeds/$userId")),

        //  Uri.parse(BaseUrl.baseUrl("postListDev/$userId")),
          headers: {'test-pass': ApiRequest.mToken});
      var str = jsonDecode(response.body);
      var data = str['posts'];
      print(data);
      return data;
    }catch (SocketException){
      Fluttertoast.showToast(msg: "No internet");
    }
  }


   Future getUser({int userId}) async {
    try {
      List<UserModel> list;
      final http.Response response = await http.get(
          Uri.parse(BaseUrl.baseUrl("userList/$userId")),
          headers: {'test-pass': ApiRequest.mToken});
      var str = jsonDecode(response.body);
      var data = str['user'] as List;
      list = data.map<UserModel>((data) => UserModel.fromJson(data)).toList();
      try {
        if (response.statusCode == 200) {
          return list;
        } else {
          return null;
        }
      } catch (e) {
        return null;
      }
    }catch (SocketException){
     // Fluttertoast.showToast(msg: "Please check your internet connection");
    }
  }

}