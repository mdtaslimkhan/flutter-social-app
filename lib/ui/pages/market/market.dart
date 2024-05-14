import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/pages/error/no_data_found.dart';
import 'package:flutter/material.dart';

class Market extends StatefulWidget {

  final UserModel user;
  Market({this.user});
  
  @override
  _MarketState createState() => _MarketState();
}

class _MarketState extends State<Market> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Market'),),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height-120,
                    color:  Colors.blue.withOpacity(0.1),
                    child: Center(
                        child: NoDataFound(),
                    ),
                ),
              ],
            ),
          )
      ),
    );
  }
}
