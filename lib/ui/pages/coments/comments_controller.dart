
import 'dart:convert';

import 'package:chat_app/ui/pages/coments/model/comment_reply.dart';
import 'package:chat_app/ui/pages/coments/post_comments.dart';
import 'package:chat_app/ui/pages/feed/model/comment.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;


class CommentListAll{
  CommentListAll();
  List<Comment> comntList = [];
  List<Reply> replyList = [];



}

class CommentsController{

  ValueNotifier<CommentListAll> comment = ValueNotifier(CommentListAll());
  ValueNotifier<List<Comment>> cmnList = ValueNotifier(<Comment>[]);
  ValueNotifier<List<Reply>> cmnReplyList = ValueNotifier(<Reply>[]);



  List<Comment> cmntList = [];
  bool tiggredOnce = true;
  Future<bool> getPostComments({String userId, String postId}) async {
    final String url = BaseUrl.baseUrl("getPostComment/${userId}/${postId}");
    final http.Response response = await http.get(Uri.parse(url),
      headers: {'test-pass' : ApiRequest.mToken},
    );
    var data = jsonDecode(response.body);
    var comnt = data['comments'] as List;
    if(tiggredOnce) {
      cmntList = comnt.map<Comment>((val) => Comment.fromJson(val)).toList();
    }
    return true;
  }


}

