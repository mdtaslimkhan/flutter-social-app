import 'dart:convert';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:chat_app/ui/pages/profile/group_profile/group_profile.dart';
import 'package:chat_app/ui/pages/widgets/progress.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:chat_app/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;


class HiveLocalDb extends StatefulWidget {
  final UserModel user;
  HiveLocalDb({this.user});
  @override
  _HiveLocalDbState createState() => _HiveLocalDbState();
}

class _HiveLocalDbState extends State<HiveLocalDb> {
  Box box;
  Box box2;
  Box box3;
  List data = [];
  List<GroupModel> gList;
  @override
  void initState() {
   // getAllData();
    super.initState();
  }

  Future getGroupData() async {
    final String url = BaseUrl.baseUrl("getAllGroups/${widget.user.id}");
    final http.Response response = await http.get(Uri.parse(url),
      headers: {'test-pass' : ApiRequest.mToken},
    );
    var str = jsonDecode(response.body)['groups'];
    return str;
  }

  Future openBox() async{
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox("data");
    box2 = await Hive.openBox("homeData");
    box3 = await Hive.openBox("messageData");
    return;
  }

 Future getAllData() async {
    await openBox();
    try {
      // api request for getting data
      var gData = await getGroupData();
      // after getting data put into the box
      await putData(gData);

    } catch (SocketException) {
      Fluttertoast.showToast(msg: "No internet available");
    }
      // getting data after saving locally
      var gMap = box.toMap().values.toList();
      var gMap2 = box2.toMap().values.toList();
      var gMap3 = box3.toMap().values.toList();
      // if(gMap.isEmpty){
      //   data.add("emty");
      // }else{
      //   gList = gMap;
      // }
   // List<GroupModel> mMap;
     // gList = gMap.map<GroupModel>((data) => GroupModel.fromJson(data)).toList();
   // mMap = gMap.map<GroupModel>((data) => GroupModel.fromJson(data)).toList();
    return gMap;
  }

  putData(data) async{
    await box.clear();
    // insert data
    for(var dt in data){
      box.add(dt);
      box2.add(dt);
      box3.add(dt);
    }
  }



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  groupListHolder(BuildContext context, List<dynamic> gList) {
    return ListView.builder(
        itemCount: gList.length,
        itemBuilder: (context, index) {
          GroupModel gm= GroupModel(
              id: gList[index]['id'],
              admin: gList[index]['admin'],
              groupId: gList[index]['group_id'],
              name: gList[index]['name'],
              photo: gList[index]['photo'],
              cover: gList[index]['cover'],
              about: gList[index]['about'],
              isVerified: gList[index]['isVerified'],
              level: gList[index]['level'],
              address: gList[index]['address'],
              isPublic: gList[index]['isPublic'],
          );

          return groupItem(context, gm);
        }
    );
  }

  groupItem(BuildContext context, GroupModel gm){
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
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => GroupProfile(user: widget.user, groupInfo: gm)));
        },
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: FutureBuilder(
        future: getAllData(),
        builder: (context, snapshot) {
          if(snapshot != null){
           return snapshot.data != null ? groupListHolder(context, snapshot.data) : circularProgress();
          }
          return Text("No data");
        },
      ),
    ));
  }
}
