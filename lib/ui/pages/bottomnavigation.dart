import 'package:chat_app/ui/pages/contact/user_list.dart';
import 'package:chat_app/ui/pages/home/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class BottomNavigationWidget extends StatelessWidget {
  const BottomNavigationWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int index = 0;
    return ClipPath(
      clipper: ShapeBorderClipper(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),


      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        onTap: (index) {
          if( index == 0){
            Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
          }else if(index == 5){
            Navigator.push(context, MaterialPageRoute(builder: (context) => Userlist()));
          }
        },
       
        items: const <BottomNavigationBarItem> [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Meeting',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket),
            label: 'Market',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Contacts',
          ),
        ],

      ),
    );
  }
}
