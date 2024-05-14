import 'dart:convert';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/chatroom/chatroom.dart';
import 'package:chat_app/ui/pages/widgets/progress.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:chat_app/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class Search extends StatefulWidget {

  String query;
  final UserModel loggedUser;
  Search({this.query, this.loggedUser});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  TextEditingController mTextController = TextEditingController();

  Future getUserFriends() async{
    List<UserModel> userList;
    final String url = BaseUrl.baseUrl("mSearch/${widget.loggedUser.id}");
    final http.Response response = await http.post(Uri.parse(url),
        headers: {'test-pass' : ApiRequest.mToken},
        body: {
         "qstr" : widget.query
        }
        );
    var str = jsonDecode(response.body);
    var data = str['user'] as List;
    userList = data.map<UserModel>((json) => UserModel.fromJson(json)).toList();
    if(response.statusCode == 200) {
      if(!str['error']) {
        return userList;
      }
      return null;
    }else{
      return null;
    }
  }



  searchResult(List<UserModel> user){
    return ListView.builder(
      itemCount: user.length,
      itemBuilder: (context, index){
        return Card(
          child: ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChatRoom(from: widget.loggedUser, toUserId: user[index].id.toString())));
            },
            leading: Hero(
              tag: "img-${user[index].id}",
              child: CircleAvatar(
                backgroundImage: NetworkImage(user[index].photo),
              ),
            ),
            title: Text(user[index].nName),
           // subtitle: Text(user[index].number),
            trailing: Icon(
                Icons.message,
                color: Colors.blueAccent,
              size: 20,
            ),
          ),
        );
      },

    );
  }


  handleSearch(String result){
    setState(() {
      widget.query = result;
    });

  }

  clearSearch() {
    mTextController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.grey
        ),
        backgroundColor: Colors.white,
        title: Container(
          height: 35,
          child: TextFormField(
            controller: mTextController..text = widget.query,
            style: fldarkgrey12,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide( color: Colors.amberAccent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide( color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide( color: Colors.indigoAccent),
              ),
              hintText: 'Search...',
              hintStyle: TextStyle(
                  fontSize: 8
              ),
              labelStyle: TextStyle(
                  fontSize: 7
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
          ),
        ),
      ),
      body:  SafeArea(

        child: Column(
          children: <Widget>[
           //  SizedBox(height: 15.0),
            Expanded(
              child: FutureBuilder(
                future: getUserFriends(),
                builder: (context, snapshot){
                  if(!snapshot.hasData){
                    circularProgress();
                  }
                  return snapshot.data != null ? searchResult(snapshot.data) : circularProgress();
                },
              ),
            ),

          ],
        ),

      ),
    );
  }
}
