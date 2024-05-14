import 'dart:io';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/group/big_group/add_group_members.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:chat_app/ui/group/big_group/model/image_model.dart';
import 'package:chat_app/ui/group/big_group/model/image_process.dart';
import 'package:chat_app/ui/group/big_group/util/goup_methods.dart';
import 'package:chat_app/util/constants.dart';
import 'package:chat_app/util/loading/loading.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BigGroupCreate extends StatefulWidget {

  final UserModel user;
  BigGroupCreate({this.user});

  @override
  _BigGroupCreateState createState() => _BigGroupCreateState();
}

class _BigGroupCreateState extends State<BigGroupCreate> {

  GroupMethods _groupMethods = GroupMethods();

  TextEditingController mTitle = TextEditingController();
  TextEditingController mText = TextEditingController();
  bool _postValid = false;
  bool _titleValid = false;
  bool _isUploading = false;

  String visibilityState = 'Public';
  String mAlbum = 'Album';
  String mCategory = 'Category';
  File file, file2;
  String mImgStr64, mImgStr642 = '';
  bool circularIndicator = false;



  pickImageForGroup({@required ImageSource source, @required int type}) async {
    ImageFileModel pifg = await _groupMethods.pickeImageGroup(source: source);
    print(pifg.file);
    setState(() {
      if(pifg != null) {
        if (type == 1) {
          mImgStr64 = "";
          file = null;
          mImgStr64 = pifg.imgString;
          file = pifg.file;
        } else if (type == 2) {
          mImgStr642 = "";
          file2 = null;
          mImgStr642 = pifg.imgString;
          file2 = pifg.file;
        }
      }
    });
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }



  handleSubmit() async{
    setState(() {
      mTitle.text.trim().length < 5 || mTitle.text.isEmpty ? _titleValid = false : _titleValid = true;
      mText.text.trim().length < 5 || mText.text.isEmpty ? _postValid = false : _postValid = true;
    });

    if(_postValid && _titleValid) {
      setState(() {
        _isUploading = true;
      });

     GroupModel g =  await _groupMethods.createGroup(uid: widget.user.id.toString(), name: mTitle.text, photo: mImgStr64,
          cover: mImgStr642, about: mText.text);
      setState(() {
        _isUploading = false;
        file = null;
        file2 = null;
        _postValid = false;
        _titleValid = false;
        mImgStr64 = "";
        mImgStr642 = "";
        mTitle.clear();
        mText.clear();
      });

      // add group owner to db

      GroupMethods().userJoinedToGroup(group: g,
          user: widget.user,
          adminId: widget.user.id.toString(),
          role: 1
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => AddGroupMembers(user: widget.user, groupInfo: g)));

      setState(() {
        circularIndicator = false;
      });


    }
  }



  // image picker dialog
  selectImage(parentContext,type){
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: type == 1 ? Text(
              "Select group profile photo",
              style: fldarkgrey15,
            ) : Text(
              "Select group cover photo",
              style: fldarkgrey15,
            ),
            children: [
              SimpleDialogOption(
                child: Text('Image Gallery'),
                onPressed: () {
                  pickImageForGroup(source: ImageSource.gallery, type: type);
                  Navigator.pop(context);
                }

              ),
              SimpleDialogOption(
                child: Text('Image Camera'),
                onPressed: () {
                  pickImageForGroup(source: ImageSource.camera, type: type);
                  Navigator.pop(context);
                }
              ),
              SimpleDialogOption(
                child: Text("Cancle"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    );
  }



  @override
  Widget build(BuildContext context) {
    return LoadingImage(
      inAsyncCall: circularIndicator,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      "Create group",
                      style: fldarkgrey20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      controller: mTitle,
                      decoration: ftcustomInputDecoration.copyWith(
                        hintText: "Enter your group name...",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      controller: mText,
                      maxLines: 2,
                      decoration: ftcustomInputDecoration.copyWith(
                        hintText: "Enter your group description...",
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Group photo: ",
                    style: fldarkgrey15,
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width * .9,
                    height: 320,
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 3,
                          right: 3,
                          left: 3,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 220,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 7,
                                  offset: Offset(2,3),
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: file2 != null ?
                            Image.file(file2) :
                            Image(
                              image: AssetImage('assets/no_image.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 35,
                          child: GestureDetector(
                            child: Column(
                              children: [
                                Text('Cover photo'),
                                Icon(
                                  Icons.camera_alt,
                                ),
                              ],
                            ),
                              onTap: () => selectImage(context, 2),
                          ),
                        ),
                        Positioned(
                          top: 10,
                            left: MediaQuery.of(context).size.width * 0.9 / 2 - 60,
                            child: GestureDetector(
                              child: Container(
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 16,
                                      offset: Offset(0,3),
                                      color: Colors.black.withOpacity(0.3),
                                      spreadRadius: -1,
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        width: 120,
                                        height: 120,

                                        child:  file != null ?
                                        Image.file(file) :
                                        Image(
                                          image: AssetImage('assets/no_image.jpg'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('Profile'),
                                          Icon(
                                            Icons.camera_alt,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () => selectImage(context, 1),
                            ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                circularIndicator = true;
              });
              handleSubmit();
            },
          ),
        ),
      ),
    );
  }
}
