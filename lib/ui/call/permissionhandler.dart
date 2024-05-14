
import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerUser {



  Future<bool> onJoin() async {
    // update input validation
      // await for camera and mic permissions before pushing video page
      await _handleCameraAndMic();

      return true;

  }

  Future<void> _handleCameraAndMic() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();
  }

  Future<bool> permissionForContacts() async{
    await _handleCameraAndMic();
    await _handleContacts();
    return true;
  }

  Future<void> _handleContacts() async{
    Map<Permission, PermissionStatus> statuses = await [
      Permission.contacts,
    ].request();
  }

  Future<bool> permissionForLocation() async {
      await _locationPermission();
      return true;
  }

  Future<void> _locationPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
    ].request();
  }

  Future<bool> permissionStorage () async {
    await _permissionStorage();
    return true;
  }

  Future<void> _permissionStorage() async{
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
  }


}