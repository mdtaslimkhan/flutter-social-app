import 'dart:convert';

import 'package:chat_app/model/post/post.dart';
import 'package:chat_app/model/quotes.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/pages/coments/post_comments.dart';
import 'package:chat_app/ui/pages/feed/widgets/postmaterial.dart';
import 'package:chat_app/ui/pages/feed/widgets/single_post_image_page.dart';
import 'package:chat_app/ui/pages/post/post_details_page.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/profile.dart';
import 'package:chat_app/ui/pages/share/share_person_lis.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:chat_app/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class SpaceSinglepost extends StatefulWidget {

  final UserModel user;
  final Post post;
  final int nType;
  SpaceSinglepost({this.user,this.post,this.nType});


  @override
  _SpaceSinglepostState createState() => _SpaceSinglepostState();
}

class _SpaceSinglepostState extends State<SpaceSinglepost> {


  // badges earned
  List<Quotes> badgeEarned = [
    Quotes(1, 'Gifts' , 'Hello, Assalamualikum, Kemon asen?'),
    Quotes(2, 'Visitors' , 'Hello, Assalamualikum, Kemon asen?'),
    Quotes(3, 'Groups' , 'Hello, Assalamualikum, Kemon asen?'),
  ];


  int _likeCount = 0;
  int _disLikeCount = 0;
  bool _isLiked = false;
  bool _isFollowing;
  bool _isOwnPost;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.post.like;
    _disLikeCount = widget.post.like;
      widget.post.currentUserLike == 1 ? _isLiked = true : _isLiked = false;
    widget.post.isFollowing != null ? _isFollowing = widget.post.isFollowing : _isFollowing = false;
     widget.user.id != widget.post.userId ? _isOwnPost = false : _isOwnPost = true;
  }




  likeSubmitHandle (int type) async {
    final String url = BaseUrl.baseUrl('likePost');
    final response = await http.post(Uri.parse(url),
        headers: {'test-pass' : ApiRequest.mToken},
        body: {
          'like' : "$type",
          'post_id' : "${widget.post.id}",
          'user_id': "${widget.user.id}",
        });
     Map data = jsonDecode(response.body);


    setState(() {
      _likeCount = data['tLike'];
      _disLikeCount = data['tDislike'];
      data['isLiked'] == 1 ? _isLiked = true : _isLiked = false;
    });

  }

  followRequest() async{
    final String url = BaseUrl.baseUrl('followUser');
    final response = await http.post(Uri.parse(url),
        headers: {'test-pass' : ApiRequest.mToken},
        body: {
          'follower_id' : "${widget.post.userId.toString()}",
          'post_id' : "${widget.post.id}",
          'user_id': "${widget.user.id}",
        });
    Map data = jsonDecode(response.body);


  }


   CircleAvatar mUserPhoto(String photo){
    return  CircleAvatar(
      backgroundImage: photo != null ? NetworkImage(photo) : Image.asset('assets/u3.gif'),
    );
  }


  showConfirm(){
    Navigator.pop(context);
    return showDialog(
      context: context,
      builder: (context){
        return SimpleDialog(
          title: Text('Are you sure you want to delete post?',
          style: fldarkgrey15,),
          children: [
            SimpleDialogOption(
              child: Text('Yes'),
              onPressed: () {
                deletePost();
              },
            ),
            SimpleDialogOption(
              child: Text('No'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      }
    );
  }

  void deletePost() async {
    Navigator.pop(context);

    final String url = BaseUrl.baseUrl('mPostDelGen/${widget.post.id}');
    final response = await http.get(Uri.parse(url),
        headers: {'test-pass' : ApiRequest.mToken});
    Map data = jsonDecode(response.body);


  }

  void editPost() {
    Navigator.pop(context);

  }

  void savePost() async {
    Navigator.pop(context);
    final String url = BaseUrl.baseUrl('mSavePost/${widget.post.id}/${widget.user.id}');
    final response = await http.get(Uri.parse(url),
        headers: {'test-pass' : ApiRequest.mToken});
    Map data = jsonDecode(response.body);

  }

  void hidePost() async {
    Navigator.pop(context);
    final String url = BaseUrl.baseUrl('mHidePost/${widget.post.id}/${widget.user.id}');
    final response = await http.get(Uri.parse(url),
        headers: {'test-pass' : ApiRequest.mToken});
    Map data = jsonDecode(response.body);

  }
  void unFollowUser() {
    Navigator.pop(context);
    _followUser();
  }

  void reportUser() async {
    Navigator.pop(context);
    final String url = BaseUrl.baseUrl('mReportPost/${widget.post.id}/${widget.user.id}');
    final response = await http.get(Uri.parse(url),
        headers: {'test-pass' : ApiRequest.mToken});
    Map data = jsonDecode(response.body);

  }

  void _followUser() {
    setState(() {
      _isFollowing ? _isFollowing = false : _isFollowing = true;
    });
    followRequest();
  }


  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 15, bottom: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(width:15 ,),
                        GestureDetector(
                          onTap: () {
                            if(widget.nType != 2) {
                              Navigator.push(context,
                              MaterialPageRoute(builder:
                               (context) => Profile(userId: widget.post.userId.toString(),
                              currentUser: widget.user,)));
                            }
                          },
                            child: widget.post.userPhoto != null ?
                            mUserPhoto(widget.post.userPhoto) : Icon(Icons.error),
                        ),
                        SizedBox(width: 8,),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    constraints: BoxConstraints(minWidth: 30, maxWidth: MediaQuery.of(context).size.width / 3 *2),
                                    child: Text(widget.post.userName??'No name',
                                      style: widget.nType == 2 ? ftwhite20 : fldarkgrey20,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Text(widget.post.createdAt??' ',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff68ca87),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _isOwnPost ? Text('') : FollowingButton(
                    onPressed: () {
                      _followUser();
                    },
                    isFollowing: _isFollowing,
                  ),
                  SizedBox(width: 5,),
                  ThreeDotButton(
                    onPressed: () {
                      // showThreeDotOption(context);
                      _optionModalBottomSheet(context);
                    },
                    type: widget.nType,
                  ),
                ],
              ),


              Container(
                margin: EdgeInsets.symmetric(horizontal: 15,vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.post.title??'no title',
                      style: widget.nType == 2 ? ftwhite20 :  fl20bold,
                    ),
                    Container(
                      child: widget.post.postType == "1" ?
                      GestureDetector(
                        child: Text(widget.post.description != null && widget.post.description.length > 150 ? widget.post.description.substring(0,250) : widget.post.description??'no text',
                            style: widget.nType == 2 ? postDescWhite : postDescWhite
                        ),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PostDetailsPage(post: widget.post, user: widget.user)));
                        },
                      ) : widget.post.postType == "2" ? Text('It is a long established fact that a reader will be distrac') :
                      Text('http://ads.asd.com'),
                    ),
                    GestureDetector(
                      child: Text('See More...',
                          style: widget.nType == 2 ? ftwhite15 : TextStyle(
                              fontSize: 12,
                              color: Colors.blueAccent
                          )
                      ),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PostDetailsPage(post: widget.post, user: widget.user)));

                      },
                    ),
                    SizedBox(height: 5),
                    widget.post.photo != null ?
                    GestureDetector(child:
                    Container(
                      child: cachedNetworkImgPost(context, widget.post.photo),
                      height: 200,
                    ),
                        onTap: () {
                          viewFullImage(context, widget.post.photo);
                       
                        }):
                    Text(''),
                    // type == 1 ? post.photo != null ?  cachedNetworkImg(context, post.photo): Image.asset('assets/profile/bg.png') :
                    // type == 2 ? post.photo != null ? cachedNetworkImg(context, post.photo) : Image.asset('assets/feed/map.jpg') :
                    // type == 3 ? post.photo != null ? cachedNetworkImg(context, post.photo) : Image.asset('assets/feed/ads.jpg') : Text(''),
                    SizedBox(height: 8),
                  ],
                ),
              ),

              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // for Like, react holder
                    PostBottomReactHolder(
                      likeCount: '$_likeCount',
                      onPressed: () {
                        likeSubmitHandle(1);
                      },
                      isLiked: _isLiked,
                      type: widget.nType,
                    ),

                    // comments status holder
                    PostBottomItem(
                      likeCount: '${widget.post.tComment}',
                      childItem: Image.asset(
                        'assets/profile/comment.png',
                        width: 15,
                        height: 15,
                      ),
                      onPressed: () {
                        commentHandle(
                          context,
                          widget.user,
                          widget.post,
                        );
                      },
                      type: widget.nType,
                    ),
                    // share button
                    IconButton(
                      onPressed: () async {
                      var mList = await Navigator.push(context, MaterialPageRoute(builder: (context) => Sharelist(post: widget.post,user: widget.user,)));
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
                      icon: Image.asset(
                        widget.nType == 2 ? 'assets/profile/share.png' : 'assets/profile/share_black.png',
                        width: 18,
                        height: 18,
                      ),

                    ),

                  ],
                ),
              ),

            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          color: Color(0xffd8d9d9),
          height: 5,
        ),
      ],
    );

  }

  viewFullImage(BuildContext context, String photo){
    Navigator.push(context, MaterialPageRoute(builder: (context) => Singleimagepage(photo: photo,)));
  }

  commentHandle(BuildContext context, UserModel user, Post post){
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Comments(
        user: user,
        post: post,
      );
    }));
  }

  // three dod option as bottom sheet
  void _optionModalBottomSheet(context){
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        builder: (BuildContext bc){
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: new Wrap(
              children:  _isOwnPost ? [
                ListTile(
                  title: Text('Action list'),
                ),
                threeDotOptionBottomsheetItem(Icons.edit, "Edit post", editPost),
                threeDotOptionBottomsheetItem(Icons.delete_forever, "Delete post", showConfirm),
                ListTile(
                  leading: Icon(Icons.close),
                  title: Text('Close'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ] : [
                ListTile(
                  title: Text('Action list'),
                ),
                threeDotOptionBottomsheetItem(Icons.receipt, "Announcement", savePost),
                threeDotOptionBottomsheetItem(Icons.receipt, "Report post", reportUser),
                ListTile(
                  leading: Icon(Icons.close),
                  title: Text('Close'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        }
    );
  }

  // three dot option as modal
  showThreeDotOption(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text('Post option',
              style: fldarkgrey15,
            ),
            children: _isOwnPost ? [
              threeDotOptionMenuItem(Icons.edit, "Edit post", editPost),
              threeDotOptionMenuItem(Icons.delete, "Delete post", showConfirm),
            ] : [
              threeDotOptionMenuItem(Icons.save, "Announcement", savePost),
              threeDotOptionMenuItem(Icons.receipt, "Report post", reportUser),
            ],
          );
        }

    );
  }





}


