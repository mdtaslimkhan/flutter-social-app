
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/storage/storage_view.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/pages/notification/notification.dart';
import 'package:chat_app/ui/pages/search/search_group.dart';
import 'package:chat_app/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

AppBar header(BuildContext context, UserModel user){
  handleSearch(String result){
    Navigator.push(context, MaterialPageRoute(builder: (parentContext) => SearchGroup(query: result, loggedUser: user)));
    // Navigator.pushNamed(context, '/profile');
  }

  return AppBar(
    toolbarHeight: 70,
    backgroundColor: Colors.white,
    leading: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          child: Container(
            margin: EdgeInsets.only(left: 10),
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(new Radius.circular(50.0)),
              border: Border.all(
                color: Colors.white,
                width: 2.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: cachedNetworkImageCircular(context, user.photo),
          ),
          onTap: () {
            Navigator.of(context).pushNamed('/viewProfile', arguments: {
              'userId' : user?.id.toString(), 'currentUser' : user,
            });
          },
        ),
        SizedBox(height: 2),
        Container(
          margin: EdgeInsets.only(left: 14),
          width: 60,
          child: Text(
            "${user.fName} ${user.nName}",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 8.0,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))
    ),
    title: Container(
      padding: const EdgeInsets.all(8.0),
      height: 45,
      child: TextFormField(
        style: fldarkgrey12,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(width: 1.8, color: Colors.amberAccent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(width: 1.9, color: Colors.grey),
          ),
          hintText: "Search... ",
          hintStyle: TextStyle(
              fontSize: 8
          ),
          labelStyle: TextStyle(
              fontSize: 7
          ),
          suffixIcon: Hero(
            tag: 'search',
            child: Icon(
              Icons.search,
              color: Colors.grey,
              size: 15,
            ),
          ),
        ),
        onFieldSubmitted: handleSearch,
      ),
    ),
    actions: [
      IconButton(
        icon: Icon(
          FontAwesome.bell,
          color: Colors.blueAccent,
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => UserNotification(user: user)));
        },
      ),


      IconButton(
        icon: Image.asset(
          'assets/profile/gear.png',
          width: 25,
        ),
        onPressed: () {
          Navigator.of(context).pushNamed('/settingNav',arguments: {'userId': user.id.toString()});
        },
      ),

      // IconButton(
      //   icon: Image.asset(''
      //       'assets/profile/plus_blue.png',
      //     width: 25,
      //   ),
      //   onPressed: () {
      //     Navigator.push(context, MaterialPageRoute(builder: (context) => StorageView()));
      //   //  Navigator.push(context, MaterialPageRoute(builder: (context) => SandboxValueNotifire()));
      //   //  Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
      //   //  Navigator.push(context, MaterialPageRoute(builder: (context) => VideoRecorder()));
      //     // Navigator.push(context, MaterialPageRoute(builder: (context) => BigGroupCreate(user: user)));
      //   },
      // ),
    ],
  );
}
