import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/chatroom/utils/online_indicator_biggroup.dart';
import 'package:chat_app/util/constants.dart';
import 'package:flutter/material.dart';

class MessageHolderGroup extends StatelessWidget {

  final String message;
  final String time;
  final String id;
  final String photo;
  final String name;
  final String contactId;
  final int type;
  MessageHolderGroup({this.message, this.time,
    this.id,
    this.photo,
    this.name,
    this.contactId,
    this.type
  });


  showUserInfo(parentContext){
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              "Group details:",
              style: fldarkgrey15,
            ),
            children: [
              Hero(
                tag: 'img-$id-$type',
                child: Container(
                  width: MediaQuery.of(context).size.width*0.5,
                  height: MediaQuery.of(context).size.width*0.5,
                  child: photo != null ?  cachedNetworkImg(context,photo) : AssetImage('assets/u3.gif'),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                    Text("$name"),
                  ],
                ),
              ),

              SimpleDialogOption(
                child: Text("Close"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    );
  }



  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
            child: GestureDetector(
              child: Hero(
                tag: 'img-$id-$type',
                child: OnlineIndicatorBigGroup(
                    uid: id,
                    photo: photo,
                    contactId: contactId
                ),
              ),
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => Sandbox3(user: fromMessageSender,)));
                 showUserInfo(context);
              },
            ),
          ),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("$name",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontFamily: '',
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    message,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontFamily: '',
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '$time',
                    style: fldarkgrey10,
                    maxLines: 1,
                  ),
                ],
              ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MaterialButton(
              padding: EdgeInsets.all(0),
              minWidth: 25,
              child: type == 1 ?  Icon(
                Icons.call,
                color: Colors.blueAccent,
              ) : Icon(
                Icons.bar_chart,
                color: Colors.blueAccent,
              ),
              onPressed: () {

              },

            ),
          ),
        ],
      ),
    );
  }
}
