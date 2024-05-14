import 'dart:ui';

import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.fromLTRB(0, 20.0, 0, 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 10,
                      sigmaY: 10,
                    ),
                    child: Container(
                      color: Colors.black.withOpacity(0.0),
                    ),
                  ),
                ),
                // container for place holder for getting blur effect for image
                Container(
                  child: Text(''),
                )

              ],
            ),
            Expanded(
              flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, '/home');
                      },
                      child: Padding(
                       padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                        child: Text(
                            'Skip',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: Colors.black54,
                            fontFamily: 'Sego',
                            fontSize: 18.0
                          ),
                          ),
                      ),
                    ),
                  ],
                ),
            ),
            Expanded(
              flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.all(10.0),
                      child: Text(
                          'Circle of Rectitude',
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SegoeLight',
                          color: Colors.white
                        ),
                      ),
            ),
                  ],
                )),
            Expanded(
              flex: 7,
              child: Container(
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Make the world\n'
                          'very easy',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 36.0,
                        color: Colors.white,
                        fontFamily: 'SegoBold',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Create your own goal with\n'
                          'friends and relatives',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontFamily: 'SegoeLight',
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50.0),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonTheme(
                    minWidth: 130.0,
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      icon: Icon(
                        Icons.person_add,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Sign Up',
                        style: TextStyle(
                            color: Colors.white,
                          fontFamily: 'SegoeLight'
                        ),
                      ),

                    ),
                  ),
                  SizedBox(width: 25.0,),
                  ButtonTheme(
                    minWidth: 130.0,
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      icon: Icon(
                        Icons.input,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Sign In',
                        style: TextStyle(
                            color: Colors.white,
                          fontFamily: 'SegoeLight'
                        ),
                      ),

                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.0),
            Center(
              child: Text(
                  'By opening an account , you agree to our \n'
                      'Terms of Service and Privacy Policy',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                  fontFamily: 'Sego',
                ),
              ),
            ),
            SizedBox(height: 60.0)
          ],
        ),

        decoration: BoxDecoration(
          color: Colors.lightBlue,
          image: DecorationImage(
            image: AssetImage('assets/login/login.png'),
            fit: BoxFit.cover,
            repeat: ImageRepeat.repeat
          ),
        ),

      ),
    );
  }
}
