import 'package:chat_app/tools/cached_network_image.dart';
import 'package:chat_app/ui/group/big_group/model/GroupModel.dart';
import 'package:chat_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class BigGroupGiftStatusList extends StatelessWidget {

  final GroupModel toGroup;
  BigGroupGiftStatusList({this.toGroup});

  String _val;
  String get val => _val;



  @override
  Widget build(BuildContext context) {

    return Container(
      height: MediaQuery.of(context).size.height,
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            toolbarHeight: 30,
            backgroundColor: Color(0xEB000000),
            automaticallyImplyLeading: false,
            title: TabBar(tabs: [
              Tab(text: "Gift sent",),
              Tab(text: "Receiving rank",),
              Tab(text: "Who sent to",),
            ]),
          ),
          body: Container(
            padding: EdgeInsets.all(10),
            color: Colors.black87,
            child: TabBarView(
              children: [
                _firstPageItem(),
                _secondPageItem(),
                _thirdPageItem(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  final _fireStore = FirebaseFirestore.instance;


  _firstPageItem(){
   return Column(
     children: [
       Expanded(
         child: StreamBuilder<QuerySnapshot>(
            stream: _fireStore
                .collection(BIG_GROUP_COLLECTION)
                .doc(toGroup.id.toString())
                .collection("userGiftSent")
                .orderBy('diamond.diamond',descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                    var dt = snapshot.data.docs;

                    if(!snapshot.hasData){
                      return CircularProgressIndicator();
                    }

                    return ListView.builder(
                        itemCount: dt.length,
                        itemBuilder: (context, index) {
                          var ds = dt[index].data() as Map;
                          return Container(
                            margin: EdgeInsets.only(bottom: 12),
                            child: GestureDetector(
                              onTap: () {},
                              child:
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          child: index == 0 ? Image.asset('assets/gift/w1.png') :
                                          index == 1 ? Image.asset('assets/gift/w2.png') :
                                          index == 2 ? Image.asset('assets/gift/w3.png') :
                                          index == 3 ? Image.asset('assets/gift/w4.png') :
                                          index == 4 ? Image.asset('assets/gift/w5.png') : Container(
                                            child: Text('${index+1}',style: TextStyle(
                                              color: Colors.white
                                            ),),
                                          ),
                                        ),
                                        SizedBox(width: 5,),
                                        Container(
                                          width: 25,
                                          height: 25,
                                          decoration: BoxDecoration(
                                            color: Colors.blueGrey,
                                            borderRadius: BorderRadius.all(new Radius.circular(25.0)),
                                            border: Border.all(
                                              color: Colors.black87,
                                              width: 1.0,
                                            ),
                                          ),
                                          child: dt[index]['photo'] != null ?  cachedNetworkImageCircular(context,dt[index]['photo']) : AssetImage('assets/u3.gif'),
                                        ),
                                        SizedBox(width: 15,),
                                        Flexible(
                                          child: Text('${dt[index]['name']}',style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12
                                          ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 60,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Image.asset("assets/gift/dimond_blue.png", width: 12,),
                                        SizedBox(width: 5,),
                                        Text('${ds.containsKey("diamond") ? dt[index]["diamond"]['diamond'] : ''}', style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10
                                        ),),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 5,),
                                ],
                              ),
                            ),
                          );
                        }
                    );
              }
              return Container();
            },
          ),
       ),
     ],
   );
  }


  _secondPageItem(){
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _fireStore
                .collection(BIG_GROUP_COLLECTION)
                .doc(toGroup.id.toString())
                .collection("userGiftReceived")
                .orderBy('diamond.diamond',descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var dt = snapshot.data.docs;

                if(!snapshot.hasData){
                  return CircularProgressIndicator();
                }

                return ListView.builder(
                    itemCount: dt.length,
                    itemBuilder: (context, index) {
                      var ds = dt[index].data() as Map;
                      return Container(
                        margin: EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () {},
                          child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      child: index == 0 ? Image.asset('assets/gift/w1.png') :
                                      index == 1 ? Image.asset('assets/gift/w2.png') :
                                      index == 2 ? Image.asset('assets/gift/w3.png') :
                                      index == 3 ? Image.asset('assets/gift/w4.png') :
                                      index == 4 ? Image.asset('assets/gift/w5.png') : Container(
                                        child: Center(
                                          child: Text('${index+1}',style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          )),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey,
                                        borderRadius: BorderRadius.all(new Radius.circular(25.0)),
                                        border: Border.all(
                                          color: Colors.black87,
                                          width: 1.0,
                                        ),
                                      ),
                                      child: dt[index]['photo'] != null ?  cachedNetworkImageCircular(context,dt[index]['photo']) : AssetImage('assets/u3.gif'),
                                    ),
                                    SizedBox(width: 15,),
                                    Flexible(
                                      child: Text('${dt[index]['name']}',style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12
                                      ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 60,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Image.asset("assets/gift/dimond_blue.png", width: 12,),
                                    SizedBox(width: 5,),
                                    Text('${ds.containsKey("diamond") ? dt[index]["diamond"]['diamond'] : ''}', style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10
                                    ),),
                                  ],
                                ),
                              ),
                              SizedBox(width: 5,),
                            ],
                          ),
                        ),
                      );
                    }
                );
              }
              return Container();
            },
          ),
        ),
      ],
    );
  }

  _thirdPageItem(){
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore
          .collection(BIG_GROUP_COLLECTION)
          .doc(toGroup.id.toString())
          .collection("hotGift")
          .orderBy('timeStamp',descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            var dt = snapshot.data.docs;
            if(!snapshot.hasData){
              return CircularProgressIndicator();
            }

            return ListView.builder(
                itemCount: dt.length,
                itemBuilder: (context, index) {
                  var ds = dt[index].data() as Map;
                  if(dt[index] != null) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () {},
                        child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                              child: Row(
                                children: [
                                  SizedBox(width: 5,),
                                  Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey,
                                      borderRadius: BorderRadius.all(
                                          new Radius.circular(25.0)),
                                      border: Border.all(
                                        color: Colors.black87,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: dt[index]['fromPhoto'] != null
                                        ? cachedNetworkImageCircular(
                                        context, dt[index]['fromPhoto'])
                                        : AssetImage('assets/u3.gif'),
                                  ),
                                  SizedBox(width: 15,),
                                  Flexible(
                                    child: dt[index]['fromName'] != null ? Text(
                                      '${dt[index]['fromName']}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ) : Container(),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10,),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Image.asset(
                                    "assets/gift/dimond_blue.png", width: 12,),
                                  SizedBox(width: 5,),
                                  Text('${ds.containsKey("diamond") ? dt[index]["diamond"] : ''}', style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10
                                  ),),
                                ],
                              ),
                            ),
                            SizedBox(width: 10,),
                            Flexible(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(width: 10,),
                                  Flexible(
                                    child: dt[index]['toName'] != null ? Text(
                                      '${dt[index]['toName']}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ) : Container(),
                                  ),
                                  SizedBox(width: 10,),
                                  Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey,
                                      borderRadius: BorderRadius.all(
                                          new Radius.circular(25.0)),
                                      border: Border.all(
                                        color: Colors.black87,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: dt[index]['toPhoto'] != null
                                        ? cachedNetworkImageCircular(
                                        context, dt[index]['toPhoto'])
                                        : AssetImage('assets/u3.gif'),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    );
                  }else{
                    return Text('no data');
                  }
                }
            );
          }
        }
        return Container();
      },
    );
  }


}
