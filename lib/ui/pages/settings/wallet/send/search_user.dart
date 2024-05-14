import 'dart:convert';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/provider/user_provider.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/pages/settings/wallet/provider/balance_provider.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:chat_app/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SearchUser extends StatefulWidget {

  String query;
  final UserModel loggedUser;
  SearchUser({this.query, this.loggedUser});

  @override
  _SearchUserState createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {

  TextEditingController mTextController = TextEditingController();
 // UserProvider _u;
 // BalanceProvider _bp;

  Future getSearchedUser({@required String uid}) async {
    List<UserModel> gList;
    final String url = BaseUrl.baseUrl("mSearch/$uid");
    final http.Response response = await http.post(Uri.parse(url),
      headers: {'test-pass' : ApiRequest.mToken},
      body: {
        "qstr" : widget.query
      }
    );
    var str = jsonDecode(response.body);
    var data = str['user'] as List;
    gList = data.map<UserModel>((data) => UserModel.fromJson(data)).toList();
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
    UserProvider  _u = Provider.of<UserProvider>(context, listen: false);
    BalanceProvider _bp = Provider.of<BalanceProvider>(context, listen: false);
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
                  future: getSearchedUser(uid: _u.user.id.toString()),
                  builder: (context, index) {
                    if(index != null){
                      return index.data != null ? groupListHolder(context, index.data, _bp) : Container();
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

  groupListHolder(BuildContext context, List<UserModel> gList, BalanceProvider _b) {
    return ListView.builder(
        itemCount: gList.length,
        itemBuilder: (context, index) {
          return groupItem(context, gList[index], _b);
        }
    );
  }


  groupItem(BuildContext context, UserModel u, BalanceProvider _b){
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
        trailing: Icon(Icons.account_tree),
        onTap: (){
          _b.setToUserDetails(userModel: u);
          Navigator.of(context).pushNamed('/sendDiamondToUser',arguments: {});
        },
      ),
    );
  }

}
