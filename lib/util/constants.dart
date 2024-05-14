import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart' as Im;

const String APP_VERSION = "1.1.2";
const String CALL_COLLECTION = "call";
const String MEMBERS_COLLECTION = "members";
const String MESSAGE_COLLECTION = "messages";
const String GROUP_COLLECTION = "groups";
const String BIG_GROUP_COLLECTION = "bigGroups";
const String GROUP_MESSAGE_COLLECTION = "groupMessage";
const String BIG_GROUP_MESSAGE_COLLECTION = "bigGroupMessage";
const String CONTACTS_COLLECTION = "contacts";
const String CONTACT_COLLECTION = "contact";
const String CONTACT_GROUP_COLLECTION = "groupContacts";
const String USER_PERSONAL  = "1";
const String USER_GROUP  = "2";
const String USER_BIG_GROUP  = "3";
const String APP_ASSETS_URL = "http://quickchatting.gumoti.com/images/application/assets";



String randNum = Random().nextInt(1000000000).toString();


String formatTimestamp(int timestamp) {
  var format = new DateFormat('d MMM, hh:mm a');
  var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  return format.format(date);
}

String checkNull(String data){
  if(data == null)
    return '';
  return data;
}

int checkNullInt(int data){
  if(data == null)
    return 0;
  return data;
}

bool checkNullBool(bool data){
  if(data == null)
    return false;
  return data ;
}

String letterLimit(String str){
  if(['',null,'null'].contains(str))
    return '';
  if(str.length > 25)
  return str.substring(0, 25);
  return str;
}

String wordLimit(String str){
  if(['',null,'null'].contains(str))
    return '';
  if(str.length > 100)
    return str.substring(0, 100);
  return str;
}

String customFormat(var time){
  var mTime;
  if(time != null){
    var t = Timestamp.now();
    var tm = t.toDate();
    var dif = tm.difference(time.toDate()).inDays;
    if(dif < 1) {
      mTime = DateFormat("hh:mm a").format(time.toDate());
    }else {
      mTime = DateFormat("hh:mm a dd/MM/yy").format(time.toDate());
    }
    return mTime;
  }else{
    return "";
  }

 }

 String mView({int count}){
   double result = 0;
    if(count < 999){
      result = count.toDouble();
      return result.toStringAsFixed(0);
    }else if(count > 999 && count < 999999) {
      result = count / 1000;
      return result.toStringAsFixed(1) + "K";
    }else if(count > 999999 && count < 999999999){
      result = count / 1000000;
      return result.toStringAsFixed(1) + "M";
    }else if(count > 999999999){
      result = count / 1000000000;
      return result.toStringAsFixed(1) + "B";
    }
    return result.toStringAsFixed(0);
 }



getFileExtention(String str){
  if(str == null)
    return '';
  return p.extension(str);
}


TextSpan EmojiText({String text, double fontSize, Color color}) {
  final children = <TextSpan>[];
  final runes = text.runes;

  for (int i = 0; i < runes.length; /* empty */) {
    int current = runes.elementAt(i);
    // we assume that everything that is not
    // in Extended-ASCII set is an emoji...
    final isEmoji = current > 255;
    final shouldBreak = isEmoji ? (x) => x <= 255 : (x) => x > 255;

    final chunk = <int>[];
    while (!shouldBreak(current)) {
      chunk.add(current);
      if (++i >= runes.length) break;
      current = runes.elementAt(i);
    }

    children.add(
      TextSpan(
        text: String.fromCharCodes(chunk),
        style: TextStyle(
          fontSize: fontSize,
          color: color,
          fontFamily: isEmoji ? '' : null,
          fontWeight: FontWeight.w700
        ),
      ),
    );
  }

  return TextSpan(children: children);
}


// cached filde move to downlaod folder
downloadFilePermanently(String url,String destinationDir, String file) async {
  File _file = File(url);
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
  final String path = await getPathToDownload();
  await Directory(path+"/"+destinationDir).create(recursive: true);
  await _file.copy(path+"/"+destinationDir+file);
  Fluttertoast.showToast(msg: "File downloaded");
}

Future<String> getPathToDownload() async {
  var path = await ExternalPath.getExternalStoragePublicDirectory(
      ExternalPath.DIRECTORY_DOWNLOADS);
 // var path;
  return path;
}




// compress image before submit to database
Future<String> compressImage({File file}) async{
  try {
    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
    // resize Image
    Im.Image bSyncImg = Im.copyResize(imageFile, width: 700);
    // compress image
    String base64 = base64Encode(Im.encodeJpg(bSyncImg, quality: 85));
    return base64;
  }catch(e){
  }
}




// text color

const textColor = Color(0xff575757);
const headingColor = Color(0xff474747);

 const mainBg = Color(0xFFFFFFFF);
// button design color set
 const btnBg = Color(0xFFECF3FC);
 const btnBorder = Color(0xFFF3F3F3);
 const btnShadow = Color(0xFFF3F3F3);

 const boxBg = Color(0xFFFFFFFF);


 // label = l, style = s, dark = d, font = f,
const flcolorBlue = Color(0xff2066D0);


const fldarkHome16 = TextStyle(
  fontSize: 16,
  color: Color.fromRGBO(90,90,90,1),
    fontWeight: FontWeight.w900,
    fontFamily: 'Roboto'
);


const fldarkgrey18 = TextStyle(
  fontSize: 18,
  color: Color(0xff393939),
    fontWeight: FontWeight.w700,
    fontFamily: 'Segoe'
);

const fldarkgrey15 = TextStyle(
  fontSize: 15,
  color: Color(0xff393939),
  fontWeight: FontWeight.w900,
  fontFamily: 'Roboto'
);

const fl20bold = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w900,
    fontFamily: 'Roboto'
);

const fldarkgrey12 = TextStyle(
  fontSize: 12,
  color: textColor,
    fontWeight: FontWeight.w700,
    fontFamily: 'Roboto'
);

const fldarkgreyLight12 = TextStyle(
    fontSize: 12,
    color: Color(0xff393939),
    fontWeight: FontWeight.w600,
    fontFamily: 'Segoe'
);

const flvilate10 = TextStyle(
  fontSize: 10,
  color: Color(0xff96a3e7),
    fontWeight: FontWeight.w900,
    fontFamily: 'Roboto'
);

const ftblack8 = TextStyle(
  fontSize: 8,
  color: Colors.black,
    fontWeight: FontWeight.w900,
    fontFamily: 'Roboto'
);

const fldarkgrey20 = TextStyle(
  fontSize: 20,
  color: Color(0xff393939),
    fontWeight: FontWeight.w300,
    fontFamily: 'Roboto'
);

const fldarkgrey22 = TextStyle(
  fontSize: 22,
  color: Color(0xff393939),
    fontWeight: FontWeight.w300,
    fontFamily: 'Roboto'
);

const fldarkgrey10 = TextStyle(
  fontSize: 10,
  color: Color(0xff393939),
    fontWeight: FontWeight.w900,
    fontFamily: 'Roboto'
);

const fldarkgrey8 = TextStyle(
  fontSize: 8,
  color: Color(0xff393939),
    fontWeight: FontWeight.w900,
    fontFamily: 'Roboto'
);


const flwhite8 = TextStyle(
  fontSize: 8,
  color: Color(0xffffffff),
    fontWeight: FontWeight.w400,
    fontFamily: 'Calibri'
);

const ftwhite10 = TextStyle(
  fontSize: 10,
  color: Color(0xffffffff),
    fontWeight: FontWeight.w400,
    fontFamily: 'Calibri'
);

const ftwhite12 = TextStyle(
  fontSize: 12,
  color: Color(0xffffffff),
    fontWeight: FontWeight.w400,
    fontFamily: 'Calibri'
);

const ftwhite14 = TextStyle(
  fontSize: 14,
  color: Color(0xffffffff),
    fontWeight: FontWeight.w400,
    fontFamily: 'Calibri'
);

const ftwhite15 = TextStyle(
    fontSize: 15,
    color: Colors.white,
    fontWeight: FontWeight.w400,
    fontFamily: 'Calibri'
);

const ftwhite18 = TextStyle(
  fontSize: 18,
  color: Color(0xffffffff),
    fontWeight: FontWeight.w400,
    fontFamily: 'Calibri'
);


const ftwhite20 = TextStyle(
  fontSize: 20,
  color: Color(0xffffffff),
  fontWeight: FontWeight.bold
);

const postTitleWhite = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: 'Segoe'
);

const postTitleBlack = TextStyle(
    color: Colors.black87,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: 'Segoe'
);

const postDescWhite = TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    fontFamily: 'Segoe'
);

const postDescBlack = TextStyle(
    color: Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    fontFamily: 'Segoe'
);


const homePageTopImageBg = BoxDecoration(
    image: DecorationImage(
        image: AssetImage('assets/profile/bg.png'),
        fit: BoxFit.cover,
        alignment: Alignment.bottomCenter
    ),
    borderRadius: BorderRadius.vertical(bottom: Radius.circular(250))
);

const ftcustomInputDecoration = InputDecoration(
  hintText: "Enter your username...",
  hintStyle: TextStyle(
    fontSize: 12
  ),
  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
  enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      borderSide: BorderSide(color:  Colors.grey, width: 2)
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(15)),
    borderSide: BorderSide(color: Colors.blue, width: 2),
  ),
);


// Personal profile color profile
const pTextColor = Color(0xFF323232);
const pBodyColor = Color(0xFFFFFFFF);


