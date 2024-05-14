import 'dart:convert';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/provider/user_provider.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/chatroom/provider/big_group_provider.dart';
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
class SearchGroupMember extends StatefulWidget {

  String query;
  final UserModel loggedUser;
  SearchGroupMember({this.query, this.loggedUser});

  @override
  _SearchGroupMemberState createState() => _SearchGroupMemberState();
}

class _SearchGroupMemberState extends State<SearchGroupMember> {

  FirebaseFirestore _firstore = FirebaseFirestore.instance;
  TextEditingController mTextController = TextEditingController();




  Future getGroupMember({@required String uid}){
    List<String> srch = [widget.query];
    return _firstore
        .collection(BIG_GROUP_COLLECTION)
        .doc(uid)
        .collection("members")
        .where('name', isGreaterThanOrEqualTo: widget.query)
        .where('name', isLessThanOrEqualTo: widget.query+"z")
        .get();
  }

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
                  child: FutureBuilder<QuerySnapshot>(
                      future: getGroupMember(uid: _bg.toGroup.id.toString()),
                      builder: (context, snapshot) {
                        if(snapshot.hasData) {
                          print("sdadsf data");
                          print(snapshot.data.docs);
                          return snapshot.data != null ? groupListHolder(context, snapshot.data.docs, _bg) : Container();
                        }

                        return Center(child: Text("No user found"));
                      }
                  ),
                ),

              ],
            ),

          ),
        ),
      );
    }

    groupListHolder(BuildContext context, var gList, BigGroupProvider _b) {
      return ListView.builder(
          itemCount: gList.length,
          itemBuilder: (context, index) {
            return groupItem(context, gList[index], _b);
          }
      );
    }


    groupItem(BuildContext context, var u, BigGroupProvider _b){
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
              child: cachedNetworkImageCircular(context, u['photo']),
            ),
          ),
          title: Text('${u['name']}',style: fldarkHome16,),
          // subtitle: Text("${u.country}",
          //   maxLines: 1,
          //   overflow: TextOverflow.ellipsis,
          // ),
          trailing: Icon(Icons.add_moderator),
          onTap: (){
            _transferDialog(context, u['userId'], _b);
          },
        ),
      );
    }
    GroupFunctions _groupFunctions = GroupFunctions();

    bool showProgress = false;
    _submitChange(String id, BigGroupProvider _p) async {
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


    _transferDialog(parentContext, String id, BigGroupProvider _p){
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


