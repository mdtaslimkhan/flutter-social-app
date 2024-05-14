import 'package:flutter/cupertino.dart';

class HomeProvider extends ChangeNotifier{


  bool _showLoader = false;
  bool get showLoader => _showLoader;

  setShowLoader({bool isShow}){
    _showLoader = isShow;
    notifyListeners();
  }


  bool _showLoaderExplore = false;
  bool get showLoaderExplore => _showLoaderExplore;

  setShowLoaderExplore({bool isShow}){
    _showLoaderExplore = isShow;
    notifyListeners();
  }

}