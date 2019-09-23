import 'package:flutter/material.dart';

class ElbowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0.0, size.height * 0.45);

    path.lineTo((size.width * 0.72), (size.height * 0.65));

    path.relativeQuadraticBezierTo(30, 20, size.width, - size.height * 0.562);

    path.lineTo(size.width, 0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
