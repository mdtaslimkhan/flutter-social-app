
class BaseUrl {
  String sUrl;
  BaseUrl({this.sUrl});
  static String baseUrl(String url) {
    return 'https://quickchatting.gumoti.com/api/chattings/exam/answerApp/$url';
  }

   static baseHeader(){
    return "{'test-pass' : 'scr273!*>@1'}";
  }






}