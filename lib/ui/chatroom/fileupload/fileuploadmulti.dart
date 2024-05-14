
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:chat_app/provider/file_upload_provider.dart';
import 'package:chat_app/ui/chatroom/chatmethods/chatmethods_big_group.dart';
import 'package:chat_app/ui/chatroom/chatmethods/chatmethods_personal.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

final _fireStore = FirebaseFirestore.instance;

class FileUploadMethods{
  CancelToken _cancelToken = CancelToken();

  Response response;
  Dio dio = new Dio();
  final ChatMethodsBigGroup _chatMethodsBigGroup = ChatMethodsBigGroup();
  final ChatMethodsPersonal _chatMethodsPersonal = ChatMethodsPersonal();
  final ImagePicker _picker = ImagePicker();

  // files uploaded options
  Future getAttachmentAndUpload({String receiverId, String senderId, String name, String userPhoto,
    String chatType, FileUploadProvider fileUploadProvider, int role, BuildContext context}) async {

    var rng = new Random();
    String randomName="";
    for (var i = 0; i < 20; i++) {
      randomName += rng.nextInt(100).toString();
    }
    FilePickerResult file = (await FilePicker.platform.pickFiles(
        allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['mp3', 'pdf', 'doc','aac','arc','azw','bin','bmp','bz2','csh','css','csv','eot','epub',
      'gz','gif','htm','html','ico','ics','jar','jpeg','jpg','docx','mid','midi','odp','ods','odt','oga','png',
      'php','ppt','pptx','rar','rtf','sh','svg','swf','tar','tif','tiff','ts','ttf','txt','vsd','wav','weba',
      'webp','woff','woff2','xhtml','xls','xlsx','xml','xul','zip','apk','7z','exe','aab','psd'],
    )

    );

    // type: FileType.custom, allowedExtensions: ['pdf','doc','jpg', 'mp4'],));
    // savePdf(file, receiverId, senderId);
    // brake operation if file null
    if(file == null) return;
    anyFileSaveToServer(file, receiverId, senderId, name, userPhoto, chatType, fileUploadProvider, role, context);
  }


  // multiple file picker and loop these
  Future anyFileSaveToServer(FilePickerResult result, receiverId, senderId, name, userPhoto, chatType, fp, role, context) async {
    var fList = result.files.map((path) => path).toList();
    for(var i = 0; i < fList.length; i++) {
      File file = File(fList[i].path);
      String mimeStr = file.toString();
      String ext = p.extension(mimeStr);
      final size = await getVideoSize(file);
      if(size < 20000000) {
        uploadFile(file: file,
            receiverId: receiverId,
            senderId: senderId,
            fileType: ext,
            name: name,
            userPhoto: userPhoto,
            chatType: chatType,
            fp: fp,
            role: role);
      }else{
        showSizeAprovalDialog(context);
      }
    }
  }

  // pick gallery image, video , camera image, and upload to server
  pickFile({ImageSource source, String receiverId, String senderId, String name, String userPhoto,
    String chatType, FileUploadProvider fp, int fileType, int role, BuildContext context}) async {
    XFile selectedFile;
    if(fileType == 1) {
      selectedFile = await _picker.pickVideo(source: source);
    }else{
      selectedFile = await _picker.pickImage(source: source);
    }

    if(selectedFile != null && selectedFile.path != null) {
      File file = File(selectedFile.path);
      final size = await getVideoSize(file);
      print("file size ");
      print(size);
      if(size < 20000000) {
        String mimeStr = file.toString();
        String ext = p.extension(mimeStr);
        uploadFile(file: file,
            receiverId: receiverId,
            senderId: senderId,
            fileType: ext,
            name: name,
            userPhoto: userPhoto,
            chatType: chatType,
            fp: fp,
            role: role
        );
      }else{
        showSizeAprovalDialog(context);
      }
    }
  }

  getVideoSize(File videoFile) async {
    final size = await videoFile.length();
    return size;
  }

  showSizeAprovalDialog(BuildContext context){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 14,),
                  Text("You can not send file size more than 20 Mb", style: fldarkgrey15,),
                  SizedBox(height: 24,),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Ok"))
                ],
              ),
            ),
          );
        }
    );
  }

  String id;
  uploadFile({String fileSource, File file, String receiverId, String senderId, String fileType, String name, userPhoto, String chatType, FileUploadProvider fp, int role}) async {
    var timeStamp = Timestamp.now();
    if(chatType == USER_BIG_GROUP) {
     id = await _chatMethodsBigGroup.sendBigGroupFile(
          url: "",
          fromUserId: receiverId,
          groupId: senderId,
          msgText: "Loader",
          type: "loader",
          name: name,
          photo: userPhoto,
          role: role,
          fileSource: fileSource
     );
    }else if(chatType == USER_PERSONAL){
      _chatMethodsPersonal.setImageMessage(timeStamp, "", receiverId, senderId, "loader", "loader");
    }

    FormData formdata = FormData.fromMap({
      "file": await MultipartFile.fromFile(
          file.path.toString(),
          filename: p.basename(file.path.toString())
        //show only filename from path
      ),
    });

    dio.options.headers["test-pass"] = ApiRequest.mToken;
    response = await dio.post(BaseUrl.baseUrl("mUploadFile"),
      cancelToken: _cancelToken,
      data: formdata,
      onSendProgress: (int sent, int total) {
      if(chatType == USER_BIG_GROUP) {
        fp.setUploadSendStatus(state: sent / total);
        fp.setUploadLayer(show: true);
        if (sent / total >= 1.0) {
          fp.setUploadLayer(show: false);
        }
      }else if(chatType == USER_PERSONAL){
        fp.setUploadSendStatusPersonal(state: sent / total);
        fp.setUploadLayerPersonal(show: true);
        if (sent / total >= 1.0) {
          fp.setUploadLayerPersonal(show: false);
        }
      }

      },
      onReceiveProgress: (int rec, int rc){
        print('on send progress $rec dif $rc');
      }
    );
    if(response.statusCode == 200){

      Map data = jsonDecode(response.toString());
      var file = data["fileName"];
      var url = data["url"];
      var ftype = "file";
      if(fileType == ".jpg'" || fileType == ".png'" || fileType == ".jpeg'"){
        ftype = "image";
      }else if(fileType == ".mp4'" || fileType == ".mpeg'" || fileType == ".webm'" || fileType == ".ogg'"
          || fileType == ".avi'" || fileType == ".mpg'") {
        ftype = "video";
      }else if(fileType == ".aac'" || fileType == ".mp3'" || fileType == ".wma'" || fileType == ".wav'"){
        ftype = "audio";
      }

      if(chatType == USER_BIG_GROUP) {
        _chatMethodsBigGroup.sendBigGroupFileUpdate(
            id: id,
            url: url,
            fromUserId: receiverId,
            groupId: senderId,
            msgText: ftype,
            type: ftype,);
      }else if(chatType == USER_PERSONAL){
        _chatMethodsPersonal.setImageMessageUpdate(timeStamp, url, receiverId, senderId, ftype, ftype);
      }
    }else{
    }
  }


  stopDownload(FileUploadProvider _fp,String senderId) async{
    if(_cancelToken != null)
      _cancelToken.cancel();
    _fp.setUploadLayer(show: false);
    await _fireStore.collection(BIG_GROUP_MESSAGE_COLLECTION)
        .doc(senderId)
        .collection("messages")
        .doc(id)
        .delete();
  }

}