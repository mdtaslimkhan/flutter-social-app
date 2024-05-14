import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/provider/user_provider.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/chatroom/function/voice_room_methods.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/controller/profile_controller.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/profile.dart';
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

final _fireStore = FirebaseFirestore.instance;

class BottomActiveUsersList extends StatefulWidget {
  final String toGroupId;
  final UserModel from;
  BottomActiveUsersList({this.toGroupId, this.from});

  @override
  _BottomActiveUsersListState createState() => _BottomActiveUsersListState();
}

class _BottomActiveUsersListState extends State<BottomActiveUsersList> {


  ProfileController _profileController = ProfileController();
  final VoiceRoomMethods roomMethods = VoiceRoomMethods();

  UserModel u;
  UserModel from;
  bool isLoading = true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      isLoading = false;
    });

  }


  getUserInfo(String userId) async{
    var usr = await _profileController.getPorfileData(userId);
    UserModel us = UserModel.fromJson(usr);
    return us;


  }



  @override
  Widget build(BuildContext context) {

    UserProvider _up = Provider.of<UserProvider>(context, listen: false);

    return  !isLoading ? StreamBuilder(
      stream: roomMethods.getActiveUsersMethod(groupId: widget.toGroupId),
      builder: (BuildContext context, event) {
        if (!event.hasData)
          return Text('');
        var ul = [];
        if(event.data.snapshot.value != null){
          final dt = Map<String, dynamic>.from((event.data).snapshot.value);
          dt.forEach((key, value) {
            final user = Map<String, dynamic>.from(value);
            ul.add(user);
          });
        }

              return Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(18.0)),
                    image: DecorationImage(
                      image: AssetImage("assets/room_profile/room_profile.png"),
                      fit: BoxFit.cover,
                    )
                ),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                height: 580,
                child: Column(
                  children: [

                    Expanded(
                      child: ListView.builder(
                           itemCount: ul.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                Navigator.of(context).pop();
                                if(ul[index]['user_id'] != null) {
                                 Navigator.push(
                                      context, MaterialPageRoute(
                                      builder: (context) =>
                                          Profile(userId: ul[index]['user_id'],
                                              currentUser: _up.user)));
                                }

                                //  String uid = dt[index]['userId'];
                                //  Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(userId: uid,currentUser: widget.from)));
                              },
                              child:
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(child: Text('${index + 1}',style: fldarkgrey12,)),
                                    SizedBox(width: 10,),
                                    Flexible(
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 28,
                                            height: 28,
                                            decoration: BoxDecoration(
                                              color: Colors.blueGrey,
                                              borderRadius: BorderRadius.all(new Radius.circular(25.0)),
                                              border: Border.all(
                                                color: Colors.black87,
                                                width: 1.0,
                                              ),
                                            ),
                                            child: ul[index]['photo'] != null ?  cachedNetworkImageCircular(context,ul[index]['photo']) : AssetImage('assets/u3.gif'),
                                          ),
                                          SizedBox(width: 15,),
                                          Flexible(
                                            child: Text('${ul[index]['name']}',style: fldarkgrey15,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(Icons.alternate_email_rounded),
                                    SizedBox(width: 5,),
                                  ],
                                ),
                              ),
                            );
                          }
                      ),
                    ),
                  ],
                ),
              );
        }


    ) : Container(
      width: MediaQuery.of(context).size.width,
        height: 100,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
            image: DecorationImage(
              image: AssetImage("assets/room_profile/room_profile.png"),
              fit: BoxFit.cover,
            )
        ),
        child: Center(child: CircularProgressIndicator())
    );
  }


}
