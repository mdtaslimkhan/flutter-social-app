import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/chatroom/big_group_widget/gift_sending_button.dart';
import 'package:chat_app/ui/chatroom/provider/get_host_hot_seat_user_list_provider.dart';
import 'package:chat_app/ui/chatroom/function/voice_room_methods.dart';
import 'package:chat_app/ui/chatroom/model/gift.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:chat_app/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class GiftSelectedUserListBottomSheetContent extends StatefulWidget {

  final String toGroupId;
  final Gift gift;
  final UserModel from;
  final GroupModel toGroup;
  GiftSelectedUserListBottomSheetContent({this.toGroupId,this.gift, this.from, this.toGroup});



  @override
  _GiftSelectedUserListBottomSheetContentState createState() => _GiftSelectedUserListBottomSheetContentState();
}

class _GiftSelectedUserListBottomSheetContentState extends State<GiftSelectedUserListBottomSheetContent> {


  final VoiceRoomMethods roomMethods = VoiceRoomMethods();
  final Set _saved = Set();


  @override
  Widget build(BuildContext context) {

    GetHostHotSeatUserProvider hostHotSeatUserProvider = Provider.of<GetHostHotSeatUserProvider>(context);

    return Container(
      height: 300,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 12, top: 15, bottom: 5),
            child: Text('Select list',
                style: ftwhite12),
          ),
          // ShareGiftUserList(gift: gift, user: widget.from, group: widget.toGroup),
          Expanded(
            child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: hostHotSeatUserProvider.hostHotSeatUserList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.white12,
                          margin: EdgeInsets.fromLTRB(0, 5.0, 0, 0),
                          child: CheckboxListTile(
                            value: hostHotSeatUserProvider.hostHotSeatUserList[index].nValue,
                            onChanged: (value) {
                              setState(() {
                                final newVal = !hostHotSeatUserProvider.hostHotSeatUserList[index].nValue;
                                hostHotSeatUserProvider.hostHotSeatUserList[index].nValue = newVal;
                                if (value) {
                                  _saved.add(hostHotSeatUserProvider.hostHotSeatUserList[index].userId);
                                } else {
                                  _saved.remove(hostHotSeatUserProvider.hostHotSeatUserList[index].userId);
                                }
                              });
                            },
                            title: Container(
                                child: Text("${hostHotSeatUserProvider.hostHotSeatUserList[index].name}")),
                            secondary: CircleAvatar(
                              backgroundImage: hostHotSeatUserProvider.hostHotSeatUserList[index].photo !=
                                  null
                                  ? NetworkImage(hostHotSeatUserProvider.hostHotSeatUserList[index].photo)
                                  : AssetImage('assets/u3.gif'),
                            ),
                          ),
                        );
                      },
                    ),

          ),
          GiftSendingButton(
            gift: widget.gift,
            saved: _saved,
            from: widget.from,
            toGroup: widget.toGroup,
          )
        ],
      ),
    );
  }
}
