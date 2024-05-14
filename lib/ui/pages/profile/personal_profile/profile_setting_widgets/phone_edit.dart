import 'dart:convert';

import 'package:chat_app/ui/pages/profile/personal_profile/local_widgets/lebel.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class PhoneEdit extends StatefulWidget {

  String userId;
  int showPhone;
  PhoneEdit({this.userId,this.showPhone});

  @override
  _PhoneEditState createState() => _PhoneEditState();
}

class _PhoneEditState extends State<PhoneEdit> {
  TextEditingController ctrName = TextEditingController();

  final _globalKey = GlobalKey<FormState>();
  int switchState = 1;

  Future update({String userId, int phone}) async {

    final String url = BaseUrl.baseUrl("updatePhone");
    final response = await http.post(Uri.parse(url), headers: {
      'test-pass': ApiRequest.mToken
    }, body: {
      'id': userId,
      'show_contact': phone.toString(),
    });

    Map data = jsonDecode(response.body);

    int email = data['user']['show_contact'];
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
  void initState() {
    // TODO: implement initState

    setState(() {
   //   _switchValue = widget.showPhone;
      if(widget.showPhone == 1){
        switchState = 1;
      }else{
        switchState = 0;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Phone edit")),
        body: Form(
          key: _globalKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    enableInteractiveSelection: false, // will disable paste operation
                    enabled:  false,
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
                      hintText: "Phone",
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
              SizedBox(height: 15,),
              LabelText(text: "Show mobile number in profile",),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: CupertinoSwitch(
                  value: switchState == 1 ? true : false,
                  onChanged: (value) async{
                    if(value == true){
                      setState(() {
                        switchState = 1;
                      });
                    }else{
                      setState(() {
                        switchState = 0;
                      });
                    }
                      int nm = await update(userId: widget.userId.toString(), phone: switchState );
                  },
                ),
              ),



            ],
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
    else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }
}
