import 'package:chat_app/util/constants.dart';
import 'package:flutter/material.dart';

class group_options_items extends StatelessWidget {

  final Function onPress;
  final Color bgColor;
  final String lableAlign;
  final String label;
  final bool isHide;
  final IconData iconImage;
  final IconData icon;
  final String descrip;
  group_options_items({this.onPress, this.bgColor, this.lableAlign, this.label, this.isHide, this.iconImage, this.icon, this.descrip});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        margin: EdgeInsets.fromLTRB(15,10,15,5),
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
        decoration: BoxDecoration(
          color: bgColor != null ? bgColor : btnBg,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
                blurRadius: 0,
                offset: Offset(1, 1),
                color: btnShadow.withOpacity(0.3),
                spreadRadius: 1),
          ],
          border: Border.all(
            color: btnBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                iconImage != null ?  Icon(iconImage) : Text(""),
                iconImage != null ? SizedBox(width: 5) : SizedBox(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: lableAlign == "center" ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$label',
                        style: TextStyle(
                          fontSize: 16,
                          color: bgColor != null ? Colors.white : headingColor,
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w900
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: (){},
                  child: Icon(
                    icon,
                    color: Color(0xff9e9fa4),
                    size: 30,
                  ),
                ),
              ],
            ),
            isHide ? Column(
              children: [
                descrip != null ? Text("$descrip", style: fldarkgrey12,) : Container(),
                SizedBox(height: 15),
              ],
            ) : Column(),

          ],
        ),
      ),
    );
  }
}

