
import 'dart:io';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/chatroom/model/message_model_personal.dart';
import 'package:chat_app/ui/chatroom/widgets/name_admin_owner.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:video_player/video_player.dart';
final _fireStore = FirebaseFirestore.instance;

class ChatVideoPlayerPersonal extends StatefulWidget {

  final bool isMe;
  final String docId;
  final UserModel loggedUser;
  final GroupModel group;
  final String groupId;
  final MessageModelPersonal msg;
  ChatVideoPlayerPersonal({
    this.isMe,
    this.docId,
    this.loggedUser,
    this.group,
    this.groupId,
    this.msg,
    Key key
  }) : super(key: key);

  @override
  State<ChatVideoPlayerPersonal> createState() => _ChatVideoPlayerPersonalState();
}

class _ChatVideoPlayerPersonalState extends State<ChatVideoPlayerPersonal> {

  VideoPlayerController _controller;

  String _pathsfl = '/data/user/0/com.chatting.chat_app/app_flutter/video/';

  bool _fileExist = false;

  String _destPath;
  String _rootDir;
  CancelToken _cancelToken;
  bool _downloading = false;
  double _downloadRatio = 0.0;
  String _downloadIndicator = "0.0%";
  File _fpth;
  bool _showCancel = false;



  @override
  void initState() {
    super.initState();

    // downlaod code
    getApplicationDocumentsDirectory().then((tmpDir) => {
      _rootDir = tmpDir.path + '/video/',
      // setstate after widget building so addPostFrameCallBack
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
         initializedFile(path: _rootDir + widget.msg.fileName);
      }),
    });
  }


  void initializedFile({String path}) async {
    _fileExist = await File(path).exists();
    _fpth = File(path);
    _controller = VideoPlayerController.file(_fpth)
      ..addListener(() => setState(() {}))
      ..setLooping(false)
      ..initialize();
    setState(() {

    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: !widget.isMe ? Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Container(
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
                Container(
                  width: MediaQuery.of(context).size.width * .45,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      userName(widget.msg.senderName),
                      adminCheckStream(widget.msg.role),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 3,),
            videoPlayer(context, widget.msg.fileName),
            SizedBox(height: 5,),
          ],
        ),
      ) : Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          videoPlayer(context, widget.msg.fileName),
        ],
      ),
    );
  }



Widget videoPlayer(BuildContext context, String fileName) {
    final isMuted = _controller != null ? _controller.value.volume == 0 : false;
    return  Stack(
      children: [

        Container(
          color: Colors.black38,
          margin: EdgeInsets.all(2),
          width: MediaQuery.of(context).size.width * .65,
          height: 150,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: _fileExist ? VideoPlayerWidget(controller: _controller, fileName: fileName) :
            Stack(
              children: [
                Container(
                  color: Color(0xffffffff),
                  alignment: Alignment.center,
                  child: CircularPercentIndicator(
                    percent: _downloadRatio,
                    progressColor: Colors.blue,
                    radius: 30,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    child: IconButton(
                      icon: Icon(Icons.download),
                      onPressed: () async {
                        setState(() {
                          _showCancel = true;
                        });
                        String file = widget.msg.fileName;
                        if(!['',null,'null'].contains(file)) {
                          String path = _rootDir + file;
                          File _fpth = File(path);
                         await _downloadFile(widget.msg.url);
                          _controller = VideoPlayerController.file(_fpth)
                            ..addListener(() => setState(() {}))
                            ..setLooping(false)
                            ..initialize();
                          // setState(() {
                          //   _fileExist = false;
                          // });
                        }
                      },
                    ),
                  ),
                ),
                Positioned(
                  child: Text(getFileExtention(widget.msg.fileName), style: fldarkgrey15,),
                  left: 5,
                  top: 10,
                ),
                Positioned(
                    child: Text(_downloadIndicator, style: fldarkgrey22,),
                  right: 5,
                  top: 10,
                ),
                if(_showCancel)
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _showCancel = false;
                        _fileExist = false;
                      });
                      String file = widget.msg.fileName;
                      if(!['',null,'null'].contains(file)) {
                        String path = _rootDir + file;
                        File _fpth = File(path);
                        if(_fpth.existsSync()){
                          _fpth.delete();
                        }
                      }
                     return _cancelDownload();
                    },
                  ),
                ),


              ],
            ),
          ), // cachedNetworkImg(context, photo),
        ),



        Positioned(
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 15,
                        offset: Offset(-3, 0),
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 1),
                  ],
                ),
                padding: EdgeInsets.all(5),
                child: Text(widget.msg.msgTime, style: TextStyle(
                    fontSize: 10,
                    fontFamily: "Segoe",
                    color: Colors.white,
                    fontWeight: FontWeight.w600
                ))
            ),
          bottom: 3,
          right: 3,
        )
      ],
    );
}





  Response response;
  Dio dio = new Dio();


  _downloadFile(String url) async {
    _cancelToken = CancelToken();
    _downloading = true;
    String fileName = "";
    if(!['',null,'null'].contains(url)){
      fileName = widget.msg.fileName;
      _destPath = _rootDir + fileName;
    }
    File ifFileExist = File(_destPath);
    if(ifFileExist.existsSync()){
      ifFileExist.delete();
    }

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
                }
                _downloadIndicator = (_downloadRatio * 100).toStringAsFixed(2) + '%';
              });
            }
          }
        },
      );
      // await _fireStore.collection(BIG_GROUP_MESSAGE_COLLECTION)
      //     .doc(widget.loggedUser.id.toString())
      //     .collection("messages")
      //     .doc(widget.docId)
      //     .update({
      //   'fileName': fileName,
      // });
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
    print(_fileExist);
    print('file exist');
    if(_downloadRatio < 1.0){
      _cancelToken.cancel();
      _downloading = false;
      setState(() {
        _downloadRatio = 0;
        _downloadIndicator = '0.0%';
        _fileExist = false;
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

class VideoPlayerWidget extends StatelessWidget {

  final VideoPlayerController controller;
  final String fileName;
  VideoPlayerWidget({this.controller, this.fileName, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMuted = controller != null ? controller.value.volume == 0 : false;

    return controller != null && controller.value.isInitialized ?
    Stack(
      children: [
        Hero(
          tag: 'video$fileName',
          child: Container(
            alignment: Alignment.topCenter,
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
                child: buildVideo()
            ),
          ),
        ),
        if(controller != null && controller.value.isInitialized )
          Positioned(
            child: IconButton(
                icon: Icon( isMuted ? Icons.volume_mute : Icons.volume_up, color: Colors.white,),
                onPressed: () {
                  controller.setVolume(isMuted ? 1 : 0);

                }
            ),
            left: 3,
            bottom: 3,
          ),
        if(controller != null && controller.value.isInitialized )
          Positioned(
            child: IconButton(
                icon: Icon(Icons.zoom_out_map, color: Colors.white,),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FullScreenVideo(controller: controller,fileName: fileName)));
                }
            ),
            right: 3,
            top: 3,
          ),
      ],
    ) : Container(
      height: 200,
      child: Center(
        child: CircularProgressIndicator(),
      )
    );
  }

 Widget buildVideo(){
    return Stack(
      children: [
        VideoPlayer(controller),
        Positioned.fill(child: BasicOverLayWidget(controller: controller,)),
      ],
    );
 }



}

class BasicOverLayWidget extends StatelessWidget {
  VideoPlayerController controller;
  BasicOverLayWidget({this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: (){
      //  Navigator.push(context, MaterialPageRoute(builder: (context) => FullScreenVideo(controller: controller,)));
        controller.value.isPlaying ? controller.pause() : controller.play();
      },
      child: Stack(
        children: [
          buildPlay(),
          Positioned(
              child: BuildIndicator(),
            bottom: 0,
            right: 0,
            left: 0,
          ),
        ],
      ),
    );
  }

 Widget BuildIndicator() {
    return VideoProgressIndicator(
        controller,
        allowScrubbing: true
    );
  }

 Widget buildPlay() {
   final isPlay = controller.value.isPlaying;
   return !isPlay ? Container(
     alignment: Alignment.center,
     color: Colors.black26,
     child: Icon( Icons.play_arrow, color: Colors.white, size: 50,),
   ) : Container();

  }



}



class FullScreenVideo extends StatefulWidget {

  final VideoPlayerController controller;
  final String fileName;
  FullScreenVideo({this.controller, this.fileName});

  @override
  State<FullScreenVideo> createState() => _FullScreenVideoState();
}

class _FullScreenVideoState extends State<FullScreenVideo> {


  @override
  Widget build(BuildContext context) {
    final isMuted = widget.controller != null ? widget.controller.value.volume == 0 : false;

    return Scaffold(
      backgroundColor: Colors.black12,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              child: Hero(
                tag: "video${widget.fileName}",
                child: widget.controller != null && widget.controller.value.isInitialized ? Container(
                   alignment: Alignment.center,
                    child: AspectRatio(
                      aspectRatio: widget.controller.value.aspectRatio,
                        child: buildFullScreenVideoPlayer()
                    )
                ) : Container(
                    height: 200,
                    child: Center(
                      child: CircularProgressIndicator(),
                    )
                ),
              ),
            ),
            if(widget.controller != null && widget.controller.value.isInitialized )
              Positioned(
                child: IconButton(
                    icon: Icon( isMuted ? Icons.volume_mute : Icons.volume_up, color: Colors.white,),
                    onPressed: () {
                      widget.controller.setVolume(isMuted ? 1 : 0);
                      setState(() {});
                    }
                ),
                left: 10,
                bottom: 3,
              ),
            Positioned(
              top: 20,
              left: 8,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white,),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
            ),
            Positioned(
              child: IconButton(
                  icon: Icon(Icons.zoom_out_map_outlined, color: Colors.white,),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }
              ),
              right: 3,
              top: 20,
            ),
          ],
        ),
      ),
    );
  }

  buildFullScreenVideoPlayer() {
    return Stack(
      children: [
        VideoPlayer(widget.controller),
        Positioned.fill(child: FullScreenBasicOverLayWidget(controller: widget.controller,onPressed: (){
          setState(() {});
        },)),

      ],
    );;
  }
}

class FullScreenBasicOverLayWidget extends StatelessWidget {
  VideoPlayerController controller;
  final onPressed;
  FullScreenBasicOverLayWidget({this.controller, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: (){
         controller.value.isPlaying ? controller.pause() : controller.play();
         onPressed();
      },
      child: Stack(
        children: [
          buildPlay(),
          Positioned(
            child: BuildIndicator(),
            bottom: 0,
            right: 0,
            left: 0,
          ),
        ],
      ),
    );
  }

  Widget BuildIndicator() {
    return VideoProgressIndicator(
        controller,
        allowScrubbing: true
    );
  }

  Widget buildPlay() {
    final isPlay = controller.value.isPlaying;
    return !isPlay ? Container(
      alignment: Alignment.center,
      color: Colors.black26,
      child: Icon( Icons.play_arrow, color: Colors.white, size: 50,),
    ) : Container();

  }



}




