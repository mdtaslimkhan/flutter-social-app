
import 'package:chat_app/ui/pages/settings/wallet/provider/balance_provider.dart';
import 'package:chat_app/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppVersion extends StatelessWidget {
  final String version;
  AppVersion({this.version});


  @override
  Widget build(BuildContext context) {

    BalanceProvider _bp = Provider.of<BalanceProvider>(context);

    return SafeArea(
        child: Scaffold(
          appBar: AppBar(),
          body: Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Organization: ", style: fldarkgrey18,),
              Text("Circle of Rectitude"),
              SizedBox(height: 10,),
              Text("Origin",style: fldarkgrey18,),
              Text("Bangladesh",style: fldarkgrey15,),
              SizedBox(height: 10,),
              Text("App version", style: fldarkgrey18,),
              SizedBox(height: 10,),
              Text(_bp.version,style: fldarkgrey22,),
            ],
          )),
        )
    );
  }
}
