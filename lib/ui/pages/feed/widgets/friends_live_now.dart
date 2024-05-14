import 'package:flutter/material.dart';


Widget friendsLiveNowTemplate(data){
  // for margin or padding to adjust list horizontally
  double v =  data.id >= 2 ? 12 : 0;
  return  Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Stack(
        children: [
          Positioned(
            child: Container(
              margin: EdgeInsets.fromLTRB(v, 0, 0, 0),
              width: 85.0,
              height: 68.0,
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage('assets/profile/bg.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 3,
                      offset: Offset(2, 2),
                      color: Colors.black45,
                      spreadRadius: 1),
                ],
              ),
            ),
          ),
          Positioned(
            width: 81,
            bottom: 2,
            // v used generated margin to adjust content padding
            left: v+2,

            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                color: Color(0xff503e45bf),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Name',
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.white
                    ),
                  ),
                  SizedBox(height: 3),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Color(0xffff2a1f),
                    ),

                    child: Text(
                      'Live',
                      style: TextStyle(
                          fontSize: 6,
                          color: Colors.white
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                ],
              ),
            ),
          ),
          Positioned(
            width: 20,
            right: 10,
            top: 8,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(3)),
                color: Color(0xffff2a1f),
              ),

              child: Text(
                'New',
                style: TextStyle(
                    fontSize: 6,
                    color: Colors.white
                ),
              ),
            ),

          ),
        ],
      ),

    ],
  );
}