import 'package:flutter/material.dart';


class LabelText extends StatelessWidget {

  final String text;
  LabelText({this.text});

  @override
  Widget build(BuildContext context) {
    return  Container(
      child: Column(
        children: [
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 18,),
              Text("$text: "),
            ],
          ),
        ],
      ),
    );
  }
}
