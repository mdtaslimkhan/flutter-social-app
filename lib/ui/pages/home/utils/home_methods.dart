import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/util/constants.dart';

class HomeMethods{

 static final _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getHomeContactWithLastMessage({String userId}) =>
      _firestore.collection(CONTACTS_COLLECTION)
        .doc(userId)
        .collection(CONTACT_COLLECTION)
        .orderBy('added_on',descending: true)
       // .where("block", isNotEqualTo: true)
        .snapshots();





 Future getContactByGroupId({String userId, String groupId}) {
   var dt = _firestore.collection(CONTACTS_COLLECTION)
       .doc(userId)
       .collection(CONTACT_COLLECTION)
       .doc(groupId)
       .get();
   return dt;
 }


   Stream<QuerySnapshot> getSingleUserMessage({String userId}) => _firestore.collection(CONTACTS_COLLECTION)
        .doc(userId)
        .collection(CONTACT_COLLECTION)
       .snapshots();


   Stream<QuerySnapshot> getGroupMessage({String userId}) => _firestore.collection(CONTACTS_COLLECTION)
        .doc(userId)
        .collection(CONTACT_GROUP_COLLECTION).snapshots();




}