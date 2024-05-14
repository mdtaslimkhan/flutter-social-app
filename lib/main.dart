
import 'package:chat_app/database/database.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/provider/file_upload_provider.dart';
import 'package:chat_app/provider/home_provider.dart';
import 'package:chat_app/provider/profile_provider.dart';
import 'package:chat_app/provider/story_provider.dart';
import 'package:chat_app/provider/user_provider.dart';
import 'package:chat_app/ui/call/provider/call_provider.dart';
import 'package:chat_app/ui/chatroom/fileupload/video_upload_provider.dart';
import 'package:chat_app/ui/chatroom/function/sound_recoder.dart';
import 'package:chat_app/ui/chatroom/function/sound_recoder_personal.dart';
import 'package:chat_app/ui/chatroom/provider/agora_provider_big_group.dart';
import 'package:chat_app/ui/chatroom/provider/big_group_provider.dart';
import 'package:chat_app/ui/chatroom/provider/get_host_hot_seat_user_list_provider.dart';
import 'package:chat_app/ui/index.dart';
import 'package:chat_app/ui/pages/login/login_methods.dart';
import 'package:chat_app/ui/pages/login/login_options.dart';
import 'package:chat_app/ui/chatroom/provider/get_dimond_gem_follow_provider.dart';
import 'package:chat_app/ui/pages/settings/wallet/provider/balance_provider.dart';
import 'package:chat_app/ui/route/routeGenerator.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';



/*
  *   blue primary: 0xFF1f3ed1
  *   blue primary accent : 0xFF85e6ff
  *   Yellow : 0xFFfbc81e
  *   blue for button : 0xFF3175fe
  *
  *
 */
void main() async {
  // firebase initialization
  Fimber.plantTree(DebugTree.elapsed(useColors: true));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await FlutterDownloader.initialize(
  //     debug: true // optional: set false to disable printing logs to console
  // );

  // main application
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]).then((value) async {
    UserModel u = await LoginMethods().getUser();
    runApp(
        MultiProvider(
          providers: [
                ChangeNotifierProvider(create: (context) => DimondGemFollowProvider()),
                ChangeNotifierProvider(create: (context) => AgoraProviderBigGroup()),
                ChangeNotifierProvider(create: (context) => GetHostHotSeatUserProvider()),
                ChangeNotifierProvider(create: (context) => UserProvider()),
                ChangeNotifierProvider(create: (context) => PersonalCallProvider()),
                ChangeNotifierProvider(create: (context) => BigGroupProvider()),
                ChangeNotifierProvider(create: (context) => BalanceProvider()),
                StreamProvider.value(value: DatabaseRepo().homeContacts, initialData: null),
                ChangeNotifierProvider(create: (context) => ProfileProvider()),
                ChangeNotifierProvider(create: (context) => HomeProvider()),
                ChangeNotifierProvider(create: (context) => FileUploadProvider()),
                ChangeNotifierProvider(create: (context) => AudioProvider()),
                ChangeNotifierProvider(create: (context) => AudioProviderPersonal()),
                ChangeNotifierProvider(create: (context) => VideoUploadProvider()),
                ChangeNotifierProvider(create: (context) => StoryProvider()),
            ],
          child: MaterialApp(
              home: u == null || u.id == null ? LoginOption() : Index(user: u),
           //  routes: {
           //    'index': (context) => Home(user: u),
               // '/register': (context) => Register(),
          //   },
              initialRoute: "/",
              onGenerateRoute: RouteGenerator.generateRoute,
              theme: ThemeData(
                brightness: Brightness.light,
                primaryColor: Color(0xFF1f3ed1),
                accentColor: Color(0xFF85e6ff),
                fontFamily: 'SegoeLight',
                textTheme: TextTheme(
                  headline1: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold
                  ),
                  headline6: TextStyle(
                      fontSize: 20.0,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold
                  ),
                  bodyText2: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'Segoe'
                  ),
                ),
              ),
    ),

        ));
  });

}

class TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text("test success"),);
  }
}



