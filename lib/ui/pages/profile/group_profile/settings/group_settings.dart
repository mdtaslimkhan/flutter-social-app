import 'dart:io';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/provider/user_provider.dart';
import 'package:chat_app/ui/chatroom/provider/big_group_provider.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:chat_app/ui/group/big_group/model/image_model.dart';
import 'package:chat_app/ui/group/big_group/util/goup_methods.dart';
import 'package:chat_app/ui/index.dart';
import 'package:chat_app/ui/pages/profile/group_profile/settings/group_about_edit.dart';
import 'package:chat_app/ui/pages/profile/group_profile/settings/group_address_edit.dart';
import 'package:chat_app/ui/pages/profile/group_profile/settings/group_announce_edit.dart';
import 'package:chat_app/ui/pages/profile/group_profile/settings/group_description_edit.dart';
import 'package:chat_app/ui/pages/profile/group_profile/settings/group_language_edit.dart';
import 'package:chat_app/ui/pages/profile/group_profile/settings/group_name_edit.dart';
import 'package:chat_app/ui/pages/profile/group_profile/settings/group_nick_name_edit.dart';
import 'package:chat_app/ui/pages/profile/group_profile/settings/group_public_edit.dart';
import 'package:chat_app/ui/pages/profile/group_profile/settings/group_rules_1_edit.dart';
import 'package:chat_app/ui/pages/profile/group_profile/settings/group_rules_2_edit.dart';
import 'package:chat_app/ui/pages/profile/group_profile/settings/group_rules_3_edit.dart';
import 'package:chat_app/ui/pages/profile/group_profile/settings/group_rules_4_edit.dart';
import 'package:chat_app/ui/pages/profile/group_profile/settings/group_tag_edit.dart';
import 'package:chat_app/ui/pages/profile/group_profile/settings/search_group_member.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/local_widgets/lebel.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/utils/setting_tile.dart';
import 'package:chat_app/util/constants.dart';
import 'package:chat_app/util/loading/loading.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';



class GroupSettings extends StatefulWidget {

  final UserModel user;
  final GroupModel group;
  GroupSettings({this.user, this.group});

  @override
  _GroupSettingsState createState() => _GroupSettingsState();
}

class _GroupSettingsState extends State<GroupSettings> {


  GroupMethods _groupMethods = GroupMethods();

  TextEditingController mTitle = TextEditingController();
  TextEditingController mText = TextEditingController();
  bool _postValid = false;
  bool _titleValid = false;
  bool _isUploading = false;

  String visibilityState = 'Public';
  String mAlbum = 'Album';
  String mCategory = 'Category';
  File file;
  String mImgStr64 = '';
  bool circularIndicator = false;



  pickImageForGroup({@required ImageSource source, @required int type}) async {
    Navigator.pop(context);
    ImageFileModel pifg = await _groupMethods.pickeImageGroup(source: source);

    setState(() {
      if(pifg != null) {
          mImgStr64 = "";
          file = null;
          mImgStr64 = pifg.imgString;
          file = pifg.file;
      }
    });
    if(file != null) {
      handleSubmit(type: type);
    }
  }



  handleSubmit({int type}) async{

      setState(() {
        _isUploading = true;
      });
      GroupModel gm = await _groupMethods.editBigGroupProfile(uid: widget.user.id.toString(),
          photo: mImgStr64, photoType: type,
          groupId: widget.group.id.toString()
      );
      setState(() {
        _isUploading = false;
        file = null;
        mImgStr64 = "";
      });
      Navigator.pop(context,gm);
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
                onPressed: () => pickImageForGroup(source: ImageSource.gallery, type: type),
              ),
              SimpleDialogOption(
                child: Text('Image Camera'),
                onPressed: () => pickImageForGroup(source: ImageSource.camera, type: type),
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



  profileInformationBuilder(BigGroupProvider _bg){
        return Column(
          children: [
            SizedBox(height: 20),
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
                      child: Image(
                        image: _bg.toGroup.cover != null ? NetworkImage(_bg.toGroup.cover) : AssetImage('assets/no_image.jpg'),
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
                          Text('Cover photo',
                            style: ftwhite12,
                          ),
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
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(150)),
                                  color: Colors.green,
                                  image: DecorationImage(
                                      image: _bg.toGroup.photo != null ? NetworkImage(_bg.toGroup.photo) : AssetImage('assets/no_image.jpg'),
                                      fit: BoxFit.cover
                                  ),
                                  border: Border.all(width: 2, color: Colors.white),
                                ),
                                child: Text(''),
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
                                  Text(
                                    'Profile',
                                    style: ftwhite12,
                                  ),
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

            SizedBox(
              height: 10,
            ),
            Container(
              child: file == null ? Text('${_bg.toGroup.name}') : Text("File uploaded",
                style: TextStyle(
                    color: Colors.green
                ),),
            ),
            SizedBox(
              height: 30,
            ),

            LabelText(text: "Announcement",),
            SettingsTile(label: !["",null, false, 0,"0"].contains(_bg.toGroup.announce) ? _bg.toGroup.announce : "", onPress: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) => GroupAnnounceEdit(id: _bg.toGroup.id.toString(), name: _bg.toGroup.announce)));
            }),

            LabelText(text: "Name",),
            SettingsTile(label: !["",null, false, 0,"0"].contains(_bg.toGroup.name) ? _bg.toGroup.name : "",onPress: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) => GroupNameEdit(id: _bg.toGroup.id.toString(), name: _bg.toGroup.name)));
            }),

            LabelText(text: "Location",),
            SettingsTile(label: !["",null, false, 0,"0"].contains(_bg.toGroup.location) ? _bg.toGroup.location : "",onPress: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) => GroupAddressEdit(id: _bg.toGroup.id.toString(), name: _bg.toGroup.location)));
            }),

            LabelText(text: "About",),
            SettingsTile(label: !["",null, false, 0,"0"].contains(_bg.toGroup.about) ? _bg.toGroup.about : "",onPress: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) => GroupAboutEdit(id: _bg.toGroup.id.toString(), name: _bg.toGroup.about)));
            }),


            LabelText(text: "Description",),
            SettingsTile(label: !["",null, false, 0,"0"].contains(_bg.toGroup.description) ? _bg.toGroup.description : "",onPress: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) => GroupDescripEdit(id: _bg.toGroup.id.toString(), name: _bg.toGroup.description)));
            }),

            LabelText(text: "Tag",),
            SettingsTile(label: !["",null, false, 0,"0"].contains(_bg.toGroup.tag) ? _bg.toGroup.tag : "",onPress: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) => GroupTagEdit(id: _bg.toGroup.id.toString(), name: _bg.toGroup.tag)));
            }),

            LabelText(text: "Language",),
            SettingsTile(label: !["",null, false, 0,"0"].contains(_bg.toGroup.language) ? _bg.toGroup.language : "",onPress: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) => GroupLanguageEdit(id: _bg.toGroup.id.toString(), name: _bg.toGroup.language)));
            }),

            LabelText(text: "Nick Name",),
            SettingsTile(label: !["",null, false, 0,"0"].contains(_bg.toGroup.nickName) ? _bg.toGroup.nickName : "",onPress: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) => GroupNickNameEdit(id: _bg.toGroup.id.toString(), name: _bg.toGroup.nickName)));
            }),

            LabelText(text: "Rules 1",),
            SettingsTile(label: !["",null, false, 0,"0"].contains(_bg.toGroup.rules1) ? _bg.toGroup.rules1 : "",onPress: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) => GroupRules1Edit(id: _bg.toGroup.id.toString(), name: _bg.toGroup.rules1)));
            }),

            LabelText(text: "Rules 2",),
            SettingsTile(label: !["",null, false, 0,"0"].contains(_bg.toGroup.rules2) ? _bg.toGroup.rules2 : "",onPress: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) => GroupRules2Edit(id: _bg.toGroup.id.toString(), name: _bg.toGroup.rules2)));
            }),

            LabelText(text: "Rules 3",),
            SettingsTile(label: !["",null, false, 0,"0"].contains(_bg.toGroup.rules3) ? _bg.toGroup.rules3 : "",onPress: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) => GroupRules3Edit(id: _bg.toGroup.id.toString(), name: _bg.toGroup.rules3)));
            }),

            LabelText(text: "Rules 4",),
            SettingsTile(label: !["",null, false, 0,"0"].contains(_bg.toGroup.rules4) ? _bg.toGroup.rules4 : "",onPress: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) => GroupRules4Edit(id: _bg.toGroup.id.toString(), name: _bg.toGroup.rules4)));
            }),

            // LabelText(text: "Group type",),
            // SettingsTile(label: _bg.toGroup.type,onPress: () async {
            //   Navigator.push(context, MaterialPageRoute(builder: (context) => GroupTypeEdit(id: _bg.toGroup.id.toString(), name: _bg.toGroup.type)));
            // }),

            LabelText(text: "Group public",),
            SettingsTile(label: _bg.toGroup.isPublic, onPress: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) => GroupPublicEdit(id: _bg.toGroup.id.toString(), name: _bg.toGroup.isPublic)));
            }),

            LabelText(text: "Group Transfer",),
            SettingsTile(label: "Transfer now", onPress: () async {
              _searchDialog(context);
              // Navigator.push(context, MaterialPageRoute(builder: (context) =>
              //     SearchUserFeed(id: _bg.toGroup.id.toString(), name: _bg.toGroup.isPublic)));
            }),
            LabelText(text: "Action to delete group",),
            SettingsTile(label: "Delete group", onPress: () async {
              _deleteDialog(context);
              // Navigator.push(context, MaterialPageRoute(builder: (context) =>
              //     SearchUserFeed(id: _bg.toGroup.id.toString(), name: _bg.toGroup.isPublic)));
            }),

            SizedBox(height: 50,),

          ],
        );

  }
  TextEditingController mTextController = TextEditingController();
  clearSearch() {
    mTextController.clear();
  }

  handleSearch(String result){
    UserProvider _u = Provider.of<UserProvider>(context, listen: false);
    Navigator.push(context, MaterialPageRoute(builder: (parentContext) => SearchGroupMember(query: mTextController.text, loggedUser: _u.user)));

  }
  handleSearch2(String result) async{
    UserProvider _u = Provider.of<UserProvider>(context, listen: false);
   await Navigator.push(context, MaterialPageRoute(builder: (parentContext) => SearchGroupMember(query: mTextController.text, loggedUser: _u.user)));
    Navigator.pop(context);
  }

  _searchDialog(parentContext,){
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title:  Center(
              child: Text(
                "Search user",
                style: fldarkgrey15,
              ),
            ) ,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                height: 35,
                child: TextFormField(
                  controller: mTextController..text,
                  style: fldarkgrey12,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide( color: Colors.amberAccent),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide( color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide( color: Colors.indigoAccent),
                    ),
                    hintText: 'Search user',
                    hintStyle: TextStyle(
                        fontSize: 10
                    ),
                    labelStyle: TextStyle(
                        fontSize: 10
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.grey,
                        size: 15,
                      ),
                      onPressed: clearSearch,
                    ),
                  ),
                  onFieldSubmitted: handleSearch,
                ),
              ),

              Container(
                width: 50,
                margin: EdgeInsets.all(10),
                child: ElevatedButton.icon(
                  onPressed: () => handleSearch2("hello"),
                  icon: Icon(Icons.search, size: 18),
                  label: Text("Search"),
                ),
              )


            ],
          );
        }
    );
  }

  _deleteDialog(parentContext,){
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title:  Center(
              child: Text(
                "Delete group",
                style: fldarkgrey15,
              ),
            ) ,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                height: 35,
                child: Text('Are you sure you want to delete the group?')
              ),

              Container(
                width: 50,
                margin: EdgeInsets.all(10),
                child: ElevatedButton.icon(
                  onPressed: () async {
                   String msg = await _groupMethods.groupDeleteById(groupId: widget.group.id.toString());
                   Fluttertoast.showToast(msg: msg);
                   GroupMethods().deleteGroup(groupId: widget.group.id.toString());
                   Navigator.push(context, MaterialPageRoute(builder: (context) => Index(user: widget.user,)));
                  },
                  icon: Icon(Icons.delete_forever, size: 18),
                  label: Text("Delete"),
                ),
              )
            ],
          );
        }
    );
  }




  @override
  Widget build(BuildContext context) {
    BigGroupProvider _bg = Provider.of<BigGroupProvider>(context, listen: true);

    return LoadingImage(
      inAsyncCall: _isUploading,
      child: Scaffold(
        backgroundColor: Color(0xffebecf0),
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
            //  onWillPop();
              Navigator.of(context).pop(true);
            },
          ),
          title: Text('Update group info'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: profileInformationBuilder(_bg),
          ),
        ),
      ),
    );
  }
}
