

import 'dart:io';

import 'package:chat_app/ui/chatroom/fileupload/fileuploadmulti.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

import '../../../provider/file_upload_provider.dart';
import 'package:path/path.dart' as p;


class TrimController{

 // final Trimmer _trimmer = Trimmer();
  final ImagePicker _picker = ImagePicker();
  final FileUploadMethods _fileUploadMethods = FileUploadMethods();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  double videoLength = 15.0;
  String audioFile = "";



  // pick gallery image, video , camera image, and upload to server
  pickFileVideo({ImageSource source, String receiverId, String senderId, String name, String userPhoto,
    String chatType, FileUploadProvider fp, int fileType, int role}) async {
    XFile selectedFile;
    if(fileType == 1) {
      selectedFile = await _picker.pickVideo(source: source);
    }else{
      selectedFile = await _picker.pickImage(source: source);
    }
    if(selectedFile != null && selectedFile.path != null) {
      File file = File(selectedFile.path);
      if(file != null){
        // Navigator.of(scaffoldKey.currentContext).push(
        //   MaterialPageRoute(builder: (context) {
        //     return TrimVideo(
        //       trimmer: _trimmer,
        //       onVideoSaved: (output) async {
        //         print("=====================================>>>>>>>>>>>>>>>>>>>> output path");
        //         print(output);
        //
        //       },
        //       onSkip: () async {
        //         Navigator.pop(context);
        //
        //       },
        //       maxLength: videoLength,
        //       sound: audioFile,
        //       showSkip: false,
        //     );
        //   }),
        // );
      }
      String mimeStr = file.toString();
      String ext = p.extension(mimeStr);
      print("file extention ================================== >>>>>>>>>>>>>>>>>>.");
      print(ext);
      _fileUploadMethods.uploadFile(file: file,
          receiverId: receiverId,
          senderId: senderId,
          fileType: ext,
          name: name,
          userPhoto: userPhoto,
          chatType: chatType,
          fp: fp,
          role: role
      );
    }
  }


}