

import 'package:chat_app/ui/pages/login/login_methods.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/controller/profile_controller.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/model/follower_model.dart';
import 'package:flutter/foundation.dart';

class DimondGemFollowProvider extends ChangeNotifier{

  LoginMethods _loginMethods = LoginMethods();
  ProfileController _profileController = ProfileController();

  // var value = 10;
  // UserModel userModel;
  Follow _follows;
  Follow get follows => _follows;

  // getUserByIdProvider(String userId) async {
  //     UserModel um = await _loginMethods.getUserById(uId: userId);
  //     userModel = um;
  //     notifyListeners();
  // }

  getDimondGemFollow(String userId) async {
    var fl  = await _profileController.getFollowrFollowing(userId);
    _follows = fl;
     notifyListeners();
  }




}