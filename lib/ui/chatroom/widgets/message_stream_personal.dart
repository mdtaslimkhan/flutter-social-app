import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/chatroom/model/message_model_personal.dart';
import 'package:chat_app/ui/chatroom/widgets/pdrsonal_widget/personal_message_boubble.dart';
import 'package:chat_app/ui/pages/feed/widgets/single_post_image_page.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/profile.dart';
import 'package:chat_app/ui/pages/widgets/progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';


final _fireStore = FirebaseFirestore.instance;

class MessageStreamPersonal extends StatelessWidget {

  final UserModel from;
  final UserModel to;
  final onPressedReply;
  MessageStreamPersonal({this.from, this.to, this.onPressedReply});

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  scrollToPos(String replyId, List<MessageBubble> msg){

    int index = msg.indexWhere((MessageBubble item) {
     return item.docId == replyId;
    });
    itemScrollController.scrollTo(
      index: index,
      duration: Duration(milliseconds: 1000),
      alignment: 0,
      curve: Curves.fastOutSlowIn,
    );

  }

  @override
  Widget build(BuildContext context) {
    return  Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: _fireStore
            .collection("messages")
            .doc(from.id.toString())
            .collection(to.id.toString())
            .orderBy("timestamp",descending: true)
            .snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            circularProgress();
          }
          if(snapshot.hasData) {
            final List<MessageBubble> messagesData = [];
            snapshot.data.docs.map((ds)  {
              final id = ds.id;
              var dt = ds.data() as Map;
              MessageModelPersonal _mmp = MessageModelPersonal.fromMap(dt);
              // final msgText = dt['text'];
              //
              // var msgSeen;
              // if(dt['seen'] != null) {
              //   msgSeen = dt['seen'];
              // }
              // final msgReceiver = dt['receiverId'];
              // final msgType = dt['type'];
              // final msgPhoto = dt['photoUrl'];
              // final msgTime = dt['timestamp'].toDate();
              if(to.id.toString() == _mmp.receiverId && !_mmp.seen){
                DocumentReference r = _fireStore
                    .collection("messages")
                    .doc(to.id.toString())
                    .collection(from.id.toString())
                    .doc(dt["timestamp"].toString());
                r.set({"seen" : true}, SetOptions(merge: true));
              }
              final allText = MessageBubble(
                msg: _mmp,
              //  text: _mmp.text,
                to: to,
              //  myPhoto: from.photo,
                isMe: from.id.toString() == _mmp.receiverId,
              //  type: _mmp.type,
              //  photo: _mmp.url,
              //  time: _mmp.timestamp,
                loggedUser: from,
                id: id,
              //  seen: _mmp.seen,
             //   onPress: onPress,
                scrollTo: () => scrollToPos(_mmp.replyId, messagesData),
                onPressedReply: onPressedReply,
              );
              messagesData.add(allText);
            }).toList();
            return ScrollablePositionedList.builder(
              reverse: true,
              itemCount: messagesData.length,
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              itemBuilder: (context, index) => messagesData[index],
              itemScrollController: itemScrollController,
              itemPositionsListener: itemPositionsListener,
            );
          }
          return circularProgress();
        },
      ),
    );
  }
}



