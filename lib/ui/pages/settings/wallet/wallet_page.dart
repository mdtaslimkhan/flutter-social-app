import 'package:chat_app/provider/user_provider.dart';
import 'package:chat_app/ui/pages/settings/wallet/provider/balance_provider.dart';
import 'package:chat_app/ui/pages/settings/wallet/redeem/widgets/balanceWidgets.dart';
import 'package:chat_app/ui/pages/settings/wallet/redeem/widgets/wallet_items.dart';
import 'package:chat_app/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WalletPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    BalanceProvider _redeem = Provider.of<BalanceProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Wallet page"),),
        body: Column(
          children: [
            Container(
              color: Colors.blue,
              child: Column(
                children: [
                  SizedBox(height: 16,),
                  Text("Current balance", style: ftwhite20,),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: CurrentDiamond(text: 'Diamonds', amount: _redeem.diamond,color: Colors.blue, img: 'assets/gift/dimond_blue.png',),
                      ),
                      SizedBox(width: 10,),
                      Container(
                        child: CurrentDiamond(text: 'Gems', amount: _redeem.gems,color: Colors.amber,  img: 'assets/gift/gem.png',),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: CurrentDiamond(text: 'Bank', amount: _redeem.bankDiamond, color: Colors.green, img: 'assets/gift/dimond_blue.png',),
                      ),
                      SizedBox(width: 10,),
                      Container(
                        child: CurrentDiamond(text: 'Castle', amount: 0,color: Colors.red, icon: Icons.import_contacts),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                ],
              ),
            ),
            SizedBox(height: 20,),

            Container(
              margin: EdgeInsets.all(16),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(new Radius.circular(10.0)),
                  border: Border.all(
                    color: Colors.white,
                    width: 2.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    Text("Services", style: fldarkgrey20,),
                    SizedBox(height: 10,),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 1,
                      runSpacing: 1,
                      children: [
                        WalletItem(color: Colors.blueAccent,text: "Recharge",icon: Icons.alt_route_sharp,
                          onPress: (){
                            Navigator.of(context).pushNamed('/rechargeScreen',arguments: {});
                          },
                        ),
                        WalletItem(color: Colors.amber,text: "Send",icon: Icons.send,
                          onPress: () {
                            Navigator.of(context).pushNamed('/sendBankDiamond',arguments: {});
                          },
                        ),
                        WalletItem(color: Color(0xFF073E93),text: "Redeem",icon: Icons.repeat_sharp,
                          onPress: () {
                          Navigator.of(context).pushNamed('/redeemPage',arguments: {});
                          },
                        ),
                        WalletItem(color: Colors.red,text: "Shopping",icon: Icons.shopping_bag,),
                        WalletItem(color: Colors.amber,text: "Bill pay",icon: Icons.payment,),
                        WalletItem(color: Color(0xFF073E93),text: "Free",icon: Icons.card_giftcard,),
                        WalletItem(color: Colors.red,text: "Nobel",icon: Icons.check_box,),
                        WalletItem(color: Colors.blueAccent,text: "Top up",icon: Icons.monetization_on,),
                      ],
                    ),
                    SizedBox(height: 20,),
                  ],
                )
            ),






          ],
        )
    );
  }
}
