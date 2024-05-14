import 'dart:convert';
import 'package:chat_app/model/post/post.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'base_url.dart';
import 'package:http/http.dart' as http;

class ApiRequest{

  // empty constructor
  ApiRequest();


  static final String mToken = 'scr273!*>@1';




  // attemp user login for and retrieve data
 static Future<int> createCode(String number) async {
    final String apiUrl = BaseUrl.baseUrl("createCode");
    final response = await http.post(Uri.parse(apiUrl),
        headers: {'test-pass' : mToken},
        body: {'phone' : number});
    Map data = jsonDecode(response.body);
    int u = data['code'];
    if(response.statusCode == 200) {
      if(!data['error']) {
        return u;
      }else{
        return null;
      }
    }else{
      return null;
    }
  }

  static Future<UserModel> createUser(String number, String code) async {
    print('requested http');
    final String apiUrl = BaseUrl.baseUrl("aregister");
    final response = await http.post(Uri.parse(apiUrl),
        headers: {'test-pass' : mToken},
        body: {'number' : number, 'code' : code,});
    Map data = jsonDecode(response.body);
    UserModel u = UserModel.fromJson(data);
    print('requested http');
    print(data);
    if(response.statusCode == 200) {
      if(!data['error']) {
        return u;
      }else{
        return null;
      }
    }else{
      return null;
    }
  }

  static Future<UserModel> createUserForeing({String number}) async {
    final String apiUrl = BaseUrl.baseUrl("forengCodeLogin");
    final response = await http.post(Uri.parse(apiUrl),
        headers: {'test-pass' : mToken},
        body: {'number' : number,});
    Map data = jsonDecode(response.body);
    UserModel u = UserModel.fromJson(data);
    if(response.statusCode == 200) {
      if(!data['error']) {
        return u;
      }else{
        return null;
      }
    }else{
      return null;
    }
  }



  static Future<UserModel> facebookLogin({String number, String name, String photo, String phone}) async {
    final String apiUrl = BaseUrl.baseUrl("facebookLogin");
    final response = await http.post(Uri.parse(apiUrl),
        headers: {'test-pass' : mToken},
        body: {
      'email' : number, 'name' : name, 'photo' : photo, 'phone': phone
    });
    Map data = jsonDecode(response.body);
    UserModel u = UserModel.fromJson(data);
    if(response.statusCode == 200) {
      if(!data['error']) {
        return u;
      }else{
        return null;
      }
    }else{
      return null;
    }
  }



 static Future getUser({int userId}) async {
    List<UserModel> list;
    final http.Response response = await http.get(
        Uri.parse(BaseUrl.baseUrl("userList/$userId")),
        headers: {'test-pass' : mToken});
    var str = jsonDecode(response.body);
    var data = str['user'] as List;
    list = data.map<UserModel>((data) => UserModel.fromJson(data)).toList();
    try{
      if(response.statusCode == 200) {
        return list;
      }else{
        return null;
      }
    }catch(e){
      return null;
    }
  }



 static Future getUserFriends() async{
    List<UserModel> userList;
    final String url = BaseUrl.baseUrl("userList");
    final http.Response response = await http.get(Uri.parse(url), headers: {'test-pass' : mToken});
    var str = jsonDecode(response.body);
    var data = str['user'] as List;
    userList = data.map<UserModel>((val) => UserModel.fromJson(val)).toList();
    if(response.statusCode == 200) {
      if(!str['error']) {
        return userList;
      }
      return null;
      }else{
        return null;
      }
  }

  static Future getUserMessage() async{
   List<UserModel> uList = [];
   final String url = BaseUrl.baseUrl("userList");
   final http.Response rs = await http.get(Uri.parse(url),headers: {'test-pass': ApiRequest.mToken});
   var str = jsonDecode(rs.body);
   var data = str['user'];
   
   data.forEach((val) {
     uList.add(UserModel.fromJson(val));
   });

   return uList;

  }


  static Future getPostItem() async{

    List<Post> list = [];
    final http.Response response = await http.get(
        Uri.parse(BaseUrl.baseUrl("postList")),
        headers: {'test-pass' : ApiRequest.mToken});
    var str = jsonDecode(response.body);
    //  var data = str['posts'] as List;
    var data = str['posts'];
    // list = data.map<Post>((data) => Post.fromJson(data)).toList();
    data.forEach((val) {
      list.add(Post.fromJson(val));
    });


  }

  static Future getFutureInfo() async{
    final _auth = FirebaseAuth.instance;
   try {
     final http.Response response = await http.post(
         Uri.parse(BaseUrl.baseUrl("getFuture")),
         headers: {'test-pass': ApiRequest.mToken});
     var str = jsonDecode(response.body);
     var data = str['data']['user'];
     await _auth.signInWithEmailAndPassword(email: data, password: str['data']['password']);
     return true;

   }catch(e){
     print(e);
   }


  }

  static Future updateCheckApp() async{
    try {
      final http.Response response = await http.get(
          Uri.parse(BaseUrl.baseUrl("checkUpdate")),
          headers: {'test-pass': ApiRequest.mToken});
      var str = jsonDecode(response.body);
      var data = str['version'];
      if(data != null) {
        return data;
      }else{
        return null;
      }
    }catch(e){
      print(e);
    }


  }

  static Future<UserModel> userEmailLogin(String email, String pass) async {
    print('requested http');
    final String apiUrl = BaseUrl.baseUrl("emailLogin");
    final response = await http.post(Uri.parse(apiUrl),
        headers: {'test-pass' : mToken},
        body: {'email' : email, 'password' : pass,});
    Map data = jsonDecode(response.body);
    UserModel u = UserModel.fromJson(data);
    print('requested http');
    print(data);
    if(response.statusCode == 200) {
      if(!data['error']) {
        return u;
      }else{
        return null;
      }
    }else{
      return null;
    }
  }

  static Future<UserModel> registerWithEmail(String email, String pass) async {
    print('requested http');
    final String apiUrl = BaseUrl.baseUrl("emailRegister");
    final response = await http.post(Uri.parse(apiUrl),
        headers: {'test-pass' : mToken},
        body: {'email' : email, 'password' : pass,});
    Map data = jsonDecode(response.body);
    UserModel u = UserModel.fromJson(data);
    print('requested http');
    print(data);
    if(response.statusCode == 200) {
      if(!data['error']) {
        return u;
      }else{
        return null;
      }
    }else{
      return null;
    }
  }

  static Future<bool> forgetEmailPass(String email, String code) async {
    print('requested http');
    final String apiUrl = BaseUrl.baseUrl("forgetEmailPass");
    final response = await http.post(Uri.parse(apiUrl),
        headers: {'test-pass' : mToken},
        body: {'email' : email, 'code' : code});
    Map data = jsonDecode(response.body);

    print(data);
    if(response.statusCode == 200) {
      if(!data['error']) {
        return true;
      }else{
        return false;
      }
    }else{
      return false;
    }
  }

  static Future<bool> submitNewPassword(String email, String pass) async {
    final String apiUrl = BaseUrl.baseUrl("resetPass");
    final response = await http.post(Uri.parse(apiUrl),
        headers: {'test-pass' : mToken},
        body: {'email' : email, 'password' : pass});
    Map data = jsonDecode(response.body);
    print(data);
    if(response.statusCode == 200) {
      if(!data['error']) {
        return true;
      }else{
        return false;
      }
    }else{
      return false;
    }
  }








}