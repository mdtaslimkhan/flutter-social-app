
import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chat_app/provider/user_provider.dart';
import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/pages/settings/wallet/provider/balance_provider.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/base_url.dart';
import 'package:chat_app/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;


class BankRechangeConfirmation extends StatefulWidget {

  final String diamond;
  BankRechangeConfirmation({this.diamond});

  @override
  _BankRechangeConfirmationState createState() => _BankRechangeConfirmationState();
}

class _BankRechangeConfirmationState extends State<BankRechangeConfirmation> {


  bool showSpiner = false;
  BalanceProvider _bp;
  UserProvider _u;


  rechargeDiamond() async {
    try {
      final String url = BaseUrl.baseUrl('sendBankDiamond');
      var response = await http.post(Uri.parse(url),
          headers: {'test-pass': ApiRequest.mToken},
          body: {
            'fromUserId': _u.user.id.toString(),
            'toUserId': _bp.toUserModel.id.toString(),
            'diamond': "${widget.diamond}",
          });
      if( response.statusCode == 200){
        Map data = jsonDecode(response.body);
        print("exchange test diamond");
        print(data);

        // get balance status too
        _bp.getDiamondGemsStatus(userId: _u.user.id.toString());
        showCustomDialog(msg: data['msg'], error: data['error']);
      }else{
        showCustomDialog(msg: "Recharge error", error: true);
      }

    }catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _bp = Provider.of<BalanceProvider>(context, listen: false);
      _u = Provider.of<UserProvider>(context, listen: false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BalanceProvider _redeem = Provider.of<BalanceProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Confirm bank recharge"),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          cachedNetworkImageCircular(context, _redeem.toUserModel.photo),
          SizedBox(height: 20,),
          Text("${_redeem.toUserModel.fName + " " + _redeem.toUserModel.nName}", style: fldarkgrey22,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Text("will get ${widget.diamond} diamonds, and diamonds will be deducted from your diamond bank",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'Segoe',
                fontSize: 12,
              ),
              textAlign: TextAlign.center,),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/gift/dimond_blue.png',width: 20,height: 20,),
              SizedBox(width: 5,),
              Text('${widget.diamond}',
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Segoe',
                    fontWeight: FontWeight.w400,
                    color: Colors.blueAccent
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Text("Are you sure?",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'Segoe',
                fontSize: 18,
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
                FocusScope.of(context).unfocus();
                setState(() {
                  showSpiner = true;
                });
                rechargeDiamond();

              //  Navigator.of(context).pushNamed('/bankTransactionScreen',arguments : {'diamond' : diamond});
              },
            ),
          ),
        ],
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
        //  Navigator.of(context).pop();
        }
    )..show();
  }
}

