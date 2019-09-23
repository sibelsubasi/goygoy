import 'package:flutter/material.dart';

class AbsoluteShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    var _height = size.height;

    //print('size.height;${size.height}');
    path.lineTo(0, _height-160);

    path.lineTo(size.width, _height-260);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
