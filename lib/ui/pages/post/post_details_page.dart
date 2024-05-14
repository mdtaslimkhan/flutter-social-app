import 'dart:convert';

import 'package:chat_app/model/post/post.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/pages/coments/post_comments.dart';
import 'package:chat_app/ui/pages/feed/widgets/single_post_image_page.dart';
import 'package:chat_app/ui/pages/share/share_person_lis.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostDetailsPage extends StatefulWidget {

  final Post post;
  final UserModel user;
  PostDetailsPage({this.post, this.user});



  @override
  _PostDetailsPageState createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers : [
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
                expandedHeight: MediaQuery.of(context).size.height / 5 * 3,
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
               child: Column(
                 children: [
                   Container(
                     constraints: BoxConstraints(
                       minHeight: MediaQuery.of(context).size.height - 105
                     ),
                     child: Padding(
                       padding: const EdgeInsets.all(10.0),
                       child: Text("${widget.post.description}",
                         style: TextStyle(
                             fontSize: 16
                         ),
                       ),
                     ),
                   ),
                   // GestureDetector(
                   //   child: Text("Commen019ts: ${widget.post.tComment}",
                   //     style: TextStyle(
                   //         color: Colors.blueAccent,
                   //         fontSize: 15
                   //     ),),
                   //   onTap: (){
                   //     commentHandle(
                   //       context,
                   //       widget.user,
                   //       widget.post,
                   //     );
                   //   },
                   // ),
                   SizedBox(height: 25,),
                 ],
               ),
             ),

            ]
          ),
        ),
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

}
