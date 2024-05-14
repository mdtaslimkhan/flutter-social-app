
import 'package:chat_app/util/constants.dart';
import 'package:flutter/material.dart';



class RechangeConfirmation extends StatelessWidget {

  final int amount;
  final int diamond;
  RechangeConfirmation({this.amount, this.diamond});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Confirm recharge amount"),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/gift/dimond_blue.png',width: 100,height: 100,),
          Text('$diamond',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${amount}',
                style: TextStyle(
                    fontSize: 40,
                    fontFamily: 'Segoe',
                    fontWeight: FontWeight.w400,
                    color: Colors.redAccent
                ),
              ),
              SizedBox(width: 5,),
              Text('Tk'),
            ],
          ),

          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Text("Recharge rate will be 2 diamonds with 1 Tk. Your conversion will be ${diamond} diamonds with ${amount} Tk.",
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
                Navigator.of(context).pushNamed('/transactionScreen',arguments : {'amount' : amount, 'diamond' : diamond});
              },
            ),
          ),
        ],
      ),
    );
  }


}

