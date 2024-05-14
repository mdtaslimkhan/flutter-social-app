
import 'package:chat_app/ui/chatroom/controller/chat_room_controller.dart';
import 'package:chat_app/ui/chatroom/model/gift.dart';
import 'package:chat_app/ui/chatroom/model/gift_showing_model.dart';
import 'package:chat_app/ui/chatroom/model/group_call.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:chat_app/ui/pages/home/controller/homeController.dart';
import 'package:flutter/foundation.dart';

class BigGroupProvider extends ChangeNotifier{

  ChatRoomController _chatRoomController = ChatRoomController();
  final HomeController _homeController = HomeController();


  bool _showSpinner = false;
  bool get showSpinner => _showSpinner;

  setShowSpinner({bool showSpinner}){
    _showSpinner = showSpinner;
    notifyListeners();
  }

  bool _isWriting = false;
  bool get isWriting => _isWriting;

  setIsWriting({bool isWriting}){
    _isWriting = isWriting;
    notifyListeners();
  }

  // bool _isHost = false;
  // bool get isHost => _isHost;
  //
  // setUserHost({bool isHost}){
  //   _isHost = isHost;
  //   notifyListeners();
  // }

  bool _isJoinedToBigGroup = false;
  bool get isJoinedToBigGroup => _isJoinedToBigGroup;

  setJoinedBigGroup({bool isJoined}){
    _isJoinedToBigGroup = isJoined;
    notifyListeners();
  }

  bool _isAdmin = false;
  bool get isAdmin => _isAdmin;

  setAdmin({bool isAdmin}){
    _isAdmin = isAdmin;
    notifyListeners();
  }

  int _role = 3;
  int get role => _role;

  setRole({int role}){
    _role = role;
    notifyListeners();
  }

  bool _showTable = false;
  bool get showTable => _showTable;

  setShowTable({bool show}){
    _showTable = show;
    notifyListeners();
  }

  bool _isCallRunning = false;
  bool get isCallRunning => _isCallRunning;

  setIsCallRunning({bool isRunning}){
    _isCallRunning = isRunning;
    notifyListeners();
  }

  bool _groupRunning = false;
  bool get groupRunning => _groupRunning;

  setGroupRunning({bool isRunning}){
    _groupRunning = isRunning;
    notifyListeners();
  }

  bool _isUserMuted = false;
  bool get isUserMuted => _isUserMuted;

  setUserMuted({bool isMuted}){
    _isUserMuted = isMuted;
    notifyListeners();
  }

  // bool _showMention = false;
  // bool get showMention => _showMention;
  //
  // setShowMention({bool show}){
  //   _showMention = show;
  //   notifyListeners();
  // }

  GiftShowingModel _gShowingModel;
  GiftShowingModel get gShowingModel => _gShowingModel;

  setGiftShowingModel({GiftShowingModel model}){
    _gShowingModel = model;
    notifyListeners();
  }

  GroupCall _callState;
  GroupCall get callState => _callState;

  setGroupCallState({GroupCall call}){
    _callState = call;
    notifyListeners();
  }

  bool _showGroupUsers = false;
  bool get showGroupUsers => _showGroupUsers;

  setShowGroupUsers({bool show}){
    _showGroupUsers = show;
    notifyListeners();
  }

  bool _muted = false;
  bool get muted => _muted;

  setMuteVoice({bool mute}){
    _muted = mute;
    notifyListeners();
  }

  bool _emojiPicker = false;
  bool get emojiPicker => _emojiPicker;

  setEmojiPickerShow({bool show}){
    _emojiPicker = show;
    notifyListeners();
  }


  List<Gift> _gift = [];
  List<Gift> get gift => _gift;
  getGiftData({String userId}) async {
    var dtbdg = await _chatRoomController.getChatRoomGiftListData(userId);
    if(dtbdg != null){
      dtbdg.forEach((val) {
        gift.add(Gift.fromJson(val));
      });
    }
    notifyListeners();
  }

  List<String> _react = [
    'think','good','hand', 'upset', 'wow'
  ];
  List<String> get react => _react;

  GroupModel _toGroup;
  GroupModel get toGroup => _toGroup;

  getGroupModelData({String groupId}) async {
    GroupModel _groupData = await _homeController.getGroupById(groupId);
    _toGroup = _groupData;
    notifyListeners();
  }

  bool _userWaiting = false;
  bool get userWaiting => _userWaiting;

  setUserWaiting({bool isWaiting}){
    _userWaiting = isWaiting;
    notifyListeners();
  }












}

