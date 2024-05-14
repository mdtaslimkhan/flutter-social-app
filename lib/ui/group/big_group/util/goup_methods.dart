

import 'dart:convert';
import 'dart:io';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/chatroom/model/group_call.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:chat_app/ui/group/big_group/model/image_model.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as Im;
import 'package:http/http.dart' as http;

class GroupMethods{

  final _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  Future<ImageFileModel> pickeImageGroup({@required ImageSource source}) async {
    XFile selectedImage = await _picker.pickImage(source: source, maxHeight: 675, maxWidth: 600);
    var file = File(selectedImage.path);
    print("selected imagesw");
    print(file.lengthSync());
    return await compressGroupImage(file: file);
  }

 Future<ImageFileModel> compressGroupImage({@required File file}) async{
    if(file != null) {
      Im.Image image = Im.decodeImage(file.readAsBytesSync());
      Im.Image byteSyncedImage = Im.copyResize(image, width: 500);
      String base64 = base64Encode(Im.encodeJpg(byteSyncedImage, quality: 85));
      return ImageFileModel(file: file, imgString: base64);
    }
  }

  Future<GroupModel> createGroup({@required String uid, @required String name, @required String photo, @required String cover, String about }) async {
    final String url = BaseUrl.baseUrl("createGroup");
    final http.Response response = await http.post(Uri.parse(url),
        headers: {'test-pass' : ApiRequest.mToken},
        body: {
          'user_id': uid,
          'name': name,
          'photo': photo != null ? photo : "",
          'cover': cover != null ? cover : "",
          'about': about,
        }
    );
    var str = jsonDecode(response.body);
    GroupModel u = GroupModel.fromJson(str["group"]);
    return u;
  }

  Future<GroupModel> editBigGroupProfile({@required String uid, @required String photo,
    @required int photoType, String groupId }) async {
    try{
    final String url = BaseUrl.baseUrl("${photoType == 1 ? 'editGroupPhoto' : 'editGroupCover'}/$groupId");
    final http.Response response = await http.post(Uri.parse(url),
        headers: {'test-pass' : ApiRequest.mToken},
        body: {
          'photo': photo != null ? photo : "",
        }
    );
    Map str = jsonDecode(response.body);
    GroupModel gm = GroupModel.fromJson(str['group']);

      if(response.statusCode == 200) {
        return gm;
      }else{
        return null;
      }
    }catch(e){
      print(e.toString());
      return null;
    }
  }


  Future<String> groupDeleteById({String groupId }) async {
    try{
      final String url = BaseUrl.baseUrl("groupDeleteById/$groupId");
      final http.Response response = await http.get(Uri.parse(url),
          headers: {'test-pass' : ApiRequest.mToken},
      );
      Map str = jsonDecode(response.body);
      var msg = str['message'];

      if(response.statusCode == 200) {
        return msg;
      }else{
        return "Group deletion error";
      }
    }catch(e){
      print(e.toString());
      return null;
    }
  }



  Future getGroups({@required String uid}) async {
    List<GroupModel> gList;
    final String url = BaseUrl.baseUrl("getGroup/$uid");
    final http.Response response = await http.get(Uri.parse(url),
        headers: {'test-pass' : ApiRequest.mToken},
    );
    var str = jsonDecode(response.body);
    var data = str['groups'] as List;
    gList = data.map<GroupModel>((data) => GroupModel.fromJson(data)).toList();
    try{
      if(response.statusCode == 200) {
        return gList;
      }else{
        return null;
      }
    }catch(e){
      return null;
    }

  }


  Future getAllGroups({@required String uid}) async {
    List<GroupModel> gList;
    final String url = BaseUrl.baseUrl("getAllGroups/$uid");
    final http.Response response = await http.get(Uri.parse(url),
      headers: {'test-pass' : ApiRequest.mToken},
    );
    var str = jsonDecode(response.body);
    var data = str['groups'] as List;
    gList = data.map<GroupModel>((data) => GroupModel.fromJson(data)).toList();
    try{
      if(response.statusCode == 200) {
        return gList;
      }else{
        return null;
      }
    }catch(e){
      return null;
    }

  }



Future<String> addMembers({String mList, String userId, String groupId}) async {

    final String url = BaseUrl.baseUrl('addMembers');
    final response = await http.post(Uri.parse(url),
        headers: {'test-pass': ApiRequest.mToken},
        body: {
          'aList': mList,
          'user_id': userId,
          'group_id': groupId,
        });
    Map data = jsonDecode(response.body);


}

  GroupCall mCall;

void addGroupMembers({UserModel user, GroupModel group, UserModel admin, int role}) {
    // only add members to big group for now
  // role 3 for normal user

  _firestore.collection("feed")
      .doc(user.id.toString())
      .collection("notification")
      .doc(group.id.toString())
      .set({
    "role": role,
    "groupId": group.id.toString(),
    "name" : group.name,
    "photo" : group.photo,
    "userId": user.id.toString(),
    "userName" : admin.fName + " " + admin.nName,
    "userPhoto" : admin.photo,
    "adminId" : admin.id.toString(),
    "timestamp": Timestamp.now(),
  });

  // add group to user's contact list
  // Contact will be added when user confirem the member ship
  // addGroupContactsToUserHomePage(groupId: group.id.toString(), userId: user.id.toString(),
  //     adminId: adminId, name: group.name, photo: group.photo);
}


  void userJoinedToGroup({UserModel user, GroupModel group, String adminId, int role}) {
    // only add members to big group for now
    // role 3 for normal user
    _firestore.collection(BIG_GROUP_COLLECTION).doc(group.id.toString())
        .collection(MEMBERS_COLLECTION).doc(user.id.toString())
        .set({
      "role": role,
      "name" : user.fName + " " +user.nName,
      "groupId": group.id.toString(),
      "userId": user.id.toString(),
      "photo" : user.photo,
      "adminId" : adminId,
      "timestamp": Timestamp.now(),
    });

    // add group to user's contact list
    // Contact will be added when user confirem the member ship
    addGroupContactsToUserHomePage(groupId: group.id.toString(), userId: user.id.toString(),
        adminId: adminId, name: group.name, photo: group.photo);

  }


  void addGroupContactsToUserHomePage({String groupId, String userId, String adminId, String name, String photo}){
    _firestore.collection(CONTACTS_COLLECTION).doc(userId).collection(CONTACT_COLLECTION).doc(groupId).set({
      "name" : name,
      "photo" : photo,
      "contact_id": groupId,
      "userId" : userId,
      "admin" : adminId,
      // this is option only to create big group or private group,
      // "type": "group",
      "type": "bigGroup",
      "added_on": Timestamp.now(),
    });
  
  }

  void removeAndBlockUser({GroupModel group, String userId, String name, String photo, UserModel admin}){
    _firestore.collection(BIG_GROUP_COLLECTION)
        .doc(group.id.toString())
        .collection("block")
        .doc(userId)
        .set({
      "userId" : userId,
      "name" : name,
      "groupId": group.id.toString(),
      "photo" : photo,
      "timestamp": Timestamp.now(),
    });
    deleteGroupMembers(groupId: group.id.toString(), userId: userId);
  }

  void deleteGroupMembers({String groupId, String userId}){
  _firestore.collection(BIG_GROUP_COLLECTION)
      .doc(groupId)
      .collection(MEMBERS_COLLECTION)
      .doc(userId)
      .delete();
  deleteGroupContactsFromUserHomePage(groupId: groupId, userId: userId);
}


  void deleteGroupContactsFromUserHomePage({String groupId, String userId}){
    _firestore.collection(CONTACTS_COLLECTION).doc(userId).collection(CONTACT_COLLECTION)
        .doc(groupId).delete();
  }



  void deleteGroup({String groupId}){
    // _firestore.collection(BIG_GROUP_COLLECTION)
    //     .doc(groupId)
    //     .delete();
    _firestore.collection(BIG_GROUP_MESSAGE_COLLECTION)
        .doc(groupId)
        .delete();
  }






Stream<DocumentSnapshot> getOwnerStatus({String uid, String gid}) => _firestore.collection(BIG_GROUP_COLLECTION).doc(gid)
    .collection("owner").doc(uid).snapshots();


  void muteGroupMember({String userId, GroupModel group}){

    _firestore.collection(BIG_GROUP_COLLECTION)
    .doc(group.id.toString())
    .collection("members")
    .doc(userId)
    .update({
      "mute" : true
    });

  }

  void unmuteGroupMember({String userId, GroupModel group}){
    _firestore.collection(BIG_GROUP_COLLECTION)
        .doc(group.id.toString())
        .collection("members")
        .doc(userId)
        .update({
      "mute" : false
    });
  }

  Stream<DocumentSnapshot> getMuteStatus({String uid, String gid}) => _firestore
      .collection(BIG_GROUP_COLLECTION)
      .doc(gid).collection("members")
      .doc(uid)
      .snapshots();


  void addAdminForGroup({String userId, GroupModel group}){
    _firestore.collection(BIG_GROUP_COLLECTION)
    .doc(group.id.toString())
    .collection("members")
    .doc(userId)
    .update({
      "role" : 2
    });


  }

  void removeAdminForGroup({String userId, GroupModel group}) {
    // role 3 for normal users
    _firestore.collection(BIG_GROUP_COLLECTION)
        .doc(group.id.toString())
        .collection("members")
        .doc(userId)
        .update({
      "role" : 3
    });
  }

  Stream<DocumentSnapshot> getAdminStatus({String uid, String gid}) => _firestore.collection(BIG_GROUP_COLLECTION)
      .doc(gid).collection("members").doc(uid).snapshots();


  Future getSearchedUser({@required String uid, String query}) async {
    List<UserModel> gList;
    final String url = BaseUrl.baseUrl("mSearch/$uid");
    final http.Response response = await http.post(Uri.parse(url),
        headers: {'test-pass' : ApiRequest.mToken},
        body: {
          "qstr" : query
        }
    );
    var str = jsonDecode(response.body);
    var data = str['user'] as List;
    gList = data.map<UserModel>((data) => UserModel.fromJson(data)).toList();
    try{
      if(response.statusCode == 200) {
        return gList;
      }else{
        return null;
      }
    }catch(e){
      return null;
    }

  }



}