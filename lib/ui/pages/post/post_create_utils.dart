
import 'package:flutter/material.dart';


class DropdownItem extends StatelessWidget {

  final Function onChange;
  final String value;
  final List<String> listItem;
  final IconData icon;
  DropdownItem({@required this.onChange, @required this.value, @required this.listItem, @required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10,top: 5),
      height: 25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Colors.white,
        boxShadow: [ BoxShadow(
          color: Colors.black.withOpacity(0.1),
          offset: Offset(0,1),
          spreadRadius: 1,
          blurRadius: 1,
        ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: 5),
          Icon(icon,
            size: 12,
          ),
          SizedBox(width: 3,),
          DropdownButton<String>(
            value: value,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 16,
            elevation: 16,
            underline: SizedBox(),
            style: TextStyle(
              color: Colors.black,
              fontSize: 10,
            ),
            onChanged: onChange,
            items: listItem
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }
            ).toList(),
          ),
          SizedBox(width: 5),
        ],
      ),
    );
  }
}
