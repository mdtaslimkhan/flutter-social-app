
// big group voice room methods
import 'dart:ui';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/chatroom/gift/gift_user_model.dart';
import 'package:chat_app/ui/chatroom/model/active_members.dart';
import 'package:chat_app/ui/chatroom/model/gift.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'dart:convert';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:http/http.dart' as http;

class VoiceRoomMethods{

  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  final _fireStore = FirebaseFirestore.instance;


  Future getUserByIdChat(String uid) async {
    try {
      final String url = BaseUrl.baseUrl("requstUser/$uid");
      final http.Response rs = await http.get(Uri.parse(url),
          headers: { 'test-pass': ApiRequest.mToken});
      Map data = jsonDecode(rs.body);
      UserModel u = UserModel.fromJson(data);
      return u;
    }catch(e){
      print(e);
    }

  }

  Future sendUserNotification({List<String> userList, UserModel from, GroupModel group}) async {
    try {
      print(userList);
      final String url = BaseUrl.baseUrl("roomNotification");
      final http.Response rs = await http.post(Uri.parse(url),
          headers: { 'test-pass': ApiRequest.mToken},
          body: {
             'userList' : userList.toString(),
             'id' : from.id.toString(),
             'photo' : group.photo,
             'name' : group.name,
             'username' : from.fName + " " + from.nName,
             'groupId' : group.id.toString()
          });

    }catch(e){
      print(e);
    }

  }

  Future sendNotification({String to, UserModel from, int type}) async {
    String descrip = "";
    if(type == 1){
      descrip = "Liked your post";
    }else if(type == 2){
      descrip = "Comment on your post";
    }else if(type == 3){
      descrip = "Comment replied";
    }else if(type == 4){
      descrip = "Following your";
    }

    try {
      final String url = BaseUrl.baseUrl("allTypeNotification");
      final http.Response rs = await http.post(Uri.parse(url),
          headers: { 'test-pass': ApiRequest.mToken},
          body: {
            'to' : to,
            'fromId' : from.id.toString(),
            'photo' : from.photo,
            'name' : from.fName + " " +from.nName,
            'description' : descrip,
          });

    }catch(e){
      print(e);
    }

  }


  Future chatNotification({String to, UserModel from, String text}) async {
    try {
      final String url = BaseUrl.baseUrl("chatNotification");
      final http.Response rs = await http.post(Uri.parse(url),
          headers: { 'test-pass': ApiRequest.mToken},
          body: {
            'to' : to,
            'fromId' : from.id.toString(),
            'photo' : from.photo,
            'name' : from.fName + " " +from.nName,
            'description' : text,
          });

    }catch(e){
      print(e);
    }

  }

  // un used function
  Stream getActiveUsers({String groupId}) {
    var ref = _databaseReference.child("biggroup_voice_room/$groupId");
    final userStream = ref.child("activeMembers").onValue;
    final streamSend = userStream.map((event) {
      final userMap = Map<String, dynamic>.from(event.snapshot.value);
      final userList = userMap.entries.map((e) {
        return ActiveMembers.fromRTDB(Map<String, dynamic>.from(e.value));
      }).toList();
      return userList;
    });
    return streamSend;
  }


  // when user entered to the voice room
  userEnteredToTheVoiceRoomReal({UserModel from, GroupModel group}){
    try {
      var dbref = _databaseReference.child(
          "biggroup_voice_room/${group.id.toString()}/activeMembers");
      dbref.push().set({
        'user_id': from.id.toString(),
        'photo': from.photo,
        'name': from.fName + " " + from.nName,
      });
      // first get the user then filter then call data
      // then loop data find with key then call onDisconnect then remove.
      dbref.orderByChild("user_id").equalTo(from.id.toString()).once().then((value) {
        final dt = Map<String, dynamic>.from(value.snapshot.value);
        dt.forEach((key, value) {
          dbref.child(key).onDisconnect().remove();
        });
      });
    }catch(e){

    }
  }

  // when user re entered to the voice room
  userWhenReEnteredToTheVoiceRoomReal({UserModel from, GroupModel group}) async {
    try {
      var dbref = _databaseReference.child("biggroup_voice_room/${group.id.toString()}/activeMembers");
      // first get the user then filter then call data
      // if not the active user in list then add user
     await dbref.orderByChild("user_id").equalTo(from.id.toString()).once().then((DatabaseEvent value) {
        if(value.snapshot.value == null) {
          dbref.push().set({
            'user_id': from.id.toString(),
            'photo': from.photo,
            'name': from.fName + " " + from.nName,
          });
        }
      });
      // run disconnect function when user disconnected from room
      dbref.orderByChild("user_id").equalTo(from.id.toString()).once().then((DatabaseEvent value) {
        if(value.snapshot.value != null){
          final dt = Map<String, dynamic>.from(value.snapshot.value);
          if (dt != null) {
            dt.forEach((key, value) {
              print(value);
              dbref.child(key).onDisconnect().remove();
            });
          }
        }
      });
    }catch(e){

    }
  }
  // when user left the voice room
  leftTheRoomByUserReal({String groupId, String userId}){
    var ref = _databaseReference.child('biggroup_voice_room/$groupId/activeMembers');
      ref.orderByChild("user_id").equalTo(userId).once().then((value) {
        if(value.snapshot.value != null) {
          final dt = Map<String, dynamic>.from(value.snapshot.value);
          dt.forEach((key, value) {
            ref.child(key).remove();
          });
        }
      });
  }

  // count how much active users in voice room
  Stream getActiveUsersMethod({String groupId}) {
    var ref = _databaseReference.child("biggroup_voice_room/$groupId");
   return ref.child("activeMembers").onValue;
  }

  // count how much active users in voice room
  Stream getOnlineGroupList({String groupId}) => _databaseReference.child("bigGroupCall").ref.onValue;



  Future<void> enteredUserIntoHostSeat({UserModel from, GroupModel group}) {
    _fireStore
        .collection(BIG_GROUP_COLLECTION)
        .doc(group.id.toString())
        .collection("hostId")
        .doc(from.id.toString())
        .set({
      'hostId': from.id.toString(),
      'userId': from.id.toString(),
      'photo': from.photo,
      'name': from.nName,
      'timeStamp': Timestamp.now()
    });
  }

  Future deleteHostId({UserModel from, GroupModel group}){
    _fireStore
        .collection(BIG_GROUP_COLLECTION)
        .doc(group.id.toString())
        .collection("hostId")
        .doc(from.id.toString())
        .delete();
  }


  // When user start a voice room by admin add hostid to host id collection in realtime database
  enteredUserIntoHostSeatReal({UserModel from, GroupModel group}){
    var dbref = _databaseReference.child("biggroup_voice_room/${group.id.toString()}/hostId");
    dbref.set({
      'userId': from.id.toString(),
      'host': true,
      'photo': from.photo,
      'mute': false,
      'name': from.nName,
      'timeStamp': ServerValue.timestamp
    });
    dbref.onDisconnect().remove();
  }

  // When user stop the voice room by admin remove hostid
  Future deleteHostIdReal({UserModel from, GroupModel group}){
    var dbref = _databaseReference.child("biggroup_voice_room/${group.id.toString()}/hostId");
    dbref.remove();
  }


  // count how much active users in voice room
  Stream getHostSeatListToCheckIfTheLoggedUserIsHostReal({UserModel from, String groupId}) {
    var ref = _databaseReference.child("biggroup_voice_room/$groupId");
    return ref.child("hostId").onValue;
  }

  // count how much active users in voice room
  Stream getHotSeatUserReal({String groupId, String collection}) {
    var ref = _databaseReference.child("biggroup_voice_room/$groupId");
    return ref.child(collection).onValue;
  }




  Future removeAllHotSeatUsers({GroupModel group}) {
    _fireStore
        .collection(BIG_GROUP_COLLECTION)
        .doc(group.id.toString())
        .collection("hotSeat").get().then((doc) {
          for(var hs in doc.docs){
            hs.reference.delete();
          }
        }
    );
  }


  Future checkHotSeatExist({GroupModel group, int pos}) async{

    try {
      DocumentReference sn = await _fireStore.collection(BIG_GROUP_COLLECTION)
          .doc(group.id.toString())
          .collection("hotSeat")
          .doc(pos.toString());

      return sn;

    }catch(e){
      print(e);
    }

  }


  Future<int> activeHotSeatMembersCountReal({GroupModel group}) async {
    try {
      var ref = _databaseReference.child("biggroup_voice_room/${group.id.toString()}");
       ref.child("hotSeat").once().then((value) {
          Map<dynamic, dynamic> dts = value.snapshot.value;
       });

    }catch(e){
      print(e);
      return null;
    }
  }

  Future<int> activeHotSeatMembersCount({GroupModel group}) async {
    try {
      QuerySnapshot hotseatActiveCount = await _fireStore.collection(BIG_GROUP_COLLECTION)
          .doc(group.id.toString())
          .collection("hotSeat")
          .get();
      return hotseatActiveCount.docs.length;
    }catch(e){
      print(e);
      return null;
    }
  }

  Stream<QuerySnapshot> activeHotSeatMembersCountStream({String groupId}) =>
      _fireStore.collection(BIG_GROUP_COLLECTION)
          .doc(groupId)
          .collection("hotSeat")
          .snapshots();



   userTapAndJoinedToHotSeat({UserModel from, GroupModel group, int position}) {

    var pos = 0;
    if(position != null){
      pos = position;
    }
    try {
     var val = _fireStore
          .collection(BIG_GROUP_COLLECTION)
          .doc(group.id.toString())
          .collection("hotSeat")
          .doc(from.id.toString())
          .set({
        'position': pos,
        'userId': from.id.toString(),
        'photo': from.photo,
        'mute': false,
        'name': from.nName,
        'timeStamp': Timestamp.now()
      });



    }catch(e){
      print(e);

    }
    return true;
  }




  Future usersGiftMention({UserModel from, GroupModel group, String toId}) async {



  UserModel to = await getUserByIdChat(toId);
  var timeStamp = Timestamp.now();
    _fireStore
        .collection(BIG_GROUP_COLLECTION)
        .doc(group.id.toString())
        .collection("mentions")
        .doc(toId)
        .collection("giftsTo")
        .add({
      'fromId': from.id.toString(),
      'fromPhoto': from.photo,
      'fromName': from.fName + ' ' +from.nName,
      'toId': to.id.toString(),
      'toPhoto': to.photo,
      'toName': to.fName + ' ' +to.nName,
      'pending' : true,
      'timeStamp': Timestamp.now()
    });
  }



  Future toast({String msg}) {
    Fluttertoast.showToast(
        msg: "$msg",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1
    );
  }

  Future removeHotSeatAndExitByUserSelf({UserModel from, GroupModel group}) async {
   await _fireStore
        .collection(BIG_GROUP_COLLECTION)
        .doc(group.id.toString())
        .collection("hotSeat")
        .doc(from.id.toString())
        .delete();
  }

  Future removeUserFromHotSeat({GroupModel group, String hotSeatUser}) {
    _fireStore
        .collection(BIG_GROUP_COLLECTION)
        .doc(group.id.toString())
        .collection("hotSeat")
        .where("userId", isEqualTo: hotSeatUser)
        .get().then((vl) {
      for(var f in vl.docs){
        f.reference.delete();
      }
    });
  }

  // count how much active users in voice room
  setMuteHotSeatUserReal({String groupId, String collection, bool isMute }) {
    var ref = _databaseReference.child("biggroup_voice_room/$groupId/$collection");
    ref.update({
      "mute": isMute
    });
    ref.onDisconnect().remove();
  }



  Future setMuteHotSeat({String userId, GroupModel group,bool mute, bool forceMute}) {
    print("force mute test here ");
    print(forceMute);
    // _fireStore
    //     .collection(BIG_GROUP_COLLECTION)
    //     .doc(group.id.toString())
    //     .collection("hotSeat")
    //     .doc(userId)
    //     .update({
    //   "mute": forceMute,
    //   "isMuted" : mute ? 1 : 0,
    // });
    _fireStore.collection(BIG_GROUP_COLLECTION)
    .doc(group.id.toString())
    .collection("hotSeat")
    .doc(userId)
    .get().then((value) {
      value.reference.update({
        "forceMute": forceMute,
        "mute": mute,
        "isMuted" : mute ? 1 : 0,
      });
    });
    // _fireStore.collection(BIG_GROUP_COLLECTION)
    //     .doc(group.id.toString())
    //     .collection("muteSeat")
    //     .doc(userId)
    //     .get().then((value) {
    //   value.reference.set({
    //     "forceMute": forceMute,
    //     "mute": mute,
    //     "isMuted" : mute ? 1 : 0,
    //   });
    // });
  }

  // Future muteUserFromHotSeat({GroupModel group, String hotSeatUser}) {
  //   _fireStore
  //       .collection(BIG_GROUP_COLLECTION)
  //       .doc(group.id.toString())
  //       .collection("hotSeat").doc(hotSeatUser)
  //       .get().then((vl) {
  //     vl.reference.update({
  //       "isMuted" : 1,
  //       "mute": true,
  //     });
  //   });
  // }
  //
  // Future unmuteUserFromHotSeat({GroupModel group, String hotSeatUser}) {
  //   _fireStore
  //       .collection(BIG_GROUP_COLLECTION)
  //       .doc(group.id.toString())
  //       .collection("hotSeat").doc(hotSeatUser)
  //       .get().then((vl) {
  //     vl.reference.update({
  //       "isMuted" : 0,
  //       "mute": false,
  //     });
  //   });
  // }

  Future setImojiUserHotSeat({GroupModel group, String hotSeatUser, String imoji, String collection}) {
    _fireStore
        .collection(BIG_GROUP_COLLECTION)
        .doc(group.id.toString())
        .collection(collection).doc(hotSeatUser)
        .get().then((vl) {
      vl.reference.update({
        "react" : imoji,
      });
      Future.delayed(Duration(seconds: 5), () {
        vl.reference.update({
          "react" : null,
        });
      });
    });
  }

  setImojiForHostSeat({GroupModel group, String hotSeatUser, String imoji, String collection}){
      var ref = _databaseReference.child("biggroup_voice_room/${group.id.toString()}");
      ref.child(collection).update({
        "react": imoji,
      });
      Future.delayed(Duration(seconds: 5), () {
        ref.child(collection).update({
          "react" : null,
        });
      });

  }



  // notification for group
  void messageForJoiningTheGroup({String msgText, UserModel user, String groupId}) async {
    if(msgText != null || msgText != "") {
      await _fireStore.collection(BIG_GROUP_MESSAGE_COLLECTION)
          .doc(groupId)
          .collection("messages")
          .add({
        'name' : user.nName,
        'photo' : user.photo,
        'receiverId': user.id.toString(),
        'senderId': groupId,
        'text': msgText,
        'timestamp': Timestamp.now(),
        'type': "notify",
      });
    }
  }


 // get host user
  getHost(String groupId) async {
    try {
      var data = await _fireStore
          .collection(BIG_GROUP_COLLECTION)
          .doc(groupId)
          .collection("hostId")
          .get();
      return data;
    }catch(e){
      print(e);
    }
  }

  // get all hot seat user list
  getHotSeatUserList(String groupId) async {
    try {
      var data = await _fireStore
          .collection(BIG_GROUP_COLLECTION)
          .doc(groupId)
          .collection("hotSeat")
          .orderBy("position", descending: false)
          .get();
      return data;
    }catch(e){
      print(e);
    }
  }

  // get all hot seat user list
  checkIfUserInHotSeat(String groupId, String userId) async {
    try {
      var data = await _fireStore
          .collection(BIG_GROUP_COLLECTION)
          .doc(groupId)
          .collection("hotSeat")
          .doc(userId)
          .get();
      return data;
    }catch(e){
      print(e);
    }
  }

  // create waiting list
  createWaitingList({UserModel from, String groupId, int waiting}) async {
    int pos = 1;
    try {
      var waitingPos = await _fireStore
          .collection(BIG_GROUP_COLLECTION)
          .doc(groupId)
          .collection("waitingList")
          .orderBy('pos', descending: false)
          .get();
     QuerySnapshot qs = waitingPos;

     if(qs.docs.isNotEmpty){
       QueryDocumentSnapshot qst = qs.docs.last;
       if(qst != null){
         var q = qst.data() as Map;
         int prev = q['pos'];
         pos = prev + 1;
       }
     }

      var data = await _fireStore
          .collection(BIG_GROUP_COLLECTION)
          .doc(groupId)
          .collection("waitingList")
          .doc(from.id.toString())
          .set({
        'pos' : pos,
        'userId': from.id.toString(),
        'photo': from.photo,
        'name': from.nName,
        'timeStamp': Timestamp.now()
      });
      return data;
    }catch(e){
      print(e);
    }
  }

  // get waiting list steam
  Stream<QuerySnapshot> hotSeatStatus({String groupId,String userId}) => _fireStore
      .collection(BIG_GROUP_COLLECTION)
      .doc(groupId)
      .collection("hotSeat")
      .snapshots();

  // get waiting list
  getWaitingListAll({String groupId}) {
    try {
      var wList = _fireStore.collection(BIG_GROUP_COLLECTION)
          .doc(groupId)
          .collection("waitingList")
          .orderBy('pos', descending: false)
          .get();
      return wList;
    }catch(e){
      print(e);
    }
  }


  removeWaitingUser({String groupId, String userId}) {
    try {
      var wList = _fireStore.collection(BIG_GROUP_COLLECTION)
          .doc(groupId)
          .collection("waitingList")
          .doc(userId)
          .delete();
      return wList;
    }catch(e){
      print(e);
    }
  }




   // get all active members
  getAllActiveMembersList(String groupId) async {
    try {
      var data = await _fireStore
          .collection(BIG_GROUP_COLLECTION)
          .doc(groupId)
          .collection("activeMembers")
          .get();
      return data;
    }catch(e){
      print(e);
    }
  }

  setGiftList({UserModel from,String groupId, Gift gift, String toId}) async {
     final giftValue = int.parse(gift.diamond);
    UserModel to = await getUserByIdChat(toId);
    try {
      await _fireStore
          .collection(BIG_GROUP_COLLECTION)
          .doc(groupId)
          .collection("hotGift")
          .add({
        "video": gift.video,
        'fromId': from.id.toString(),
        'fromPhoto': from.photo,
        'fromName': from.fName + ' ' +from.nName,
        'toId': to.id.toString(),
        'toPhoto': to.photo,
        'toName': to.fName + ' ' +to.nName,
        'pending' : true,
        'diamond' : gift.diamond,
        'timeStamp': Timestamp.now()
      });


      // new collection for user who sent gift to other users
      DocumentReference dsu = _fireStore
          .collection(BIG_GROUP_COLLECTION)
          .doc(groupId)
          .collection("userGiftSent")
          .doc(from.id.toString());

      if(dsu.get() != null){
        dsu.get().then((value) => {

          if(value.data() != null){
            dsu.set({
              "id": from.id.toString(),
              "name": from.fName + " " + from.nName,
              "photo": from.photo,
              "diamond": {"diamond": FieldValue.increment(giftValue)},
              "video": gift.video,
              "image": gift.img,
              'timeStamp': Timestamp.now()
            },SetOptions(merge: true)),
          }else{
            dsu.set({
              "id": from.id.toString(),
              "name": from.fName + " " + from.nName,
              "photo": from.photo,
              "diamond": {"diamond": int.parse(gift.diamond)},
              "video": gift.video,
              "image": gift.img,
              'timeStamp': Timestamp.now()
            }),
          }
        });

      }

      // new collection for user who sent gift to other users
      DocumentReference ds = _fireStore
          .collection(BIG_GROUP_COLLECTION)
          .doc(groupId)
          .collection("userGiftReceived")
          .doc(to.id.toString());

          if(ds.get() != null){
            ds.get().then((value) => {

            if(value.data() != null){
             ds.set({
                "id": to.id.toString(),
                "name": to.fName + " " + to.nName,
                "photo": to.photo,
                "diamond": {"diamond": FieldValue.increment(giftValue)},
                "video": gift.video,
                "image": gift.img,
                'timeStamp': Timestamp.now()
              },SetOptions(merge: true)),
            }else{
              ds.set({
                "id": to.id.toString(),
                "name": to.fName + " " + to.nName,
                "photo": to.photo,
                "diamond": {"diamond": int.parse(gift.diamond)},
                "video": gift.video,
                "image": gift.img,
                'timeStamp': Timestamp.now()
              }),
            }
     });

       }



      // new collection for giftType
      DocumentReference dsgt = await _fireStore
          .collection(BIG_GROUP_COLLECTION)
          .doc(groupId)
          .collection("giftType")
          .add({
        "fromId" : from.id.toString(),
        "fromName" : from.fName + " "+ from.nName,
        "fromPhoto" : from.photo,
        "toId" : to.id.toString(),
        "toName" : to.fName + " "+ to.nName,
        "toPhoto" : to.photo,
        "diamond" : gift.diamond,
        "video": gift.video,
        "image" : gift.img,
        'timeStamp': Timestamp.now()
      });



    }catch(e){
      print(e);
    }

    setGiftListAllTimes(from: from, groupId: groupId, gift: gift, giftValue: giftValue, to: to);
  }



  setGiftListAllTimes({UserModel from,String groupId, Gift gift, int giftValue, UserModel to}) async{

    try{

      // new collection for user who sent gift to other users
      DocumentReference dsuat = _fireStore
          .collection(BIG_GROUP_COLLECTION)
          .doc(groupId)
          .collection("userGiftSentAll")
          .doc(from.id.toString());

      if(dsuat.get() != null){
        dsuat.get().then((value) => {

          if(value.data() != null){
            dsuat.set({
              "id": from.id.toString(),
              "name": from.fName + " " + from.nName,
              "photo": from.photo,
              "diamond": {"diamond": FieldValue.increment(giftValue)},
              "video": gift.video,
              "image": gift.img,
              'timeStamp': Timestamp.now()
            },SetOptions(merge: true)),
          }else{
            dsuat.set({
              "id": from.id.toString(),
              "name": from.fName + " " + from.nName,
              "photo": from.photo,
              "diamond": {"diamond": int.parse(gift.diamond)},
              "video": gift.video,
              "image": gift.img,
              'timeStamp': Timestamp.now()
            }),
          }
        });

      }

      // new collection for user who sent gift to other users
      DocumentReference dsat = _fireStore
          .collection(BIG_GROUP_COLLECTION)
          .doc(groupId)
          .collection("userGiftReceivedAll")
          .doc(to.id.toString());

      if(dsat.get() != null){
        dsat.get().then((value) => {
          if(value.data() != null){
            dsat.set({
              "id": to.id.toString(),
              "name": to.fName + " " + to.nName,
              "photo": to.photo,
              "diamond": {"diamond": FieldValue.increment(giftValue)},
              "video": gift.video,
              "image": gift.img,
              'timeStamp': Timestamp.now()
            },SetOptions(merge: true)),
          }else{
            dsat.set({
              "id": to.id.toString(),
              "name": to.fName + " " + to.nName,
              "photo": to.photo,
              "diamond": {"diamond": int.parse(gift.diamond)},
              "video": gift.video,
              "image": gift.img,
              'timeStamp': Timestamp.now()
            }),
          }
        });

      }

    }catch(e){
      print(e);
    }
  }
  deleteCollection({String groupId, String collection}) {
    _fireStore.collection(BIG_GROUP_COLLECTION).doc(groupId).collection(collection).get().then((v) => {
        for(var d in v.docs){
          _fireStore.collection(BIG_GROUP_COLLECTION).doc(groupId).collection(collection).doc(d.id).delete(),
        }
    });
  }

  Stream lastGiftSender({String groupId, String giftSentCollection}) => _fireStore
      .collection(BIG_GROUP_COLLECTION)
      .doc(groupId)
      .collection(giftSentCollection)
      .orderBy("timeStamp",descending: true)
      .limit(1)
      .snapshots();

 Stream topGiftSender({String groupId, String giftSentCollection}) => _fireStore
        .collection(BIG_GROUP_COLLECTION)
        .doc(groupId)
        .collection(giftSentCollection)
        .orderBy("diamond",descending: true)
        .limit(3)
        .snapshots();

  Stream getCurrentRoomMyGift({String groupId, String giftSentCollection}) => _fireStore
      .collection(BIG_GROUP_COLLECTION)
      .doc(groupId)
      .collection(giftSentCollection)
      .snapshots();

  Stream getWaitingUser({String groupId, String giftSentCollection}) => _fireStore
      .collection(BIG_GROUP_COLLECTION)
      .doc(groupId)
      .collection(giftSentCollection)
      .orderBy("pos",descending: false)
      .limit(3)
      .snapshots();


  // get all hot seat user list
  getGroupMembersList(String groupId) async {
    List<String> userIdlist = [];
    try {
      QuerySnapshot data = await _fireStore
          .collection(BIG_GROUP_COLLECTION)
          .doc(groupId)
          .collection("members")
          .get();
      for(var id in data.docs){
        var dt = id.data() as Map;
        if(dt['userId'] != null) {
          userIdlist.add(dt['userId']);
        }
      }
      return userIdlist;
    }catch(e){
      print(e);
    }
  }





  // setGiftType({UserModel from,String groupId, Gift gift}) async {
  //   try {
  //     await _fireStore
  //         .collection(BIG_GROUP_COLLECTION)
  //         .doc(groupId)
  //         .collection("giftType")
  //         .add({
  //       "fromId" : from.id.toString(),
  //       "fromName" : from.fName + " "+ from.nName,
  //       "fromPhoto" : from.photo,
  //       "diamond" : gift.diamond,
  //       "video": gift.video,
  //       "image" : gift.img,
  //       'timeStamp': Timestamp.now()
  //     });
  //
  //
  //   }catch(e){
  //     print(e);
  //   }
  //
  // }

  Future getGiftUserListAll(String groupId) async{
    List<GiftUserModel> uLists = [];
    var host = await getHost(groupId);
    var hot =  await getHotSeatUserList(groupId);
    hot.docs.forEach((val) {
      uLists.add(GiftUserModel.fromJson(val.data()));
    });
    host.docs.forEach((val) {
      // replace hostId with hostId to marge hostId and hotSeat
      uLists.add(GiftUserModel(name: val.data()['name'], photo: val.data()['photo'], userId: val.data()['hostId']));
    });
    return uLists;
  }



  Future getUserById(int uId) async {
    try {
      final String url = BaseUrl.baseUrl("requstUser/$uId");
      final http.Response rs =
      await http.get(Uri.parse(url), headers: {'test-pass': ApiRequest.mToken});
      Map data = jsonDecode(rs.body);
      return data;
    }catch(e){
      print(e);
    }
  }


  Future putGift({String gift, String groupId, String userId}){
    _fireStore.collection(BIG_GROUP_COLLECTION)
        .doc(groupId)
        .set({
      "user_id" : userId,
      "gift" : gift,
    });
  }


  void getMessages() async {
    final messages = await _fireStore.collection("messages").get();
    for (var msg in messages.docs) {

    }
  }

  void getStreamMessage() async {
    await for (var msg in _fireStore.collection("messages").snapshots()) {
      for (var m in msg.docs) {

      }
    }
  }


  void setTypingGroup({String groupId, UserModel user}){
    var dbref = _databaseReference.child('biggroup_voice_room/$groupId/isTyping/${user.id.toString()}');
    dbref.update({
      "isTyping" : true,
      'user_id': user.id.toString(),
      'photo': user.photo,
      'name': user.fName +" "+user.nName,
    });
    dbref.onDisconnect().remove();
  }

  void setNotTypingGroup({String groupId, UserModel user}){
    var dbref = _databaseReference.child('biggroup_voice_room/$groupId/isTyping/${user.id.toString()}');
    dbref.remove();
  }

  Stream getUserOnlineStateGroup({String groupId}){
    var dbref = _databaseReference.child('biggroup_voice_room/$groupId/isTyping')
        .orderByChild("isTyping")
        .startAt(true).endAt(true);
    return dbref.onValue;

  }


  void setBackgroundColors({String groupId, UserModel user, Color color}){
    var dbref = _databaseReference.child('biggroup_voice_room/$groupId/settings');
    String colorString = color.toString();
    String valueString = colorString.split('(0x')[1].split(')')[0];
    dbref.update({
      "color" : valueString,
      'user_id': user.id.toString(),
    });
   // dbref.onDisconnect().remove();
  }

  void setBackgroundImage({String groupId, UserModel user, String bg}){
    var dbref = _databaseReference.child('biggroup_voice_room/$groupId/settings');
    dbref.update({
      "bg" : bg,
      'user_id': user.id.toString(),
    });
   // dbref.onDisconnect().remove();
  }

  // count how much active users in voice room
  Stream getBackgroundColors({String groupId}) {
    var ref = _databaseReference.child("biggroup_voice_room/$groupId");
    return ref.child("settings").onValue;
  }







}