

import 'package:chat_app/model/post/post.dart';
import 'package:flutter/cupertino.dart';

class FeedProvider extends ChangeNotifier {

  List<Post> _list = [];
  get post => _list;

  setPostList(List<Post> post){
    _list = post;
    notifyListeners();
  }

  setIndex({int index}){
    Post post = _list.elementAt(index);
    print(post.id);
  }

  addMorePost(var val){
    _list.add(Post.fromJson(val));
    notifyListeners();
  }



}