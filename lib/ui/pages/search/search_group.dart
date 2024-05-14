import 'dart:convert';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/chatroom/chatroom.dart';
import 'package:chat_app/ui/chatroom/provider/big_group_provider.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:chat_app/ui/pages/profile/group_profile/group_profile.dart';
import 'package:chat_app/ui/pages/widgets/progress.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:chat_app/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SearchGroup extends StatefulWidget {

  String query;
  final UserModel loggedUser;
  SearchGroup({this.query, this.loggedUser});

  @override
  _SearchGroupState createState() => _SearchGroupState();
}

class _SearchGroupState extends State<SearchGroup> {

  TextEditingController mTextController = TextEditingController();



  Future getAllGroups({@required String uid}) async {
    List<GroupModel> gList;
    final String url = BaseUrl.baseUrl("mSearchGroup");
    final http.Response response = await http.post(Uri.parse(url),
      headers: {'test-pass' : ApiRequest.mToken},
      body: {
        "qstr" : widget.query
      }
    );
    var str = jsonDecode(response.body);
    var data = str['groups'] as List;
    gList = data.map<GroupModel>((data) => GroupModel.fromJson(data)).toList();
    try{
      if(response.statusCode == 200) {
        return gList;
      }else{
        return null;
      }
    }catch(e){
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
    BigGroupProvider _p = Provider.of<BigGroupProvider>(context, listen: true);

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
                  future: getAllGroups(uid: null),
                  builder: (context, index) {
                    if(index != null){
                      return index.data != null ? groupListHolder(context, index.data, _p) : circularProgress();
                    }
                    return Text("No data");
                  }
              ),
            ),

          ],
        ),

      ),
    );
  }

  groupListHolder(BuildContext context, List<GroupModel> gList, BigGroupProvider _p) {
    return ListView.builder(
        itemCount: gList.length,
        itemBuilder: (context, index) {
          return groupItem(context, gList[index], _p);
        }
    );
  }


  groupItem(BuildContext context, GroupModel gm, BigGroupProvider _p){
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
            child: cachedNetworkImageCircular(context, gm.photo),
          ),
        ),
        title: Text(gm.name,style: fldarkHome16,),
        subtitle: Text("${gm.about}",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Icon(Icons.dehaze),
        onTap: () async {
          await _p.getGroupModelData(groupId: gm.id.toString());
          Navigator.push(context, MaterialPageRoute(builder: (context) => GroupProfile(user: widget.loggedUser, groupInfo: gm)));
        },
      ),
    );
  }

}
