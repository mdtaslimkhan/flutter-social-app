import 'package:chat_app/ui/pages/settings/wallet/provider/balance_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrentDiamond extends StatelessWidget {
  final String text;
  final int amount;
  final Color color;
  final IconData icon;
  final String img;
  const CurrentDiamond({this.text,this.amount, this.color, this.icon, this.img});

  @override
  Widget build(BuildContext context) {
    final providerdataa = Provider.of<BalanceProvider>(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      width: MediaQuery.of(context).size.width / 2.5,
      height: 60,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(7)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 1,
              ),
              Text(text),
              Text(
                '$amount',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
          icon != null ? Icon(
            icon,
            color: color,
          ) : img != null ?
              Image.asset(img, width: 20, height: 20,) :
          Container(),
        ],
      ),
    );
  }
}

