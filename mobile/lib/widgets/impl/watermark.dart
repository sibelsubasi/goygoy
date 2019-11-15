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
        opacity: 0.4,
        child: Container(
          padding: EdgeInsets.all(8.0),
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
                      blurRadius: 3.0,
                      color: Colors.orange,
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
