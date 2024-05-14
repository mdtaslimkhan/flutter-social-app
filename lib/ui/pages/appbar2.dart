
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/ui/pages/search/search.dart';
import 'package:flutter/material.dart';




Column circleImage(context, UserModel user) {


  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      GestureDetector(
        child:Container(
          margin: EdgeInsets.only(left: 10),
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            color: Color(0xff7c94b6),
            image: DecorationImage(
              image: NetworkImage(user.photo),
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
                spreadRadius: 1,
                blurRadius: 4,
                offset: Offset(0, 1), // changes position of shadow
              ),

            ],
          ),

        ),
        onTap: (){
          //   Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(user: user)));
        },
      ),
      SizedBox(height: 2),
      Container(
        margin: EdgeInsets.only(left: 10),
        width: 30,
        child: Text(
          "CR${user.nName}",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 8.0,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}




 AppBar header(BuildContext context, UserModel userName){

   handleSearch(String result){
     Navigator.push(context, MaterialPageRoute(builder: (parentContext) => Search(query: result)));
     // Navigator.pushNamed(context, '/profile');

   }

  return AppBar(
    toolbarHeight: 70,
    backgroundColor: Colors.white,
    leading: circleImage(context, userName),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))
    ),
    title: Container(
      padding: const EdgeInsets.all(8.0),
      height: 45,
      child: TextFormField(
        style: TextStyle(
          fontSize: 9
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(width: 1.8, color: Colors.amberAccent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(width: 1.9, color: Colors.grey),
          ),
          hintText: "Search... ",
          hintStyle: TextStyle(
            fontSize: 8
          ),
          labelStyle: TextStyle(
            fontSize: 7
          ),

          suffixIcon: Hero(
            tag: 'search',
            child: Icon(
                Icons.search,
              color: Colors.grey,
              size: 15,
            ),
          ),
        ),
        onFieldSubmitted: handleSearch,
      ),
    ),
    actions: [
      IconButton(
        icon: Image.asset(''
            'assets/profile/plus_blue.png',
          width: 25,
        ),
        onPressed: () {
        //  Navigator.push(context, MaterialPageRoute(builder: (context) => PostCreate(user: userName)));
        },
      ),

      IconButton(
        icon: Image.asset(
          'assets/profile/gear.png',
          width: 25,
        ),
        onPressed: () {
          // do something
        },
      ),
    ],
  );
}