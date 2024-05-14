import 'dart:convert';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/pages/settings/wallet/model/diamond_recharge.dart';
import 'package:chat_app/ui/pages/settings/wallet/model/redeem_diamond.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

class BalanceProvider extends ChangeNotifier {
  var currentDiamond =885;


 List<RedeemDiamond> gemslist = [
   RedeemDiamond(diamond: 50, gem: 200),
   RedeemDiamond(diamond: 100, gem: 400),
   RedeemDiamond(diamond: 500, gem: 2000),
   RedeemDiamond(diamond: 1000, gem: 4000),
   RedeemDiamond(diamond: 2000, gem: 8000),
   RedeemDiamond(diamond: 5000, gem: 20000),
 ];

 List<RechargeDiamond> rechargelist = [
   RechargeDiamond(diamond: 50, amount: 90),
   RechargeDiamond(diamond: 200, amount: 350),
   RechargeDiamond(diamond: 500, amount: 900),
   RechargeDiamond(diamond: 1000, amount: 1800),
   RechargeDiamond(diamond: 2000, amount: 3500),
   RechargeDiamond(diamond: 4000, amount: 6500),
 ];

  List<RechargeDiamond> bankRechargeList = [
    RechargeDiamond(diamond: 10000, amount: 5000),
    RechargeDiamond(diamond: 20000, amount: 9000),
    RechargeDiamond(diamond: 30000, amount: 14000),
    RechargeDiamond(diamond: 40000, amount: 18000),
    RechargeDiamond(diamond: 100000, amount: 40000),
    RechargeDiamond(diamond: 500000, amount: 190000),
  ];


  int _gems = 0;
  int get gems => _gems;


  int _diamond = 0;
  int get diamond => _diamond;

 getDiamondGemsStatus({String userId}) async {
   // get bank diamond status too
    this.getBankDiamondStatus(userId: userId);
   try {
     final String url = BaseUrl.baseUrl('getBalanceState');
     final response = await http.post(Uri.parse(url),
         headers: {'test-pass': ApiRequest.mToken},
         body: {
           'userid': userId,
         });
     if(response.statusCode == 200){
       Map data = jsonDecode(response.body);
       _gems = data['gems'];
       _diamond = data['diamonds'];
       notifyListeners();
       return true;
     }else{
       return false;
     }

   }catch(e){
     print(e);
   }

   return false;

 }

  int _bankDiamond = 0;
  int get bankDiamond => _bankDiamond;

  getBankDiamondStatus({String userId}) async {
    try {
      final String url = BaseUrl.baseUrl('getBankDiamondStatus');
      final response = await http.post(Uri.parse(url),
          headers: {'test-pass': ApiRequest.mToken},
          body: {
            'userid': userId,
          });
      if(response.statusCode == 200){
        Map data = jsonDecode(response.body);
        _bankDiamond = data['bankDiamond'];
        notifyListeners();
      }
    }catch(e){
      print(e);
    }
  }

  UserModel _toUserModel;
  UserModel get toUserModel => _toUserModel;

  setToUserDetails({UserModel userModel}){
    _toUserModel = userModel;
    notifyListeners();
  }


  String _version = '';
  String get version => _version;

  setVersionInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _version = packageInfo.version;
    notifyListeners();
  }



}

