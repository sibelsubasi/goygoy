
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
    return Container(
      padding: EdgeInsets.fromLTRB(8.0, 8.0, 10.0, 0),
      height: height,
      width: width,
      alignment: alignment,
      child: LimitedBox(
        maxHeight: height, maxWidth: width,
        child: Opacity(
          opacity: 0.5,
          child: RotatedBox(
            quarterTurns: rotate,
            child: Text('GoyGoy App',
              textAlign: TextAlign.center,
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
    );
  }
}
