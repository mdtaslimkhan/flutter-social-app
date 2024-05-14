import 'package:flutter/material.dart';

class TextsWidget extends StatelessWidget {
  const TextsWidget(String txt, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('With',
      style: TextStyle(
        fontSize: 10,
        color: Color(0xffffffff),
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
