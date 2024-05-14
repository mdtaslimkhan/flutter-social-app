import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/chatroom/function/voice_room_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VoiceroomDiamondSend extends StatelessWidget {

  final String toGroupId;
  final UserModel from;
  final String collection;
  final bool isDiamond;
  VoiceroomDiamondSend({this.toGroupId, this.from, this.collection, this.isDiamond});

  final VoiceRoomMethods roomMethods = VoiceRoomMethods();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15,
      width: 60,
      decoration: BoxDecoration(
        color: Color(0xff1d1f1f).withOpacity(0.4),
        borderRadius: BorderRadius.all(new Radius.circular(15.0)),

        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         isDiamond ? Image.asset("assets/gift/dimond_blue.png",width: 12) : Image.asset("assets/gift/gem.png",width: 12),
          SizedBox(width: 2),
          StreamBuilder<QuerySnapshot>(
              stream: roomMethods.getCurrentRoomMyGift(
                  giftSentCollection: collection,
                  groupId: toGroupId
              ),
              builder:(context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                var qds = snapshot.data.docs;

                var myDiamond = 0;
                for(var d in qds){
                  var dt = d.data() as Map;
                  if(d.id == from.id.toString()){
                    myDiamond = dt['diamond']['diamond'];
                  }
                }
                var val = '';
                if(myDiamond > 999){
                  val = (myDiamond * 0.001).toStringAsFixed(1);
                }else{
                  val = myDiamond.toString();
                }
                return Text('$val${ myDiamond > 999 ? 'k' : ''}',
                    style: TextStyle(
                        color: Color(0xffffffff),
                        fontSize: 10
                    ));
              }
          ),
        ],
      ),
    );
  }
}
