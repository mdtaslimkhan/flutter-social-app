
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:chat_app/ui/chatroom/chatmethods/chatmethods_big_group.dart';
import 'package:chat_app/ui/chatroom/chatmethods/chatmethods_personal.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:chat_app/util/constants.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as p;

import '../../../provider/file_upload_provider.dart';

class SingleFileUploadMethods{

  Response response;
  Dio dio = new Dio();
  final ChatMethodsBigGroup _chatMethodsBigGroup = ChatMethodsBigGroup();

  CancelToken _cancelToken = CancelToken();

  // files uploaded options
  Future getAttachmentAndUpload({String receiverId, String senderId, String name, String userPhoto, String chatType, FileUploadProvider fileUploadProvider}) async {

    var rng = new Random();
    String randomName="";
    for (var i = 0; i < 20; i++) {
      randomName += rng.nextInt(100).toString();
    }
    FilePickerResult file = (await FilePicker.platform.pickFiles(
     type: FileType.custom, allowedExtensions: ['mp3','aac','amr','ogg','wav']));
   String url = await anyFileSaveToServer(file, receiverId, senderId, name, userPhoto, chatType, fileUploadProvider);
   return url;
  }


  Future anyFileSaveToServer(result, receiverId, senderId, name, userPhoto, chatType, fp) async {
    var files = result.paths.map((path) => File(path)).toList();
      String mimeStr = files[0].toString();
      String ext = p.extension(mimeStr);
    String url = await uploadFile(file: files[0], receiverId: receiverId, senderId: senderId, fileType: ext, name: name , userPhoto: userPhoto, chatType: chatType, fp: fp);
    return url;
  }

  uploadFile({File file, String receiverId, String senderId, String fileType, String name, userPhoto, String chatType, FileUploadProvider fp}) async {
    FormData formdata = FormData.fromMap({
      "file": await MultipartFile.fromFile(
          file.path.toString(),
          filename: p.basename(file.path.toString())
        //show only filename from path
      ),
    });

    dio.options.headers["test-pass"] = ApiRequest.mToken;
    response = await dio.post(BaseUrl.baseUrl("mUploadFileSingle"),
      cancelToken: _cancelToken,
      data: formdata,
      onSendProgress: (int sent, int total) {
        fp.setUploadSendStatusAudio(state: sent / total);
        fp.setUploadLayerAudio(show: true);
        if(sent / total >= 1.0) {
          fp.setUploadLayerAudio(show: false);
        }
      },
    );
    if(response.statusCode == 200){

      Map data = jsonDecode(response.toString());
      var file = data["fileName"];
      var url = data["url"];


      return url;
    }

    return null;


  }
  stopDownload(){
    if(_cancelToken != null)
    _cancelToken.cancel();
    print('code workded');
  }


}