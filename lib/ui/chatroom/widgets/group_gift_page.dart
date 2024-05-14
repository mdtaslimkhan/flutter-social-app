
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/chatroom/controller/chat_room_controller.dart';
import 'package:chat_app/ui/chatroom/model/gift.dart';
import 'package:chat_app/ui/chatroom/widgets/gift_widget.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:flutter/material.dart';

class GroupGiftList extends StatefulWidget {
  final GroupModel toGroup;
  final UserModel user;
  GroupGiftList({this.toGroup,this.user});

  @override
  _GroupGiftListState createState() => _GroupGiftListState();
}

class _GroupGiftListState extends State<GroupGiftList> {
  ChatRoomController _chatRoomController = ChatRoomController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  List<Gift> gift = [];
  initData() async {
    var dtbdg = await _chatRoomController.getChatRoomGiftListData(widget.user.id.toString());
    if(dtbdg != null){
      dtbdg.forEach((val) {
        gift.add(Gift.fromJson(val));
      });
  
      // initial load widgets
      setState(() {

      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Wrap(
                children: gift.map((data) =>
                    GiftWidget(gift: data,
                    //  user: widget.user,
                      group: widget.toGroup, chattroom: false,),
                //  Container(child: Text("hello"),),
                ).toList(),
              ),
             // return ListView.builder(
             //      scrollDirection: Axis.horizontal,
             //      shrinkWrap: true,
             //      physics: AlwaysScrollableScrollPhysics(),
             //      itemCount: snapshot.data.length,
             //      itemBuilder: (context, index) {
            
             //        return topCrownTemplate(
             //            context: context, crown: snapshot.data[index]);
             //      }
             //  );


        ),
    );
  }
}
