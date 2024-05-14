import 'package:flutter/material.dart';

class group_rules extends StatelessWidget {
  const group_rules({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      padding: EdgeInsets.fromLTRB(5,0,5,0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xffEAEBF3),
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
              blurRadius: 0,
              offset: Offset(1, 1),
              color: Colors.black45.withOpacity(0.3),
              spreadRadius: 1),
        ],
        border: Border.all(
          color: Colors.white,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(3,8,3,8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 5,),
            Text('1'),
            SizedBox(width: 5,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "About",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Welcome to all about cr group. This is the group there we help the people to make a circle."
                        "story chat and fun. You can join with us... ",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

