import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


final _fireStore = FirebaseFirestore.instance;

class LastMessageContainerBigGroup extends StatelessWidget {
  final String name;
  final String senderId;
  final String receiverId;
  LastMessageContainerBigGroup({@required this.name, @required this.senderId, this.receiverId});

  @override
  Widget build(BuildContext context) {


    return StreamBuilder(
      stream: _fireStore.collection(BIG_GROUP_MESSAGE_COLLECTION).doc(receiverId)
          .collection("messages")
          .orderBy("timestamp",descending: true).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(snapshot.hasData){
          var docList = snapshot.data.docs.first.data() as Map;

          print(docList);

          if(docList.isNotEmpty){
            final msgText = docList['text'];
            final time = docList['timestamp'].toDate();
            String dateTime = DateFormat( "hh:mm a dd/M/yy").format(time);

            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text("$name",
                          style: fldarkHome16,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          msgText,
                          style: fldarkgrey12,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '$dateTime',
                    style: fldarkgrey10,
                    maxLines: 1,
                  ),
                ],
              ),
            );
          }

          return Text("No message found",
            style: fldarkgrey12,
          );

        }

        return Text("..",
          style: fldarkgrey12,
        );
      }
    );
  }
}

