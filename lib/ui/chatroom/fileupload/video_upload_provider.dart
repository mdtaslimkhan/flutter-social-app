import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../../../provider/file_upload_provider.dart';

class VideoUploadProvider extends ChangeNotifier{


  VideoUploadModel _vModel;
  VideoUploadModel get videoModel => _vModel;

  setVideoModel({VideoUploadModel videoModel}){
    _vModel = videoModel;
    notifyListeners();
  }

}


class VideoUploadModel{
  File file;
  String receiverId;
  String senderId;
  int fileType;
  String name;
  String userPhoto;
  String chatType;
  FileUploadProvider fp;
  int role;
  VideoUploadModel({this.file, this.receiverId, this.senderId, this.fileType,
    this.name, this.userPhoto, this.chatType, this.fp, this.role});


}