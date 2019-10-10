// (C) 2019 Haziran Yazılım. All rights reserved.
// Proprietary License.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/commons/config.dart';
import 'package:mobile/themes/theme.dart';


class Bubble extends StatelessWidget {
  Bubble({this.message, this.time, this.delivered, this.position});

  final String message, time;
  final delivered, position;

  @override
  Widget build(BuildContext context) {
    //position=false is green bubble, means right bubble.
    final bg = position ? Colors.white : Colors.green;
    final align = position ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final icon = delivered ? Icons.done_all : Icons.done;
    final radius = position
        ? BorderRadius.only(
      topRight: Radius.circular(18.0),
      bottomLeft: Radius.circular(0),
      bottomRight: Radius.circular(18.0),
      topLeft: Radius.circular(18.0),
    )
        : BorderRadius.only(
      topLeft: Radius.circular(18.0),
      bottomLeft: Radius.circular(18.0),
      bottomRight: Radius.circular(0),
      topRight: Radius.circular(18.0),
    );
    return Column(
      crossAxisAlignment: align,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(3.0),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: .5,
                  spreadRadius: 1.5,
                  color: Colors.black.withOpacity(.12))
            ],
            color: bg,
            borderRadius: radius,
          ),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 14.0),
                child: Text(message, style: TextStyle(
                  color: position ? Colors.black : Colors.white,
                  fontSize: 14.0,
                ),),
              ),
              /*Positioned(
                bottom: 0.0,
                right: 0.0,
                child: Row(
                  children: <Widget>[
                    Text(time,
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 10.0,
                        )),
                    SizedBox(width: 3.0),
                    Icon(
                      icon,
                      size: 12.0,
                      color: Colors.black38,
                    )
                  ],
                ),
              )*/
            ],
          ),
        )
      ],
    );
  }
}

class BubbleAccent extends StatelessWidget {
  BubbleAccent({this.message, this.time, this.delivered, this.position});

  final String message, time;
  final delivered, position;

  @override
  Widget build(BuildContext context) {
    //position=false is green bubble, means right bubble.
    final bg = position ? Colors.white.withOpacity(0.7) : Colors.greenAccent.shade100.withOpacity(0.7);
    final align = position ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final icon = delivered ? Icons.done_all : Icons.done;
    final radius = position
        ? BorderRadius.only(
      topRight: Radius.circular(5.0),
      bottomLeft: Radius.circular(10.0),
      bottomRight: Radius.circular(5.0),
    )
        : BorderRadius.only(
      topLeft: Radius.circular(5.0),
      bottomLeft: Radius.circular(5.0),
      bottomRight: Radius.circular(10.0),
    );
    return Column(
      crossAxisAlignment: align,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(3.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: .5,
                  spreadRadius: 1.0,
                  color: Colors.black.withOpacity(.12))
            ],
            color: bg,
            borderRadius: radius,
          ),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 48.0),
                child: Text(message, style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                ),),
              ),
              Positioned(
                bottom: 0.0,
                right: 0.0,
                child: Row(
                  children: <Widget>[
                    Text(time,
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 10.0,
                        )),
                    SizedBox(width: 3.0),
                    Icon(
                      icon,
                      size: 12.0,
                      color: Colors.black38,
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}