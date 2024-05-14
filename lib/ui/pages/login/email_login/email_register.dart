

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/index.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/constants.dart';
import 'package:chat_app/util/loading/loading.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../login_methods.dart';


LoginMethods loginMethods = LoginMethods();


class EmailRegister extends StatefulWidget {
  const EmailRegister({Key key}) : super(key: key);

  @override
  _EmailRegisterState createState() => _EmailRegisterState();
}

class _EmailRegisterState extends State<EmailRegister> {

  final TextEditingController emailControllers = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController retypePassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _passwordEntered = "";

  bool imageLoad = false;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Create a new account"),),
          body: LoadingImage(
            inAsyncCall: imageLoad,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Create new account to CR", style: fldarkgrey22,),
                      Text("Please enter email address and new password."),
                      SizedBox(height: 30,),
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
                          onTap: (){
                            if(_formKey.currentState.validate()){
                              setState(() {
                                imageLoad = true;
                              });
                              enterEmailInfoSubmit(email: emailControllers.text, pass: password.text);
                            }
                          },
                          child: Center(child: Text("Submit", style: ftwhite15,)),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text("Please keep your password in secure place. Without password you will not be able to login in this app"),

                    ],
                  ),
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

  void signIn (UserModel user) async {
    await loginMethods.setUser(user);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Index(user: user)), (route) => false);
  }

  enterEmailInfoSubmit({String email, String pass}) async {
    // check if user request can retrieve user data
    final UserModel user = await ApiRequest.registerWithEmail(email, pass);
    // if retrieve pass and not null then login with user info
    if(user != null) {
      // for firebase user only
      await ApiRequest.getFutureInfo();
      //  await _auth.signInWithEmailAndPassword(email: U_NAME, password: U_PASS);
      signIn(user);

    }else{
      setState(() {
        imageLoad = false;
      });
      Fluttertoast.showToast(msg: "User already exist try to login");
    }
  }






}



