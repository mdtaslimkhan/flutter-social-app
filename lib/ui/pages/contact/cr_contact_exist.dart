
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/chatroom/chatroom.dart';
import 'package:chat_app/ui/chatroom/model/contact.dart';
import 'package:chat_app/ui/pages/contact/methods/contacts_methods.dart';
import 'package:flutter/material.dart';


class CrContactExist extends StatefulWidget {
  final String contact;
  final UserModel user;
  CrContactExist({this.contact,this.user});

  @override
  _CrContactExistState createState() => _CrContactExistState();
}

class _CrContactExistState extends State<CrContactExist> {

  ContactsMethods _contactsMethods = ContactsMethods();

  // Future<UserModel> getContactInfo({@required String contact}) async {
  //
  //   final String url = BaseUrl.baseUrl("ifContactExist");
  //   final http.Response response = await http.post(url,
  //       headers: {'test-pass' : ApiRequest.mToken},
  //       body: {
  //         "number" : contact
  //       }
  //   );
  //   Map usr = jsonDecode(response.body);
  //   UserModel u = UserModel.fromJson(usr);
  //   try{
  //     if(response.statusCode == 200) {
  //       return u;
  //     }else{
  //       return null;
  //     }
  //   }catch(e){
  //     return null;
  //   }
  //
  // }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ContactsMethods().getContactInfo(contact: widget.contact),
      builder: (context , snapshot) {
        if(!snapshot.hasData){
          return Icon(
            Icons.call,
            color: Colors.white,
          );
        }
        UserModel u = snapshot.data;
        if(u.exist == 1){
          ContactsMethods().insertData(contact: u.number,
              from: widget.user,
              name: u.fName + u.nName,
              to: u);
          return GestureDetector(
            child: Icon(
              Icons.message,
              color: Colors.blueAccent,
            ),
            onTap: () async {
              UserModel to = await _contactsMethods.getContactInfo(contact: u.number);
              Navigator.push(context, MaterialPageRoute(builder:
                  (context) => ChatRoom(
                from: widget.user,
                toUserId: to.id.toString(),
                contact: ContactHome(
                    uid: to.id.toString(), name: u.fName + " " + u.nName,photo: u.photo
                ),
              )));

              // UserModel to = await _contactsMethods.getContactInfo(contact: u.number);
              // Navigator.of(context).pushNamed("/audioCallScreen", arguments:
              // {'from': widget.user,
              //   'toUserId': to.id.toString(),
              //   'toUserPhoto': u.photo,
              //   'role' : ClientRole.Broadcaster,
              //   'onReceive' : false,
              // });
            },
          );
        }

        return Icon(
          Icons.message,
          color: Colors.white,
        );
      },
    );
  }
}
