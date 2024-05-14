
import 'package:chat_app/ui/index.dart';
import 'package:chat_app/ui/pages/login/login_options.dart';
import 'package:chat_app/ui/pages/login/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class LoginMethods{



  Future<void> setUser(UserModel n) async {
    var sfm = await SharedPreferences.getInstance();
    sfm.setInt('id', n.id);
    sfm.setString('fName', n.fName != null ? n.fName : "");
    sfm.setString('nName', n.nName != null ? n.nName : "");
    sfm.setString('number', n.number != null ? n.number : "");
    sfm.setString('photo', n.photo != null ? n.photo : "");
    sfm.setString('cover', n.cover != null ? n.cover : "");
    sfm.setString('gender', n.gender != null ? n.gender : '' );
    sfm.setInt('is_active', n.isActive != null ? n.isActive : 1);
  }

  Future<UserModel> getUser() async {
    try {
     // SharedPreferences.setMockInitialValues({});
      var sfm = await SharedPreferences.getInstance();
      UserModel u = UserModel(
        id: sfm.getInt('id'),
        fName: sfm.getString('fName'),
        nName: sfm.getString('nName'),
        number: sfm.getString('number'),
        photo: sfm.getString('photo'),
        cover: sfm.getString('cover'),
        gender: sfm.getString('gender'),
        isActive: sfm.getInt('is_active'),
      );

      return u;
    }catch(e) {
 
      return null;
    }

  }

  Future<String> userClear(BuildContext context) async {
    var sfm = await SharedPreferences.getInstance();
    sfm.clear();
    await FirebaseAuth.instance.signOut();
  //  Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginOption()), (route) => false);
  }

  Future<UserModel> getUserById({String uId}) async {
    try {
      final String url = BaseUrl.baseUrl("requstUser/$uId");
      final http.Response rs = await http.get(Uri.parse(url),
          headers: { 'test-pass': ApiRequest.mToken});
      Map data = jsonDecode(rs.body);
      UserModel u = UserModel.fromJson(data);
      return u;
    }catch(e){
      print("this error from login_methods file");
      print(e);
    }
    return null;
  }


  static void refreshUserInfo (String uid,BuildContext context) async {
    UserModel u = await LoginMethods().getUserById(uId: uid);
    await LoginMethods().setUser(u);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Index(user: u)), (route) => false);
  }



  Future isContactFetchedForfirstTime() async{
    var sfm = await SharedPreferences.getInstance();
    sfm.setInt("isContactFetched", 1);
  }

  Future<int> checkIfContactFetched() async{
    try {
      var sfm = await SharedPreferences.getInstance();
      int val = sfm.get("isContactFetched");
      return val;
    }catch(e){
      return 0;
    }
  }



}