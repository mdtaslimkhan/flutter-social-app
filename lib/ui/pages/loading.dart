
import 'package:chat_app/ui/pages/login/login_methods.dart';
import 'package:flutter/material.dart';


class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  LoginMethods loginMethods = LoginMethods();


  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.all(20.0),
              child: TextButton.icon(
                  label: Text(
                    'Loading...',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'SegoeLight'
                    ),
                  ),
                icon: Icon(
                    Icons.loop,
                  color: Colors.white,
                ),
                onPressed: () {
                    Navigator.pushNamed(context, '/login');
                },
              ),
            ),
            SizedBox(height: 80.0)
          ],
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/splash.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
