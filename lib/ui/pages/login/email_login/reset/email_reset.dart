

import 'package:chat_app/ui/pages/home/home.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/constants.dart';
import 'package:chat_app/util/loading/loading.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../email_login.dart';


class PasswordReset extends StatefulWidget {
  final String email;
  const PasswordReset({this.email});

  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {

  final TextEditingController numberControllers = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController retypePassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _passwordEntered = "";

  bool imageLoad = false;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Password reset"),),
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
                    Text("Please enter new password"),

                    TextFormField(
                      controller: password,
                      decoration: const InputDecoration(labelText: 'Password'),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      validator: (val) => validatePass(val),
                      onChanged: (val){
                        print(val);
                        _passwordEntered = val;
                      },
                    ),
                    TextFormField(
                      controller: retypePassword,
                      decoration: const InputDecoration(labelText: 'Retype password'),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      validator: (val) => validateRePass(val),
                    ),
                    SizedBox(height: 30,),
                    Container(
                      width: 100,
                      height: 40,
                      color: Colors.green,
                      child: GestureDetector(
                        onTap: () async{
                          if(_formKey.currentState.validate()){
                            setState(() {
                              imageLoad = true;
                            });
                            final bool ifUpdated = await ApiRequest.submitNewPassword(widget.email, password.text);
                            if(ifUpdated){
                              Fluttertoast.showToast(msg: "Password successfully changed");
                            }else{
                              Fluttertoast.showToast(msg: "Password changed error");
                            }
                            Navigator.push(context, MaterialPageRoute(builder: (parentContext) => EmailLogin()));
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


  String validatePass(String value) {
    print(value);
    if (value.length == 0) {
      return 'Please enter password 8 - 18 char';
    }
    if (value.length < 8) {
      return 'Password too short';
    }
    if (value.length > 18) {
      return 'Password too long';
    }
    return null;
  }

  String validateRePass(String value) {
    print("passwodg");
    print(value);
    if(value != _passwordEntered){
      return 'Password did not matched';
    }
    if (value.length < 8) {
      return 'Password too short';
    }
    if (value.length > 18) {
      return 'Password too long';
    }
    return null;
  }




}



