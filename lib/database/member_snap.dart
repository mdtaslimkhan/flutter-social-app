import 'package:cloud_firestore/cloud_firestore.dart';

class MemberSnap {
  final QuerySnapshot snapshot;
  MemberSnap(this.snapshot);
}