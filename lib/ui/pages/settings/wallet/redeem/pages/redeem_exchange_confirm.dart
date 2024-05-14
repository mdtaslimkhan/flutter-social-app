import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chat_app/provider/user_provider.dart';
import 'package:chat_app/ui/pages/settings/wallet/provider/balance_provider.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:chat_app/util/constants.dart';
import 'package:chat_app/util/loading/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';


class RedeemExchangeConfirmation extends StatefulWidget {

  final int diamond;
  final int gem;
  RedeemExchangeConfirmation({this.diamond, this.gem});
  @override
  _RedeemExchangeConfirmationState createState() => _RedeemExchangeConfirmationState();
}

class _RedeemExchangeConfirmationState extends State<RedeemExchangeConfirmation> {

  bool showSpiner = false;
  BalanceProvider _bp;
  UserProvider _u;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _bp = Provider.of<BalanceProvider>(context, listen: false);
      _u = Provider.of<UserProvider>(context, listen: false);
    });
    super.initState();
  }

 convertGemsToDiamond() async {
    try {
      final String url = BaseUrl.baseUrl('mRedeem');
      var response = await http.post(Uri.parse(url),
          headers: {'test-pass': ApiRequest.mToken},
          body: {
            'userid': _u.user.id.toString(),
            'diamond': "${widget.diamond.toString()}",
          });
      if( response.statusCode == 200){
        Map data = jsonDecode(response.body);
        print("exchange test diamond");
        print(data);
        setState(() {
          showSpiner = false;
        });
        // get balance status too
        _bp.getDiamondGemsStatus(userId: _u.user.id.toString());
        showCustomDialog(msg: data['msg'], error: data['error']);
      }else{
        showCustomDialog(msg: "Conversion error", error: true);
      }

    }catch(e){
      print(e);
    }
  }



  @override
  Widget build(BuildContext context) {

    return LoadingImage(
      inAsyncCall: showSpiner,
      child: Scaffold(
        appBar: AppBar(title: Text("Confirm redeem amount"),),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/gift/dimond_blue.png',width: 100,height: 100,),
            Text('${widget.diamond}',
              style: TextStyle(
                fontSize: 80,
                fontFamily: 'Segoe',
                fontWeight: FontWeight.w400,
                color: Colors.blueAccent
              ),
            ),
            SizedBox(height: 10,),
            Text("By",),
            SizedBox(height: 10,),
            Text('${widget.gem}',
              style: TextStyle(
                  fontSize: 40,
                  fontFamily: 'Segoe',
                  fontWeight: FontWeight.w400,
                  color: Colors.redAccent
              ),
            ),
            SizedBox(height: 5,),
            Image.asset('assets/gift/gem.png',width: 16,),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Text("Redeem rate will be 4 diamonds with 10 beans. Your conversion will be ${widget.diamond} diamonds with ${widget.gem} beans.",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'Segoe',
                fontSize: 12,
              ),
              textAlign: TextAlign.center,),
            ),
            SizedBox(height: 20,),
            Center(
              child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Container(
                    alignment: Alignment.center,
                    height: 30,
                    width: 120,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        border: Border.all(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(7)),
                    child: Text("Confirm",
                      style: ftwhite15,
                    ),
                  ),
                ),
                onTap: () {
                  setState(() {
                    showSpiner = true;
                  });
                   convertGemsToDiamond();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  showCustomDialog({String msg, bool error}){
    AwesomeDialog(
        context: context,
        dialogType: error ? DialogType.ERROR : DialogType.SUCCES,
        animType: AnimType.TOPSLIDE,
        title: msg,
      //  desc: 'Redeem rate will be 4 diamonds with 10 beans. Your conversion will be ${widget.amount} diamonds with ${widget.amount * 4} beans.',
      //  btnCancelOnPress: (){},
        btnOkOnPress: (){
          Navigator.of(context).pop();
        }
    )..show();
  }
}

