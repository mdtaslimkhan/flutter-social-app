import 'dart:convert';

import 'package:chat_app/ui/pages/post/post_create_utils.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:chat_app/util/constants.dart';
import 'package:chat_app/util/loading/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;




class GenderEdit extends StatefulWidget {

  String userId;
  String gender;
  GenderEdit({this.userId,this.gender});

  @override
  _GenderEditState createState() => _GenderEditState();
}

class _GenderEditState extends State<GenderEdit> {

  TextEditingController ctrName = TextEditingController();

  final _globalKey = GlobalKey<FormState>();

  String gender = "Gender";
  bool showProgress = false;


  Future update({String userId, String gender}) async {

    final String url = BaseUrl.baseUrl("updateGender");
    final response = await http.post(Uri.parse(url), headers: {
      'test-pass': ApiRequest.mToken
    }, body: {
      'id': userId,
      'gender': gender,
    });

    Map data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (!data['error']) {
        return data['user']['gender'];
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  bool validateState = true;



  @override
  Widget build(BuildContext context) {
    return LoadingImage(
      inAsyncCall: showProgress,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(title: Text("Gender edit")),
          body: Form(
            key: _globalKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0,15,15.0,0),
                  child: Container(
                    height: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 50,
                          child: DropdownItem(
                            onChange: (String val) {
                              setState(() {
                                gender = val;
                              });
                              if(gender == "Gender"){
                                setState(() {
                                  validateState = false;
                                });
                              }else{
                                setState(() {
                                  validateState = true;
                                });
                              }
                            },
                            value: gender,
                            listItem: ["Gender","Male", "Female", "Other"],
                            icon: FontAwesome.intersex,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: validateState ? Container() : Text("Please select gender",style: TextStyle(
                            color: Colors.red
                          ),),
                        ),
                      ],
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
                    if(gender == "Gender"){
                      setState(() {
                        validateState = false;
                      });
                    }else{
                      if(_globalKey.currentState.validate()){
                        setState(() {
                          showProgress = true;
                        });
                        String nm = await update(userId: widget.userId.toString(), gender: gender);
                        Navigator.pop(context,nm);
                      }
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
    if (value.length > 40) {
      return 'Text should not be too long';
    }
    // else if (!regExp.hasMatch(value)) {
    //   return 'Please enter valid mobile number';
    // }
    return null;
  }
}
