
import 'dart:convert';
import 'dart:io';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/pages/post/post_create_utils.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/profile.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:chat_app/util/constants.dart';
import 'package:chat_app/util/loading/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as Im;


class PostCreate extends StatefulWidget {

  final UserModel user;
  PostCreate({this.user});

  @override
  _PostCreateState createState() => _PostCreateState();
}

class _PostCreateState extends State<PostCreate> {
  final ImagePicker _picker = ImagePicker();
  TextEditingController mTitle = TextEditingController();
  TextEditingController mText = TextEditingController();
  bool _postValid = false;
  bool _titleValid = false;
  bool isUploading = false;

  String visibilityState = 'Public';
  String mAlbum = 'Album';
  String mCategory = 'Category';
  File file;
  String mImgStr64 = '';


  // image from camera
  handleTakePhoto() async{
    Navigator.pop(context);
    XFile file = await _picker.pickImage(source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,
    );
    setState(() {
      this.file = File(file.path);
    });
  }

  // image from gallery
  handleChoseFromGallery() async{
    Navigator.pop(context);
    XFile file = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      this.file = File(file.path);
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


  // image picker dialog
  selectImage(parentContext){
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              "Select post image",
              style: fldarkgrey15,
            ),
            children: [
              SimpleDialogOption(
                child: Text("Photo with camera"),
                onPressed: handleTakePhoto,
              ),
              SimpleDialogOption(
                child: Text("Image from gallery"),
                onPressed: handleChoseFromGallery,
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



  Future<bool> submitPost() async {
    final String url = BaseUrl.baseUrl("createPost");
    final http.Response response = await http.post(Uri.parse(url),
        headers: {'test-pass' : ApiRequest.mToken},
        body: {
          'user_id' : widget.user.id.toString(),
          'title' : mTitle.text,
          'photo' : mImgStr64,
          'description': mText.text,
          'post_type': "1",
        }
        );
    if(response.statusCode == 200) {
      var str = jsonDecode(response.body);
      if(!str['error']){

      }else{
        print("Post creation failed");
      }
    }else{

    }
    return true;

  }


  handleSubmit(BuildContext context) async{

    setState(() {
      mTitle.text.trim().length < 5 || mTitle.text.isEmpty ? _titleValid = false : _titleValid = true;
      mText.text.trim().length < 5 || mText.text.isEmpty ? _postValid = false : _postValid = true;
    });

    if(_postValid == true && _titleValid == true && file != null) {
      setState(() {
        isUploading = true;
      });

      if(file != null) {
       String img = await compressImage(file: file);
       setState(() {
         mImgStr64 = img;
       });
      }

      await submitPost();

      setState(() {
        isUploading = false;
        file = null;
        _postValid = false;
        _titleValid = false;
      });

      Navigator.of(context).pushReplacementNamed('/viewProfile', arguments: {'userId': widget.user.id.toString(), 'currentUser': widget.user });

    }
  }




  @override
  Widget build(BuildContext context) {
    return LoadingImage(
      inAsyncCall: isUploading,
      child: Scaffold(
        appBar: header(context, widget.user),
        body: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Column(
              children: [
                SizedBox(height: 20),
                // rich text box
                Row(
                  children: [
                    GestureDetector(
                      child:Container(
                        margin: EdgeInsets.only(left: 10),
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: Color(0xff7c94b6),
                          image: DecorationImage(
                            image: NetworkImage(widget.user.photo),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(new Radius.circular(50.0)),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: Offset(0, 1), // changes position of shadow
                            ),

                          ],
                        ),

                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(userId: widget.user?.id.toString())));
                      },
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 15),
                          child: Text(
                            "${widget.user.nName}",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(width: 5),
                            DropdownItem(
                              onChange: (String newValue) {
                                setState(() {
                                  visibilityState = newValue;
                                });
                              },
                              value: visibilityState,
                              listItem: <String>['Public', 'Private','Friends'],
                              icon: FontAwesome.globe,
                            ),
                            DropdownItem(
                              onChange: (String newValue) {
                                setState(() {
                                  mAlbum = newValue;
                                });
                              },
                              value: mAlbum,
                              listItem: <String>['Album', 'Bangla'],
                              icon: Icons.photo,
                            ),
                            DropdownItem(
                              onChange: (String newValue) {
                                setState(() {
                                  mCategory = newValue;
                                });
                              },
                              value: mCategory,
                              listItem: <String>['Category', 'News'],
                              icon: Icons.share,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 0),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(
                    controller: mTitle,
                    decoration: ftcustomInputDecoration.copyWith(
                      hintText: "Post title..."
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(
                    controller: mText,
                  maxLines: 8,
                    decoration: ftcustomInputDecoration.copyWith(
                        hintText: "Post body text...",
                        suffix:  IconButton(
                          icon: Icon(
                            Icons.image,
                            color: Colors.grey,
                            size: 25,
                          ),
                          onPressed: () => selectImage(context),
                        ),
                    ),
                ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () => selectImage(context),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .9,
                    height: 220,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 16,
                          offset: Offset(0,3),
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: -1,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          width: MediaQuery.of(context).size.width,
                          height: 250,
                          child: Image(
                            image: file != null ? FileImage(file) : AssetImage('assets/no_image.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          width: 20,
                          bottom: 10,
                          left: 35,
                          child: GestureDetector(
                            child: Icon(
                              Icons.camera_alt,
                            ),
                            //  onTap: () => selectImage(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }



  AppBar header(BuildContext context, UserModel userName){



    return AppBar(
      iconTheme: IconThemeData(
          color: Colors.grey
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))
      ),
      backgroundColor: Theme.of(context).primaryColor,
      title: Center(
        child: Text(
            'Create post',
        ),
      ),
      actions: [
        TextButton(
          child: Text(
              'POST',
            style: TextStyle(
              color: Colors.white
            ),
          ),
          onPressed: () async {
           await handleSubmit(context);
           // Navigator.pop(context);
          },
        )
      ],
    );
  }










}




