
import 'dart:io';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/chatroom/model/message_model.dart';
import 'package:chat_app/ui/chatroom/widgets/name_admin_owner.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';

final _fireStore = FirebaseFirestore.instance;

class ChatFileWidget extends StatefulWidget {

  final bool isMe;
  final String docId;
  final UserModel loggedUser;
  final GroupModel group;
  final MessageModel msg;
  ChatFileWidget({
    this.isMe,
    this.docId,
    this.loggedUser,
    this.group,
    this.msg,
    Key key
  }) : super(key: key);

  @override
  State<ChatFileWidget> createState() => _ChatFileWidgetState();
}

class _ChatFileWidgetState extends State<ChatFileWidget> {



  // downalod
  File file;
  // String _downloadingPath = "http://quickchatting.gumoti.com/files/1646746594_7605_Over_the_Horizon.mp3";
  String _destPath;
  String _rootDir;
  CancelToken _cancelToken;
  bool _downloading = false;
  double _downloadRatio = 0.0;
  String _downloadIndicator = "0.0%";
  bool _fileExist = false;
  bool _showCancel = false;


  @override
  void initState() {
    super.initState();



    // downlaod code
    getApplicationDocumentsDirectory().then((tmpDir) => {
      _rootDir = tmpDir.path + '/file/',
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        if(widget.msg.url != null)
        initializedFile(path: _rootDir + widget.msg.fileName);
      }),
    });



  }

  initializedFile({String path}) async {
    _fileExist = await File(path).exists();
    setState(() {
    });
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }



  @override
  Widget build(BuildContext context) {
    String _ext;
    String extFile;
    if(widget.msg.url != null) {
       extFile = widget.msg.fileName;
       _ext = p.extension(extFile);
    }
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          widget.isMe
              ? Container()
              : Container(
            height: 33,
            width: 33,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                    blurRadius: 9,
                    offset: Offset(0, 0),
                    color: Colors.black45.withOpacity(0.2),
                    spreadRadius: 1),
              ],
              border: Border.all(width: 1.5, color: Colors.white),
            ),
            child: cachedNetworkImageCircular(context, widget.msg.uPhoto),
          ),
          SizedBox(width: 5,),
          Column(
            crossAxisAlignment: widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * .65,
                child: Row(
                  mainAxisAlignment: !widget.isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
                  children: [
                    widget.isMe ? adminCheckStream(widget.msg.role) :
                    userName(widget.msg.senderName),
                    !widget.isMe ? adminCheckStream(widget.msg.role) :
                    userName(widget.msg.senderName),
                  ],
                ),
              ),
              _fileExist ? Container(
                margin: EdgeInsets.all(2),
                child: GestureDetector(
                  onTap: () async {
                    print('file download chat');
                    String file = widget.msg.fileName;
                    if(!['',null,'null'].contains(file)) {
                      String path = _rootDir + file;
                      File _fpth = File(path);
                      _launchUrl(_fpth.path);
                    //  return  OpenFile.open(_fpth.path);
                    }
                  },
                  child: Container(
                   // color: Colors.green,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 9,
                            offset: Offset(0, 0),
                            color: Colors.black45.withOpacity(0.2),
                            spreadRadius: 1),
                      ],
                      color: Colors.white,
                      border: Border.all(width: 1.5, color: Colors.white),
                    ),
                    width: 50,
                    height: 38,
                    child: Icon(
                      _ext == ".pdf" ? FontAwesome5.file_pdf :
                      _ext == ".docx" || _ext == ".doc" ? FontAwesome5.file_word :
                      _ext == ".xls" || _ext == ".xlsx" ? FontAwesome5.file_excel :
                      _ext == ".zip" || _ext == ".7z" ? FontAwesome.file_zip_o :
                      _ext == ".txt" || _ext == ".rtf" ? FontAwesome.file_text :
                      _ext == ".wav" || _ext == ".weba" ? FontAwesome.file_audio_o :
                      FontAwesome5.file_alt,
                      size: 20,color: Colors.green,), // cachedNetworkImg(context, photo),
                  ),
                ),
              ) :
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 9,
                        offset: Offset(0, 0),
                        color: Colors.black45.withOpacity(0.2),
                        spreadRadius: 1),
                  ],
                  color: Colors.white,
                  border: Border.all(width: 1.5, color: Colors.white),
                ),
                height: 38,
                width: 90,
                child: Stack(
                  children: [
                    Positioned(
                      top: 3,
                      left: 3,
                      child: Container(
                        height: 30,
                        width: 30,
                        color: Color(0xffffffff),
                        child: CircularPercentIndicator(
                          percent: _downloadRatio,
                          progressColor: Colors.blue,
                          radius: 15,
                          lineWidth: 3,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 11,
                      top: 10,
                      child: GestureDetector(
                        child: Icon(
                          FontAwesome.download,
                          size: 15,color: Colors.black,),
                        onTap: () async {
                          setState(() {
                            _showCancel = true;
                          });
                          String file = widget.msg.fileName;
                          if(!['',null,'null'].contains(file)) {
                            await _downloadFile(widget.msg.url);
                            downloadFilePermanently(_rootDir+file, "CR/Files/",file);
                            Fluttertoast.showToast(msg: "File downloaded");
                          }
                        },
                      ),
                    ),
                    Positioned(
                        child: Icon(
                          _ext == ".pdf" ? FontAwesome5.file_pdf :
                          _ext == ".docx" || _ext == ".doc" ? FontAwesome5.file_word :
                          _ext == ".xls" || _ext == ".xlsx" ? FontAwesome5.file_excel :
                          _ext == ".zip" || _ext == ".7z" ? FontAwesome.file_zip_o :
                          _ext == ".txt" || _ext == ".rtf" ? FontAwesome.file_text :
                          _ext == ".wav" || _ext == ".weba" ? FontAwesome.file_audio_o :
                          FontAwesome5.file_alt,
                          size: 20,color: Colors.red,),
                      bottom: 8,
                      left: 40,
                    ),
                    if(_showCancel)
                    Positioned(
                        child: GestureDetector(
                          child: Icon(
                            Icons.cancel,
                            size: 18,
                          ),
                          onTap: () => _cancelDownload(),
                        ),
                      bottom: 0,
                      right: 0,

                    ),
                    // Positioned(
                    //   child: Text(_downloadIndicator, style: fldarkgrey10,),
                    //   right: 5,
                    //   top: 10,
                    // ),
                    // Positioned(
                    //   bottom: 0,
                    //   left: 0,
                    //   child: IconButton(
                    //     icon: Icon(Icons.close,size: 15,),
                    //     onPressed: () => _cancelDownload(),
                    //   ),
                    // ),
                  ],
                ),
              ),

              Row(
                children: [
                  // Container(
                  //   width: 100,
                  //   child: Text("$extFile",
                  //     style: TextStyle(
                  //         color: widget.isMe ? Colors.white : Colors.white,
                  //         fontSize: 12,
                  //         fontFamily: "Segoe",
                  //       fontWeight: FontWeight.w800
                  //     ),
                  //     overflow: TextOverflow.ellipsis,
                  //   ),
                  // ),
                  Text("$_ext",
                    style: TextStyle(
                        color: widget.isMe ? Colors.white : Colors.white,
                        fontSize: 12,
                        fontFamily: "Segoe",
                        fontWeight: FontWeight.w800
                    ),
                  ),
                  SizedBox(width: 5,),
                  Text("${widget.msg.msgTime}",
                    style: TextStyle(
                        color: widget.isMe ? Colors.white : Colors.white,
                        fontSize: 10,
                        fontFamily: "Segoe",
                        fontWeight: FontWeight.w800
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(width: 5,),
          !widget.isMe
              ? Container()
              : Container(
            height: 33,
            width: 33,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                    blurRadius: 9,
                    offset: Offset(0, 0),
                    color: Colors.black45.withOpacity(0.2),
                    spreadRadius: 1),
              ],
              border: Border.all(width: 1.5, color: Colors.white),
            ),
            child: cachedNetworkImageCircular(context, widget.msg.uPhoto),
          ),

        ],
      ),
    );
  }




  Response response;
  Dio dio = new Dio();

  _downloadFile(String url) async {
    _cancelToken = CancelToken();
    _downloading = true;
    String fileName = "";
    if(!['',null,'null'].contains(url)){
      fileName = url.split("/").last;
      _destPath = _rootDir + fileName;
    }
    File ifFileExist = File(_destPath);

    if(ifFileExist.existsSync()){
      ifFileExist.delete();
    }

    print("destination path");
    print(_destPath);

    try{
      dio.options.headers["test-pass"] = ApiRequest.mToken;
      response = await dio.download(
        url,
        _destPath,
        cancelToken: _cancelToken,
        onReceiveProgress: (int receive, int total) {
          if(total != -1) {
            if(!_cancelToken.isCancelled) {
              setState(() {
                _downloadRatio = receive / total;
                if(_downloadRatio == 1){
                  _downloading = false;
                  setState(() {

                  });
                }
                _downloadIndicator = (_downloadRatio * 100).toStringAsFixed(2) + '%';
              });
            }
          }
        },
      );
      await _fireStore.collection(BIG_GROUP_MESSAGE_COLLECTION)
          .doc(widget.group.id.toString())
          .collection("messages")
          .doc(widget.docId)
          .update({
        'fileName': fileName,
      });
      setState(() {
        _destPath = '';
        // after download completed the file set new state to show player
        _fileExist = true;
      });

    } on DioError catch(e){
      print(e.toString());
      if(CancelToken.isCancel(e)){
        print('Download is canceled' + e.message);
      }
    } on Exception catch(e){
      print(e.toString());
    }
  }

  _cancelDownload() {
    if(_downloadRatio < 1.0){
      _cancelToken.cancel();
      _downloading = false;
      setState(() {
        _downloadRatio = 0;
        _downloadIndicator = '0.0%';
        _showCancel = false;
      });
    }
  }

  _deleteFile(String destPath) {
    try{
      File downlodFile = File(destPath);
      if(downlodFile.existsSync()){
        downlodFile.delete();
        setState(() {
          _downloading = false;
          _downloadRatio = 0;
          _downloadIndicator = '0.0%';
          //  file = null;
        });
        print("Deleted file sucessfully");
      }else{
        print("File doesnt exist.");
      }
    }catch(e){
      print(e.toString());
    }

  }










}
