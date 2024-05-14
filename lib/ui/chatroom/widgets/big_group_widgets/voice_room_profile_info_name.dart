import 'package:chat_app/model/quotes.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/widget/profile_widgets.dart';
import 'package:flutter/material.dart';

class VoiceRoomProfileInfoUserNameRow extends StatelessWidget {
  final UserModel user;
  VoiceRoomProfileInfoUserNameRow({this.user});
  @override
  Widget build(BuildContext context) {
    return  Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(48),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 16,
                        offset: Offset(0, 8),
                        color: Colors.green,
                        spreadRadius: -10)
                  ],
                  border: Border.all(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
                child: IconButton(
                  icon: Image.asset('assets/profile/crown_main.png'),
                  onPressed: null,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10,0,10,0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(48),
                  border: Border.all(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(3,2,3,2),
                  child: Text(
                    "Level ${user.level != null ? user.level : '0'}",
                    style: TextStyle(
                      fontSize: 8,
                      color: Color(0xFFffffff),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 20,),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 180,
                    child: Text(
                      "${user.nName} ${user.fName}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w600,
                          fontSize: 22
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 5),
                  user.isVerified != null ? Image.asset(
                    'assets/profile/check2.png',
                    width: 12,
                  ) : Text(''),
                ],
              ),
              Wrap(
                spacing: 3,
                children: badgeEarned.map((data) =>
                    badgeEarnedTemplate(data)
                ).toList(),
              ),
            ],
          ),
          SizedBox(width: 20,),
          Column(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(48),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 16,
                          offset: Offset(0, 8),
                          color: Colors.green,
                          spreadRadius: -10)
                    ],
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    )
                ),
                child: IconButton(
                  icon: Image.asset('assets/profile/flag_bd.png'),
                  onPressed: null,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(3,0,3,0),
                decoration: BoxDecoration(
                  color: Color(0xFFfbc81e),
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(
                    color: Colors.white,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(3,2,3,2),
                  child: Row(
                    children: [
                      Icon(
                        Icons.remove_red_eye,
                        size: 12,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "100",
                        style: TextStyle(
                          fontSize: 8,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

  }


  // badges earned
  List<Quotes> badgeEarned = [
    Quotes(0, 'Gifts' , 'Hello, Assalamualikum, Kemon asen?'),
    Quotes(1, 'Visitors' , 'Hello, Assalamualikum, Kemon asen?'),
    Quotes(2, 'Groups' , 'Hello, Assalamualikum, Kemon asen?'),
  ];


}
