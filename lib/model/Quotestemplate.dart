import 'package:flutter/material.dart';
import 'quotes.dart';

class CardWidget extends StatelessWidget {

  final Quotes quotes;
  final Function delete;
  CardWidget({this.quotes, this.delete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(0, 5.0,0, 0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0,0,15.0,0),
                      width: 45.0,
                      height: 45.0,
                      decoration: BoxDecoration(
                        color: Color(0xff7c94b6),
                        image: DecorationImage(
                          image: AssetImage('assets/u1.gif'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quotes.text,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(width: 20),
                    Text(
                      quotes.author,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),

              ],
            ),


          ],
        ),
      ),
    );
  }
}

