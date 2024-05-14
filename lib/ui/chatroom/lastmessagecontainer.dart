import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/storage/local_db.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/call/permissionhandler.dart';
import 'package:chat_app/ui/call/util/callUtil.dart';
import 'package:chat_app/ui/chatroom/utils/online_indicator.dart';
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final _fireStore = FirebaseFirestore.instance;

class LastMessageContainer extends StatelessWidget {

  final UserModel senderId;
  final UserModel receiverId;
  LastMessageContainer({@required this.senderId, this.receiverId});


  showUserInfo(parentContext, UserModel toUser){
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              "User details: ",
              style: fldarkgrey15,
            ),
            children: [
              Hero(
                tag: 'img-${toUser.id}',
                child: Container(
                  width: MediaQuery.of(context).size.width*0.5,
                  height: MediaQuery.of(context).size.width*0.5,
                  child: toUser.photo != null ?  cachedNetworkImg(context,toUser.photo) : AssetImage('assets/u3.gif'),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                    Text("${toUser.nName}"),
                  ],
                ),
              ),

              SimpleDialogOption(
                child: Text("Close"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    );
  }

  insertData({int id, String title, String message, String image, String date,
    String seen, String docId, int type}) async {
   var exist = await LocalDbHelper.instance.checkifDataExist(id);
   if(!exist) {
     int i = await LocalDbHelper.instance.insertLastMessage({
       LocalDbHelper.lastmessageId: id,
       LocalDbHelper.lastmessageTitle: title,
       LocalDbHelper.lastmessageMessage: message,
       LocalDbHelper.lastmessageImage: image,
       LocalDbHelper.lastmessageDate: date,
       LocalDbHelper.lastmessageSeen: seen,
       LocalDbHelper.lastmessageDocId: docId,
       LocalDbHelper.lastmessageType: type,
     });
   }else{
   }
  }

  @override
  Widget build(BuildContext context) {


    return StreamBuilder(
      stream: _fireStore.collection("messages").doc(senderId.id.toString())
          .collection(receiverId.id.toString())
          .orderBy("timestamp",descending: true).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(snapshot.hasData){
          var docList = snapshot.data.docs.first.data() as Map;


          if(docList.isNotEmpty) {
            final msgText = docList['text'];
            final time = docList['timestamp'].toDate();
            String dateTime = DateFormat( "hh:mm a dd/M/yy").format(time);

            insertData(
                id: receiverId.id,
                title: '${receiverId.fName} ${receiverId.nName}',
                message: msgText,
                date: dateTime,
                image: receiverId.photo,
                seen: 'seen',
                docId: senderId.id.toString(),
                type: 1
            );

            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: GestureDetector(
                      child: Hero(
                        tag: 'img-${receiverId.id}',
                        child: OnlineIndicator(
                          uid: receiverId.id.toString(),
                          photo: receiverId.photo,
                          from: senderId,
                        ),
                      ),
                      onTap: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => Sandbox3(user: fromMessageSender,)));
                        showUserInfo(context, receiverId);
                      },
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${receiverId.fName} ${receiverId.nName}',
                            style: fldarkHome16,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                          '$msgText',
                          style: fldarkgrey12,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '$dateTime',
                            style: fldarkgrey10,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12, top: 14),
                    child: MaterialButton(
                      padding: EdgeInsets.all(0),
                      minWidth: 35,
                      child: Icon(
                          Icons.call,
                          color: Colors.blueAccent
                      ),
                      onPressed: () async => await PermissionHandlerUser().onJoin() ?
                      CallUtils.mdial(
                          from: senderId,
                          toUserId: receiverId.id.toString(),
                          context: context,
                          type: 1
                      ) : {},
                    ),
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

