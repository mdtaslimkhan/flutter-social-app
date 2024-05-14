import 'package:agora_rtc_engine/rtc_engine.dart';

class Call {
  String callerId;
  String callerName;
  String callerPic;
  String receiverId;
  String receiverName;
  String receiverPic;
  String channelId;
  String mtoken;
  bool hasDialled;
  int type;
  bool isGroup;
  ClientRole role;
  String groupId;
  bool onCallReceived;
  String appId;


  Call({
    this.callerId,
    this.callerName,
    this.callerPic,
    this.receiverId,
    this.receiverName,
    this.receiverPic,
    this.channelId,
    this.mtoken,
    this.hasDialled,
    this.type,
    this.isGroup,
    this.role,
    this.groupId,
    this.onCallReceived,
    this.appId,
  });

  Map<String, dynamic> toMap(Call call){
    Map<String, dynamic> callMap = Map();
       callMap["caller_id"] = call.callerId;
       callMap["caller_name"] = call.callerName;
       callMap["caller_pic"] = call.callerPic;
       callMap["receiver_id"] = call.receiverId;
       callMap["receiver_name"] = call.receiverName;
       callMap["receiver_pic"] = call.receiverPic;
       callMap["channel_id"] = call.channelId;
       callMap["has_dialled"] = call.hasDialled;
       callMap["mtoken"] = call.mtoken;
       callMap["type"] = call.type;
       callMap["is_group"] = call.isGroup;
       callMap["group_id"] = call.groupId;
       callMap["on_call_received"] = call.onCallReceived;
       callMap["appId"] = call.appId;
       return callMap;
  }

  Call.fromMap(Map callMap){
   this.callerId = callMap["caller_id"];
   this.callerName = callMap["caller_name"];
   this.callerPic = callMap["caller_pic"];
   this.receiverId = callMap["receiver_id"];
   this.receiverName = callMap["receiver_name"];
   this.receiverPic = callMap["receiver_pic"];
   this.channelId = callMap["channel_id"];
   this.mtoken = callMap["mtoken"];
   this.type = callMap["type"];
   this.isGroup = callMap["is_group"];
   this.hasDialled = callMap["has_dialled"];
   this.groupId = callMap["group_id"];
   this.onCallReceived = callMap["on_call_received"];
   this.appId = callMap["appId"];
  }



}