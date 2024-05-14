import 'package:chat_app/ui/chatroom/provider/big_group_provider.dart';
import 'package:chat_app/ui/pages/post/post_create_utils.dart';
import 'package:chat_app/ui/pages/profile/group_profile/settings/group_functions.dart';
import 'package:chat_app/util/constants.dart';
import 'package:chat_app/util/loading/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';




class GroupPublicEdit extends StatefulWidget {

  String name;
  String id;
  GroupPublicEdit({this.id,this.name});

  @override
  _GroupPublicEditState createState() => _GroupPublicEditState();
}

class _GroupPublicEditState extends State<GroupPublicEdit> {
  GroupFunctions _groupFunctions = GroupFunctions();
  bool showProgress = false;
  String visibilityState = 'Public';

  @override
  Widget build(BuildContext context) {
    BigGroupProvider _bg = Provider.of<BigGroupProvider>(context, listen: true);
    return LoadingImage(
      inAsyncCall: showProgress,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(title: Text("Group public or private")),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  SizedBox(width: 5),
                  DropdownItem(
                    onChange: (String newValue) async {
                      setState(() {
                        visibilityState = newValue;
                      });
                    },
                    value: visibilityState,
                    listItem: <String>['Public', 'Private'],
                    icon: FontAwesome.globe,
                  ),


                ],
              ),

              GestureDetector(
                child: Container(
                    margin: EdgeInsets.all(15),
                    height: 40,
                    width: 180,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 16,
                          offset: Offset(0,3),
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: -1,
                        ),
                      ],
                    ),
                    child: Center(child: Text("Save",style: ftwhite14,))
                ),
                onTap: () async {

                    setState(() {
                      showProgress = true;
                    });

                    var isUpdated = await _groupFunctions.updateGroup(groupId: widget.id, text: visibilityState, field: "is_public");
                    if(isUpdated){
                      setState(() {
                        showProgress = false;
                      });
                    }
                    _bg.getGroupModelData(groupId: widget.id);

                    Navigator.pop(context);

                },
              ),
            ],
          ),
        ),
      ),
    );
  }


}
