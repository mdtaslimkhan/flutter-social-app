import 'package:chat_app/ui/chatroom/provider/big_group_provider.dart';
import 'package:chat_app/ui/pages/profile/group_profile/settings/group_functions.dart';
import 'package:chat_app/util/constants.dart';
import 'package:chat_app/util/loading/loading.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';




class GroupAboutEdit extends StatefulWidget {

  String name;
  String id;
  GroupAboutEdit({this.id,this.name});

  @override
  _GroupAboutEditState createState() => _GroupAboutEditState();
}

class _GroupAboutEditState extends State<GroupAboutEdit> {
  TextEditingController ctrName = TextEditingController();
  final _globalKey = GlobalKey<FormState>();
  GroupFunctions _groupFunctions = GroupFunctions();

  bool showProgress = false;


  @override
  Widget build(BuildContext context) {
    BigGroupProvider _bg = Provider.of<BigGroupProvider>(context, listen: false);

    ctrName.text = widget.name;
    return LoadingImage(
      inAsyncCall: showProgress,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(title: Text("Group about edit")),
          body: Form(
            key: _globalKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0,15,15.0,0),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 16,
                          offset: Offset(0,3),
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: -1,
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: ctrName,
                      validator: (val) => validateText(val),
                      maxLines: 18,
                      style: TextStyle(
                          fontSize: 14
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                        fillColor: Color(0xffebecf0),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(width: 0.8, color: Colors.amberAccent),
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(width: 0.8, color: Color(0xffebecf0)),
                        ),
                        hintText: "First name",
                        hintStyle: TextStyle(
                            fontSize: 14
                        ),
                        labelStyle: TextStyle(
                            fontSize: 7
                        ),
                        suffixIcon: Icon(
                          Icons.chevron_right,
                          color: Colors.grey,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
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

                    final fnm = ctrName.text;
                    if(_globalKey.currentState.validate()){
                      setState(() {
                        showProgress = true;
                      });

                     var isUpdated = await _groupFunctions.updateGroup(groupId: widget.id, text: fnm, field: "about");
                      if(isUpdated){
                        setState(() {
                          showProgress = false;
                        });
                      }
                      _bg.getGroupModelData(groupId: widget.id);

                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String validateText(String value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return 'Please enter name';
    }
    if (value.length > 5000) {
      return 'Text should not be too long';
    }
    // else if (!regExp.hasMatch(value)) {
    //   return 'Please enter valid mobile number';
    // }
    return null;
  }
}
