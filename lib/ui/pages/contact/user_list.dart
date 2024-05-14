

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/storage/local_db.dart';
import 'package:chat_app/ui/call/permissionhandler.dart';
import 'package:chat_app/ui/chatroom/chatroom.dart';
import 'package:chat_app/ui/chatroom/model/contact.dart';
import 'package:chat_app/ui/pages/contact/cr_contact_exist.dart';
import 'package:chat_app/ui/pages/contact/methods/contacts_methods.dart';
import 'package:chat_app/ui/pages/contact/user_contact_item.dart';
import 'package:chat_app/ui/pages/home/utils/home_methods.dart';
import 'package:chat_app/ui/pages/widgets/progress.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/constants.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';


class Userlist extends StatefulWidget {
  final HomeMethods _homeMethods = HomeMethods();
  final UserModel user;
  Userlist({this.user});

  @override
  _UserlistState createState() => _UserlistState();
}

class _UserlistState extends State<Userlist> {
  bool _isButtonDisabled;
  ContactsMethods _contactsMethods = ContactsMethods();
  String _packageName;


  @override
  void initState() {
    super.initState();
    getPackageInfo();
    ApiRequest.getUser().then((data) {});
    _isButtonDisabled = false;
    checkPermissionForContacts();
  }


  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }


  List<Contact> contactList = [];

  initContacts() async {
    List<Contact> contacts =
    (await ContactsService.getContacts()).toList();
    setState(() {
      contactList = contacts;
    });

  }




  List<UserContactItem> _userList = [];


  custom_tile(UserContactItem _contact) {
    return Container(
      margin: EdgeInsets.only(top: 15, bottom: 25, left: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(new Radius.circular(10.0)),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(3, 5), // changes position of shadow
          ),
        ],
      ),
      padding: EdgeInsets.only(left: 15, top: 5, bottom: 5, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          !_contact.imageUrl.isEmpty
              ? CircleAvatar(
            backgroundImage: MemoryImage(_contact.imageUrl),
          )
              : CircleAvatar(
            child: Icon(Icons.person),
          ),
          SizedBox(width: 5,),
          Text(' ${_contact.contactName}'),
          Container(
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.all(new Radius.circular(15.0)),
              border: Border.all(
                color: Colors.white,
                width: 2.0,
              ),

            ),
            padding: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5),
            margin: EdgeInsets.only(left: 10, top: 5, right: 5, bottom: 5),
            child: Row(
              children: [
                Icon(
                  Icons.add,
                  size: 15,
                  color: Colors.white,
                ),
                Text('Invite',
                  style: ftwhite10,),
              ],
            ),
          ),
        ],
      ),
    );
  }

  getcontactsList(List<UserContactItem> contactList) {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: contactList.length,
        itemBuilder: (context, index) {
          UserContactItem _contact = contactList[index];

          return GestureDetector(
            child: custom_tile(_contact),
            onTap: () {
                share(_contact.number.value);
             // _textMe(_contact.number.value);
           
            },
          );
        });
  }


  showFetchedContact(List<UserContactItem> contactList) {
    return ListView.builder(
      itemCount: contactList.length,
      shrinkWrap: true,
      itemBuilder: (context, contactIndex) {
        String number = contactList[contactIndex].number.value;
        // remove white space from number
        String nm = number.replaceAll(new RegExp(r"\s+"), "");
        // remove hyphen from number
        String num = nm.replaceAll(new RegExp("[\\s\\-()]"), "");

        return ListTile(
          leading: !contactList[contactIndex].imageUrl.isEmpty
              ? CircleAvatar(
            backgroundImage: MemoryImage(contactList[contactIndex].imageUrl),
          )
              : CircleAvatar(
               child: Icon(Icons.person),
          ),
          onTap: () async {

          },
          title: Text(
            contactList[contactIndex].contactName, style: fldarkgrey12,),
          trailing: CrContactExist(contact: num, user: widget.user),
        );
      },
    );
  }


  bool showContact = false;

  _showCrContact() {
    setState(() {
      _isButtonDisabled ? _isButtonDisabled = false : _isButtonDisabled = true;
    });
  }

  checkPermissionForContacts() async {
    bool contactShow = await PermissionHandlerUser().permissionForContacts();
    if (contactShow == true) {
      setState(() {
        showContact = true;
      });
    }
  }

  scaffold() {
    if (showContact == true) {
      return RefreshIndicator(
        onRefresh: () => _contactsMethods.getAllcontact(user: widget.user),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(title: Text('Contacts'),),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(left: 20, top: 10, bottom: 0),
                    child: Text('Invite to CR')),
                Container(
                    height: 120,
                    child: FutureBuilder(
                      future: _contactsMethods.getContacts(),
                      builder: (context, snapshot) {
                        return snapshot.data != null ? getcontactsList(
                            snapshot.data) : circularProgress();
                      },
                    )
                ),
                Container(
                    margin: EdgeInsets.only(left: 15, bottom: 10),
                    child: Text('Contact')
                ),
                Row(
                  children: [
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 2,
                      child: TextButton(
                        child: new Text(
                          "All", style: fldarkHome16,
                        ),
                        onPressed: !_isButtonDisabled ? null : _showCrContact,
                      ),
                    ),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 2,
                      child: TextButton(
                        child: new Text(
                          "CR", style: fldarkHome16,
                        ),
                        onPressed: _isButtonDisabled ? null : _showCrContact,
                      ),
                    ),
                  ],
                ),
                Expanded(child:

                !_isButtonDisabled ? FutureBuilder(
                  future: _contactsMethods.getContacts(),
                  builder: (context, snapshot) {
                    return snapshot.data != null ? showFetchedContact(
                        snapshot.data) : circularProgress();
                  },
                ) :
                FutureBuilder(
                  future: LocalDbHelper.instance.getAllContact(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    return snapshot.data != null
                        ? dataList(rows: snapshot.data)
                        : circularProgress();
                  },
                ),
                  // FutureBuilder(
                  //   future: getContacts(),
                  //   builder: (context, snapshot) {
                  //     return snapshot.data != null ? showCrContact(
                  //         snapshot.data) : circularProgress();
                  //   },
                  // ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      );
    } else {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(title: Text('Contacts'),),
          body: Container(
            child: Center(
              child: Text(
                  'Contact Permission need to show contact'
              ),
            ),
          ),
        ),
      );
    }
  }

  dataList({List<Map<String, dynamic>> rows}) {
    return ListView.builder(
        itemCount: rows.length,
        itemBuilder: (context, index) {
          int id = rows[index][LocalDbHelper.contactId];
          String name = rows[index][LocalDbHelper.contactName];
          String exist = rows[index][LocalDbHelper.contactIsExist];
          String number = rows[index][LocalDbHelper.contactNumber];
          String image = rows[index][LocalDbHelper.contactImage];
          int fromId = rows[index][LocalDbHelper.contactFromUserId];
          int toId = rows[index][LocalDbHelper.contactToUserId];

          return ListTile(
            leading: image != null ? CircleAvatar(
              backgroundImage: NetworkImage(image),
            ) : CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: Text('$name',style: fldarkgrey12,),
            trailing: IconButton(
              icon: Icon(Icons.call,
                color: Colors.lightBlue,),
              onPressed: () async {
                // await LocalDbHelper.instance.deleteContact(id: id);
                // setState(() { });
                UserModel to = await _contactsMethods.getContactInfo(contact: number);
                Navigator.of(context).pushNamed("/audioCallScreen", arguments:
                {'from': widget.user,
                  'toUserId': to.id.toString(),
                  'toUserPhoto': image,
                  'role' : ClientRole.Broadcaster,
                  'onReceive' : false,
                });
              },
            ),
            onTap: () async {
              UserModel to = await _contactsMethods.getContactInfo(contact: number);
              Navigator.push(context, MaterialPageRoute(builder:
                  (context) => ChatRoom(
                from: widget.user,
                toUserId: to.id.toString(),
                contact: ContactHome(
                    uid: to.id.toString(), name: name,photo: image
                ),
              )));
            },
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return scaffold();
  }



  void getPackageInfo() async {
    PackageInfo.fromPlatform().then((PackageInfo p) {
      _packageName = p.packageName;
    });
  }


  Future<void> share(String number) async {
    await FlutterShare.share(
        title: 'Download CR ',
        text: 'Social media app to join with me.',
        linkUrl: 'https://play.google.com/store/apps/details?id=$_packageName',
        chooserTitle: 'Share CR App'
    );
  }


  _textMe(String number) async {
    // Android
    String uri = "sms: $number ?body=Dowinload the CR Social media app to join with me. Download link: https://play.google.com/store/apps/details?id=$_packageName";
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      // iOS
      String uri = 'sms:$number?body=Dowinload the CR Social media app to join with me. Download link: https://play.google.com/store/apps/details?id=$_packageName';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }



}



