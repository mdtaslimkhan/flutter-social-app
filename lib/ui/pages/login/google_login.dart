

import 'package:chat_app/ui/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class GoogleLogin extends StatefulWidget {
  const GoogleLogin({Key key}) : super(key: key);

  @override
  _GoogleLoginState createState() => _GoogleLoginState();
}

class _GoogleLoginState extends State<GoogleLogin> {


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Google login"),),
          body: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 50,
                  color: Colors.green,
                  child: GestureDetector(
                    onTap: (){
                      AuthService().signInwithGoolge();
                    },
                    child: Center(child: Text("Google signin", style: TextStyle(
                      color: Colors.white, fontSize: 25
                    ),)),
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
}


class AuthService{

  handleAuthState() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot){
        if(snapshot.hasData) {
          return Column(
            children: [
              Text("logged in"),
              MaterialButton(onPressed: (){
                AuthService().signOut();
              },
              child: Text("logout"
              ),)
            ],
          );
        }else{
          return Text("login now");
        }
      },
    );
  }

  signInwithGoolge() async {
    final GoogleSignInAccount user = await GoogleSignIn(
      scopes: <String>["email"]).signIn();

    final GoogleSignInAuthentication gAuth = await user.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);

  }

  signOut(){
    FirebaseAuth.instance.signOut();
  }

}
