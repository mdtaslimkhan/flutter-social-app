



import 'package:flutter/cupertino.dart';

class CallScreenClipper extends CustomClipper<Path>{



  @override
  getClip(Size size) {

    Path path = Path();
    path.lineTo(size.width / 2, 5);
    // Offset curvePoint1 = Offset( 3 * size.width / 7, 0);
    // Offset middlePoint = Offset( 4 * size.width / 7, 2 * size.height / 5);
    // path.quadraticBezierTo(curvePoint1.dx, curvePoint1.dy, middlePoint.dx, middlePoint.dy);
    // Offset curvePoint2 = Offset(5 * size.width / 7, 0);
    // Offset endPoint = Offset(size.width, 0);
    // path.quadraticBezierTo(curvePoint2.dx, curvePoint2.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {

    return false;
  }

}