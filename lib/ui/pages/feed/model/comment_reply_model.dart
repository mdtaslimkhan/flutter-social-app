import 'dart:convert';

import 'package:chat_app/ui/pages/coments/model/comment_reply.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;

class ComentReplyList extends StatefulWidget {
  ComentReplyList({
    this.commentId,
    this.currentUserId,
    this.reply,
    this.showBottomst
  });
  final int commentId;
  final int currentUserId;
  final Reply reply;
  final showBottomst;

  @override
  _ComentReplyListState createState() => _ComentReplyListState();
}

class _ComentReplyListState extends State<ComentReplyList> {
  bool isSubcommentLike = false;
  int mCount = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      widget.reply.risLiked > 0 ? isSubcommentLike = true : isSubcommentLike = false;
      mCount = widget.reply.rtlike;
    });
  }

  submitReplyCommentLike() async{
    final String url = BaseUrl.baseUrl("comentReplyLike");
    final http.Response response = await http.post(Uri.parse(url),
        headers: {'test-pass' : ApiRequest.mToken},
        body: {
          'comment_id' : widget.reply.id.toString(),
          'user_id' : widget.currentUserId.toString(),
          'post_id' : widget.reply.postId.toString(),
          'isLiked' : '1',
        }
    );
    var str = jsonDecode(response.body);
    setState(() {
      // getComments = getPostComments();
    });
    return true;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, top: 2, right: 10, bottom: 2),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 20,
                width: 20,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.reply.photos),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${widget.reply.name}',
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Segoe",
                            fontWeight: FontWeight.w800
                        ),),
                      Text('${widget.reply.comment}',
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: "Segoe",
                           fontWeight: FontWeight.w600
                        ),
                      ),
                      Text('${widget.reply.createdAt}',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontFamily: "Segoe",
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.reply_all,
                  color: Colors.grey,
                  size: 18,),
                onPressed: () => widget.showBottomst(widget.commentId.toString(),
                    widget.reply.postId.toString(), widget.reply.name, widget.reply.userId),

              ),
              IconButton(
                icon: Icon(
                  !isSubcommentLike ? FontAwesome.heart_o : FontAwesome.heart,
                  color: !isSubcommentLike ? Colors.redAccent : Colors.redAccent,
                  size: 15,),
                onPressed: () {
                  submitReplyCommentLike();
                  setState(() {
                    !isSubcommentLike ? isSubcommentLike = true : isSubcommentLike = false;
                    !isSubcommentLike ? mCount -- : mCount++;
                  });
                },
              ),
              Text('$mCount',
                style: TextStyle(
                    fontSize: 10
                ),),
            ],
          ),
          SizedBox(height: 8,),
          Divider(height: 0.0),
        ],
      ),
    );
  }

}

