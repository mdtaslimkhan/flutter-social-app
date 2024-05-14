class AppIdToken{
  String token;
  String appId;
  AppIdToken({this.token, this.appId});
  AppIdToken.fromMap(Map appIdToken){
    this.appId = appIdToken["appId"];
    this.token = appIdToken["token"];
  }

}