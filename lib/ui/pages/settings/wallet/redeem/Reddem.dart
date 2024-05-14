import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chat_app/ui/pages/settings/wallet/model/redeem_diamond.dart';
import 'package:chat_app/ui/pages/settings/wallet/provider/balance_provider.dart';
import 'package:chat_app/ui/pages/settings/wallet/redeem/widgets/balanceWidgets.dart';
import 'package:chat_app/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';


class Redeempage extends StatefulWidget {
  Redeempage({Key key}) : super(key: key);

  @override
  _RedeempageState createState() => _RedeempageState();
}

class _RedeempageState extends State<Redeempage> {

  @override
  Widget build(BuildContext context) {

    BalanceProvider _redeem = Provider.of<BalanceProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Title(color: Colors.black, child: Text("Redeem diamonds")),
      ),
      body: Column(
        children: [
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                child: CurrentDiamond(text: 'Diamond', amount: _redeem.diamond, color: Colors.blue, icon: Icons.import_contacts),
              ),
              Container(
                child: CurrentDiamond(text: 'Gems', amount: _redeem.gems, color: Colors.blue, icon: Icons.import_contacts),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            height: 1,
            margin: EdgeInsets.all(0),
            width: MediaQuery.of(context).size.width,
            color: Colors.black.withOpacity(0.1),
          ),
          SizedBox(height: 20),
          Column(
            children: _redeem.gemslist.map((RedeemDiamond e) =>
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: 16,top: 5),
                              width: 18,
                              child: Image.asset('assets/gift/dimond_blue.png')
                          ),
                          SizedBox(width: 10),
                          Text('${e.diamond}',style: fldarkgreyLight12),
                          Expanded(child: Container()),
                          InkWell(
                            onTap: (){
                              Navigator.of(context).pushNamed('/redeemConfirm',arguments : {'diamond' : e.diamond, 'gem': e.gem});
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Container(
                                alignment: Alignment.center,
                                height: 30,
                                width: 120,
                                margin: EdgeInsets.only(right: 16),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(7)),
                                child: Text("${e.gem} GEMS",
                                  style: fldarkgreyLight12,
                                ),
                              ),
                            ),
                          )
                        ],
                    ),
                    Container(
                      height: 1,
                      margin: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black.withOpacity(0.1),
                    ),

                  ],
                ),
            ).toList(),
          ),
        ],
      ),
    );
  }
}
