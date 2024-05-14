
import 'package:chat_app/ui/pages/home/tophorizontalscroller.dart';
import 'package:flutter/material.dart';

Column horizontalScrollerPosts(BuildContext context, List<Topscroller> jobOrAds,  Widget jobOrAdsTemplate(data) ) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
          margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            child: Text('Jobs you may like',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),),
          )
      ),
      Container(
        height: 270.0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: jobOrAds.map((data) =>
              jobOrAdsTemplate(data)
          ).toList(),

        ),
      ),
      // see All
      GestureDetector(
        onTap: (){},
        child: Container(
          margin: EdgeInsets.fromLTRB(15,10,15,5),
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
          decoration: BoxDecoration(
            color: Color(0xfffcfcfc),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  blurRadius: 3,
                  offset: Offset(2, 2),
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
              SizedBox(width: 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'See All',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: 10,),
      Container(
        width: MediaQuery.of(context).size.width,
        color: Color(0xffd8d9d9),
        height: 5,
      ),

    ],
  );
}


Widget jobOrAdsTemplate(data){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Container(
        margin: EdgeInsets.fromLTRB(12.0, 0, 0, 0),
        width: 250.0,
        height: 260.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),

          boxShadow: [
            BoxShadow(
                blurRadius: 3,
                offset: Offset(2, 2),
                color: Colors.black45.withOpacity(0.3),
                spreadRadius: 1),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 125,
              width: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage('assets/feed/job.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10,10,10,0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fri, Oct 12 - Oct 27',
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.red,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    'Blcak diamond Weekend 2020',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Executive manager',
                    style: TextStyle(
                        fontSize: 13
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    'Salary: 25000/- BDT',
                    style: TextStyle(
                        fontSize: 13,
                      //  color: Theme.of(context).primaryColor
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ButtonTheme(
                        minWidth: 150,
                        height: 30,
                        child: ElevatedButton.icon(
                          onPressed: () {},

                          label: Padding(
                            padding: const EdgeInsets.fromLTRB(10.0,0,0,0),
                            child: Text('Apply',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),),
                          ) ,
                        ),
                      ),
                      ButtonTheme(
                        minWidth: 50,
                        height: 3,
                        child: ElevatedButton(
                          onPressed: () {},
                         
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ],
        ),
      ),

    ],
  );
}
