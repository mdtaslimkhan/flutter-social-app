import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/chatroom/function/send_gift_big_group.dart';
import 'package:chat_app/ui/chatroom/model/gift.dart';
import 'package:chat_app/ui/chatroom/provider/big_group_provider.dart';
import 'package:chat_app/ui/chatroom/utils/gift_count_dropdown.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:chat_app/ui/chatroom/provider/get_dimond_gem_follow_provider.dart';
import 'package:chat_app/ui/pages/profile/group_profile/settings/group_functions.dart';
import 'package:chat_app/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GiftSendingButton extends StatefulWidget {
  final Gift gift;
  final UserModel from;
  final Set saved;
  final GroupModel toGroup;
  GiftSendingButton({this.gift,this.from, this.saved, this.toGroup});

  @override
  _GiftSendingButtonState createState() => _GiftSendingButtonState();
}

class _GiftSendingButtonState extends State<GiftSendingButton> {

  GroupFunctions _groupFunctions = GroupFunctions();
  String visibilityState = '1';
  final SendGiftBigGroup _sendGiftBigGroup = SendGiftBigGroup();

  @override
  Widget build(BuildContext context) {
    var getValue = Provider.of<DimondGemFollowProvider>(context).getDimondGemFollow(widget.from.id.toString());
    BigGroupProvider _bgp = Provider.of<BigGroupProvider>(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              children: [
                SizedBox(width: 10,),
                Consumer<DimondGemFollowProvider>(
                  builder: (_, um, __) {
                   return Column(
                     children: [
                       Text("${um.follows.diamond}", style: ftwhite15),
                     ],
                   );
                  }
                ),
                SizedBox(width: 5,),
                Container(
                  width: 20,
                    child: Image.asset('assets/gift/dimond_blue.png')
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                Container(
                  height: 35,
                  width: 90,
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                    border: Border.all(
                      color: Colors.pinkAccent,
                      width: 1.0,
                    ),
                  ),
                  child: Container(
                    child: Center(
                      child: GiftCountDropdown(
                        onChange: (String newValue) {
                          setState(() {
                            visibilityState = newValue;
                          });
                        },
                        value: visibilityState,
                        listItem: <String>['999','99', '10','1'],

                        icon: Icons.close,
                      ),
                      ),
                    ),
                ),
                GestureDetector(
                  child: Container(
                    height: 35,
                    width: 90,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.pinkAccent,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                    ),
                    child: Container(
                      child: Center(
                        child: Text("SEND",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                  onTap: () async => {
                  Navigator.of(context).pop(),

                  // increase group experience , for now field name is Level
                  await _groupFunctions.updateGroup(groupId: _bgp.toGroup.id.toString(),
                  text: (_bgp.toGroup.level + 5 ).toString(), field: "level"),
                  // update experience and other gorup data
                  _bgp.getGroupModelData(groupId: _bgp.toGroup.id.toString()),

                  _sendGiftBigGroup.sendGiftToUser(
                        gift: widget.gift,
                        saved: widget.saved,
                        from: widget.from,
                        toGroup: widget.toGroup
                  ),
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


}
