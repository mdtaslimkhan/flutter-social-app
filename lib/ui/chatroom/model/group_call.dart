import 'package:agora_rtc_engine/rtc_engine.dart';

class GroupCall {
  String callerId;
  String callerName;
  String callerPic;
  String groupId;
  String groupName;
  String groupPic;
  String channelId;
  String mtoken;
  bool hasDialled;
  int type;
  bool isGroup;
  ClientRole role;
  bool onCallReceived;
  bool isPrivate;
  String appId;


  GroupCall({
    this.callerId,
    this.callerName,
    this.callerPic,
    this.groupId,
    this.groupName,
    this.groupPic,
    this.channelId,
    this.mtoken,
    this.hasDialled,
    this.type,
    this.isGroup,
    this.role,
    this.onCallReceived,
    this.isPrivate,
    this.appId,
  });

  Map<String, dynamic> toMap(GroupCall call){
    Map<String, dynamic> callMap = Map();
       callMap["caller_id"] = call.callerId;
       callMap["caller_name"] = call.callerName;
       callMap["caller_pic"] = call.callerPic;
       callMap["group_id"] = call.groupId;
       callMap["group_name"] = call.groupName;
       callMap["group_pic"] = call.groupPic;
       callMap["channel_id"] = call.channelId;
       callMap["has_dialled"] = call.hasDialled;
       callMap["mtoken"] = call.mtoken;
       callMap["type"] = call.type;
       callMap["is_group"] = call.isGroup;
       callMap["group_id"] = call.groupId;
       callMap["on_call_received"] = call.onCallReceived;
       callMap["is_private"] = call.isPrivate;
       callMap["appId"] = call.appId;
       return callMap;
  }

  GroupCall.fromMap(Map callMap){
   this.callerId = callMap["caller_id"];
   this.callerName = callMap["caller_name"];
   this.callerPic = callMap["caller_pic"];
   this.groupId = callMap["group_id"];
   this.groupName = callMap["group_name"];
   this.groupPic = callMap["group_pic"];
   this.channelId = callMap["channel_id"];
   this.mtoken = callMap["mtoken"];
   this.type = callMap["type"];
   this.isGroup = callMap["is_group"];
   this.hasDialled = callMap["has_dialled"];
   this.onCallReceived = callMap["on_call_received"];
   this.isPrivate = callMap["is_private"];
   this.appId = callMap["appId"];
  }



}