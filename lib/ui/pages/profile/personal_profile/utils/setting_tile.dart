import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {

  final String label;
  final Function onPress;
  SettingsTile({this.label, this.onPress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      child: Container(
        margin: EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              blurRadius: 6,
              offset: Offset(0,1),
              color: Colors.black.withOpacity(0.2),
              spreadRadius: -1,
            ),
          ],
        ),
        child: ListTile(
          title: !["null", null, false].contains(label) ? Text("$label") : Text(''),
          onTap: onPress,
          trailing: Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}
