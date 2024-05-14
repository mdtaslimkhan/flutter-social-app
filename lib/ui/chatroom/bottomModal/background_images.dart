import 'dart:convert';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/chatroom/function/voice_room_methods.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:chat_app/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class BackgroundImagesWidget extends StatefulWidget {

  final UserModel from;
  final String toGroupId;
  BackgroundImagesWidget({this.from,this.toGroupId});

  @override
  State<BackgroundImagesWidget> createState() => _BackgroundImagesWidgetState();
}

class _BackgroundImagesWidgetState extends State<BackgroundImagesWidget> {

  List<BackgroundImage> bimage;
  final VoiceRoomMethods roomMethods = VoiceRoomMethods();

  @override
  void initState() {
    getBackgroundImage();
    super.initState();
  }

  getBackgroundImage() async{
    List<BackgroundImage> bm = await BackgroundImageLoad.getBackgroundImages();
    print(bm);
    if(bm.length > 0) {
      setState(() {
        bimage = bm;
      });
    }

  }



  @override
  Widget build(BuildContext context) {
    return bimage != null && bimage.length > 0 ?
     Container(
       margin: EdgeInsets.only(top: 20),
       child: Wrap(
            direction: Axis.horizontal,
            runSpacing: 10,
            children: bimage.map((BackgroundImage bg) => GestureDetector(
              child: Container(
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width / 4,
                      child: Column(
                        children: [
                          cachedNetworkImg(context, bg.image),
                          Text("${bg.title}"),
                        ],
                      )
                  ),
              onTap: () => setBackground(bg),
            ),
            ).toList(),
          ),
     ) : Center(child: CircularProgressIndicator());
  }

  setBackground(BackgroundImage bg) {
    roomMethods.setBackgroundImage(groupId: widget.toGroupId, user: widget.from, bg: bg.image);
    Navigator.of(context).pop();
    print(bg.image);
  }




}


Widget background({var dt, BuildContext context}){
  Color otherColor;
  if(dt != null && dt["color"] != null) {
    int value = int.parse(dt["color"], radix: 16);
     otherColor = new Color(value);
  }
  return Stack(
    children: [
      Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: dt != null && dt["bg"] != null ? cachedNetworkImg(context, dt["bg"]) : Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/big_group/voice_room_bg.jpg"),
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(Colors.black.withOpacity(1), BlendMode.dstATop),
              ),
            ),
          )
      ),
      Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: otherColor != null ? Container(
            color: otherColor,
          ) : Container()
      ),

    ],
  );
}


class BackgroundImageLoad{
  static Future<List<BackgroundImage>> getBackgroundImages() async {
    List<BackgroundImage> images;
    final String apiUrl = BaseUrl.baseUrl("backgrounds");
    final response = await http.get(Uri.parse(apiUrl),
        headers: {'test-pass' : ApiRequest.mToken});
    Map data = jsonDecode(response.body);
    var u = data['images'] as List;

    images = u.map<BackgroundImage>((bi) => BackgroundImage.fromMap(bi)).toList();

    if(response.statusCode == 200) {
      if(!data['error']) {
        return images;
      }else{
        return null;
      }
    }else{
      return null;
    }
  }

}

class BackgroundImage{
  final String image;
  final String title;
  final String created_at;
  BackgroundImage({this.image,this.title, this.created_at});

 factory BackgroundImage.fromMap(Map<String , dynamic> map) => BackgroundImage(
    image: map["image"],
    title: map['title'],
   created_at: map['created_at']
  );

}


