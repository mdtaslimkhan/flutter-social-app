


import 'package:chat_app/ui/chatroom/function/voice_room_methods.dart';
import 'package:chat_app/ui/chatroom/gift/gift_user_model.dart';
import 'package:flutter/foundation.dart';

class GetHostHotSeatUserProvider extends ChangeNotifier{

  final VoiceRoomMethods _roomMethods = VoiceRoomMethods();


   List<GiftUserModel> _hostHotSeatUserList = [];
   List<GiftUserModel> get hostHotSeatUserList => _hostHotSeatUserList;


  getHostHotSeatUserListProvider({String toGroupId, String fromUserId}) async {
    List<GiftUserModel> gulist = await _roomMethods.getGiftUserListAll(toGroupId);
    _hostHotSeatUserList = gulist;
    _hostHotSeatUserList.removeWhere((e) => e.userId == fromUserId);
    notifyListeners();
  }


}