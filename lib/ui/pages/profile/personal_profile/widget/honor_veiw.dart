
import 'package:chat_app/ui/pages/profile/personal_profile/model/crown_model.dart';
import 'package:flutter/material.dart';

class HonorView extends StatelessWidget {

  final Crown crown;
  HonorView({this.crown});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Image.network(crown.img),
                ),
                Text("${crown.title}", style: TextStyle(
                    color: Colors.white,
                    fontSize: 45,
                    fontFamily: "Sego"
                ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20,),
                Text("${crown.description}", style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15,),
                Text("Time: ${crown.date}", style: TextStyle(
                    color: Colors.white
                ),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
