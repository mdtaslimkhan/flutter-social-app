import 'dart:convert';

import 'package:chat_app/model/post/post.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:chat_app/util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;




class Sharelist extends StatefulWidget {

  final Post post;
  final UserModel user;
  Sharelist({this.post, this.user});

  @override
  _SharelistState createState() => _SharelistState();
}


class _SharelistState extends State<Sharelist> {

  ScrollController _scrollController = ScrollController();
  Future getAllUserData;
  final Set _saved = Set();
  List<UserModel> uList = [];

  ValueNotifier<List<UserModel>> _userList = ValueNotifier(<UserModel>[]);

  @override
  void initState() {
    super.initState();
    requestInitial();
  }

  requestInitial() async {
    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        getMoreData();
      }
    });
     List<UserModel> um = await ApiRequest.getUser(userId: widget.user.id);
     if(um != null){
       setState(() {
        // uList = um;
       });
       _userList.value = um;
       _userList.notifyListeners();
     }

  }

  // load more data function helper and functions
  int _addPage = 2;
  bool tiggredOnce = true;
  bool _isBottomLoader = true;

  // fire every time when at the end
  getMoreData() async{
    final http.Response response = await http.get(
        Uri.parse(BaseUrl.baseUrl("userList/${widget.user.id}?page=$_addPage")),
        headers: {'test-pass' : ApiRequest.mToken});
    var str = jsonDecode(response.body);
    var data = str['user'];
    var lPage = str['last_page'];
    // add data to list every time when at the and end
    List<UserModel> list = [];
    data.forEach((val) {
    //  uList.add(UserModel.fromJson(val));
     _userList.value.add(UserModel.fromJson(val));
    });

    // await putData(data);

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

  Future userSearch({int userId, String qstr}) async {
    print(qstr + "result");
    List<UserModel> list;
    final http.Response response = await http.post(
        Uri.parse(BaseUrl.baseUrl("mSearch/$userId")),
        headers: {'test-pass' : ApiRequest.mToken},
        body: {'qstr': qstr}
    );
    var str = jsonDecode(response.body);
    var data = str['user'] as List;
    list = data.map<UserModel>((data) => UserModel.fromJson(data)).toList();
    try{
      if(response.statusCode == 200) {
        _userList.value = list;
        _userList.notifyListeners();
        return list;
      }else{
        return null;
      }
    }catch(e){
      return null;
    }
  }

  Widget listViewData(){
    return Container(
        child: ListView.builder(
          itemCount: uList.length,
          controller: _scrollController,
          itemBuilder: (context, index){
            if(index == uList.length){
              if(_isBottomLoader) {
                // list.length + 1 the 1 st position for loader
                return CupertinoActivityIndicator();
              }else{
                // to stop showing error the loader will replaced by text('') widget
                return Container();
              }
            }
            return Card(
              margin: EdgeInsets.fromLTRB(0, 5.0,0, 0),
              child: CheckboxListTile(
                value: uList[index].nValue,
                onChanged: (value){
                  print(uList[index]);
                  setState(() {
                    final newVal = !uList[index].nValue;
                    uList[index].nValue = newVal;
                   if(value){
                     _saved.add(uList[index].id);
                   }else{
                     _saved.remove(uList[index].id);
                   }
                  });
                },
                title: Container(child: Text("${uList[index].fName} ${uList[index].nName}")),

                secondary: CircleAvatar(
                  backgroundImage: uList[index].photo != null ?  NetworkImage(uList[index].photo) : AssetImage('assets/u3.gif'),
                ),
              ),
            );
          },
        )
    );
  }



  Widget listViewDataValuNotifire(){
    return Container(
        child: ValueListenableBuilder(
          valueListenable: _userList,
          builder: (context, List<UserModel> user, _) {
            return ListView.builder(
              itemCount: user.length,
              controller: _scrollController,
              itemBuilder: (context, index){
                if(index == user.length){
                  if(_isBottomLoader) {
                    // list.length + 1 the 1 st position for loader
                    return CupertinoActivityIndicator();
                  }else{
                    // to stop showing error the loader will replaced by text('') widget
                    return Container();
                  }
                }
                return Card(
                  margin: EdgeInsets.fromLTRB(0, 5.0,0, 0),
                  child: CheckboxListTile(
                    value: user[index].nValue,
                    onChanged: (value){
                      print(user[index]);
                      setState(() {
                        final newVal = !user[index].nValue;
                        user[index].nValue = newVal;
                        if(value){
                          _saved.add(user[index].id);
                        }else{
                          _saved.remove(user[index].id);
                        }
                      });
                    },
                    title: Container(child: Text("${user[index].fName} ${user[index].nName}")),

                    secondary: CircleAvatar(
                      backgroundImage: user[index].photo != null ?  NetworkImage(user[index].photo) : AssetImage('assets/u3.gif'),
                    ),
                  ),
                );
              },
            );
          }
        )
    );
  }


  bool searchResult = false;

  TextEditingController mTextController = TextEditingController();
  clearSearch() {
    mTextController.clear();
    setState(() {
      searchResult = false;
    });
  }

  handleSearch(String result){
    //  UserProvider _u = Provider.of<UserProvider>(context, listen: false);

    print('hello');
  }

  String queryText = "";
  onTextUpdate(String text){
    if(!searchResult) {
      searchResult = true;
    }
    setState(() {
      queryText = text;
    });
    userSearch(userId: widget.user.id, qstr: text);
    print(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Share with people"),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: 45,
              child: TextFormField(
                controller: mTextController..text,
                style: fldarkgrey12,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide( color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide( color: Color(0xffffffff)),
                  ),
                  hintText: 'Search',
                  hintStyle: TextStyle(
                      fontSize: 12,
                      color: Color(0xff7d7d7d)
                  ),
                  labelStyle: TextStyle(
                      fontSize: 12
                  ),
                  prefixIcon: IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onPressed: clearSearch,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.grey,
                      size: 15,
                    ),
                    onPressed: clearSearch,
                  ),
                ),
                onFieldSubmitted: handleSearch,
                onChanged: (val) => onTextUpdate(val),
              ),
            ),
            Expanded(
                child: listViewDataValuNotifire(),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
        onPressed: () {
            Navigator.pop(context, _saved);
          //  var st = await getUser();
        },
      ),
    );
  }
}
