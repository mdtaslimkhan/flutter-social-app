import 'dart:io';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:chat_app/ui/pages/home/controller/homeController.dart';
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _fireStore = FirebaseFirestore.instance;
class ChatMethodsBigGroup{

   HomeController _homeController = HomeController();

   // function for big group

   void replyBigGroupMessage({String replyId, String replyUser, String replyPhoto, String reply, String url, String msgText, String fromUserId,
     String name, String userPhoto, String groupId, int role}) async {
     if(msgText != null || msgText != "") {
       await _fireStore.collection(BIG_GROUP_MESSAGE_COLLECTION)
           .doc(groupId)
           .collection("messages")
           .add({
         'name' : name,
         'photo' : userPhoto,
         'receiverId': fromUserId,
         'senderId': groupId,
         'text': msgText,
         'replyId' : replyId,
         'reply': reply,
         'replyName' : replyUser,
         'replyPhoto' : replyPhoto,
         'timestamp': Timestamp.now(),
         // file url as photoUrl
         'photoUrl': url,
         'type': 'reply',
         'role': role == 1 ? "Owner" : role == 2 ? "Admin" : "",
       });
       addSendersToBigGroupContacts(groupId, fromUserId, msgText);
     }
   }

  void sendBigGroupMessage({String url, String msgText, String fromUserId,
    String name, String photo, String groupId, int role}) async {
    String type = "text";
    _isLink(msgText) ? type = "link" : "text";
    if(msgText != null || msgText != "") {
      await _fireStore.collection(BIG_GROUP_MESSAGE_COLLECTION)
          .doc(groupId)
          .collection("messages")
          .add({
            'name' : name,
            'photo' : photo,
            'receiverId': fromUserId,
            'senderId': groupId,
            'text': msgText,
            'timestamp': Timestamp.now(),
        // file url as photoUrl
            'photoUrl': url,
            'type': type,
            'role': role == 1 ? "Owner" : role == 2 ? "Admin" : "",
      });
      addSendersToBigGroupContacts(groupId, fromUserId, msgText);
    }
  }

   bool _isLink(String input) {
     final matcher = new RegExp(
         r"(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)");
     return matcher.hasMatch(input);
   }


   // set place holder to show file is uploading
   Future<String> sendBigGroupFile({String fileSource, String url, String msgText, String fromUserId,
     String name, String photo, String groupId, String type, int role}) async {
    String id;
     if(msgText != null || msgText != "") {
      DocumentReference dt = await _fireStore.collection(BIG_GROUP_MESSAGE_COLLECTION)
           .doc(groupId)
           .collection("messages")
           .add({
         'name' : name,
         'photo' : photo,
         'receiverId': fromUserId,
         'senderId': groupId,
         'text': msgText,
         'timestamp': Timestamp.now(),
         'photoUrl': url,
         'type': type,
         'role': role == 1 ? "Owner" : role == 2 ? "Admin" : "",
         'source': fileSource
       });
       id = dt.id;
     }
     return id;
   }


   // update place holder and show file
   void sendBigGroupFileUpdate({String id, String url, String msgText, String fromUserId, String groupId, String type}) async {
     if(msgText != null || msgText != "") {
       await _fireStore.collection(BIG_GROUP_MESSAGE_COLLECTION)
           .doc(groupId)
           .collection("messages")
           .doc(id)
           .update({
             'text': msgText,
             'timestamp': Timestamp.now(),
             'photoUrl': url,
             'type': type,
       });
       addSendersToBigGroupContacts(groupId, fromUserId, msgText);
     }
   }


  Future<void> addSendersToBigGroupContacts(String groupId, String fromUserId,String text) async {
    GroupModel _groupModel = await _homeController.getGroupById(groupId);
    _fireStore.collection(CONTACTS_COLLECTION)
        .doc(fromUserId).collection(CONTACT_COLLECTION)
        .doc(groupId)
        .set({
          "contact_id": groupId,
          "userId" : fromUserId,
          "type": "bigGroup",
          "name" : _groupModel.name,
          "photo": _groupModel.photo,
          "added_on": Timestamp.now(),
          "text" : text
    });
  }



  Stream<QuerySnapshot> totalMembersStream({String groupId}) => _fireStore.collection(BIG_GROUP_COLLECTION).doc(
        groupId).collection("members")
      .snapshots();


  void messageForJoiningTheGroup({String msgText, String receiverId, String name, String photo, String groupId}) async {
    if(msgText != null || msgText != "") {
      await _fireStore.collection(BIG_GROUP_MESSAGE_COLLECTION)
          .doc(groupId)
          .collection("messages")
          .add({
        'name' : name,
        'photo' : photo,
        'receiverId': receiverId,
        'senderId': groupId,
        'text': msgText,
        'timestamp': Timestamp.now(),
        'type': "notify",
      });
    }
  }


  Stream<QuerySnapshot> ifAlreadyAnUser({String groupId, String userId}) =>
    _fireStore.collection(BIG_GROUP_COLLECTION).doc(
        groupId).collection("members").snapshots();

   Stream<QuerySnapshot> ifAlreadyInBlackList({String groupId, String userId}) =>
       _fireStore.collection(BIG_GROUP_COLLECTION).doc(
           groupId).collection("block").snapshots();

   Future<DocumentSnapshot> ifAlreadyAnUserCheck({String groupId, String userId}) {
    return _fireStore.collection(BIG_GROUP_COLLECTION).doc(
         groupId).collection("members")
         .doc(userId)
         .get();

   }



}

