import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/call/call_method.dart';
import 'package:chat_app/ui/call/callscreens/group/pickupscreen_group.dart';
import 'package:chat_app/ui/call/callscreens/pickupscreen.dart';
import 'package:chat_app/ui/call/model/Call.dart';
import 'package:chat_app/ui/pages/widgets/progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PickupLayout extends StatelessWidget {

  final Widget scaffold;
  final CallMethods callMethods = CallMethods();
  final UserModel usermodel;

  PickupLayout({@required this.scaffold, this.usermodel});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: usermodel != null && usermodel.id != null ?  StreamBuilder<DocumentSnapshot>(
         // stream: _fireStore.collection("call").document(usermodel.id.toString()).snapshots(),
          stream: callMethods.callStream(uid: usermodel.id.toString()),
          builder: (context, snapshot) {
            if(snapshot.hasData && snapshot.data.data() != null){
              Call call = Call.fromMap(snapshot.data.data());
              if(!call.hasDialled && call.onCallReceived != true) {
                if(call.isGroup != null && call.isGroup == false && call.onCallReceived == false) {
                  return PickupScreen( userModel: usermodel, call: call);
                }else{
                  return PickupScreenGrooup(
                      call: call, userModel: usermodel, callType: call.type);
                }
              }
              return scaffold;
            }
            return scaffold;
          }
      ) : Scaffold(body: circularProgress(),),

    );
  }
}

// class PickupLayout extends StatelessWidget {
//
//   final Widget scaffold;
//   final CallMethods callMethods = CallMethods();
//   final UserModel usermodel;
//
//   PickupLayout({@required this.scaffold, this.usermodel});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: usermodel != null && usermodel.id != null ?  StreamBuilder<DocumentSnapshot>(
//         // stream: _fireStore.collection("call").document(usermodel.id.toString()).snapshots(),
//           stream: callMethods.callStream(uid: usermodel.id.toString()),
//           builder: (context, snapshot) {
//             if(snapshot.hasData && snapshot.data.data() != null){
//               Call call = Call.fromMap(snapshot.data.data());
//               if(!call.hasDialled && call.onCallReceived != true) {
//                 if(call.isGroup != null && call.isGroup == false && call.onCallReceived == false) {
//                   return PickupScreen( userModel: usermodel, call: call);
//                 }else{
//                   return PickupScreenGrooup(
//                       call: call, userModel: usermodel, callType: call.type);
//                 }
//               }
//               return scaffold;
//             }
//             return scaffold;
//           }
//       ) : Scaffold(body: circularProgress(),),
//
//     );
//   }
// }
