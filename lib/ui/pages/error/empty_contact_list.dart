import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/pages/contact/user_list.dart';
import 'package:chat_app/util/constants.dart';
import 'package:flutter/material.dart';

class EmptyContactList extends StatelessWidget {

  final UserModel user;
  EmptyContactList({this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Image.asset("assets/icon/add_friend.jpg", width: 300,),
                SizedBox(height: 20),
                Text("Contact list empty",style: fldarkgrey18,),
                SizedBox(height: 5),
                Text("To start chatting with friends \n click below button", style: TextStyle(
                ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                MaterialButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Userlist(user: user)));
                    },
                  child: Text("Add contact", style: TextStyle(
                    color: Colors.white,
                  ),),
                  color: Colors.blue,
                ),
                SizedBox(height: 55,),
              ],
            )
        )
    );
  }
}
