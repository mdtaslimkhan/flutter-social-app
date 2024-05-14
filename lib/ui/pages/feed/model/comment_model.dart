import 'dart:convert';

import 'package:chat_app/ui/pages/coments/comments_controller.dart';
import 'package:chat_app/ui/pages/coments/model/comment_reply.dart';
import 'package:chat_app/ui/pages/feed/model/comment.dart';
import 'package:chat_app/ui/pages/feed/model/comment_reply_model.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;

class CommentList extends StatefulWidget {

  final showBottomst;
  final int logedUserId;
  final Comment comment;

  CommentList({
    this.showBottomst,
    this.logedUserId,
    this.comment,

  });

  @override
  _CommentListState createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {

  TextEditingController _ctrComment = TextEditingController();
  final CommentsController _commentsController = CommentsController();

  List<Reply> newReplyList = [];
  List<Reply> replyList = [];

  bool isCommentLike = false;
  bool isSubcommentLike = false;

  int count = 0;
  Future getCommentsReply;


  getReply(int id) async{
    final String url = BaseUrl.baseUrl("cmntReplyList/${widget.logedUserId}/$id");
    final http.Response response = await http.get(Uri.parse(url),
      headers: {'test-pass' : ApiRequest.mToken},
    );
    var data = jsonDecode(response.body);
    var comnt = data['reply'];
   // newReplyList = comnt.map<Reply>((val) => Reply.fromJson(val)).toList();
    _commentsController.cmnReplyList.value.clear();
    comnt.forEach((val){
      _commentsController.cmnReplyList.value.add(Reply.fromJson(val));
    });
    _commentsController.cmnReplyList.notifyListeners();
    return newReplyList;
  }

  @override
  void initState() {
    super.initState();
     getCommentsReply = getReply(widget.comment.id);
    replyList = widget.comment.reply;
    widget.comment.isLiked > 0 ? isCommentLike = true : isCommentLike = false;
    count = widget.comment.tlike;
  }



  submitCommentLike() async{
    final String url = BaseUrl.baseUrl("comentReact");
    final http.Response response = await http.post(Uri.parse(url),
        headers: {'test-pass' : ApiRequest.mToken},
        body: {
          'comment_id' : widget.comment.id.toString(),
          'user_id' : widget.logedUserId.toString(),
          'post_id' : widget.comment.postId.toString(),
          'isLiked' : '1',
        }
    );
    var str = jsonDecode(response.body);
    setState(() {
      // getComments = getPostComments();
    });
    return true;
  }

  // reply comments
  buildCommentItem(){
    return Container(
      margin: EdgeInsets.only(left: 30, top: 2),
      child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.comment.reply.length,
            reverse: false,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {

              return ComentReplyList(
                // need comment id for track comment
                commentId: widget.comment.id,
                currentUserId: widget.logedUserId,
                reply: widget.comment.reply[index],
                showBottomst: widget.showBottomst,
              );

            },
          ),
    );
  }

  // main comment list
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: 15, top: 3, right: 10, bottom: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 30,
                width: 30,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.comment.photo),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${widget.comment.name}',
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Segoe",
                            fontWeight: FontWeight.w800,
                            color: Color(0xff3c63db)
                        ),),
                      Text('${widget.comment.comment}',
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: "Segoe",
                            fontWeight: FontWeight.w800
                        ),
                      ),
                      Text('${widget.comment.createdAt}',
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                            fontFamily: "Segoe",
                            fontWeight: FontWeight.w800
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.reply_all,
                  color: Colors.grey,
                  size: 15,),
                onPressed: () => widget.showBottomst(widget.comment.id.toString(),widget.comment.postId.toString(), widget.comment.name,0),
              ),
              IconButton(
                icon: Icon(
                  !isCommentLike ? FontAwesome.heart_o : FontAwesome.heart,
                  color: !isCommentLike ? Colors.redAccent : Colors.redAccent,
                  size: 15,),
                onPressed: () {
                  submitCommentLike();
                  setState(() {
                    !isCommentLike ? isCommentLike = true : isCommentLike = false;
                    !isCommentLike ? count-- : count++;
                  });
                },
              ),
              Text('$count',
                style: TextStyle(
                    fontSize: 10
                ),),
            ],
          ),
        ),
        buildCommentItem(),
        Divider(height: 0.0),
      ],
    );

  }


}

