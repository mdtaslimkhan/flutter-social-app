


import 'package:chat_app/database/member_snap.dart';
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseRepo{

  final _fireStore = FirebaseFirestore.instance;

  Stream<MemberSnap> get homeContacts {
    return _fireStore.collection(BIG_GROUP_COLLECTION)
        .snapshots().map((QuerySnapshot qs) => MemberSnap(qs));
  }

}