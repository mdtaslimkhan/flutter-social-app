

import 'dart:math';

import 'package:chat_app/ui/pages/home/home.dart';
import 'package:chat_app/ui/pages/login/email_login/reset/email_code.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/constants.dart';
import 'package:chat_app/util/loading/loading.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';


class EmailInputToReset extends StatefulWidget {
  const EmailInputToReset({Key key}) : super(key: key);

  @override
  _EmailInputToResetState createState() => _EmailInputToResetState();
}

class _EmailInputToResetState extends State<EmailInputToReset> {

  final TextEditingController emailControllers = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _passwordEntered = "";
  bool imageLoad = false;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Enter email to reset password"),),
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
                    Text("Enter your email and submit to get code in email address"),
                    TextFormField(
                      controller: emailControllers,
                      decoration: const InputDecoration(labelText: 'email@mail.com'),
                      keyboardType: TextInputType.emailAddress,
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
                        onTap: () async {
                          if(_formKey.currentState.validate()){
                            setState(() {
                              imageLoad = true;
                            });

                            var rng = Random();
                            var code = rng.nextInt(1000000);
                            print(code);
                            final bool ifMailSent = await ApiRequest.forgetEmailPass(emailControllers.text, code.toString());
                            if(ifMailSent) {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (parentContext) => EmailCode(email: emailControllers.text, code: code)));
                            }else{
                              setState(() {
                                imageLoad = false;
                              });
                              Fluttertoast.showToast(msg: "Mail sending error");
                            }
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
      return 'Please enter email';
    }
    if (value.length > 30) {
      return 'Email too long';
    }
    return null;
  }






}



