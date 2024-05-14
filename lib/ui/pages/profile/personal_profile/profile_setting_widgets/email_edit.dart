import 'dart:convert';

import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:chat_app/util/constants.dart';
import 'package:chat_app/util/loading/loading.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class EmailEdit extends StatefulWidget {

  String userId;
  String email;
  EmailEdit({this.userId, this.email});

  @override
  _EmailEditState createState() => _EmailEditState();
}

class _EmailEditState extends State<EmailEdit> {
  TextEditingController ctrName = TextEditingController();

  final _globalKey = GlobalKey<FormState>();
  bool showProgress = false;

  Future update({String userId, String eml}) async {

    final String url = BaseUrl.baseUrl("updateEmail");
    final response = await http.post(Uri.parse(url), headers: {
      'test-pass': ApiRequest.mToken
    }, body: {
      'id': userId,
      'email': eml,
    });

    Map data = jsonDecode(response.body);

    String email = data['user']['email'];
    if (response.statusCode == 200) {
      if (!data['error']) {
        return email;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    ctrName.text = widget.email;
    return LoadingImage(
      inAsyncCall: showProgress,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(title: Text("Email edit")),
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
                        hintText: "Email",
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
                    final txt = ctrName.text;
                    if(_globalKey.currentState.validate()){
                      setState(() {
                        showProgress = true;
                      });
                      String nm = await update(userId: widget.userId.toString(), eml: txt );
                      Navigator.pop(context,nm);
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
    String patttern = r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return 'Please enter email address';
    }
    if (value.length > 80) {
      return 'Email address should not be too long';
    }
    else if (!regExp.hasMatch(value)) {
      return 'Please enter valid email address';
    }
    return null;
  }
}
