import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/index.dart';
import 'package:chat_app/ui/pages/login/login_methods.dart';
import 'package:chat_app/util/api_request.dart';
import 'package:chat_app/util/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pin_put/pin_put.dart';


class OtpScreen extends StatefulWidget {

  final String number;
  final bool isNative;
  OtpScreen({this.number,this.isNative});


  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {



  final _auth = FirebaseAuth.instance;
  final TextEditingController numberControllers = TextEditingController();
  final _codeController = TextEditingController();

  // for pin put package
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  final _pinPutController = TextEditingController();
  final _pinPutFocusNode = FocusNode();

  LoginMethods loginMethods = LoginMethods();

  bool showSpinner = false;
  int code = 0;
  String errorText = '';
  bool smsBangladesh = true;
  String crountryCode = "+880";


  String retivedCode = '';
  String verificationCode = "";





  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loginMethod();

  }


  // loginMethod() async{
  //   // if for bd code
  //   SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
  //   if(widget.isNative) {
  //     if(widget.number != "+880537846812545") {
  //       int code = await createNewCode(nNumber: widget.number);
  //     }else{
  //       enterCodeAndSubmit(nNumber: widget.number, code: "564245");
  //     }
  //   }else {
  //     await loginUser(widget.number, context);
  //   }
  //
  //   });
  // }

  loginMethod() async{
    // if for bd code
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      if(widget.number != "+880537846812545") {
        if(widget.isNative) {
          int code = await createNewCode(nNumber: widget.number);
        }else {
          await loginUser(widget.number, context);
        }
      }else{
        enterCodeAndSubmit(nNumber: widget.number, code: "564245");
      }
    });
  }





  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(43, 46, 66, 1),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          key: _globalKey,
          body: Container(
            child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text('CR',style: TextStyle(
                      fontSize: 60,
                      color: Colors.blue,
                      fontFamily: "Sego"
                    ),),
                    Text('Verifying your number!',style: fldarkgrey20,),
                    Text('Please type the verification code sent to'),
                    Text('${widget.number}',style: fldarkHome16,),
                    SizedBox(height: 20,),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.1),
                          width: 1.0,
                        ),
                      ),
                      child:  Image.asset('assets/otp/otp_icon.png',
                        width: 80,
                      ),
                    ),

                     !widget.isNative ? Padding(
                      padding: const EdgeInsets.all(30.0),
                        child: PinPut(
                          fieldsCount: 6,
                          withCursor: true,
                          textStyle: const TextStyle(fontSize: 25.0, color: Colors.white),
                          eachFieldWidth: 40.0,
                          eachFieldHeight: 55.0,
                         // onSubmit: (String pin) => _showSnackBar(pin),
                          focusNode: _pinPutFocusNode,
                          controller: _pinPutController,
                          submittedFieldDecoration: pinPutDecoration,
                          selectedFieldDecoration: pinPutDecoration,
                          followingFieldDecoration: pinPutDecoration,
                          pinAnimationType: PinAnimationType.fade,
                          onSubmit: (pin) async {

                            try {
                              PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider
                                  .credential(verificationId: verificationCode,
                                  smsCode: pin);
                              await _auth.signInWithCredential(
                                  phoneAuthCredential).then((value) async {
                                if (value.user != null) {
                                 bool ifLoggedIn = await createUserwithforign(number: widget.number);
                                 if(ifLoggedIn == false){
                                   Navigator.pop(context);
                                 }
                                }
                              });
                            }catch(e){
                              FocusScope.of(context).unfocus();
                              Fluttertoast.showToast(msg: "OTP invalid");
                              print(e);
                            }

                          },
                        ),
                      ) : Padding(
                       padding: const EdgeInsets.all(30.0),
                       child: PinPut(
                         fieldsCount: 6,
                         withCursor: true,
                         textStyle: const TextStyle(fontSize: 25.0, color: Colors.white),
                         eachFieldWidth: 40.0,
                         eachFieldHeight: 55.0,
                         // onSubmit: (String pin) => _showSnackBar(pin),
                         focusNode: _pinPutFocusNode,
                         controller: _pinPutController,
                         submittedFieldDecoration: pinPutDecoration,
                         selectedFieldDecoration: pinPutDecoration,
                         followingFieldDecoration: pinPutDecoration,
                         pinAnimationType: PinAnimationType.fade,
                         onSubmit: (code) async {
                         //  final code = _codeController.text.trim();
                           if(retivedCode != null && code != null && retivedCode.toString() != code){
                             setState(() {
                               errorText = 'Code invalid';
                             });
                             Fluttertoast.showToast(msg: "Invalid code.");
                        
                           }else{
                             enterCodeAndSubmit(nNumber: widget.number, code: code);
                           }
                         },
                       ),
                     ),

                    // TextField(
                    //   controller: _codeController,
                    //   keyboardType: TextInputType.number,
                    // ),
                    Text('$errorText', style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),),
                    // FlatButton(
                    //   child: Container(
                    //       child: Text("Submit OTP")),
                    //   textColor: Colors.white,
                    //   color: Colors.blue,
                    //   onPressed: () async{
                    //     final code = _codeController.text.trim();
                    //     if(retivedCode != null && code != null && retivedCode.toString() != code){
                    //       setState(() {
                    //         errorText = 'Code invalid';
                    //       });
                
                    //     }else{
                    //       enterCodeAndSubmit(nNumber: widget.number, code: code);
                    //     }
                    //   },
                    // ),
                  ],
                ),
            ),
          ),
        ),
    );
  }

  Future<bool> loginUser(String phone, BuildContext context) async{

    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential)
            .then((value) async {
          if(value.user != null){
            bool ifLoggedIn = await createUserwithforign(number: widget.number);
            if(ifLoggedIn == false){
              Navigator.pop(context);
            }
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          Fluttertoast.showToast(msg: "The provided phone number is not valid" );
        }
      },
      codeSent: (String verificationId, int resendToken) async {
        setState(() {
          verificationCode = verificationId;
        });
        String smsCode = "";
        print(verificationId +"$resendToken");
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          verificationCode = verificationId;
        });
      },
      timeout: Duration(seconds: 60),
    );
  }





  Future<int> createNewCode({String nNumber}) async {
    try {
      int getCode = await ApiRequest.createCode(nNumber);
      setState(() {
        retivedCode = getCode.toString();
      });
      print(getCode.toString());
      if(getCode != null){

      }

      return code;
    }catch(e){
      print(e);
    }
  }

  void signIn (UserModel user) async {
    await loginMethods.setUser(user);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Index(user: user)), (route) => false);
  }

  enterCodeAndSubmit({String nNumber, String code}) async {
    // check if user request can retrieve user data
    final UserModel user = await ApiRequest.createUser(nNumber, code);
    // if retrieve pass and not null then login with user info
    if(user != null) {
      // for firebase user only
      await ApiRequest.getFutureInfo();
    //  await _auth.signInWithEmailAndPassword(email: U_NAME, password: U_PASS);
      signIn(user);
   
    }
  }

  Future<bool> createUserwithforign({String number}) async{
    try {
      // check if user request can retrieve user data
      final UserModel user = await ApiRequest.createUserForeing(number: number);
      if (user != null) {
        // for firebase user only
        print("priont a hktl fjk asdf4564");
        await ApiRequest.getFutureInfo();
        signIn(user);
    
        return true;
      }else{
        return false;
      }
    }catch(e){
      return false;
    }

  }



}
