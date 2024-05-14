import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/chatroom/provider/big_group_provider.dart';
import 'package:chat_app/ui/group/big_group/big_group_create.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:chat_app/ui/group/big_group/util/goup_methods.dart';
import 'package:chat_app/ui/pages/profile/group_profile/group_profile.dart';
import 'package:chat_app/ui/pages/widgets/progress.dart';
import 'package:chat_app/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class GroupList extends StatelessWidget {

  final GroupMethods _groupMethods = GroupMethods();
  final UserModel user;
  final String userId;
  GroupList({this.user , this.userId});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Group list"),
      ),
      body: FutureBuilder(
        future: _groupMethods.getGroups(uid: userId),
          builder: (context, snapshot) {
            
            if(snapshot != null){
              return snapshot.data != null ? groupListHolder(context, snapshot.data) : circularProgress();
            }
            return Text("No data");
          }
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.blueAccent,
      //   child: Icon(
      //     Icons.add,
      //     color: Colors.white,
      //   ),
      //   onPressed: () {
      //
      //     Navigator.push(context, MaterialPageRoute(builder: (context) => BigGroupCreate(user: user,)));
      //     //  Navigator.push(context, MaterialPageRoute(builder: (context) => GroupProfile()));
      //   },
      // ),
    );
  }

  groupListHolder(BuildContext context, List<GroupModel> gList) {
    return ListView.builder(
        itemCount: gList.length,
        itemBuilder: (context, index) {
          return groupItem(context, gList[index]);
        }
    );
  }

  groupItem(BuildContext context, GroupModel gm){
    BigGroupProvider _p = Provider.of<BigGroupProvider>(context);
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
        title: Text(gm.name,style: fldarkHome16,),
        subtitle: Text("${gm.about}",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Icon(Icons.dehaze),
        onTap: (){
          _p.getGroupModelData(groupId: gm.id.toString());
          print(gm.admin);
          print(gm.groupId);
          print(gm.id);
          Navigator.push(context, MaterialPageRoute(builder: (context) => GroupProfile(user: user, groupInfo: gm)));
        },
      ),
    );
  }

}
