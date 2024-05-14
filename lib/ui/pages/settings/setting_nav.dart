import 'package:chat_app/ui/pages/profile/personal_profile/local_widgets/lebel.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/utils/setting_tile.dart';
import 'package:chat_app/ui/pages/settings/wallet/provider/balance_provider.dart';
import 'package:chat_app/util/constants.dart';
import 'package:chat_app/util/loading/loading.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';


class SettingNav extends StatefulWidget {
  final String userId;
  SettingNav({this.userId});

  @override
  _SettingNavState createState() => _SettingNavState();
}

class _SettingNavState extends State<SettingNav> {

  bool showSpinner = false;
  String version = "";


  @override
  void initState() {
    // TODO: implement initState
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        version = packageInfo.version;
      });

    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    BalanceProvider _bp = Provider.of<BalanceProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Setting"),),
      body: LoadingImage(
        inAsyncCall: showSpinner,
        child: Column(
          children: [
            LabelText(text: "Profile settings",),
            SettingsTile(label: "Profile",onPress: () async {
              Navigator.of(context).pushNamed('/personalSetting', arguments: {'userId': widget.userId});
            }),
            LabelText(text: "Wallet settings",),
            SettingsTile(label: "Wallet",onPress: () async {
              setState(() {
                showSpinner = true;
              });
             bool status = await _bp.getDiamondGemsStatus(userId: widget.userId);
             if(status != null && status) {
               setState(() {
                 showSpinner = false;
               });
               Navigator.of(context).pushNamed('/settingWallet', arguments: {});
             }else{
               Fluttertoast.showToast(msg: "Please check your internet connection");
             }
            }),
            LabelText(text: "About app",),
            SettingsTile(label: "Version: ${_bp.version}" ,onPress: () async {
             // String ad = await Navigator.push(context, MaterialPageRoute(builder: (context) => AppVersion(version: APP_VERSION)));
              Navigator.of(context).pushNamed('/appVersion', arguments: {'version': APP_VERSION});
            }),

          ],
        ),
      ),
    );
  }
}
