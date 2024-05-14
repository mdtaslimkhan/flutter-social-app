

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/index.dart';
import 'package:chat_app/ui/pages/login/email_login/email_register.dart';
import 'package:chat_app/ui/pages/login/email_login/reset/email_input.dart';
import 'package:chat_app/ui/pages/login/login_methods.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/constants.dart';
import 'package:chat_app/util/loading/loading.dart';
import 'package:flutter/material.dart';


LoginMethods loginMethods = LoginMethods();

class EmailLogin extends StatefulWidget {
  const EmailLogin({Key key}) : super(key: key);

  @override
  _EmailLoginState createState() => _EmailLoginState();
}

class _EmailLoginState extends State<EmailLogin> {

  final TextEditingController emailControllers = TextEditingController();
  final TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _passwordEntered = "";
  bool imageLoad = false;

  Future<bool> willPop() {
    setState(() {
      imageLoad = false;
    });
    Navigator.of(context).pop();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: willPop,
        child: Scaffold(
          appBar: AppBar(title: Text("Email login"),),
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
                      Text("Login to CR", style: fldarkgrey22),
                      SizedBox(height: 5,),
                      Text("Please enter your email and password."),
                      TextFormField(
                        controller: emailControllers,
                        decoration: const InputDecoration(labelText: 'email@mail.com'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) => validateMobile(val),
                        onChanged: (val){
                          print(val);
                        },
                      ),
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
                              print(emailControllers.text);
                              print(password.text);
                              enterEmailInfoSubmit(email: emailControllers.text, pass: password.text);

                            }
                          },
                          child: Center(child: Text("Submit", style: ftwhite15,)),
                        ),
                      ),
                      SizedBox(height: 30,),
                      GestureDetector(
                        child: Text("New to CR? Tap to create account.", style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                        ),),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (parentContext) => EmailRegister()));


                        },
                      ),
                      SizedBox(height: 16,),
                      GestureDetector(
                        child: Text("Forgot your account? Tap to reset password", style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                        ),),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (parentContext) => EmailInputToReset()));
                        },
                      ),

                    ],
                  ),
                ),
              ),
            )
        ),
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


  void signIn (UserModel user) async {
    await loginMethods.setUser(user);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Index(user: user)), (route) => false);
  }

  enterEmailInfoSubmit({String email, String pass}) async {
    // check if user request can retrieve user data
    final UserModel user = await ApiRequest.userEmailLogin(email, pass);
    // if retrieve pass and not null then login with user info
    if(user != null) {
      // for firebase user only
      await ApiRequest.getFutureInfo();
      //  await _auth.signInWithEmailAndPassword(email: U_NAME, password: U_PASS);
      signIn(user);

    }
  }





}





