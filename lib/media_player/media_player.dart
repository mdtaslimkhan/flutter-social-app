import 'package:audioplayers/audioplayers.dart';

class MediaPlayer{
  AudioPlayer advancedPlayer;
  AudioCache audioCache;
  String localFilePath;

  void initPlayer(){
    advancedPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: advancedPlayer);
  }
}