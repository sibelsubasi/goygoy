import 'package:flutter/material.dart';

class BowlClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    var _height = size.height;

    //print('size.height;${size.height}');
    path.lineTo(0, _height-40);
    path.quadraticBezierTo(0.0, _height, 40.0, _height);

    path.lineTo(size.width-40, _height);
    path.quadraticBezierTo(size.width, _height, size.width, _height - 40);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
