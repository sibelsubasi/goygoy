// (C) 2019 Haziran Yazılım. All rights reserved.
// Proprietary License.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:mobile/commons/config.dart';
import 'package:mobile/themes/theme.dart';

class MessageWithImage extends StatelessWidget {
  final String title;
  final double width;
  final double height;
  final String path;

  const MessageWithImage({Key key, this.title, this.width, this.height, this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
      Column(mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
              width: width,
              height: height,
              child: new Image.asset(path,
                  fit: BoxFit.contain)),
          SizedBox(height: 17),
          Text(title,
              style: AppTheme.textListDefaultSubBody()),
        ],
      ),
    );
  }
}
