
import 'package:chat_app/ui/chatroom/model/gift.dart';
import 'package:chat_app/ui/chatroom/widgets/gift_widget.dart';
import 'package:chat_app/ui/pages/profile/personal_profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';

class UserGiftList extends StatefulWidget {
  final String userId;
  UserGiftList({this.userId});

  @override
  _UserGiftListState createState() => _UserGiftListState();
}

class _UserGiftListState extends State<UserGiftList> {
  ProfileController _profileController = ProfileController();


  List<Gift> gift = [];

  initData() async {
    var dtbdg = await _profileController.getGiftListData(widget.userId);
    if (dtbdg != null) {
      dtbdg.forEach((val) {
        gift.add(Gift.fromJson(val));
      });
      // initial load widgets
      setState(() {

      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black26,
        appBar: AppBar(
          title: Title(
            color: Colors.white,
            child: Text("Gift list"),
          ),
        ),
        body: SizedBox(
          // child: Wrap(
          //       direction: Axis.horizontal,
          //       children: gift.map((data) =>
          //           Container(
          //             width: MediaQuery.of(context).size.width / 4,
          //               child: GiftWidget(
          //                   chattroom: false,
          //                   gift: data
          //               ),
          //           ),
          //         //  Container(child: Text("hello"),),
          //       ).toList(),
          //     ),
          child: FutureBuilder(
            future: _profileController.getGiftListData(widget.userId),
            builder: (context, snapshot) {
              List<GiftWidget> gift = [];
              if (snapshot.hasData) {
                var dt = snapshot.data;
                if (dt != null) {
                  dt.forEach((dts) {
                    Gift giftItem = Gift.fromJson(dts);
                    gift.add(
                        GiftWidget(
                          chattroom: false,
                          gift: giftItem
                      ));
                  });
                }
              }

              return GridView.count(
                crossAxisCount: 4,
                children: gift,
              );;
            },
          ),


        ),

      ),
    );
  }
}




