import 'package:flutter/material.dart';

class BottomListItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String name;
  final Function fn;
  BottomListItem({this.name,this.color, this.fn, this.icon});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: fn,
      child: Column(
        children: [
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 18,),
                Icon(icon,color: color, size: 15,),
                SizedBox(width: 10,),
                Container(
                  height: 50,
                  child: Center(
                      child: Text(
                          "$name",
                          style: TextStyle(
                            color: color
                          ),
                      ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 1,)
        ],
      ),
    );
  }
}
