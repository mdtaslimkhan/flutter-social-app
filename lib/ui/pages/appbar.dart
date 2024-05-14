import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class AppBarWidget extends StatelessWidget {

 final String name;
 final bool isPlusSign;
  const AppBarWidget({@required this.name, @required this.isPlusSign}) : assert( name != null);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
          ),
          child: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: 75.0,
            padding: EdgeInsets.fromLTRB(0.0, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      child: Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: Color(0xff7c94b6),
                          image: DecorationImage(
                            image: AssetImage('assets/person.jpg'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(new Radius.circular(50.0)),
                          border: Border.all(
                            color: Colors.white,
                            width: 2.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                      ),
                      onPressed: (){
                        Navigator.pushNamed(context, '/profile');
                      },
                    ),
                    SizedBox(height: 0),
                    Text(
                      name,
                      style: TextStyle(
                          color: Colors.black87,
                        fontSize: 10.0,
                      ),
                    ),
                  ],
                ),

                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width-100,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                        //  width: MediaQuery.of(context).size.width,
                          height: 27,
                          decoration: BoxDecoration(
                            color: Color(0xffffffff),
                            borderRadius: BorderRadius.all(new Radius.circular(5.0)),
                            border: Border.all(
                              color: Color(0xffc8c8c8),
                              width: 2.0,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ButtonTheme(
                                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                minWidth: 35, //wraps child's width
                                height: 35, //wraps child's height
                                child: IconButton(
                                  icon: Image.asset(
                                      'assets/profile/search.png',
                                    width: 30,
                                    height: 30,
                                  ),
                                  onPressed: () {
                                    // do something
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),


                     SizedBox(width: 15,),
                      Container(
                        width: 75,
                        child: Stack(
                          children: [
                           Positioned(
                              child: IconButton(
                              icon: Image.asset(''
                                  'assets/profile/plus_blue.png',
                                width: 25,
                              ),
                              onPressed: () {
                                // do something
                              },
                          ),
                            ),
                            Positioned(
                              left: 35,
                              child: IconButton(
                                icon: Image.asset(
                                  'assets/profile/gear.png',
                                  width: 25,
                                ),
                                onPressed: () {
                                  // do something
                                },
                              ),
                            ),
          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
