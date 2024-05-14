import 'package:flutter/material.dart';

class WalletItem extends StatelessWidget {

  final Color color;
  final IconData icon;
  final String text;
  final Function onPress;
  WalletItem({this.color, this.icon, this.text, this.onPress});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 70,
        height: 70,
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(new Radius.circular(10.0)),
          color: color != null ? color.withOpacity(0.1) : Colors.green.withOpacity(0.2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text != null ? text : 'Item',style: TextStyle(
              fontSize: 12,
              fontFamily: 'Segoe',
              fontWeight: FontWeight.w600,
              color: color != null ? color : Colors.black
            ),
              textAlign: TextAlign.center,
            ),
           SizedBox(height: 5,),
           icon != null ? Icon(icon, color: color != null ? color : Colors.green ,) : Icon(Icons.camera_outlined, color: color != null ? color : Colors.green,),
          ],
        ),
      ),
      onTap: onPress,
    );
  }
}
