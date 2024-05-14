import 'dart:convert';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class FlagUser extends StatefulWidget {

  final profileId;
  final userId;
  FlagUser({this.profileId, this.userId});

  @override
  _FlagUserState createState() => _FlagUserState();
}

class _FlagUserState extends State<FlagUser> {

  final strcontroller = TextEditingController();
  int _groupValue = -1;
  bool _other = false;
  String _flagstr = "";
  bool _btnDisable = true;

  FocusNode textFocus = FocusNode();



 getButtonValue(state){
   if(state != 6){
     setState(() {
       _other = false;
       _btnDisable = false;
     });
   }
   switch(state){
     case 0:
       setState(() {
         _flagstr = "Spam content";
         _groupValue = 0;
       });
       break;
     case 1:
         setState(() {
           _flagstr =  "Pornography or sexual content";
         _groupValue = 1;
         });
       break;
     case 2:
         setState(() {_flagstr =  "Child abuse";
         _groupValue = 2;
         });
       break;
     case 3:
         setState(() {_flagstr =  "Promotes terrorism";
         _groupValue = 3;
         });
       break;
     case 4:
         setState(() {_flagstr =  "Suicide or self injury";
         _groupValue = 4;
         });
       break;
     case 5:
         setState(() {
           _flagstr =   "Misinformation";
         _groupValue = 5;
         });
       break;
     case 6:
         setState(() {
           _flagstr = strcontroller.text;
         _groupValue = 6;
         _other = true;
         _btnDisable = true;
         });
         FocusScope.of(context).requestFocus(textFocus);
       break;
     default:

       break;
   }
 }


  _textUpdate(String vl) {
    setState(() => _flagstr = vl);
    print(vl);
    print(_flagstr);
    if(_groupValue == 6 && strcontroller.text.isNotEmpty){
      setState(() {
        _btnDisable = false;
      });
    }else{
      setState(() {
        _btnDisable = true;
      });
    }
  }

  _submitFlag() async {
    final dta = await setUserFlag(uId: widget.userId, currentUserId: widget.profileId, flagstr: _flagstr);
    print(dta);
    Fluttertoast.showToast(msg: dta);
    strcontroller.clear();
    if(_groupValue == 6 && strcontroller.text.isEmpty) {
      setState(() {
        _btnDisable = true;
      });
    }
  }
   setUserFlag({String uId, String currentUserId, String flagstr}) async {
    try {
      final String url = BaseUrl.baseUrl("flagUser");
      final http.Response rs = await http.post(Uri.parse(url),
          headers: { 'test-pass': ApiRequest.mToken},
          body: {'user_id' : uId, 'reson' : flagstr, 'flaged_id': currentUserId}
      );
      Map data = jsonDecode(rs.body);
      String dt = data["flag"].toString();
      return dt;
    }catch(e){
      print("this error from login_methods file");
      print(e);
    }
    return null;
  }



  @override
  void initState() {
    strcontroller.addListener(() {
      setState(() {

      });
      print(strcontroller.text);
      print("controller text");
    });
    super.initState();
  }

  @override
  void dispose() {
    strcontroller.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Flag this user"),

        ),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _myRadioButton(
                  title: "Spam content",
                  value: 0,
                  onChanged: (newValue) => getButtonValue(newValue),
                ),
                _myRadioButton(
                  title: "Pornography or sexual content",
                  value: 1,
                  onChanged: (newValue) => getButtonValue(newValue),
                ),
                _myRadioButton(
                  title: "Child abuse",
                  value: 2,
                  onChanged: (newValue) => getButtonValue(newValue),
                ),
                _myRadioButton(
                  title: "Promotes terrorism",
                  value: 3,
                  onChanged: (newValue) => getButtonValue(newValue),
                ),
                _myRadioButton(
                  title: "Suicide or self injury",
                  value: 4,
                  onChanged: (newValue) => getButtonValue(newValue),
                ),
                _myRadioButton(
                  title: "Misinformation",
                  value: 5,
                  onChanged: (newValue) => getButtonValue(newValue),
                ),

                _myRadioButton(
                  title: "Other",
                  value: 6,
                  onChanged: (newValue) => getButtonValue(newValue),
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Card(
                      color: Color(0xffe5e5e5),
                      child: Padding(
                        padding: EdgeInsets.all(0.0),
                        child: TextField(
                          controller:  strcontroller,
                          onChanged: (vl) => _textUpdate(vl) ,
                          enabled: _other,
                          maxLines: 8, //or null
                        //  decoration: InputDecoration.collapsed(hintText: "Enter your text here"),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Enter your text here",
                          ),
                          textInputAction: TextInputAction.done,
                          focusNode: textFocus,
                        ),
                      )
                  ),
                ),

                MaterialButton(

                  child: Text('Submit'),
                  onPressed: _btnDisable ? null : () => _submitFlag(),
                  height: 40,
                  color: Colors.blue,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),

                ),

                SizedBox(height: 230,),




              ],
            )
        ),
      ),
    );
  }

  Widget _myRadioButton({String title, int value, Function onChanged}) {
    return RadioListTile(
      value: value,
      groupValue: _groupValue,
      onChanged: onChanged,
      title: Text(title),
    );
  }




}
