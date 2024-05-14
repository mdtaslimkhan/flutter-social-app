
import 'dart:async';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/provider/file_upload_provider.dart';
import 'package:chat_app/provider/home_provider.dart';
import 'package:chat_app/provider/story_provider.dart';
import 'package:chat_app/ui/chatroom/lastmessage/lastmessage_group.dart';
import 'package:chat_app/ui/chatroom/model/contact.dart';
import 'package:chat_app/ui/pages/home/controller/homeController.dart';
import 'package:chat_app/ui/pages/home/utils/home_methods.dart';
import 'package:chat_app/ui/pages/home/widgets/header_home.dart';
import 'package:chat_app/ui/pages/home/widgets/message_item_home.dart';
import 'package:chat_app/ui/pages/widgets/progress.dart';
import 'package:chat_app/util/loading/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:async/async.dart' show StreamZip;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../error/empty_contact_list.dart';
final _fireStore = FirebaseFirestore.instance;

class Home extends StatefulWidget {
  final HomeMethods _homeMethods = HomeMethods();
  final UserModel user;
  Home({this.user});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {

  AnimationController animController;
  final HomeController _homeController = HomeController();
  ScrollController _scrollController = ScrollController();

  StreamSubscription streamSubscription;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  _registerOnFirebase() async {
    _firebaseMessaging.subscribeToTopic('all');
   await _firebaseMessaging.getToken().then((token) {
      _homeController.submitDeviceToken(userid: widget.user.id.toString(), token: token);
    });

  }

  // set state only munted data very important to fix error ==== setState after dispose method
  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }


  @override
  void dispose() {
    if(streamSubscription != null) {
      streamSubscription.cancel();
    }
    super.dispose();
  }



  @override
  void initState() {
    super.initState();
    getInitialSetupData();
    animController = AnimationController(
      duration: Duration(milliseconds: 700),
      vsync: this,
    );

   // getMessage();



  }

  HomeProvider _hp;
  StoryProvider _sp;
  FileUploadProvider _fup;

  getInitialSetupData() async {

    WidgetsBinding.instance.addPostFrameCallback((_){
      _hp = Provider.of(context, listen: false);
      _sp = Provider.of(context, listen: false);
      _hp.setShowLoader(isShow: false);
    });
    _registerOnFirebase();
    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        // at the end point load data from server
        print(_scrollController.position.pixels);
        print(_scrollController.position.maxScrollExtent);
      }
    });

  }




  getRefreshedData() async{

  }

  bool isFabShow = true;

  @override
  Widget build(BuildContext context) {
    HomeProvider _hp = Provider.of(context, listen: true);
    StoryProvider _sProvider = Provider.of(context, listen: true);
    return LoadingImage(
      inAsyncCall: _hp.showLoader,
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: header(context, widget.user),
            body: NotificationListener<UserScrollNotification>(
              onNotification: (n){
                if(n.direction == ScrollDirection.forward){
                  if(!isFabShow){setState(() { isFabShow = true; });}
                }
                if(n.direction == ScrollDirection.reverse){
                  if(isFabShow){setState(() { isFabShow = false; });}
                }
                return true;
              },
              child: RefreshIndicator(
                onRefresh: () => getRefreshedData(),
              //  onRefresh: () {},
                child: WillPopScope(
                  onWillPop: _homeController.onWillPop,
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                    },
                    child: SafeArea(
                      child: Column(
                        children: <Widget>[

                          // Container(
                          //   margin: EdgeInsets.fromLTRB(0,6.0,0,0),
                          //   height: 70.0,
                          //   child: ListView(
                          //     scrollDirection: Axis.horizontal,
                          //     children: _homeController.topsecondscroller.map((data) =>
                          //         topsecondhorizontalscrollertemplate(data)
                          //     ).toList(),
                          //   ),
                          // ),
                         SizedBox(height: 5.0),
                         Expanded(
                            child: StreamBuilder<QuerySnapshot>(
                              stream: widget._homeMethods.getHomeContactWithLastMessage(userId: widget.user.id.toString()),
                              builder: (context, snapshot) {

                                if(!snapshot.hasData){
                                  circularProgress();
                                }
                                if(snapshot.hasData) {
                                  if(snapshot.data != null) {
                                    var docList = snapshot.data.docs;
                                    // var gMap = box.toMap().values.toList();
                                    return docList.isNotEmpty ? ListView.builder(
                                     // physics: BouncingScrollPhysics(),
                                      itemCount: docList.length,
                                      itemBuilder: (context, index) {
                                        ContactHome contact = ContactHome.fromMap(docList[index].data());
                                        if(contact.uid != null) {
                                          if (contact.type == "single") {
                                            return contact.block == null ? GestureDetector(
                                                child: Card(
                                                  color: Colors.white,
                                                    child: messageItem(context, widget.user, contact)
                                                ),
                                            ) : Container();
                                          } else if (contact.type == "group") {
                                            return MessageListGroup(
                                                widget.user, contact, 1);
                                          } else if (contact.type == "bigGroup") {
                                            return  groupContact(context, contact, widget.user);
                                          } else {
                                            return Container();
                                          }
                                        }
                                        return Text('No contacts found');
                                        //  return Text('no group found');
                                      },
                                    ) : EmptyContactList(user: widget.user);
                                  }
                                }
                                return Center(child: Text('Please wait...'));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),


          ),
      ),
    );
  }




}

