import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
final _fireStore = FirebaseFirestore.instance;


class LastMessageContainerGroup extends StatelessWidget {

  final String senderId;
  final String receiverId;
  LastMessageContainerGroup({@required this.senderId, this.receiverId});



  @override
  Widget build(BuildContext context) {


    return StreamBuilder(
      stream: _fireStore.collection("groupMessage").doc(receiverId)
          .collection("messages")
          .orderBy("timestamp",descending: true).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(snapshot.hasData){
          var docList = snapshot.data.docs.first.data() as Map;

          if(docList.isNotEmpty){
            final msgText = docList['text'];
            final time = docList['timestamp'];
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Text(
                    msgText,
                    style: fldarkgrey12,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    time,
                    style: fldarkgrey12,
                    maxLines: 1,
                  ),
                ],
              ),
            );
          }

          return Text("No message founds",
            style: fldarkgrey12,
          );

        }

        return Text("",
          style: fldarkgrey12,
        );
      }
    );
  }
}

