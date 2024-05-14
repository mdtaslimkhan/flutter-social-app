import 'package:chat_app/enum/user_state.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/chatroom/function/voice_room_methods.dart';
import 'package:chat_app/ui/chatroom/model/contact.dart';
import 'package:chat_app/ui/pages/home/controller/homeController.dart';
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

final _fireStore = FirebaseFirestore.instance;


class ChatMethodsPersonal{

  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  HomeController _homeController = HomeController();
  final VoiceRoomMethods roomMethods = VoiceRoomMethods();

  void sendMessage(String msgText, UserModel user, String senderId) async {
    UserModel _toUserInfo = await _homeController.getUserById(senderId);
    var timeStamp = Timestamp.now();
    if(msgText != null || msgText != "") {
      await _fireStore
          .collection(MESSAGE_COLLECTION)
          .doc(senderId)
          .collection(user.id.toString())
          .doc(timeStamp.toString())
          .set({
        'name' : user.nName,
        'photo' : user.photo,
        'receiverId': user.id.toString(),
        'senderId': senderId,
        'text': msgText,
        'timestamp': timeStamp,
        'type': "text",
        'seen': false,
      });

      await _fireStore
          .collection(MESSAGE_COLLECTION)
          .doc(user.id.toString())
          .collection(senderId)
          .doc(timeStamp.toString())
          .set({
        'name' : user.nName,
        'photo' : user.photo,
        'receiverId': user.id.toString(),
        'senderId': senderId,
        'text': msgText,
        'timestamp': timeStamp,
        'type': "text",
        'seen': false,
      });

      addToContacs(toUser: _toUserInfo, fromUser: user, text: msgText );

      roomMethods.chatNotification(to: senderId, from: user, text: msgText);

    }
  }




  Future<void> addToFromUserContacts(UserModel toUser, UserModel fromUser, currentTime, String text) async {
    ContactHome receiverContact = ContactHome(
        uid: toUser.id.toString(),
        addedon: currentTime,
        type: "single",
        name: toUser.fName + " " + toUser.nName,
        photo: toUser.photo,
        text: text,
    );
    var rMap = receiverContact.toMap(receiverContact);
    _fireStore.collection(CONTACTS_COLLECTION)
        .doc(fromUser.id.toString())
        .collection(CONTACT_COLLECTION)
        .doc(toUser.id.toString()).set(rMap);
  }


  Future<void> addToUserContacts(UserModel toUser, UserModel fromUser, currentTime, String text) async {

   var db = _fireStore.collection(CONTACTS_COLLECTION)
        .doc(toUser.id.toString())
        .collection(CONTACT_COLLECTION)
        .doc(fromUser.id.toString());
       await db.set({
         "added_on": currentTime,
         "contact_id" : fromUser.id.toString(),
         "type": "single",
         "name": fromUser.fName + " " + fromUser.nName,
         "photo" : fromUser.photo,
         "text": text,
         "count" : FieldValue.increment(1),
       }, SetOptions(merge: true));
  }


  // create a place holder to show file is uploading
  void setImageMessage(Timestamp timestamp, String url, String fromUserId, String toUserId, String text, String type) async {
    UserModel _toUserInfo = await _homeController.getUserById(toUserId);
    UserModel _fromUserInfo = await _homeController.getUserById(fromUserId);

    await _fireStore
        .collection(MESSAGE_COLLECTION)
        .doc(toUserId)
        .collection(fromUserId)
        .doc(timestamp.toString())
        .set({
      'receiverId': fromUserId,
      'senderId': toUserId,
      'text': text,
      'timestamp': timestamp,
      'type': type,
      'photoUrl': url,
      'seen': false,
    });
    await _fireStore
        .collection(MESSAGE_COLLECTION)
        .doc(fromUserId)
        .collection(toUserId)
        .doc(timestamp.toString())
        .set({
      'receiverId': fromUserId,
      'senderId': toUserId,
      'text': text,
      'timestamp': timestamp,
      'type': type,
      'photoUrl': url,
      'seen': false,
    });

   // addToContacs(toUser: _toUserInfo, fromUser: _fromUserInfo);

  }


  // Update place holder and show file to user
  void setImageMessageUpdate(Timestamp timestamp, String url, String fromUserId, String toUserId, String text, String type) async {
    UserModel _toUserInfo = await _homeController.getUserById(toUserId);
    UserModel _fromUserInfo = await _homeController.getUserById(fromUserId);
    await _fireStore
        .collection(MESSAGE_COLLECTION)
        .doc(toUserId)
        .collection(fromUserId)
        .doc(timestamp.toString())
        .update({
      'timestamp': timestamp,
      'type': type,
      'photoUrl': url,
      'text': text,
    });
    await _fireStore
        .collection(MESSAGE_COLLECTION)
        .doc(fromUserId)
        .collection(toUserId)
        .doc(timestamp.toString())
        .update({
      'timestamp': timestamp,
      'type': type,
      'photoUrl': url,
      'text': text,
    });

    addToContacs(toUser: _toUserInfo, fromUser: _fromUserInfo);

  }

  addToContacs({UserModel toUser, UserModel fromUser, String text}) async{
    Timestamp currentTime = Timestamp.now();
    await addToFromUserContacts(toUser, fromUser, currentTime, text);
    await addToUserContacts(toUser, fromUser, currentTime, text);
  }


  static int StateToNum(UserState userState){
    switch(userState){
      case UserState.Offline:
        return 0;
      case UserState.Online:
        return 1;
      default:
        return 2;
    }

  }

  static UserState numToState(int number){

    switch(number){
      case 0:
        return UserState.Offline;
      case 1:
        return UserState.Online;
      default:
        return UserState.Waiting;
    }

  }

  void setUserStatus({String userId}){
    var dbref = _databaseReference.child('users/$userId');
    try{
      dbref.set({
        "userState" : 1,
        "timeStamp": ServerValue.timestamp
      });
      dbref.onDisconnect().update({
        "userState" : 0,
        "timeStamp": ServerValue.timestamp
      });
    }catch(e){
      print("Firebase error");
    }
  }


  void setTyping({String userId}){
    var dbref = _databaseReference.child('users/$userId');
    dbref.update({
        "isTyping" : true,
        "timeStamp": ServerValue.timestamp,
        "userState" : 1,
      });
    dbref.onDisconnect().update({
        "isTyping" : false,
        "timeStamp": ServerValue.timestamp,
        "userState" : 0,
      });
  }

  void setNotTyping({String userId}){
    var dbref = _databaseReference.child('users/$userId');
    dbref.update({
      "isTyping" : false,
      "timeStamp": ServerValue.timestamp
    });
    dbref.onDisconnect().update({
      "isTyping" : false,
      "timeStamp": ServerValue.timestamp
    });
  }

  Stream getUserOnlineState({String userId}){
    var dbref = _databaseReference.child('users/$userId');
    return dbref.onValue;

  }

  



  Stream<QuerySnapshot> getUnreadMessage({@required String toUid, String fromUid}) => _fireStore
      .collection("messages").doc(fromUid)
      .collection(toUid)
      .where('receiverId', isNotEqualTo: fromUid)
      .where("seen",isEqualTo: false).snapshots();

  Future<QuerySnapshot> getUnreadMsg({@required String toUid, String fromUid}) {
    print("futurterd called from functions");
   return _fireStore
        .collection("messages")
        .doc(fromUid)
        .collection(toUid)
        .where('receiverId', isNotEqualTo: fromUid)
        .where("seen", isEqualTo: false).get();
  }

    setMessageCountZero({@required String toUid, String fromUid}) =>
        _fireStore.collection(CONTACTS_COLLECTION)
        .doc(fromUid)
        .collection(CONTACT_COLLECTION)
        .doc(toUid).update({"count": 0});


}