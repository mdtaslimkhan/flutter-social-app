import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:chat_app/ui/chatroom/model/message_model.dart';
import 'package:chat_app/ui/chatroom/model/message_model_personal.dart';
import 'package:chat_app/ui/chatroom/widgets/chat_room_user_image.dart';
import 'package:chat_app/ui/chatroom/widgets/name_admin_owner.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:path/path.dart' as p;


final _fireStore = FirebaseFirestore.instance;


class PlayAudioPersonal extends StatefulWidget {
  final String docId;
  final String groupId;
  final bool isMe;
  final MessageModelPersonal msg;

  const PlayAudioPersonal({
    Key key,
    this.docId,
    this.groupId,
    this.isMe,
    this.msg
  }) : super(key: key);

  @override
  _PlayAudioPersonalState createState() => _PlayAudioPersonalState();
}

class _PlayAudioPersonalState extends State<PlayAudioPersonal> with TickerProviderStateMixin{
  //for audio files
  AnimationController _animationIconController1;
  AudioCache audioCache;
  AudioPlayer audioPlayer;
  Duration _duration = new Duration();
  Duration _position = new Duration();
  Duration _slider = new Duration(seconds: 0);
  double durationValue;
  bool isSongPlaying = false;
  bool isPlaying = false;


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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //for audio inside initState
    _position = _slider;
    _animationIconController1 = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 750),
      reverseDuration: new Duration(milliseconds: 750),
    );
    audioPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: audioPlayer);
    audioPlayer.onDurationChanged.listen((d) {
      setState(() {
        _duration = d;
      });
    });


    audioPlayer.onAudioPositionChanged.listen((p) {
      setState(() {
        _position = p;
      });
    });


    // downlaod code
    getApplicationDocumentsDirectory().then((tmpDir) => {
      _rootDir = tmpDir.path + '/audio/',
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        initializedFile(path: _rootDir + widget.msg.fileName);
      }),
    });



  }

  initializedFile({String path}) async {
    _fileExist = await File(path).exists();
    // if file already not download then download the audio file
    if(widget.msg.source == "voice") {
      if (!_fileExist) {
        _downloadFile(widget.msg.url);
      }
    }
    setState(() {
    });
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  void seekToSeconds(int second) {
    Duration newDuration = Duration(seconds: second);
    audioPlayer.seek(newDuration);
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if(!widget.isMe)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              chatRoomUserImage(context, widget.msg.uPhoto),
              SizedBox(width: 5,),
              Container(
                width: MediaQuery.of(context).size.width * .45,
                height: 30,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    userName(widget.msg.senderName),
                    adminCheckStream(widget.msg.role),
                  ],
                ),
              ),
            ],
          ),
        Row(
          mainAxisAlignment: widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 3),
              width: MediaQuery.of(context).size.width * 0.65,
              decoration: BoxDecoration(
                color: Color(0xff171515),
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(width: 1.5, color: Color(0xff282828)),
              ),
              height: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  player(),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 5,)
      ],
    );
  }


  Widget player(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 8,),
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: widget.msg.source == "voice" ? Color(0xff7c3bb6) : Color(0xffffac32),
          ),
          child: widget.msg.source == "voice" ? Icon(Icons.record_voice_over, color: Colors.white) :
          Icon(Icons.headset, color: Colors.white),
        ),
        SizedBox(width: 8,),
        Expanded(
          child: Container(
            child: Column(
              children: [
                Container(
                  height: 30,
                  child: Row(
                    children: [
                      SizedBox(width: 5,),
                      _fileExist ? GestureDetector(
                        onTap: () {
                          setState(() {
                            isPlaying ? _animationIconController1.reverse() : _animationIconController1.forward();
                            isPlaying = !isPlaying;
                          });
                          // Add code to pause and play the music.
                          if (!isSongPlaying){
                            if(!['',null,'null'].contains(widget.msg.fileName)) {
                              audioPlayer.play('${_rootDir + widget.msg.fileName}');
                            }
                            setState(() {
                              isSongPlaying = true;
                            });
                          } else {
                            audioPlayer.pause();
                            setState(() {
                              isSongPlaying = false;
                            });
                          }
                        },
                        child: ClipOval(
                          child: Container(
                            color: Colors.pink[600],
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: AnimatedIcon(
                                icon: AnimatedIcons.play_pause,
                                size: 14,
                                progress: _animationIconController1,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ) : GestureDetector(child: Icon(
                          Icons.download,
                          color: Colors.white,
                          ), onTap: () => _downloadFile(
                          widget.msg.url,
                          ),),
                      Expanded(
                        child: _fileExist ? Slider.adaptive(
                          activeColor: Colors.white,
                          inactiveColor: Colors.grey,
                          value: _position.inSeconds.toDouble(),
                          max: _duration.inSeconds.toDouble(),
                          onChanged: (double value) {
                            seekToSeconds(value.toInt());
                            value = value;
                          },
                          thumbColor: Colors.blue,
                        ) : LinearPercentIndicator(
                          percent: _downloadRatio,
                          progressColor:  Colors.blue,
                          lineHeight: 2,
                        ) ,
                      ),
                      !_fileExist ?
                      Text(_downloadIndicator, style: ftwhite12,) : Text(''),
                      SizedBox(width: 5,),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 5, right: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(child: Text("date", style: ftwhite10,),),
                      Container(child: Text("${widget.msg.msgTime}", style: ftwhite10,),),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Text('${_position.toString().split(".")[0]}', style: ftwhite14,),
        SizedBox(width: 5,)
      ],
    );
  }
  Widget downloader(){
    return Container(
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(child: Icon(
            Icons.download,
            color: Colors.white,
          ), onTap: () => _downloadFile(
            widget.msg.url,
          ),),
          Container(
            width: 110,
            child: LinearPercentIndicator(
              percent: _downloadRatio,
              progressColor:  Colors.blue,
              lineHeight: 2,
            ),
          ),
          Text(_downloadIndicator, style: ftwhite12,),
        ],
      ),
    );
  }



  Response response;
  Dio dio = new Dio();

  _downloadFile(String url) async {
    _cancelToken = CancelToken();
    _downloading = true;
    if(!['',null,'null'].contains(url)){
      _destPath = _rootDir + widget.msg.fileName;
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
          .doc(widget.groupId)
          .collection("messages")
          .doc(widget.docId)
          .update({
        'fileName': widget.msg.fileName,
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












