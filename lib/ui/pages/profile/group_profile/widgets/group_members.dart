import 'package:flutter/material.dart';


class group_members extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(15,10,15,5),
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
          //  width: 2,
        ),
      ),
      child: Row(
        children: [
          Column(
            children: [

              Container(
                height: 70,
                width: 55,
                child: Stack(
                  children: [
                    Positioned(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/profile/user.png',
                          width: 45,
                          height: 45,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 45,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10,0,10,0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(48),
                          border: Border.all(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(3,2,3,2),
                          child: Text(
                            "Level 3",
                            style: TextStyle(
                              fontSize: 8,
                              color: Color(0xFFffffff),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Relation of ',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    'of Rectitude',
                    style: TextStyle(
                        fontSize: 10
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.fromLTRB(0,0,15,0),
              padding: EdgeInsets.fromLTRB(5,0,5,0),
              decoration: BoxDecoration(
                color: Color(0xff3d8cf3),
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 3,
                      offset: Offset(2, 2),
                      color: Colors.black45,
                      spreadRadius: 1),
                ],
                border: Border.all(
                  color: Colors.white,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(3,4,3,4),
                child: Row(
                  children: [
                    Text(
                      "Follow",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}