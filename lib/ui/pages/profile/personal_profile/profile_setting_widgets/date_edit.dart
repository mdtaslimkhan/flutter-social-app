import 'dart:convert';

import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:chat_app/util/constants.dart';
import 'package:chat_app/util/loading/loading.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DateEdit extends StatefulWidget {
  String userId;
  String date;
  DateEdit({this.userId,this.date});

  @override
  _DateEditState createState() => _DateEditState();
}

class _DateEditState extends State<DateEdit> {

  TextEditingController dateOfBirth = TextEditingController();

  DateTime selectedDate = DateTime.now();
  bool isNewBirth = false;
  String pickedDate;
  bool showProgress = false;
  bool datePickedCompleted = false;

  Future _selectDate(context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1030, 5),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateOfBirth.text = "${selectedDate.toLocal()}".split(' ')[0];
        isNewBirth = true;
        datePickedCompleted = true;
      });
    }
  }

  Future<String> updateDate({String url, String id, String key}) async {
    final String url = BaseUrl.baseUrl("updateDate");
    final response = await http.post(Uri.parse(url), headers: {
      'test-pass': ApiRequest.mToken
    }, body: {
      'id': widget.userId,
      'birth': dateOfBirth.text,
    });
    Map data = jsonDecode(response.body);

    var txt = data['user']['birth'];
    if (response.statusCode == 200) {
      if (!data['error']) {
        return txt;
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
      selectDate = widget.date;
    });

    super.initState();
  }

  String selectDate = "Select date";



  @override
  Widget build(BuildContext context) {

    return LoadingImage(
      inAsyncCall: showProgress,
      child: SafeArea(
          child: Scaffold(
          appBar: AppBar(title: Text("Birth edit")),
          body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 15, 15.0, 0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffebecf0),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 16,
                    offset: Offset(0, 3),
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: -1,
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Icon(Icons.calendar_today),
                title: isNewBirth
                    ? Text(dateOfBirth.text)
                    : pickedDate != null
                        ? Text(pickedDate)
                        : Text('$selectDate'),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                ),
                onTap: () => _selectDate(context),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: isNewBirth ? Container() : Text("Please select birth",style: TextStyle(
                color: Colors.red
            ),),
          ),
          GestureDetector(
            child: Container(
                margin: EdgeInsets.all(15),
                height: 40,
                width: 180,
                decoration: BoxDecoration(
                  color: !datePickedCompleted ? Colors.grey : Colors.blueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 16,
                      offset: Offset(0, 3),
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: -1,
                    ),
                  ],
                ),
                child: Center(
                    child: Text(
                  "Save",
                  style: ftwhite14,
                ))),
            onTap: !datePickedCompleted ? null : () async {

              final txt = dateOfBirth.text;
              if(isNewBirth) {
                setState(() {
                  showProgress = true;
                });
                String date = await updateDate();
                Navigator.pop(context, date);
              }else{

              }
            },
          ),
        ]),
      )),
    );
  }

  String validateText(String value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return 'Please enter some text';
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
