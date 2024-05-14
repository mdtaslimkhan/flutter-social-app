
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/call/big_group_call_util/big_group_call_method.dart';
import 'package:chat_app/ui/pages/widgets/progress.dart';
import 'package:flutter/material.dart';



// ignore: must_be_immutable
class BigGroupCallNotifier extends StatelessWidget {

  Widget scaffold;
  UserModel user;
  CallMethodsBigGroup callMethodsBigGroup = CallMethodsBigGroup();
  BigGroupCallNotifier({this.scaffold, this.user});


  @override
  Widget build(BuildContext context) {
    return Container(
      child: user != null && user.id != null ? StreamBuilder(
          stream: callMethodsBigGroup.callStream(uid: user.id.toString()),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return Text('');
            }
            return scaffold;
          }
      ) : Scaffold(body: circularProgress(),),
    );
  }
}
