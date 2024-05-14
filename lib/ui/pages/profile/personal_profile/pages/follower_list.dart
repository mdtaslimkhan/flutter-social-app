import 'dart:convert';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/controller/profile_controller.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/model/user_item.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:chat_app/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class FollowerList extends StatefulWidget {
  final UserModel user;
  final String userId;
  FollowerList({this.user , this.userId});
  @override
  _FollowerListState createState() => _FollowerListState();
}

class _FollowerListState extends State<FollowerList> {
  final ProfileController _profileController = ProfileController();
  ScrollController _scrollController = ScrollController();
  int _addPage = 2;
  bool tiggredOnce = true;
  bool _isBottomLoader = true;
  List<UserItem> gList = [];
  Future getData;

  Future getFollowereduserList({@required String uid}) async {
    try{
    final String url = BaseUrl.baseUrl("followingByList/$uid");
    final http.Response response = await http.get(Uri.parse(url),
      headers: {'test-pass' : ApiRequest.mToken},
    );
    var str = jsonDecode(response.body);
    var data = str['data'] as List;
     gList = data.map<UserItem>((data) => UserItem.fromJson(data)).toList();
      if(response.statusCode == 200) {
        setState(() {
          _isBottomLoader = false;
        });
      }else{
        return null;
      }
    }catch(e){
      return null;
    }

  }


  unFollowerRequest({String client, String myid}) async{
    final String url = BaseUrl.baseUrl('unFollowUser');
    final response = await http.post(Uri.parse(url),
        headers: {'test-pass' : ApiRequest.mToken},
        body: {
          'user_id' : myid,
          'follower_id' : client
        });
    Map data = jsonDecode(response.body);
    print(data);
    return true;
  }

  @override
  void initState() {
    super.initState();
    initialMethod();
    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        // at the end point load data from server
        print('Follower list extend');
        getMoreData();
        setState(() {
          _isBottomLoader = true;
        });
      }
    });

  }



  getMoreData() async{
    print('hello test');
    print(widget.userId);
    print(_addPage);
    try {
      final http.Response response = await http.get(Uri.parse(BaseUrl.baseUrl("followingByList/${widget.userId}?page=$_addPage")),
          headers: {'test-pass': ApiRequest.mToken});
      var str = jsonDecode(response.body);
      var lPage = str['last_page'];
      var data = str['data'] as List;
      data.forEach((element) {
        gList.add(UserItem.fromJson(element));
      });
      _addPage >= lPage ? _isBottomLoader = false : _isBottomLoader = true;
      _addPage = _addPage + 1;
      setState(() {
        tiggredOnce = false;
        _isBottomLoader = false;
      });
    } catch (e){
      Fluttertoast.showToast(msg: "Sms ");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  initialMethod() async {
    getData = await getFollowereduserList(uid: widget.userId);
    return true;
  }

  onRefreshData() async {
    _addPage = 2;
    bool isRefreshed = await initialMethod();
    return isRefreshed;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => onRefreshData(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Following me"),
        ),
        body: Container(
          child: groupListHolder(context, gList),
        )
      ),
    );
  }

  groupListHolder(BuildContext context, List<UserItem> gList) {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        controller: _scrollController,
        itemCount: gList.length + 1,
        itemBuilder: (context, index) {
          if(index == gList.length){
            if(_isBottomLoader) {
              // list.length + 1 the 1 st position for loader
              return Center(child: CircularProgressIndicator());
            }else{
              // to stop showing error the loader will replaced by text('') widget
              return Container();
            }
          }
          return groupItem(context, gList[index], index);
        }
    );
  }

  groupItem(BuildContext context, UserItem gm, int index){
    return Container(
      child: ListTile(
        leading: Container(
          margin: EdgeInsets.only(left: 0),
          width: 45.0,
          height: 45.0,
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            image: DecorationImage(
              image: NetworkImage(gm.photo),
              fit: BoxFit.cover,
            ),
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

        ),
        title: Text(gm.name,style: fldarkHome16,overflow: TextOverflow.ellipsis,),
        subtitle: Text("${gm.date}",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: fldarkgrey12,
        ),
        trailing: Icon(Icons.connect_without_contact, color: Colors.red,),
        onTap: (){
          removeFolloweredList(context, gm.id, index);
        //  Navigator.push(context, MaterialPageRoute(builder: (context) => GroupProfile(user: widget.user, groupInfo: gm)));
        },
      ),
    );
  }

   removeFolloweredList(BuildContext context, int id, int index) {
    return showDialog(
        context: context,
        builder: (context){
          return SimpleDialog(
               children: [
                 Container(
                   margin: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                   child: Column(
                     children: [
                       Text("Do you want to make user unfollow?",style: fldarkgrey15,),
                       SizedBox(height: 10,),
                       MaterialButton(
                          child: Text("Yes", style: ftwhite18,),
                           color: Colors.green,
                           onPressed: (){
                             print(widget.userId.toString());
                             print(widget.user.id.toString());
                             Navigator.pop(context);
                             gList.removeAt(index);
                             unFollowerRequest(client: id.toString(), myid: widget.user.id.toString());
                             setState(() {
                             });
                          },
                       )
                     ],
                   ),
                 ),
               ],
          );
        }
    );
  }



}
