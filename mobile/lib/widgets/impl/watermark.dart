import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WaterMark extends StatelessWidget {
  final double width;
  final double height;
  final int rotate;
  final Alignment alignment;

  const WaterMark({Key key, this.width, this.height, this.alignment, this.rotate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Opacity(
        opacity: 0.6,
        child: Container(
          padding: EdgeInsets.all(18.0),
          //color: Colors.red,
          child: Align(
            alignment: alignment,
            child: RotatedBox(
              quarterTurns: rotate,
              child: Text(
                'GoyGoy App',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 2.0,
                      color: Colors.black,
                      offset: Offset(1.0, 1.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
