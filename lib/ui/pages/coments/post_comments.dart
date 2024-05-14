import 'dart:convert';
import 'package:chat_app/model/post/post.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/chatroom/function/voice_room_methods.dart';
import 'package:chat_app/ui/pages/coments/comments_controller.dart';
import 'package:chat_app/ui/pages/coments/model/comment_reply.dart';
import 'package:chat_app/ui/pages/feed/model/comment.dart';
import 'package:chat_app/ui/pages/feed/model/comment_model.dart';
import 'package:chat_app/ui/pages/feed/widgets/single_post_image_page.dart';
import 'package:chat_app/ui/pages/share/share_person_lis.dart';
import 'package:chat_app/ui/pages/widgets/progress.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;


class Comments extends StatefulWidget {

  final UserModel user;
  final Post post;
  final Comment comment;

  Comments({this.user, this.post, this.comment});

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  ScrollController _scrollController = ScrollController();
  TextEditingController _ctrComment = TextEditingController();
  TextEditingController _replyController = TextEditingController();
  final VoiceRoomMethods roomMethods = VoiceRoomMethods();
  final CommentsController _commentsController = CommentsController();

  List<Comment> cmntList = [];
  bool isCommetField = false;
  Future getComments;
  int _addPage = 2;
  bool tiggredOnce = true;
  bool _isBottomLoader = true;
  bool _onReply = false;
  FocusNode mfocusNode;
  bool loadingFinished = false;




  @override
  void initState() {
    super.initState();
    // prevent firing multiple time
    getComments = getPostComments();
    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        // at the end point load data from server
        getMoreData();
      }
    });

    mfocusNode = FocusNode();

  }
  // get all comments
  Future<bool> getPostComments() async {
    print(widget.user.id);
    print(widget.post.id);
    List<Comment> cmLst = [];
    final String url = BaseUrl.baseUrl("getPostComment/${widget.user.id.toString()}/${widget.post.id.toString()}");
    final http.Response response = await http.get(Uri.parse(url),
      headers: {'test-pass' : ApiRequest.mToken},
    );
    var data = jsonDecode(response.body);
    var comnt = data['comments'];
    if(tiggredOnce) {
      _commentsController.cmnList.value.clear();
      comnt.forEach((val){
        _commentsController.cmnList.value.add(Comment.fromJson(val));
      });
      _commentsController.cmnList.notifyListeners();
      setState(() {
        loadingFinished = true;
      });
    }
    return true;
  }
  // fire every time when at the end
  getMoreData() async{
    final http.Response response = await http.get(
        Uri.parse(BaseUrl.baseUrl("getPostComment/${widget.user.id.toString()}/${widget.post.id.toString()}?page=$_addPage")),
        headers: {'test-pass' : ApiRequest.mToken});
    var str = jsonDecode(response.body);
    var data = str['comments'];
    var lPage = str['last_page'];
    // add data to list every time when at the and end
    data.forEach((val) {
    //  cmntList.add(Comment.fromJson(val));
      _commentsController.cmnList.value.add(Comment.fromJson(val));
    });
    _commentsController.cmnList.notifyListeners();

    // increase page number after fetching data finished
    _addPage >= lPage ? _isBottomLoader = false : _isBottomLoader = true;
    _addPage = _addPage + 1;
    // rebuild state when finished loading data
    setState(() {
      // Future getPostItem() will stop adding data when  tiggredOnce = false
      tiggredOnce = false;
      // bottom loader will stop showing when data view completed

    });
  }
  // submit comment on post
  submitPost() async {
    final String url = BaseUrl.baseUrl("postComment");
    final http.Response response = await http.post(Uri.parse(url),
        headers: {'test-pass' : ApiRequest.mToken},
        body: {
          'user_id' : widget.user.id.toString(),
          'post_id' : widget.post.id.toString(),
          'comment' : _ctrComment.text,
        }
    );
    var data = jsonDecode(response.body);
    var commentId = data['comment']['id'];

    _commentsController.cmnList.value.insert(0, Comment(
      id: commentId,
      name: widget.user.fName + " " + widget.user.nName ,
      photo: widget.user.photo,
      userId: widget.user.id,
      postId: widget.post.id,
      comment: _ctrComment.text,
      tlike: 0,
      isLiked: 0,
      reply: [],
      replyLastPage: 0,
      createdAt: '1 seconds ago',
    ));
    _commentsController.cmnList.notifyListeners();
    mfocusNode.unfocus();

    bool notCurrentUser = widget.user.id.toString() == widget.post.userId.toString() ? false : true;
    if(notCurrentUser) {
      roomMethods.sendNotification(
          to: widget.post.userId.toString(), from: widget.user, type: 2);
    }

    return true;

  }
  // main comments list
  commentList(){
     return ValueListenableBuilder(
       valueListenable: _commentsController.cmnList,
       builder: (context, List<Comment> cla, _) {
         if(cla.length > 0) {
           return Container(
             child: SliverList(
               delegate: SliverChildBuilderDelegate((context, index) {
                 return CommentList(
                   showBottomst: showBottomSts,
                   logedUserId: widget.user.id,
                   comment: _commentsController.cmnList.value[index],
                 );
               },
                   childCount: _commentsController.cmnList.value.length
               ),
             ),
           );
         }else{
           return SliverToBoxAdapter(
               child: Container(
                   height: 300,
                   child: Center(child: !loadingFinished ? CircularProgressIndicator() : Text("No comments found", style: fldarkgrey12,))
               ),
           );
         }
       }
     );
  }

  String replyCommentId;
  String replyPostId;
  int replyUserId;
  showBottomSts(String commentId, String postId, String userName, int userId) {
  //  var textField = TextField(focusNode: focusNode)
    replyCommentId = commentId;
    replyPostId = postId;
    replyUserId = userId;
    setState(() {
      _onReply = true;
    });
    mfocusNode.requestFocus();
    _replyController..text = "@$userName ";
  }

// build main comment
  buildComments(){
    return FutureBuilder(
      future: getComments,
      builder: (context, snapshot){
        return snapshot.hasData ? commentList() : circularProgress();
      },
    );
  }

  onRefreshData() async {
    bool isRefreshed = await getPostComments();
    return isRefreshed;
  }

  // comment item
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: GestureDetector(
        onTap: () {
          setState(() {
            _onReply = false;
          });
          FocusScope.of(context).requestFocus(new FocusNode());
        //  mfocusNode.unfocus();
        },
        child: RefreshIndicator(
          onRefresh: () => onRefreshData(),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.share_sharp,
                          color: Colors.white,
                          size: 15,
                        ),
                        onPressed: () async {
                          var mList = await Navigator.push(context, MaterialPageRoute(builder: (context) => Sharelist(post: widget.post, user: widget.user,)));
                          if(mList != null) {
                            final String url = BaseUrl.baseUrl('mSharePost');
                            final response = await http.post(Uri.parse(url),
                                headers: {'test-pass': ApiRequest.mToken},
                                body: {
                                  'aList': "${mList.toString()}",
                                  'post_id': "${widget.post.id}",
                                  'who_sharing': "${widget.user.id}",
                                });
                            Map data = jsonDecode(response.body);
                          }
                        },
                      ),
                    ],
                  ),
                ],
                backgroundColor: Colors.blueAccent,
                pinned: true,
                floating: false,
                expandedHeight: MediaQuery.of(context).size.height / 7 * 3,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  background: GestureDetector(
                      child: Container(
                        child: cachedNetworkImgPostDetail(context, widget.post.photo),
                        height: 250,
                        width: MediaQuery.of(context).size.width,
                      ),
                      onTap: () {
                        viewFullImage(context, widget.post.photo);
                      }
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 6 * 4,
                      child: Text("${widget.post.title}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))
                ),
              ),

              SliverToBoxAdapter(
                child: ListTile(
                  title: !_onReply ? TextFormField(
                    enabled: true,
                    focusNode: mfocusNode,
                    controller: _ctrComment,
                    decoration: InputDecoration(
                      hintText: 'Write a comment...',
                    ),
                  ) : TextFormField(
                      enabled: true,
                      focusNode: mfocusNode,
                      controller: _replyController,
                      decoration: InputDecoration(
                      hintText: 'Reply...',
                      ),
                  ),
                  trailing: TextButton(
                    child: Text('Post'),
                    onPressed: () async {
                      if(!_onReply) {
                        if(_ctrComment.text.length > 0) {
                          await submitPost();
                          _ctrComment.clear();
                        }else{
                          Fluttertoast.showToast(msg: "Enter some text");
                        }
                      }else{
                        if(_replyController.text.length > 0) {
                          submitReply(replyCommentId, replyPostId, replyUserId);
                          _replyController.clear();
                        }else{
                          Fluttertoast.showToast(msg: "Enter some text");
                        }
                      }
                    },
                  ),
                ),
              ),
              commentList(),
            ],
          ),
        ),
      ),
    );
  }

  submitReply(String commentId,String postId,int repliedUserId) async{
    final String url = BaseUrl.baseUrl("cmntReplyCreate");
    final http.Response response = await http.post(Uri.parse(url),
        headers: {'test-pass' : ApiRequest.mToken},
        body: {
          'comment_id' : commentId,
          'user_id' : widget.user.id.toString(),
          'post_id' : postId,
          'comment' : _replyController.text,
          'replied_user' : repliedUserId != null && repliedUserId > 0 ? '$repliedUserId' : '0',
        }
    );
    var str = jsonDecode(response.body);
    _commentsController.cmnReplyList.notifyListeners();

    setState(() {
      _onReply = false;
    });
    mfocusNode.unfocus();
    return true;
  }

  viewFullImage(BuildContext context, String photo){
    Navigator.push(context, MaterialPageRoute(builder: (context) => Singleimagepage(photo: photo,)));
  }

}
