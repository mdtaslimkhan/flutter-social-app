

import 'package:chat_app/ui/pages/home/home.dart';
import 'package:chat_app/ui/pages/login/email_login/reset/email_reset.dart';
import 'package:chat_app/util/constants.dart';
import 'package:chat_app/util/loading/loading.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';


class EmailCode extends StatefulWidget {
  final String email;
  final int code;
  const EmailCode({this.email, this.code});

  @override
  _EmailCodeState createState() => _EmailCodeState();
}

class _EmailCodeState extends State<EmailCode> {

  final TextEditingController codeControllers = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _passwordEntered = "";

  bool imageLoad = false;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Submit code"),),
          body: LoadingImage(
            inAsyncCall: imageLoad,
            child: Container(
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Please enter email code"),
                    TextFormField(
                      controller: codeControllers,
                      decoration: const InputDecoration(labelText: '15xxxx'),
                      keyboardType: TextInputType.number,
                      validator: (val) => validateMobile(val),
                      onChanged: (val){
                        print(val);
                      },
                    ),

                    SizedBox(height: 30,),
                    Container(
                      width: 100,
                      height: 40,
                      color: Colors.green,
                      child: GestureDetector(
                        onTap: (){
                          if(_formKey.currentState.validate()){
                            setState(() {
                              imageLoad = true;
                            });
                            if(widget.code.toString() == codeControllers.text) {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (parentContext) => PasswordReset(email: widget.email)));
                            }else{
                              Fluttertoast.showToast(msg: "Code you entered is invalid.");
                            }
                            setState(() {
                              imageLoad = false;
                            });
                          }
                        },
                        child: Center(child: Text("Submit", style: ftwhite15,)),
                      ),
                    ),
                    SizedBox(height: 10,),

                  ],
                ),
              ),
            ),
          )
      ),
    );
  }


  String validateMobile(String value) {
    if (value.length == 0) {
      return 'Please enter code';
    }
    if (value.length > 6) {
      return 'Email too long';
    }
    if (value.length < 1) {
      return 'Email too short';
    }
    return null;
  }








}



