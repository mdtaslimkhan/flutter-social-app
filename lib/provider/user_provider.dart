import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/controller/profile_controller.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier{
  ProfileController _profileController = ProfileController();

  UserModel _user;
  UserModel get user => _user;

  getUser({String userId}) async{
   var usr = await _profileController.getPorfileData(userId);
   if(usr != null) {
     UserModel u = UserModel.fromJson(usr);
     _user = u;
   }
   notifyListeners();
  }

}