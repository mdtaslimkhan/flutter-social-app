
import 'dart:convert';
import 'dart:io';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/profile.dart';
import 'package:chat_app/ui/pages/widgets/progress.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:chat_app/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as Im;


class SpacePostCreate extends StatefulWidget {

  final UserModel user;
  final GroupModel group;
  SpacePostCreate({this.user, this.group});

  @override
  _SpacePostCreateState createState() => _SpacePostCreateState();
}

class _SpacePostCreateState extends State<SpacePostCreate> {
  final ImagePicker _picker = ImagePicker();
  TextEditingController mTitle = TextEditingController();
  TextEditingController mText = TextEditingController();
  bool _postValid = false;
  bool _titleValid = false;
  bool _isUploading = false;

  String visibilityState = 'Public';
  String mAlbum = 'Album';
  String mCategory = 'Category';
  XFile file;
  String mImgStr64 = '';


  // image from camera
  handleTakePhoto() async{
    Navigator.pop(context);
    XFile file = await _picker.pickImage(source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,
    );
    setState(() {
      this.file = file;
    });
  }

  // image from gallery
  handleChoseFromGallery() async{
    Navigator.pop(context);
    XFile file = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      this.file = file;
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


  // compress image before submit to database
  compressImage() async{
    // Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
    // // resize Image
    // Im.Image bSyncImg = Im.copyResize(imageFile, width: 700);
    // // compress image
    // String base64 = base64Encode(Im.encodeJpg(bSyncImg,quality: 85));

    // setState(() {
    //   mImgStr64 = base64;
    // });

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
          'post_type': '2',
          'group_id': widget.group.id.toString(),
        }
        );
    var str = jsonDecode(response.body);
    return true;

  }




  handleSubmit(BuildContext context) async{

    setState(() {
      mTitle.text.trim().length < 5 || mTitle.text.isEmpty ? _titleValid = false : _titleValid = true;
      mText.text.trim().length < 5 || mText.text.isEmpty ? _postValid = false : _postValid = true;
    });

    if(_postValid && _titleValid) {
      setState(() {
        _isUploading = true;
      });
      if(file != null) {
        await compressImage();
      }

      await submitPost();

      setState(() {
        _isUploading = false;
        file = null;
        _postValid = false;
        _titleValid = false;
      });

    }

    Navigator.pop(context);


  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, widget.user),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Column(
            children: [
              _isUploading ? linearProgressBar() : Text(''),
              SizedBox(height: 10),
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
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
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
                          image: AssetImage('assets/no_image.jpg'),
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
          onPressed: () {
            handleSubmit(context );
          },
        )
      ],
    );
  }










}




