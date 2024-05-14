

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:chat_app/ui/call/model/Call.dart';
import 'package:flutter/foundation.dart';

class PersonalCallProvider extends ChangeNotifier {

  bool _callRunning = false;
  bool get callRunning => _callRunning;

  Call _callData;
  Call get callData => _callData;

  String _networkStatus = "";
  String get networkStatus => _networkStatus;

  bool _isCallInitiated = false;
  bool get isCallInitiated => _isCallInitiated;

  Future<void> setCallStatus({bool callRunning}) {
    _callRunning = callRunning;
    notifyListeners();
  }

  setInitializationFalse(){
    _isCallInitiated = false;
    notifyListeners();
  }


  Future<Call> getCallDataProvider({Call call}){
    _callData = call;
    _isCallInitiated = true;
    notifyListeners();
  }

   getNetwrokStatus({NetworkQuality state}){
    switch(state){
      case NetworkQuality.Bad:
          _networkStatus = "Network bad";
        break;
      case NetworkQuality.Detecting:
          _networkStatus = "Network detecting";
        break;
      case NetworkQuality.Down:
          _networkStatus = "Network down";
        break;
      case NetworkQuality.Excellent:
          _networkStatus = "Network excellent";
        break;
      case NetworkQuality.Good:
          _networkStatus = "Network good";
        break;
      case NetworkQuality.Poor:
          _networkStatus = "Network poor";
        break;
      case NetworkQuality.Unsupported:
          _networkStatus = "Network unsupported";
        break;
      case NetworkQuality.VBad:
          _networkStatus = "Network very bad";
        break;
      default:
    }
    notifyListeners();
  }

  setConnectionLost(){
    _networkStatus = "Connection lost";
  }


  String _stopwatchtime = "00:00:00";
  String get stopwatchtime => _stopwatchtime;

  bool _isShowTimer = false;
  bool get isShowTimer => _isShowTimer;

  bool _isConneted = false;
  bool get isConneted => _isConneted;

  String _remoteStatus = "";
  String get remoteStatus => _remoteStatus;

  bool _showRemoteStatus = false;
  bool get showRemoteStatus => _showRemoteStatus;


  setShowTimer({bool isShown}){
    _isShowTimer = isShown;
    notifyListeners();
  }

  setNewTime({String nNewTime}){
    _stopwatchtime = nNewTime;
    notifyListeners();
  }

  setConnectedState({bool isConnected}){
    _isConneted = isConnected;
    notifyListeners();
  }

  setRemoteStatusText({String status}){
    _remoteStatus = status;
    notifyListeners();
  }

  setRemoteStatusBool({bool status}){
    _showRemoteStatus = status;
    notifyListeners();
  }




}
















