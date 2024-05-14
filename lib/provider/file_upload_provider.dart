import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class FileUploadProvider extends ChangeNotifier{


  // biggorup upload status
  double _uploadSent;
  double get uploadSent => _uploadSent;

  setUploadSendStatus({double state}){
    _uploadSent = state;
    notifyListeners();
  }

  bool _showUploadLayer = false;
  bool get showUploadLayer => _showUploadLayer;

  setUploadLayer({bool show}){
    _showUploadLayer = show;
    notifyListeners();
  }

  // personal upload status
  double _uploadSentPersonal;
  double get uploadSentPersonal => _uploadSentPersonal;

  setUploadSendStatusPersonal({double state}){
    _uploadSentPersonal = state;
    notifyListeners();
  }

  bool _showUploadLayerPersonal = false;
  bool get showUploadLayerPersonal => _showUploadLayerPersonal;

  setUploadLayerPersonal({bool show}){
    _showUploadLayerPersonal = show;
    notifyListeners();
  }


  // audio play biggroup upload status
  double _uploadSentAudio;
  double get uploadSentAudio => _uploadSentAudio;

  setUploadSendStatusAudio({double state}){
    _uploadSentAudio = state;
    notifyListeners();
  }

  bool _showUploadLayerAudio = false;
  bool get showUploadLayerAudio => _showUploadLayerAudio;

  setUploadLayerAudio({bool show}){
    _showUploadLayerAudio = show;
    notifyListeners();
  }





}