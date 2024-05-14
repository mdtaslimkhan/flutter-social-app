import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/chatroom/chatmethods/chatmethods_big_group.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:chat_app/ui/group/big_group/util/goup_methods.dart';
import 'package:chat_app/ui/pages/widgets/progress.dart';
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


final _fireStore = FirebaseFirestore.instance;

class UserGroupSetting extends StatefulWidget {

  final String userId;
  final String name;
  final String photo;
  final GroupModel group;
  final UserModel admin;
  UserGroupSetting({this.userId, this.name, this.group,this.admin, this.photo});

  @override
  _UserGroupSettingState createState() => _UserGroupSettingState();
}

class _UserGroupSettingState extends State<UserGroupSetting> {

  GroupMethods _groupMethods = GroupMethods();


  bool isMute = false;
  bool isAdmin = false;



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading:  IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Group settings'
          ),
        ),
        body: Container(
          padding: EdgeInsets.only(left: 20,top: 20),
          child: Column(
            children: [
              StreamBuilder<DocumentSnapshot>(
                stream: _groupMethods.getMuteStatus(uid: widget.userId, gid: widget.group.id.toString()),
                builder: (context, snapshot) {
                  if(snapshot.data != null) {
                    var dt = snapshot.data.data() as Map;
                    if (!snapshot.hasData) {
                      return circularProgress();
                    }
                    if (dt['mute'] != null) {
                      var v = dt['mute'];
                      if (v) {
                        isMute = true;
                      } else {
                        isMute = false;
                      }
                    }
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Mute',
                        style: fldarkHome16,
                      ),
                      Switch(value: isMute, onChanged: (value) {
                        setState(() {
                          isMute = value;
                        });
                        if(value){

                          _groupMethods.muteGroupMember(userId: widget.userId, group: widget.group);

                          ChatMethodsBigGroup().messageForJoiningTheGroup(msgText:"muted to the group by ${widget.admin.nName}",
                              receiverId: widget.userId,
                              name: widget.name,
                              photo: widget.admin.photo,
                              groupId: widget.group.id.toString());

                        }else{
                          _groupMethods.unmuteGroupMember(userId: widget.userId, group: widget.group);

                          ChatMethodsBigGroup().messageForJoiningTheGroup(msgText:"un muted to the group by ${widget.admin.nName}",
                              receiverId: widget.userId,
                              name: widget.name,
                              photo: widget.admin.photo,
                              groupId: widget.group.id.toString());
                        }
                      }),
                    ],
                  );
                },
              ),
              StreamBuilder<DocumentSnapshot>(
                stream: _groupMethods.getAdminStatus(uid: widget.userId, gid: widget.group.id.toString()),
                builder: (context, snapshot) {
                  if(snapshot.data != null) {
                    var dt = snapshot.data.data() as Map;
                    if (!snapshot.hasData) {
                      return circularProgress();
                    }
                    if (dt["role"] != null) {
                      var v = dt['role'];
                      if (v == 2) {
                        isAdmin = true;
                      } else if (v == 3) {
                        isAdmin = false;
                      }
                    }
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Admin',
                        style: fldarkHome16,
                      ),
                      Switch(value: isAdmin, onChanged: (value) {
                        setState(() {
                          isAdmin = value;
                        });
                        if(value) {
                          _groupMethods.addAdminForGroup(userId: widget.userId, group: widget.group);
                          ChatMethodsBigGroup().messageForJoiningTheGroup(msgText:"got admin privileged approved by ${widget.admin.nName}",
                              receiverId: widget.userId,
                              name: widget.name,
                              photo: widget.admin.photo,
                              groupId: widget.group.id.toString());

                        }else{
                          _groupMethods.removeAdminForGroup(userId: widget.userId, group: widget.group);
                          ChatMethodsBigGroup().messageForJoiningTheGroup(msgText:"dismissed from admin privileged by ${widget.admin.nName}",
                              receiverId: widget.userId,
                              name: widget.name,
                              photo: widget.admin.photo,
                              groupId: widget.group.id.toString());
                        }
                      }),
                    ],
                  );
                },
              ),
              ListTile(
                title: Center(child: Text("Remove from group",style: TextStyle(color: Colors.red,fontSize: 15,fontWeight: FontWeight.bold),)),
                onTap: () {
                  GroupMethods().deleteGroupMembers(groupId: widget
                      .group.id.toString(),
                      userId: widget.userId.toString());
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Center(child: Text("Remove from group and block",style: TextStyle(color: Colors.red,fontSize: 15,fontWeight: FontWeight.bold),)),
                onTap: () {
                  GroupMethods().removeAndBlockUser(group: widget.group,
                      userId: widget.userId.toString(),
                      name: widget.name,
                      photo: widget.photo,
                      admin: widget.admin
                  );
                  ChatMethodsBigGroup().messageForJoiningTheGroup(msgText:"Remove and blocked from group by ${widget.admin.nName}",
                      receiverId: widget.userId,
                      name: widget.name,
                      photo: widget.admin.photo,
                      groupId: widget.group.id.toString());
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Center(child: Text("Remove with chat history",style: TextStyle(color: Colors.red,fontSize: 15,fontWeight: FontWeight.bold),)),
                onTap: () {
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
