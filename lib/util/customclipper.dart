


import 'package:flutter/rendering.dart';

class CurveClipper extends CustomClipper<Path> {

  final double moveVal;
  CurveClipper({this.moveVal});

  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.lineTo(0, 4 * size.height / 5);
    Offset curvePoint1 = Offset(size.width / 4, size.height);
    Offset middlePoint = Offset(size.width / 2, 4 * size.height / 5);
    path.quadraticBezierTo(curvePoint1.dx, curvePoint1.dy, middlePoint.dx, middlePoint.dy);
    Offset curvePoint2 = Offset(3 * size.width / 4, 3 * size.height / 5);
    Offset endPoint = Offset(size.width, 6 * size.height / 7);
    path.quadraticBezierTo(curvePoint2.dx, curvePoint2.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    throw false;
  }

}
