
import 'dart:convert';

import 'package:chat_app/model/post/post.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:chat_app/ui/group/big_group/space/space_post_create.dart';
import 'package:chat_app/ui/group/big_group/space/space_post_template.dart';
import 'package:chat_app/ui/pages/widgets/progress.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class MySpace extends StatefulWidget {
  final UserModel user;
  final GroupModel group;
  MySpace({this.user,this.group});

  @override
  _MySpaceState createState() => _MySpaceState();
}

class _MySpaceState extends State<MySpace> {

  ScrollController _scrollController = ScrollController();

  // feed page loading lines
  List<Post> list = [];
  int _addPage = 2;
  bool tiggredOnce = true;
  bool _isBottomLoader = true;
  // declear with another name of future builder to prevent firing multiple times
  // also have to include in initsate like getPosts = getPostItem();
  Future getPosts;
  Future fpeopleYouMayKnow;


  // load first time for future builder and load items to List<Post> list = [];
  Future getPostItem() async{
    final http.Response response = await http.get(
        Uri.parse(BaseUrl.baseUrl("groupPost/${widget.group.id}")),
        headers: {'test-pass': ApiRequest.mToken});
    var str = jsonDecode(response.body);
    var data = str['posts'] as List;

    //  add items once after loading and prevent loading by triggerOnce condition

    // list = data.map<Singlepost>((val)  => Singlepost.fromJson(val)).toList();
    // list = data.map<User>((data) => User.fromJson(data)).toList();
    if(tiggredOnce) {
      data.forEach((val) {
        list.add(Post.fromJson(val));
      });
      list = list.toSet().toList();
    }
    return list;
  }



  @override
  void initState() {
    super.initState();
    // prevent firing multiple time
    getPosts = getPostItem();
    fpeopleYouMayKnow = ApiRequest.getUser();
    // initiate listening scrolling
    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        // at the end point load data from server
        getMoreData();
      }
    });
  }

  // fire every time when at the end
  getMoreData() async{
    final http.Response response = await http.get(
        Uri.parse(BaseUrl.baseUrl("groupPost/${widget.group.id}?page=$_addPage")),
        headers: {'test-pass' : ApiRequest.mToken});
    var str = jsonDecode(response.body);
    var data = str['posts'];
    var lPage = str['last_page'];
    // add data to list every time when at the and end
    data.forEach((val) {
      list.add(Post.fromJson(val));
    });

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


  listViewItems() {
    return  ListView.builder(
      controller: _scrollController,
      itemCount: list.length + 1,
      itemBuilder: (context, index){
   

        if(index == list.length){
          if(_isBottomLoader) {
            // list.length + 1 the 1 st position for loader
            return CupertinoActivityIndicator();
          }else{
            // to stop showing error the loader will replaced by text('') widget
            return Container();
          }
        }
        return Column(
          children: [
            //  post_with_image(context, list[index].postType, list[index], widget.user),
            //  postWithImages(),
            SpaceSinglepost(user: widget.user, post: list[index], nType: 1,),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'Group board'
            ),
          ),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.add_circle,
                  size: 30,
                ),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SpacePostCreate(user: widget.user, group: widget.group)));
                }
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height-50,
                child: FutureBuilder(
                  future:  getPosts,
                  builder: (context, snapshot) {
                    return snapshot.data != null ? listViewItems() : circularProgress();
                  },
                ),
              ),

            ],
          ),
        ),
        ),
      );
  }





}
