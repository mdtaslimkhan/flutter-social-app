import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/chatroom/bottomModal/user_profile_details.dart';
import 'package:chat_app/ui/chatroom/model/message_model.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:chat_app/ui/pages/widgets/progress.dart';
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'message_bubble_group.dart';

final _fireStore = FirebaseFirestore.instance;

class MessageStreamGroup extends StatelessWidget {
  final UserModel from;
  final GroupModel to;
  final onPressedReply;

  MessageStreamGroup({this.from, this.to, this.onPressedReply});


  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();


  scrollToPos(String replyId, List<MessageBubbleGroup> msg){
  int index = msg.indexWhere((MessageBubbleGroup item) {
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
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: _fireStore
            .collection(BIG_GROUP_MESSAGE_COLLECTION)
            .doc(to.id.toString())
            .collection("messages")
            .limit(50)
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            circularProgress();
          }

          if (snapshot.hasData) {
            final List<MessageBubbleGroup> messagesData = [];
            final messages = snapshot.data.docs;
            for (var message in messages) {
              var msg = message.data() as Map;
               final id = message.id;
              MessageModel mMessage = MessageModel.fromMap(msg);
              final allMessage = MessageBubbleGroup(
                docId: id,
                isMe: from.id.toString() == mMessage.senderId,
                loggedUser: from,
                group: to,
                onPressedReply: onPressedReply,
                msg: mMessage,
                scrollTo: () => scrollToPos(mMessage.replyId, messagesData),
              );
              messagesData.add(allMessage);

            }
            return ScrollablePositionedList.builder(
              itemCount: messagesData.length,
              reverse: true,
              itemBuilder: (context, index) => messagesData[index],
              itemScrollController: itemScrollController,
              itemPositionsListener: itemPositionsListener,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            );
          }
          return circularProgress();
        },
      ),
    );
  }
}
