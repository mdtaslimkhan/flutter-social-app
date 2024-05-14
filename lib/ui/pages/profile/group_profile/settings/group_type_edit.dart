import 'package:chat_app/ui/chatroom/provider/big_group_provider.dart';
import 'package:chat_app/ui/pages/profile/group_profile/settings/group_functions.dart';
import 'package:chat_app/util/constants.dart';
import 'package:chat_app/util/loading/loading.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';




class GroupTypeEdit extends StatefulWidget {

  String name;
  String id;
  GroupTypeEdit({this.id,this.name});

  @override
  _GroupTypeEditState createState() => _GroupTypeEditState();
}

class _GroupTypeEditState extends State<GroupTypeEdit> {
  TextEditingController ctrName = TextEditingController();
  final _globalKey = GlobalKey<FormState>();
  GroupFunctions _groupFunctions = GroupFunctions();

  bool showProgress = false;
  bool type = false;


  @override
  Widget build(BuildContext context) {
    BigGroupProvider _bg = Provider.of<BigGroupProvider>(context, listen: false);

    ctrName.text = widget.name;
    return LoadingImage(
      inAsyncCall: showProgress,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
              title: Text("Group type edit")),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Private',
                  style: fldarkHome16,
                ),
                Container(
                  child: Switch(value: type, onChanged: (value) async {
                    setState(() {
                      type = value;
                    });
                    if(value){
                      _bg.getGroupModelData(groupId: widget.id);
                      var isUpdated = await _groupFunctions.updateGroup(groupId: widget.id, text: null, field: "type");
                      if(isUpdated){
                        setState(() {
                          showProgress = false;
                        });
                      }


                    }else{
                      _bg.getGroupModelData(groupId: widget.id);
                      var isUpdated = await _groupFunctions.updateGroup(groupId: widget.id, text: null, field: "type");
                      if(isUpdated){
                        setState(() {
                          showProgress = false;
                        });
                      }

                    }

                  }),
                ),
              ],
            ),
          ),
          ),
        ),
      );
  }

}
