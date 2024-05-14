import 'dart:convert';

import 'package:chat_app/ui/pages/profile/personal_profile/controller/profile_controller.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/model/crown_model.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/model/follower_model.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/widget/crown_widget.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../model/post/post.dart';
import '../util/api_request.dart';

class ProfileProvider extends ChangeNotifier{

  ProfileController _profileController = ProfileController();




  bool tiggredOnce = true;
  int _addPage = 2;
  List<Post> _list = [];
  List<Post> get list => _list;

  bool _isBottomLoader = true;
  bool get isBottomLoader  => _isBottomLoader;

  Future getPostItem({String userId}) async{
    print("tiggered firest function");
    _list.clear();
    tiggredOnce = true;
    final http.Response response = await http.get(
        Uri.parse(BaseUrl.baseUrl("postListByUser/$userId")),
        headers: {'test-pass': ApiRequest.mToken});
    var str = jsonDecode(response.body);
    var data = str['posts'] as List;

    if(tiggredOnce) {
      data.forEach((val) {
        _list.add(Post.fromJson(val));
      });
      _list = _list.toSet().toList();
    }
    notifyListeners();
  }

  getMorePostData({String userId}) async{
    print("tringgered more post data");
    final http.Response response = await http.get(
        Uri.parse(BaseUrl.baseUrl("postListByUser/$userId?page=$_addPage")),
        headers: {'test-pass' : ApiRequest.mToken});
    var str = jsonDecode(response.body);
    var data = str['posts'];
    var lPage = str['last_page'];
    // add data to list every time when at the and end
    data.forEach((val) {
      _list.add(Post.fromJson(val));
    });
    _addPage >= lPage ? _isBottomLoader = false : _isBottomLoader = true;
    _addPage = _addPage + 1;
    tiggredOnce = false;
    notifyListeners();
  }




  List<CrownWidget> _crownList = [];
  List<CrownWidget> get crownList => _crownList;


  getProfileCrown({String userId}) async {
    _crownList.clear();
    var dt = await _profileController.getCrownListData(userId);
    if(dt != null){
      dt.forEach((val) {
        var v = Crown.fromJson(val);
        _crownList.add(CrownWidget(
          crown: v,
        ));
      });

    }
    notifyListeners();
  }


  List<Crown> _badge = [];
  List<Crown> get badge => _badge;

  getProfileBadgeList({String userId}) async {
    _badge.clear();
    var dtbdg = await _profileController.getBadgeListData(userId);
    if(dtbdg != null){
      dtbdg.forEach((val) {
        _badge.add(Crown.fromJson(val));
      });
    }
    notifyListeners();
  }


  Follow _follows;
  Follow get follows => _follows;

  getFoloingUsers({String userId}) async {
    var follow  = await _profileController.getFollowrFollowing(userId);
    if(follow != null){
        _follows = follow;
    }
    notifyListeners();
  }



}