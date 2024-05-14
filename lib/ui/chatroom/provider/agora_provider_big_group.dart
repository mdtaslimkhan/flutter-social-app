
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:chat_app/ui/chatroom/model/mute_model.dart';
import 'package:flutter/foundation.dart';

class AgoraProviderBigGroup extends ChangeNotifier{

  bool _joined = false;
  bool get joined => _joined;

  int _remoteUid = null;
  int get remoteUid => _remoteUid;

  List<AudioVolumeInfo> _remoteUserAudioInfo;
  List<AudioVolumeInfo> get remoteUserAudioInfo => _remoteUserAudioInfo;

  MuteModel _isMutedAgora;
  MuteModel get isMutedAgora => _isMutedAgora;


  // Initialize the app
  Future<void> setHandlerAgoraBigGroup({RtcEngine engine}) async {
    // Get microphone permission

    engine.setEventHandler(RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          print('joinChannelSuccess $channel $uid');
            _joined = true;
            notifyListeners();
        },
        userJoined: (int uid, int elapsed) {
          print('userJoined $uid');
            _remoteUid = uid;
            notifyListeners();
        },
        userOffline: (int uid, UserOfflineReason reason) {
          print('userOffline $uid');
          print(reason);
            _remoteUid = null;
            _joined = false;
            notifyListeners();
        },

        audioVolumeIndication: (audioVolumeInfo, speakers) {
            _remoteUserAudioInfo = audioVolumeInfo;
            notifyListeners();
           // print("======================== audio volume indication ${speakers.toString()}");
        },

        userMuteAudio:(uid, muted) {
          MuteModel am = MuteModel(userId: uid, isMuted: muted);
            _isMutedAgora = am;
            print("======================== audio mute user id ${am.userId}");
            notifyListeners();
        },
      clientRoleChanged: (oldRole, newRole ) {
          print('new role $newRole');
          print('old role $oldRole');
      },
      audioMixingStateChanged: (state, error) {
          print("Audio mixing state");
          print(state);
          print(error);
      },
      audioMixingFinished: (){
          print("audio mixing finished");
      },


    ));

  }


}