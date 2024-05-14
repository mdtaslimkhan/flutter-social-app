

import 'dart:convert';

import 'package:chat_app/ui/pages/home/controller/homeController.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:chat_app/util/base_url.dart';


class StoryProvider extends ChangeNotifier{


  final HomeController _homeController = HomeController();




  int _storyLength = 0;
  get storyLength => _storyLength;



  Future<String> setStroyView({String id}) async {
    try{
      final http.Response response = await http.post(
          Uri.parse(BaseUrl.baseUrl("storyViewCount")),
          headers: {'test-pass' : ApiRequest.mToken},
          body: {'story_id' : id});
      var str = jsonDecode(response.body);
      if(response.statusCode == 200) {
        return str;
      }else{
        return null;
      }
    }catch(e){
      return null;
    }
  }


  // load more data function helper and functions
  int _addPage = 2;
  bool tiggredOnce = true;
  bool _isLoader = true;
  get isLoader => _isLoader;







}