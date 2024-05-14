import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/provider/story_provider.dart';
import 'package:chat_app/provider/user_provider.dart';
import 'package:chat_app/ui/call/call_method.dart';
import 'package:chat_app/ui/call/callscreens/pickuplayout.dart';
import 'package:chat_app/ui/call/model/Call.dart';
import 'package:chat_app/ui/call/permissionhandler.dart';
import 'package:chat_app/ui/chatroom/chatmethods/chatmethods_personal.dart';
import 'package:chat_app/ui/chatroom/provider/big_group_provider.dart';
import 'package:chat_app/ui/pages/contact/methods/contacts_methods.dart';
import 'package:chat_app/ui/pages/contact/user_list.dart';
import 'package:chat_app/ui/pages/explore/explore.dart';
import 'package:chat_app/ui/pages/home/home.dart';
import 'package:chat_app/ui/pages/home/utils/home_methods.dart';
import 'package:chat_app/ui/pages/login/login_methods.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'pages/settings/wallet/provider/balance_provider.dart';




class Index extends StatefulWidget {

  final UserModel user;
  Index({this.user});

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> with WidgetsBindingObserver {

  bool isNeedUpdate = false;
  final CallMethods _callMethods = CallMethods();
  ContactsMethods _contactsMethods = ContactsMethods();
  LoginMethods _loginMethods = LoginMethods();
  PageController pageController;
  int pageIndex = 0;
  bool isCallRunning = false;
  Call call;
  BigGroupProvider _p;
  UserProvider _u;
  BalanceProvider _bp;
  String _packageName;
  StoryProvider _sp;

  final _fireStore = FirebaseFirestore.instance;

  static const platform = const MethodChannel("call_channel");
  ChatMethodsPersonal _chatMethodsPersonal = ChatMethodsPersonal();
  final HomeMethods _homeMethods = HomeMethods();
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    pageController = PageController();
    super.initState();
    forceUpdateCheckApp();
    getCrContacts();
    // user connection status online or offline
    _chatMethodsPersonal.setUserStatus(userId: widget.user.id.toString());
    platform.setMethodCallHandler(nativeMethodCallHandler);


    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {

      addPostFrameCallback();
      // set User details in provider class
      _sp = Provider.of(context, listen: false);
      _p = Provider.of<BigGroupProvider>(context, listen: false);
      _bp = Provider.of<BalanceProvider>(context, listen: false);
      _bp.getDiamondGemsStatus(userId: widget.user.id.toString());
      _u = Provider.of<UserProvider>(context, listen: false);
      _u.getUser(userId: widget.user.id.toString());
      _bp.setVersionInfo();

    

    });


  }



  // Force users to update their application
  forceUpdateCheckApp() async {
    var buildNumber;
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
       buildNumber = packageInfo.buildNumber;
       _packageName = packageInfo.packageName;
    });
    int version = await ApiRequest.updateCheckApp();
   if(version != null && version > int.parse(buildNumber)) {
     setState(() {
       isNeedUpdate = true;
     });
   }
  }


  // call method from java native MainActivity
  Future<dynamic> nativeMethodCallHandler(MethodCall methodCall) async {
    // Navigator.push(context, MaterialPageRoute(builder: (context) => Userinfo()));
    switch (methodCall.method) {
      case "methodNameItz" :
        break;
      // case "openGroup" :
      //   var val = methodCall.arguments;
      //   DocumentSnapshot ref = await _homeMethods.getContactByGroupId(userId: widget.user.id.toString(), groupId: val['groupId']);
      //   ContactHome ch = ContactHome.fromMap(ref.data());
      //   await _p.getGroupModelData(groupId: val['groupId']);
      //   Navigator.of(context).pushReplacementNamed("/bigGroupChatRoom", arguments:
      //   {'from': widget.user,
      //     'toGroupId': val['groupId'],
      //     'contact': ch,
      //     'floatButton': true,
      //   });
      //
      //   break;

      case "openPersonalCallScreen":
        var val = methodCall.arguments;
        call.type == 1 ? Navigator.of(context).pushReplacementNamed("/audioCallScreen", arguments:
        {'from': widget.user,
          'toUserId': call.callerId,
          'toUserPhoto': call.callerPic,
          'role' : ClientRole.Broadcaster,
          'onReceive' : true,
        }) : Navigator.of(context).pushReplacementNamed("/videoCallScreen", arguments:
        {'from': widget.user,
          'toUserId': call.callerId,
          'toUserPhoto': call.callerPic,
          'role' : ClientRole.Broadcaster,
          'onReceive' : true,
        });
        break;
      case "openIncomingCallScreen":
        var val = methodCall.arguments;
        if(val["answerType"] == "1") {
          val["call_type"] == "1" ?
          Navigator.of(context).pushReplacementNamed("/audioCallScreen", arguments:
          {'from': widget.user,
            'toUserId': call.callerId,
            'toUserPhoto': call.callerPic,
            'role' : ClientRole.Broadcaster,
            'onReceive' : true,
          })
              : Navigator.of(context).pushReplacementNamed("/videoCallScreen", arguments:
          {'from': widget.user,
            'toUserId': call.callerId,
            'toUserPhoto': call.callerPic,
            'role' : ClientRole.Broadcaster,
            'onReceive' : true,
          });
        }else if(val["answerType"] == "0"){
          _callMethods.endCall(call: call);
        }

        break;

      default:
        return "Nothing";
        break;
    }
  }




  // get all cr contacts
  getCrContacts() async {
    bool contactShow = await PermissionHandlerUser().permissionForContacts();
    if(contactShow){
      // If contacts already not fetched then fetch contacts again.
      int isFetched = await _loginMethods.checkIfContactFetched();
      if(isFetched != 1) {
        _contactsMethods.getAllcontact(user: widget.user);
      }
      // Save value 1 for contact already fetched.
      await _loginMethods.isContactFetchedForfirstTime();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    String currentUserId = (widget.user != null && widget.user.id != null) ? widget.user.id.toString() : "";
    super.didChangeAppLifecycleState(state);
    switch(state){
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }




  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    pageController.dispose();
    streamSubscription.cancel();
    super.dispose();
  }


  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

   onTap(int pageIndex) {
    pageController.animateToPage(
        pageIndex,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease
    );
  }

  StreamSubscription streamSubscription;
  // ready for receving call
  addPostFrameCallback(){
      streamSubscription = _callMethods.callStream(uid: widget.user.id.toString())
          .listen((DocumentSnapshot ds) {
            var dt = ds.data() as Map;
        if (dt != null && dt['caller_id'] == widget.user.id.toString() ||
            dt != null && dt['receiver_id'] == widget.user.id.toString()
        ){
          setState(() {
            isCallRunning = true;
            call = Call.fromMap(ds.data());
          });
        }else{
          setState(() {
          isCallRunning = false;
          });
        }
      });
  }


  @override
  Widget build(BuildContext context) {

    return isNeedUpdate ? Container(
      color: Colors.black,
      child: SafeArea(
          child: Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Recommended update', style: fldarkgrey18,),
                  Image.asset('assets/icon/following.jpg', width: 300,),
                  SizedBox(height: 30,),
                  new ElevatedButton.icon(
                      label: new Text('Click to update'),
                      onPressed: () => launch('https://play.google.com/store/apps/details?id=$_packageName'),
                      icon: Icon(Icons.update),
                  ),
                  SizedBox(height: 10,),
                  Center(child:
                  Text('Update your CR app from play store to \n get better experience.',
                    textAlign: TextAlign.center,
                  )
                  ),

                ],
              )
          )
      ),
    ) : SafeArea(
          child: PickupLayout(
            usermodel: widget.user,
            scaffold: Scaffold(
              backgroundColor: Colors.white,
              body: Column(
                children: [
                  Expanded(
                    child: PageView(
                      children: [
                       Home(user: widget.user),
                       Explore(user: widget.user),
                      //  Index page for calling with Agora API
                      // Market(user: widget.user),
                       Userlist(user: widget.user),
                      ],
                      controller: pageController,
                      onPageChanged: onPageChanged,
                      physics: NeverScrollableScrollPhysics(),
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: CupertinoTabBar(
                currentIndex: pageIndex,
                onTap: onTap,
                activeColor: Theme.of(context).primaryColor,
              //  unselectedItemColor: Colors.black.withOpacity(0.7),
              //  selectedItemColor: Theme.of(context).primaryColor,
              //  showUnselectedLabels: true,
              //  selectedLabelStyle: TextStyle(
               //   fontSize: 12,
               // ),
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.message),
                    label: 'Message',
                  ),

                  BottomNavigationBarItem(
                    icon: Icon(Icons.explore),
                    label: 'Explore',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.contacts),
                    label: 'Contacts',
                  ),
                ],
              ),
            ),
          ),
      );


  }
}
