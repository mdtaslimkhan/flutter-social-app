import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/chatroom/model/message_model.dart';
import 'package:chat_app/ui/chatroom/model/message_model_personal.dart';
import 'package:chat_app/ui/chatroom/widgets/name_admin_owner.dart';
import 'package:flutter/material.dart';

class ChatLinkPersonal extends StatelessWidget {

  final bool isMe;
  final MessageModelPersonal msg;
  ChatLinkPersonal({this.isMe, this.msg});

  @override
  Widget build(BuildContext context) {
    var _errorImage;
    return  Container(
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start ,
        children: [
          SizedBox(height: 5,),
          if(!isMe)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Container(
                  height: 33,
                  width: 33,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 9,
                          offset: Offset(0, 0),
                          color: Colors.black45.withOpacity(0.2),
                          spreadRadius: 1),
                    ],
                    border: Border.all(width: 1.5, color: Colors.white),
                  ),
                  child: cachedNetworkImageCircular(context, msg.url),
                ),
                SizedBox(width: 5,),
                Container(
                  width: MediaQuery.of(context).size.width * .45,
                  height: 30,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      userName(msg.senderName),
                      adminCheckStream(msg.role),
                    ],
                  ),
                ),
              ],
            ),
          // Container(
          //   width: MediaQuery.of(context).size.width * .65,
          //   child: ![null,''].contains(msg.text) ? AnyLinkPreview(
          //     link: msg.text,
          //    // displayDirection: uiDirection.uiDirectionVertical,
          //     showMultimedia: true,
          //     bodyMaxLines: 10,
          //     cache: Duration(days: 7),
          //     bodyTextOverflow: TextOverflow.ellipsis,
          //     titleStyle: TextStyle(
          //       color: Colors.black,
          //       fontWeight: FontWeight.bold,
          //       fontSize: 12,
          //     ),
          //     bodyStyle: TextStyle(color: Color(0xff2f2f2f), fontSize: 10),
          //     backgroundColor: Colors.grey[300],
          //     errorWidget: Container(
          //       color: Colors.grey[300],
          //       child: Center(child: Text('Oops! link error')),
          //     ),
          //     errorImage: _errorImage,
          //   ) : Container(),
          // ),

        ],
      ),
    );
  }
}
