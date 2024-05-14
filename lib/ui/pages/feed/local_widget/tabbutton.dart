import 'package:flutter/material.dart';
class TabButton extends StatelessWidget {

  final Widget child;
  final bool bol;
  final Function onPress;
  TabButton({@required this.child, @required this.bol, this.onPress}) : assert(child != null);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 50,
      height: 25,
      child: ElevatedButton(
        onPressed: onPress,
      ),
    );
  }
}
