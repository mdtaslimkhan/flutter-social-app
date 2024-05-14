import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/index.dart';
import 'package:chat_app/ui/pages/login/email_login/email_login.dart';
import 'package:chat_app/ui/pages/login/google_login.dart';
import 'package:chat_app/ui/pages/login/login_methods.dart';
import 'package:chat_app/ui/pages/login/register.dart';
import 'package:chat_app/util/constants.dart';
import 'package:chat_app/util/loading/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../../../util/api_request.dart';


class LoginOption extends StatefulWidget {
  @override
  _LoginOptionState createState() => _LoginOptionState();
}

class _LoginOptionState extends State<LoginOption> {
  bool isChecked = false;
  Map<String, dynamic> _udata;
  AccessToken _accessToken;
  bool _checking = true;
  LoginMethods loginMethods = LoginMethods();
  bool _loading = false;



  fblogincheck() async{
    final aToken = await FacebookAuth.instance.accessToken;
    setState(() {
      _checking = false;
    });
    if(aToken != null){
      print(aToken.toJson());
      final _data = await FacebookAuth.instance.getUserData();
      _accessToken = aToken;
      setState(() {
        _udata = _data;
      });
    }else{

    }
  }

  _login(BuildContext context) async {
   // await FacebookAuth.instance.logOut();
    setState(() {
      _loading = true;
    });
    final result = await FacebookAuth.instance.login();
    if(result.status == LoginStatus.success){
      _accessToken = result.accessToken;
      print("access token");
      final dt = await FacebookAuth.instance.getUserData();
      _udata = dt;
      print(dt["name"]);
      print(dt["email"]);
      print(dt["picture"]["data"]["url"]);
      print(dt["mobile_phone"]);
      print(dt);
      final UserModel user = await ApiRequest.facebookLogin(number: checkNull(dt["email"]), name: checkNull(dt["name"]), photo: checkNull(dt["picture"]["data"]["url"]), phone: checkNull(dt["mobile_phone"]));
      if (user != null) {
        // for firebase user only
        print("priont a hktl fjk asdf4564");
        await ApiRequest.getFutureInfo();
        await loginMethods.setUser(user);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Index(user: user)), (route) => false);
      }

    }
  }




  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }
    return LoadingImage(
      inAsyncCall: _loading,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 280.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.blueAccent, Colors.lightBlueAccent],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.all(10.0),
                        child: Text(
                          'Welcome \nto \nCR',
                          style: TextStyle(
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SegoeLight',
                              color: Colors.white
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Text(
                        'Login or Register now',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SegoeLight',
                            color: Colors.white
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Positioned(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  fillColor: MaterialStateProperty.resolveWith(getColor),
                                  value: isChecked,
                                  onChanged: (bool value) {
                                    setState(() {
                                      // isChecked = value;
                                      // print(value);
                                    });
                                  },
                                ),
                                Text("Agree with terms and conditions", style: fldarkgrey15,)
                              ],
                            ),
                          ),
                          GestureDetector(
                            child: Align(
                                child: Container(
                                  width: 280,
                                  height: 40,
                                  color: Colors.transparent,
                                )
                            ),
                            onTap: (){
                              print("detected");
                              applyagreement(context);
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      ButtonTheme(
                        minWidth: 280.0,
                        child: ElevatedButton(
                          onPressed: !isChecked ? null : () async {
                            Navigator.push(context, MaterialPageRoute(builder: (parentContext) => EmailLogin()));
                          },
                          child: Text(
                            'Login with email',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Sego',
                                fontSize: 18.0
                            ),
                          ),

                        ),
                      ),

                      // SizedBox(height: 10.0),
                      // ButtonTheme(
                      //   minWidth: 280.0,
                      //   child: ElevatedButton(
                      //     onPressed: !isChecked ? null : () async {
                      //       Navigator.push(context, MaterialPageRoute(builder: (parentContext) => GoogleLogin()));
                      //     },
                      //     child: Text(
                      //       'Login with Google',
                      //       style: TextStyle(
                      //           color: Colors.white,
                      //           fontFamily: 'Sego',
                      //           fontSize: 18.0
                      //       ),
                      //     ),
                      //
                      //   ),
                      // ),
                      SizedBox(height: 10.0),
                      ButtonTheme(
                        minWidth: 280.0,
                        child: ElevatedButton(
                          onPressed: !isChecked ? null : () async {
                            _login(context);
                          },
                          child: Text(
                            'Login with facebook',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Sego',
                                fontSize: 18.0
                            ),
                          ),

                        ),
                      ),
                      SizedBox(height: 10.0),
                      ButtonTheme(
                        minWidth: 280.0,
                        child: ElevatedButton(
                          onPressed: !isChecked ? null : () async {
                            Navigator.push(context, MaterialPageRoute(builder: (parentContext) => Register()));

                          },
                          child: Text(
                            'Login with phone number',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Sego',
                                fontSize: 18.0
                            ),
                          ),

                        ),
                      ),

                    ],
                  ),
                ),
                SizedBox(height: 30.0),


              ],
            ),
          ),
        ),
      ),
    );
  }

  applyagreement(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context){
          return SimpleDialog(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                child: Column(
                  children: [
                    Text("CR Privacy and policy, Terms and conditions",style: fldarkgrey18,),
                    Text("Please read carefully before login",style: fldarkgrey15,),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        children: [
                          TextSpan(
                              text: 'Acceptance of the Policy \n'
                                  ' The privacy and security of your personal information is of utmost importance to the Circle of rectitude(CR). The services that CR(Circle of rectitude) provides to you are subject to the following Policy ("Policy"). This Policy applies to all CR(Circle of rectitude) sites within "gumoti.com" domain name. The most current version of the Policy can be reviewed by clicking on the "Privacy Policy" hypertext link located at the footer of our Web pages and by accepting it.\n\n'


                                  'Description of Services\n'
                                  ' Through its network of Web properties, CR(Circle of rectitude) provides you with access to a variety of resources, including our public website, extra net, web services, download areas, communication forums and product information ("Services"). The Services include any updates, enhancements, new features, and/or the addition of any new site for the work of the organization.\n\n'


                                  ' Unlawful or Prohibited Use\n'
                                  'As a condition of your use of the Services, you will not use the Services for any purpose that\n\n'
                                  'is unlawful or prohibited by these terms, conditions, and notices. You may not use the Services in any manner that could damage, disable, overburden, or impair any CR(Circle of rectitude) server, or the network(s) connected to any CR(Circle of rectitude) server, or interfere with any other party\'s use and enjoyment of any Services. You may not attempt to gain unauthorized access to any Services, other accounts, computer systems or networks connected to any CR(Circle of rectitude) server or to any of the Services, through hacking, password mining or any other means. You may not obtain or attempt to obtain any materials or information through any means not intentionally made available through the Services.\n\n'

                                  'How CR(Circle of rectitude) uses your data\n\n'
                                  'The personal data that CR(Circle of rectitude) collects is used:\n\n'
                                  'to provide you information that you have requested or which may be relevant to a subject in which you have demonstrated an interest;\n\n'
                                  'to fulfil an obligation or agreement that CR(Circle of rectitude) have entered into with you or with the entity that you represent;\n\n'
                                  'to ensure the security and safe operation of our websites and underlying infrastructure, and to manage any communication between you and us.\n\n'
                                  'We do not sell your data or share your data with third parties.\n\n'

                                  'Member Account, Password, and Security\n\n'
                                  'You may use our Public website without providing any personal information to us. The information gathered during general browsing of the "gumoti.com" domain is used to analysis trends and usage of the CR(Circle of rectitude) sites and to improve the usefulness of the sites. It is not connected with any personal information.\n\n'

                                  'If any of our Services requires you to open an account, you must complete the registration process by providing us with current, complete and accurate information as prompted by the applicable registration form. You also will choose a password and a user-name. You are entirely responsible for maintaining the confidentiality of your password and account. Furthermore, you are entirely responsible for any and all activities that occur under your account. You agree to notify CR(Circle of rectitude) immediately of any unauthorized use of your account or any other breach of security. CR(Circle of rectitude) will not be liable for any loss that you may incur as a result of someone else using your password or account, either with or without your knowledge. However, you could be held liable for losses incurred by CR(Circle of rectitude) or another party due to someone else using your account or password. You may not use anyone else\'s account at any time, without the permission of the account holder.\n\n'


                                  'Personal and Non-Commercial Use Limitation\n'
                                  'Unless otherwise specified and authorized by the CR(Circle of rectitude), the Services we provide are for your personal and non-commercial use. You may not modify, copy, distribute, transmit, display, perform, reproduce, publish, license, create derivative works from, transfer, or sell any information, software, products or services obtained from the Services. Specifically, this includes a prohibition on the unauthorized use of automated software to retrieve, display, copy, store or otherwise use data obtained from our Services.\n\n'



                                  'Security measures\n'
                                  'Our information security management system (ISMS) is certified to ISO/IEC 27001. We have what we believe are appropriate security controls in place to protect personal data. We do not share your information outside CR(Circle of rectitude) and will not use your information in ways other than those set forth in this Policy. Risk assessment, including assessing risks to the data, is at the heart of our ISMS. However, we do not have any control over what happens between your device and the boundary of our information infrastructure. You should be aware of the many information security risks that exist and take appropriate steps to safeguard your own information.\n\n'

                                  'All our employees who have access to, and are associated with the processing of personal data, are obliged to respect the confidentiality of official business matters, including personal data.\n\n'

                                  'The CR(Circle of rectitude) site contains links to sites external to the quickchatting.gumoti.com domain. CR(Circle of rectitude) is not responsible for the privacy practices or the content of such sites.\n\n'


                                  'Managing your data\n'
                                  'You may access a copy of the personal data we hold about you. In order to process your request, please email privacy@gumoti.com or privacy@circleofrectitude.com We will ask you to provide proof of identification for verification purposes. Once we have verified your identity, we will provide access to the personal data we hold about you.\n\n'
                                  'When you believe we hold inaccurate or incomplete personal information about you, you may correct or complete this data.\n\n'
                                  'You may request that we delete your personal data. This includes personal data that you may have provided to us. We will take all reasonable steps to ensure erasure.\n\n'

                                  'Changes to this Policy\n'
                                  'This Policy will be updated from time to time and the updated version will be available on our web services under our "Privacy Policy".\n\n'

                                  'Liability Disclaimer\n'
                                  'Any usage of CR(Circle of rectitude) websites and related web services on quickchatting.gumoti.com domain implies acknowledgment and acceptance of the terms set out in the privacy policy, the most current version of which can be accessed by clicking on the "privacy policy" hypertext link located at the footer of this Web pages.\n\n'
                                  'Welcome to CR \n'
                                  'CR considers your privacy seriously. We are committed to offering comfort in social media by protecting user rights, especially a sense of security when surfing and making video, audio and meeting calls. Personal policy in assisting profiles and accounts. This privacy policy explains how we collect feedback or any issue related to service of how user download, install, and register account, purchase, or use CR application to communicate, job search, online shop and NGO charity action. Our service provided applications on various mobile operating systems, iOs, Windows. Further information visit circleofrectitude.com or CR Public Service Account Platform.\n\n'
                                  'PLEASE READ CR APP POLICIES CAREFULLY AS IT DESCRIBES OUR PRIVACY POLICIES AND PRACTICES. IF YOU DO NOT AGREE WITH OUR PRIVACY POLICIES AND PRACTICES, DO NOT DOWNLOAD, INSTALL, REGISTER, OR USE THE SERVICE.  BY DOWNLOADING, INSTALLING, REGISTERING AND USING CR, YOU WILL BE REQUIRED TO CONFIRM THAT YOU HAVE READ, UNDERSTOOD, AND AGREE TO COMPLY WITH OUR POLICY. USERS WILL GET THE NOTIFICATION IF THIS POLICY CHANGE FROM TIME TO TIME ACCORDING TO THE NEEDS AND FEEDBACK RECEIVED FROM USERS. BY CLICKING THE ‘I AGREE’ AND CONTINUING TO USE CR SERVICE AFTER YOU ARE NOTIFIED OF ANY CHANGES, YOU ALREADY ACCEPT AND AGREE TO THOSE CHANGES CONTENTS: About CR Teamwork Thanks for using CR service. \n\n'
                                  'We brought to you by Circle of Rectitude Organization, Head Office placed in Dhaka Bangladesh. How the CR enforces policies on users When you access and use our app, you already agree by clicking the “I agree” means you already bound with; CR privacy and policy, CR Terms of Service.  We are committed to protecting user privacy and providing a safe and secure environment for our users. Policies are strictly enforced and account use prohibitions will be made for those that have violated the stipulated conditions. Information, Feedback and Response We need to collect your personal data to provide support, improve, market the service. Direct information that we get automatically when you access our app collect from log data, ID addresses, overall user data and your history activates in CR app.  \n\n'
                                  'We use your personal data for legitimate interest to improve the service and to comply your feedback. In addition we protect your fundamental rights and freedoms.  We will not misuse your personal identity for things that violate the law and consumer rights. Cookies To remember your preferences and to distinguish you from other users of the Service and the distribution platform (App Store and Play Store), we use cookies and/or other similar technologies. Further information you can check our Cookie Policy. Application integration Your data will be keep safely. According to our Policy which permitted to do by law, we will share your personal data in certain condition: Legal process or to comply with relevant laws investigations. Legal rights to defend against a legal claim, and violation of our Terms of Service and our policies or agreement. \n\n'
                                  'We provide your personal data information to CR Teamwork whom are bound by all of the confidentiality and other data processing protections. We use your personal information strictly to carry out job duties on a need-to-know basis, and only do so as required by law and as required by our legitimate interest. Your information provide for our Vendors to maintain the confidentiality of your data to take appropriate measures to keep it secure. They will periodically access our web server and/or employ analytics technologies during the course of their work that may automatically collect and store the user general information; originating name of the domain from which you access the internet, the date and time you access the services, the page you visit, the website address which you linked directly to the service, the type of device, device ID, and browser. \n\n'
                                  'By using your personal information we will improve the service by tabulating statistics of any access issue. Other CR users. We may disclose your personal data in response to your request to share photos, videos, stories, or posts. Affiliated Third Parties. We will share your information to Affiliated Third Parties to respond to Affiliated Third Parties.your feedback, issue report, request, and any support and answer your questions. Unaffiliated Third Parties. We will share your personal information with unaffiliated third   parties according to your consent. Corporate Change. Since you checked ‘I agree’ and use our service, your personal data being one of our assets. To keep the corporate exist, we have rights to use our assets in connection with a merger, reorganization, or sale of assets without your permission. Collected Data. We use your personal \n\n'
                                  'information to be used for informational purposes, new product development, marketing, and/or promotional purposes, without seeking additional consent from you. Advertisers. Affiliated Third Parties allow to collect the advertising identifier and IP address from your mobile device and to set tracking tools on your browser (e.g. cookies) in order to collect information regarding to your history activities. We share de-identified information for purposes of delivering targeted advertisements to you when you visit non-CR websites within their networks. Opt-Out receiving communication You have the rights to Pot-Out of certain uses and disclosures of your personal information, as discussed below; Emails and Instant Messaging (IM) You have rights and option to receive or not our marketing email. You can set unsubscribe link found at the bottom of the email to Opt-Out. \n\n'
                                  'To provide certain transaction-related communication regarding updates or Privacy Policy, we use email or in-app messaging to respond to customer service.  Mobile Device Opt-Out Notification You are allow to change the settings on your mobile device to choose Opt-Out from our service notification. DNT “Do Not Track” Users can set DNT in certain web browsers and devices, so you cannot be tracked. Advertising System Based-On User Interest CR provide Opt-Out in limiting the advertising tracking via advertising identifiers through your mobile device’s privacy settings. Rights of access, fixes, deletions, and restrictions You have access to and control over your personal data at any time, at no charge. CR will respond to all legitimate requests regarding your personal information within one month. We will keep you notify and keep you updated.  \n\n'
                                  'CR will ask your information to identify your account before granting your access to or making any changes to your personal information by certain requirements.  Access As required by law or to protect the legal rights of others, there are certain exceptions in granting the access. We grant any request from you to download, navigate account info of yours.  Fixes You can contact us to give accurate information, and you may edit your account information via the service. Deletions You have legal rights to delete your personal information, chat history, and/or entire CR’s account by selecting the option setting. And we may delete your personal information if we believe it is incomplete, inaccurate, or that our continued storage of your personal information is contrary to our legal obligations or business objectives. \n\n'
                                  'Restrictions You have rights under applicable law to ask us to erase or restrict our use of your personal information. If you require the direct transfer of data to another responsible party, this will only be done to the extent technically feasible. Changing the permissions and settings on your mobile device or within the service may cause certain features of the service to stop functioning. Let us know if you wish to change personal information, or if you want us update your information or edit your account information.  We are not responsible for any losses arising from any inaccurate, inauthentic, deficient or incomplete personal data that you provide to us. User Data Our app is uploading users’ contact list information to “ADMIN PANNEL”  \n\n'
                                  'website to give them virtual badges and virtual gifts as well as identify which number or ID they are violating community guidelines and block/BANED  them from that number. Data Retention Retaining your personal information needed to fulfill the purposes for which it was collected and to provide the service to you; as long as it necessary to comply with our business requirements and legal obligations, to resolve disputes, to protect our assets, to provide our services, and to enforce our agreements. Data will improve the service for better understand our users’ interest, analyze trends, and customize the user experience. Data security To prevent your personal information for being used indiscriminately, based on our Privacy and Policy, \n\n'
                                  'we maintain appropriate technical and organizational measures. Your information is stored in secure, limited access servers behind firewalls. Personal data and information is also password-protected also secure, so that only you can log in to your account.  Anyhow, no security systems is perfect and we cannot guarantee that unauthorized third parties will not be able to access and/or use your personal information for improper purposes. Do not share password and personal number with strangers carelessly.  The safety and security of your personal information also depends on you. You must use a password for access to restricted parts of the Service, you are responsible for keeping the password confidential. \n\n'
                                  'Please ensure that, when using this app, you do not submit any personal data that you do not want to be seen, collected or used by other users. Personal Data transfer Your personal data and information will be transferred in accordance with the requirements of applicable law.  CR Head Office located in Dhaka, Bangladesh. We store and process your personal data on servers in the Bangladesh, Arab Saudi, and Indonesia. Be aware that your personal data and information is transferred to, stored in, and processed in these countries which may not have the same adequate level of data protection as in your home country.  If you do not agree to the transfer data system, you must not use the Service. \n\n'
                                  'Children’s privacy Children under 13 years of age are not allow to use this app directly. CR does not knowingly collect children personal data. If your children provided us with personal information without your consent, you may “Delete CR Account” or contact us at circleofrectitude@gmail.com . we will immediate delete the account. Rights and Responsible If you have any feedback and questions about our privacy and policy practices, please contact us by email at circleofrectitude@gmail.com or via the methods listed below. We will address your concerns and attempt to resolve any privacy issues in a timely manner. Change of Privacy Policy User must providing us an active, up-to-date email address to inform any notification related any change of our Privacy Policy, you will be asked to check \n\n'
                                  '“I agree” option confirm that you have read, understand, and agree to the updated terms. CR App’s Contact We will collect your contact information will be stored in CR server and google server to use in future to give you better social media experience. If you do not want to share your contact information then DO NOT DOWNLOAD THIS CR application and DO NOT INSTALL THIS CR application.   We will read your contact from your phone and will use it to find other known person from our application who are using this application so you can communicate with your contact listed friends.   '
                                  'We basically connect the user’s contact number “ADMIN PANNEL”  website to give them virtual badges and virtual gifts as well as identify which number or ID they are violating community guidelines and block/BANED  them from that number. Feedback For feedback, questions, comments about policy providing by us related to your personal data and information, please use the contact details below and we will response and do effort to give best service to you:\n\n'


                          )
                        ],
                      ),
                      textWidthBasis: TextWidthBasis.longestLine,
                    ),
                    SizedBox(height: 10,),
                    MaterialButton(
                      child: Text("I agree with terms and condition", style: ftwhite18,),
                      color: Colors.green,
                      onPressed: (){
                        setState(() {
                          isChecked = true;
                        });
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              ),
            ],
          );
        }
    );
  }
}
