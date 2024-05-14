
import 'package:flutter/material.dart';


class GiftCountDropdown extends StatelessWidget {

  final Function onChange;
  final String value;
  final List<String> listItem;
  final IconData icon;
  GiftCountDropdown({@required this.onChange, @required this.value, @required this.listItem, @required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10,top: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Colors.transparent,
        boxShadow: [ BoxShadow(
          color: Colors.black.withOpacity(0.1),
          offset: Offset(0,1),
          spreadRadius: 1,
          blurRadius: 1,
        ),
        ],
        // border: Border.all(
        //   color: Colors.grey.withOpacity(0.3),
        //   width: 2,
        // ),
      ),
      child: Row(
        children: [
          Icon(icon,
            size: 12,
            color: Colors.white,
          ),
          DropdownButton<String>(
            value: value,
            icon: Icon(Icons.keyboard_arrow_up_sharp),
            iconSize: 16,
            elevation: 60,
            dropdownColor: Colors.black87,
            underline: SizedBox(),
            style: TextStyle(
              color: Colors.white70,
              fontSize: 10,
            ),
            onChanged: onChange,
            items: listItem.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }
            ).toList(),
          ),
        ],
      ),
    );
  }
}
