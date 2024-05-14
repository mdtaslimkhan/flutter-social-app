
import 'dart:io';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/provider/file_upload_provider.dart';
import 'package:chat_app/ui/chatroom/fileupload/fileuploadmulti.dart';
import 'package:chat_app/util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as p;

class SoundRecorderPersonal{

  final FileUploadMethods _fileUploadMethods = FileUploadMethods();


  FlutterSoundRecorder _audioRecorder;
  bool isRecoderInitialized = false;
  String uploadFileName = randNum  + ".aac";


  bool get isRecodring =>  _audioRecorder.isRecording;



  void init() async {


    _audioRecorder = FlutterSoundRecorder();
    Map<Permission, PermissionStatus> ps = await [
      Permission.microphone,
    ].request();

   await _audioRecorder.openAudioSession();
    isRecoderInitialized = true;
  }

  void dispose() {
    _audioRecorder.closeAudioSession();
    _audioRecorder = null;
    isRecoderInitialized = false;
  }


  Future _startRecord() {
    if(_audioRecorder != null) {
      _audioRecorder.startRecorder(toFile: uploadFileName);
    }
  }

  Future _stopRecord({String rootDir, String senderId, UserModel user, String chatType, FileUploadProvider fp}) async{
    if(_audioRecorder != null) {
      await  _audioRecorder.stopRecorder();
    }
    String path = rootDir + "/cache/" + uploadFileName;
    File file = File(path);
    String mimeStr = file.toString();
    String ext = p.extension(mimeStr);
    _fileUploadMethods.uploadFile(
        fileSource: "voice",
        file: file,
        receiverId: user.id.toString(),
        senderId: senderId,
        fileType: ext,
        name: user.fName + " "+ user.nName ,
        userPhoto: user.photo,
        chatType: chatType,
        fp: fp,
    );
  }

  Future toggleRecording({String rootDir, String senderId, UserModel user, String chatType, FileUploadProvider fp, AudioProviderPersonal ap}) async {
    if(_audioRecorder != null) {
      if(_audioRecorder.isStopped){
        await _startRecord();
        ap.setIsRecordingState(isRecording: true);
      }else{
        await _stopRecord(rootDir: rootDir, senderId: senderId, user: user, chatType: chatType, fp: fp,);
        ap.setIsRecordingState(isRecording: false);
      }
    }
  }


}


class AudioProviderPersonal extends ChangeNotifier{

  bool _isRecording = false;
  bool get isRecodring =>  _isRecording;

  setIsRecordingState({bool isRecording}){
    _isRecording = isRecording;
    notifyListeners();
  }

}
