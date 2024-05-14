import 'dart:convert';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/provider/user_provider.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/chatroom/provider/big_group_provider.dart';
import 'package:chat_app/ui/group/big_group/util/goup_methods.dart';
import 'package:chat_app/ui/pages/profile/group_profile/settings/group_functions.dart';
import 'package:chat_app/ui/pages/settings/wallet/provider/balance_provider.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:chat_app/util/constants.dart';
import 'package:chat_app/util/loading/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SearchUserFeed extends StatefulWidget {

  String query;
  final UserModel loggedUser;
  SearchUserFeed({this.query, this.loggedUser});

  @override
  _SearchUserFeedState createState() => _SearchUserFeedState();
}

class _SearchUserFeedState extends State<SearchUserFeed> {

  FirebaseFirestore _firstore = FirebaseFirestore.instance;
  GroupMethods _groupMethods = GroupMethods();

  TextEditingController mTextController = TextEditingController();
 // UserProvider _u;
 // BalanceProvider _bp;






  searchResult(List<UserModel> user){
    return ListView.builder(
      itemCount: user.length,
      itemBuilder: (context, index){
        return Card(
          child: ListTile(
            onTap: () {
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
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BigGroupProvider _bg = Provider.of<BigGroupProvider>(context, listen: false);

    UserProvider  _u = Provider.of<UserProvider>(context, listen: false);

    return LoadingImage(
      inAsyncCall: showProgress,
      child: Scaffold(
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
                hintText: 'Search user',
                hintStyle: TextStyle(
                    fontSize: 9
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
                    future: _groupMethods.getSearchedUser(uid: widget.loggedUser.id.toString(), query: widget.query),
                    builder: (context, index) {
                      if(index != null){
                        return index.data != null ? groupListHolder(context, index.data, _bg) : Container();
                      }
                      return Text("No data");
                    }
                ),
              ),

            ],
          ),

        ),
      ),
    );
  }

  groupListHolder(BuildContext context, List<UserModel> gList, BigGroupProvider _b) {
    return ListView.builder(
        itemCount: gList.length,
        itemBuilder: (context, index) {
          return groupItem(context, gList[index], _b);
        }
    );
  }


  groupItem(BuildContext context, UserModel u, BigGroupProvider _b){
    return Container(
      child: ListTile(
        leading: Container(
          margin: EdgeInsets.only(left: 0),
          width: 45.0,
          height: 45.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 2.0,
            ),
            //  borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 4,
                offset: Offset(0, 0), // changes position of shadow
              ),

            ],
          ),
          child: CircleAvatar(
            child: cachedNetworkImageCircular(context, u.photo),
          ),
        ),
        title: Text('${u.fName + " " + u.nName}',style: fldarkHome16,),
        // subtitle: Text("${u.country}",
        //   maxLines: 1,
        //   overflow: TextOverflow.ellipsis,
        // ),
        trailing: Icon(Icons.add_moderator),
        onTap: (){
          _transferDialog(context, u.id, _b);
        },
      ),
    );
  }
  GroupFunctions _groupFunctions = GroupFunctions();

  bool showProgress = false;
  _submitChange(int id, BigGroupProvider _p) async {
    setState(() {
      showProgress = true;
    });

    var isUpdated = await _groupFunctions.updateGroup(groupId: _p.toGroup.id.toString(), text: id.toString(), field: "user_id");
    if(isUpdated){
      setState(() {
        showProgress = false;
      });
    }
    _p.getGroupModelData(groupId: _p.toGroup.id.toString());

    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
  }


  _transferDialog(parentContext, int id, BigGroupProvider _p){
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title:  Center(
              child: Text(
                "Transfer group",
                style: fldarkgrey15,
              ),
            ) ,
            children: [

              Text('If you once transfer this group then no longer \n you will be able to manage this group again. '
                  'Ownership will be changed also. ',
              textAlign: TextAlign.center,),
              SizedBox(height: 10,),
              Center(
                child: Text(
                  "Are you sure?",
                  style: fldarkgrey15,
                ),
              ),
              Container(
                width: 50,
                margin: EdgeInsets.all(10),
                child: ElevatedButton.icon(
                  onPressed: () => _submitChange(id, _p),
                  icon: Icon(Icons.add_moderator, size: 18),
                  label: Text("Confirm"),
                ),
              )

            ],
          );
        }
    );
  }



}
