import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/chatroom/function/voice_room_methods.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/controller/profile_controller.dart';
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final _fireStore = FirebaseFirestore.instance;

class BottomWaitingList extends StatefulWidget {
  GroupModel group;
  final String userId;
  final int position;
  final String fromId;
  final bool isHost;

  BottomWaitingList({this.userId, this.group, this.position, this.fromId, this.isHost});

  @override
  _BottomWaitingListState createState() => _BottomWaitingListState();
}

class _BottomWaitingListState extends State<BottomWaitingList> {


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
   setState(() {
     u = us;
   });

  }




  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }



  @override
  Widget build(BuildContext context) {

    return  !isLoading ? StreamBuilder<QuerySnapshot>(
      stream: _fireStore
          .collection(BIG_GROUP_COLLECTION)
          .doc(widget.group.id.toString())
          .collection("waitingList")
          .orderBy('pos', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
           var dt = snapshot.data.docs;
              return Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                height: 580,
                child: Column(
                  children: [
                    Text('Waiting list',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: Colors.white
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                           itemCount: dt.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                //  String uid = dt[index]['userId'];
                                //  Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(userId: uid,currentUser: widget.from)));

                              },
                              child:
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(child: Text('${index + 1}',style: ftwhite15,)),
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
                                            child: dt[index]['photo'] != null ?  cachedNetworkImageCircular(context,dt[index]['photo']) : AssetImage('assets/u3.gif'),
                                          ),
                                          SizedBox(width: 15,),
                                          Flexible(
                                            child: Text('${dt[index]['name']}',style: ftwhite15,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(Icons.arrow_upward_rounded),
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
        return Container();
      },
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
