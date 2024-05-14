
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
final _fireStore = FirebaseFirestore.instance;


class LoaderBubble extends StatelessWidget {
  final String docId;
  final bool isMe;
  LoaderBubble({
    this.docId,
    this.isMe
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15, bottom: 15),
      child: Row(
        mainAxisAlignment: !isMe ? MainAxisAlignment.start :  MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 5,
          ),
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 9,
                      offset: Offset(0, 0),
                      color: Colors.black45.withOpacity(0.2),
                      spreadRadius: 1),
                ],
                border: Border.all(width: 1.5, color: Colors.white),
                color: Colors.white
              ),
            height: 70,
            width: 70,
            child: Center(child: CircularProgressIndicator())
          ),
        ],
      ),
    );
  }


}


