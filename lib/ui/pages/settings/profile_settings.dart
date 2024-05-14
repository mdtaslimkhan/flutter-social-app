import 'dart:convert';
import 'dart:io';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/group/big_group/model/image_model.dart';
import 'package:chat_app/ui/group/big_group/model/image_process.dart';
import 'package:chat_app/ui/group/big_group/util/goup_methods.dart';
import 'package:chat_app/ui/pages/login/login_methods.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/local_widgets/lebel.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/model/name_model.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/profile_setting_widgets/about_edit.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/profile_setting_widgets/address_edit.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/profile_setting_widgets/date_edit.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/profile_setting_widgets/email_edit.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/profile_setting_widgets/gender_edit.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/profile_setting_widgets/name_edit.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/profile_setting_widgets/occupation_edit.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/profile_setting_widgets/phone_edit.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/utils/setting_tile.dart';
import 'package:chat_app/ui/pages/widgets/progress.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:chat_app/util/constants.dart';
import 'package:chat_app/util/loading/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;



class ProfileSettings extends StatefulWidget {

  final String userId;
  ProfileSettings({this.userId});

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {

  GroupMethods _groupMethods = GroupMethods();


  bool isUploading = false;
  bool _namevalid = true;
  bool _mGender = true;
  UserModel _userInfo;
  // date of birth update
  bool isNewBirth = false;

  DateTime selectedDate = DateTime.now();
  final ImagePicker _picker = ImagePicker();

  // image from camera
  handleTakePhoto() async{
    Navigator.pop(context);
   XFile file = await _picker.pickImage(source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,
    );

   var imgPath = File(file.path);

   setState(() {
     this.file = imgPath;
   });
  }

  // image from gallery
  handleChoseFromGallery() async{
    Navigator.pop(context);
    XFile file = await _picker.pickImage(source: ImageSource.gallery);
    var imgPath = File(file.path);
    setState(() {
      this.file = imgPath;
    });
  }

  bool _postValid = false;
  bool _titleValid = false;
  bool _isUploading = false;


  File file, file2;
  String mImgStr64, mImgStr642 = '';

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


  pickImageForGroup({@required ImageSource source, @required int type}) async {
    ImageFileModel pifg = await _groupMethods.pickeImageGroup(source: source);
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

    setState(() {
      isUploading = true;
    });

    Navigator.pop(context);

    if(type == 1){
      await uploadImage();
    }

    if(type == 2){
      await uploadImage2();
    }


    setState(() {
      isUploading = false;
      file = null;
    });


  }



  Future<UserModel> uploadImage() async {
      final String url = BaseUrl.baseUrl("updatePhoto");
      final response = await http.post(Uri.parse(url),
          headers: {'test-pass' : ApiRequest.mToken},
          body: {
        'id' : _userInfo.id.toString(),
        'photo_id' : mImgStr64,
          });

      Map data = jsonDecode(response.body);
      UserModel u = UserModel.fromJson(data['user']);
      if(response.statusCode == 200) {
        if(!data['error']) {
          return u;
        }else{
          return null;
        }
      }else{
        return null;
      }
  }


  Future<UserModel> uploadImage2() async {
    final String url = BaseUrl.baseUrl("updateCover");
    final response = await http.post(Uri.parse(url),
        headers: {'test-pass' : ApiRequest.mToken},
        body: {
          'id' : _userInfo.id.toString(),
          'cover' : mImgStr642,
        });

    Map data = jsonDecode(response.body);


    UserModel u = UserModel.fromJson(data['user']);
    if(response.statusCode == 200) {
      if(!data['error']) {
        return u;
      }else{
        return null;
      }
    }else{
      return null;
    }
  }





  Future getUserById(String uId) async {
    final String url = BaseUrl.baseUrl("requstUser/$uId");
    final http.Response rs = await http.get(Uri.parse(url),
        headers: { 'test-pass' : ApiRequest.mToken});
    Map data = jsonDecode(rs.body);
    return data;
  }


  String dateStr = "Select date of birth";
  String name = "Enter name";
  String gender = "Gender";
  String email = "Email";
  String occupation = "Occupation";
  String address = "Address";
  String about = "About";
  String phone = "Phone";
  int showPhone = 1;


  profileInformationBuilder(){
    return FutureBuilder(
      future: getUserById(widget.userId),
        builder: (context, snapshot) {
        if(!snapshot.hasData){
          return linearProgressBar();
        }

        UserModel u = UserModel.fromJson(snapshot.data);
        _userInfo = u;
        dateStr = u.birth;
        name = "${u.fName} ${u.nName}";
        email = u.email;
        occupation = u.occupation;
        address = u.address;
        about = u.about;
        phone = u.number;
        showPhone = u.showContact;

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
                        image:  u.cover != null ? NetworkImage(u.cover) : AssetImage('assets/no_image.jpg'),
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
                                      image: u.photo != null ? NetworkImage(u.photo) : AssetImage('assets/no_image.jpg'),
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
              child: file == null ? Text('${u.fName} ${u.nName}') : Text("File uploaded",
                style: TextStyle(
                    color: Colors.green
                ),),
            ),
            SizedBox(
              height: 30,
            ),

            LabelText(text: "Name",),
            SettingsTile(label: name,onPress: () async {
            NameModel nm = await Navigator.push(context, MaterialPageRoute(builder: (context) => NameEdit(userId: widget.userId, fName: u.fName, nName: u.nName)));
              setState(() {
                if(nm != null) {
                  name = '${nm.fName} ${nm.nName}';
                }
              });
            }),
            LabelText(text: "Birth",),
            SettingsTile(label: dateStr, onPress: () async {
             String date = await Navigator.push(context, MaterialPageRoute(builder: (context) => DateEdit(userId: widget.userId, date: u.birth)));
             setState(() {
               dateStr = date != null ? date : u.birth;
             });
            }),

            LabelText(text: "Gender",),
            SettingsTile(label: gender,onPress: () async {
             String gn = await Navigator.push(context, MaterialPageRoute(builder: (context) => GenderEdit(userId: widget.userId, gender: gender)));
              setState(() {
                gender = gn != null ? gn : u.gender;
              });
            }),

            LabelText(text: "Email",),
            SettingsTile(label: email,onPress: () async {
             String eml = await Navigator.push(context, MaterialPageRoute(builder: (context) => EmailEdit(userId: widget.userId,email: email)));
              setState(() {
                email = eml != null ? eml : u.email;
              });
            }),

            LabelText(text: "Occupation",),
            SettingsTile(label: "$occupation",onPress: () async {
             String oc = await Navigator.push(context, MaterialPageRoute(builder: (context) => OccupationEdit(userId: widget.userId, occupation: occupation,)));
              setState(() {
                occupation = oc != null ? oc : u.occupation;
              });
            }),

            LabelText(text: "Address",),
            SettingsTile(label: "$address",onPress: () async {
              String ad = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddressEdit(userId: widget.userId, address: address,)));
              setState(() {
                address = ad != null ? ad : u.address;
              });
            }),

            LabelText(text: "Phone",),
            SettingsTile(label: "$phone",onPress: () async {
              String ad = await Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneEdit(userId: widget.userId, showPhone: showPhone,)));
              setState(() {
                phone = ad != null ? ad : u.number;
              });
            }),

            LabelText(text: "About me",),
            SettingsTile(label: "$about",onPress: () async {
              String ad = await Navigator.push(context, MaterialPageRoute(builder: (context) => AboutEdit(userId: widget.userId, about: about,)));
              setState(() {
                about = ad != null ? ad : u.about;
              });
            }),

            LabelText(text: "Log out",),
            SettingsTile(label: "Logout",onPress: () async {
              _askePermissionForLogOut(context);
            }),

            SizedBox(height: 70,),

          ],
        );
        }
        
    );
  }

  _askePermissionForLogOut(BuildContext buildContext){
    return showDialog(
        context: buildContext,
        builder: (context){
          return SimpleDialog(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(height: 5,),
                    SizedBox(height: 20,),
                    Text("If you logout no longer you will be able to receive notification from the app.",style: fldarkHome16,),
                    Text("Are you sure?",style: fldarkgrey15,),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            icon: Text("Yes",style: TextStyle(
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.w900,
                                color: Colors.red,
                                fontSize: 16
                            )),
                            onPressed: () async  {
                              Navigator.pop(context);
                              // final aToken = await FacebookAuth.instance.accessToken;
                              // print("hello ghpk hskdfpwokin ");
                              // print(aToken);
                              // if(aToken != null){
                              //   await FacebookAuth.instance.logOut();
                              // }
                              LoginMethods().userClear(context);
                            }
                        ),
                        IconButton(
                          icon: Text("No",style: TextStyle(
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w900,
                              color: Colors.green,
                              fontSize: 16
                          )),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }








  Future<bool> onWillPop() {
    LoginMethods.refreshUserInfo(widget.userId, context);
   // return Future.value(true);
  }


  @override
  Widget build(BuildContext context) {
    return LoadingImage(
      inAsyncCall: isUploading,
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          backgroundColor: Color(0xffebecf0),
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                onWillPop();
              },
            ),
            title: Text('Update profile info'),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: profileInformationBuilder(),
            ),
          ),
        ),
      ),
    );
  }
}
