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
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;


class TransactionCodeScreen extends StatefulWidget {

  final int amount;
  final int diamond;
  TransactionCodeScreen({this.amount, this.diamond});

  @override
  _TransactionCodeScreenState createState() => _TransactionCodeScreenState();
}

class _TransactionCodeScreenState extends State<TransactionCodeScreen> {

  bool showSpiner = false;
  BalanceProvider _bp;
  UserProvider _u;
  final TextEditingController numberControllers = TextEditingController();
  final TextEditingController codeController = TextEditingController();


  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _bp = Provider.of<BalanceProvider>(context, listen: false);
      _u = Provider.of<UserProvider>(context, listen: false);
    });
    super.initState();
  }


  rechargeDiamond() async {
    try {
      final String url = BaseUrl.baseUrl('requestBalance');
      var response = await http.post(Uri.parse(url),
          headers: {'test-pass': ApiRequest.mToken},
          body: {
            'user_id': _u.user.id.toString(),
            'amount': "${widget.amount.toString()}",
            'diamond': "${widget.diamond.toString()}",
            'trx' : codeController.text
          });
      if( response.statusCode == 200){
        Map data = jsonDecode(response.body);
        print("exchange test diamond");
        print(data);
        setState(() {
          showSpiner = false;
        });
        // get balance status too
        showCustomDialog(msg: data['msg'], error: data['error']);
      }else{
        showCustomDialog(msg: "Recharge error", error: true);
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
          appBar: AppBar(title: Text("Submit transaction id"),),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${widget.amount}',
                    style: TextStyle(
                      fontSize: 60
                    ),),
                    Text('Tk'),
                  ],
                ),
                SizedBox(height: 20,),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('স্টেপ ১: আপনার বিকাশ নাম্বার থেকে *২৪৭# ডায়েল করুন'),
                      Text('স্টেপ ২: সেন্ড মানি অপশন ১ চয়ন করুন'),
                      Text('স্টেপ ৩: 01400881302 নাম্বার লিখে সেন্ড চাপুন'),
                      Text('স্টেপ ৪: নিচে দেয়া পরিমান লিখুন'),
                      Text('স্টেপ ৫: রেফারেন্স ১ লিখুন'),
                      Text('স্টেপ ৬: আপনার গোপন পিন দিয়ে সেন্ড বাটন'),
                      Text('স্টেপ ৭: ফিরতি এসএমএস এ প্রাপ্ত ট্রানসেকশন আইডি নিচের ঘরে লিখে সাবমিট করুন'),
                      SizedBox(height: 20,),
                      Text('দ্রষ্টব্য: আপনার ব্যালেন্সন অনুরোধ ৩ ঘন্টার মধ্যে আপডেট করা হবে।'
                          'আপনি পর পর ৩ বার ভুল ট্রান্সসেকশন আইডি পাঠালে'
                          'আপনার একাউন্ট ব্লক হয়ে যাবে।'
                          'প্রয়োজনে যোগাযোগ করুন।',
                        textAlign: TextAlign.center,
                      ),
                      // TextFormField(
                      //   controller: numberControllers,
                      //   decoration: const InputDecoration(labelText: '1917XXXXXX Your bkash number here...'),
                      //   keyboardType: TextInputType.phone,
                      //   validator: (val) => validateMobile(val),
                      // ),
                      TextFormField(
                        controller: codeController,
                        decoration: const InputDecoration(labelText: 'KJXXXXXX Transaction number...'),
                        keyboardType: TextInputType.text,
                        validator: (val) => validateCode(val),
                      ),
                      SizedBox(height: 40,),
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
                              child: Text("Submit",
                                style: ftwhite15,
                              ),
                            ),
                          ),
                          onTap: () {
                            final String number = numberControllers.text.trim();
                            final String trx = codeController.text.trim();
                            FocusScope.of(context).unfocus();
                            print(number);
                            print(trx);
                            setState(() {
                              showSpiner = true;
                            });
                            rechargeDiamond();
                          },
                        ),
                      ),




                    ],
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }

  String validateCode(String value) {
    if (value.length == 0) {
      return 'Please enter trx number';
    }
    if (value.length > 18) {
      return 'Trx number should not be too long';
    }
    return null;
  }

  String validateMobile(String value) {
    // String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    String patttern = r'(^(?:[+0]9)?[0-9]{7,12}$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return 'Please enter mobile number';
    }
    if (value.length > 18) {
      return 'Mobile number should not be too long';
    }
    else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
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
          Navigator.of(context).pop();
        }
    )..show();
  }

}
