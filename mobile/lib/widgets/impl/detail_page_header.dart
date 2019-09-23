// (C) 2019 Haziran Yazılım. All rights reserved.
// Proprietary License.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:mobile/commons/config.dart';
import 'package:mobile/themes/theme.dart';

class DetailPageHeader extends StatelessWidget {
  final String title;
  final Color color;
  final Color bgcolor;
  final Color iconcolor;

  const DetailPageHeader({Key key, this.title, this.color, this.bgcolor, this.iconcolor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgcolor,
      width: double.maxFinite,
      height: 70,
      padding: EdgeInsets.only(top: 18.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: PlatformIconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    androidIcon: Icon(Icons.arrow_back,
                        color: iconcolor),
                    iosIcon: Icon(CupertinoIcons.back,
                        color: iconcolor)),
              ),
              Expanded(
                flex: 4,
                child: Center(
                  child: Text(title,style: TextStyle(color: color, fontSize: 19, fontFamily: 'Rubik')),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DefaultPageHeader extends StatelessWidget {
  final String title;
  final Color color;
  final Color bgcolor;
  final Color iconcolor;

  const DefaultPageHeader({Key key, this.title, this.color, this.bgcolor, this.iconcolor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgcolor,
      width: double.maxFinite,
      height: 105,
      padding: EdgeInsets.only(top: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
                child: PlatformIconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    androidIcon: Icon(Icons.arrow_back,
                        color: iconcolor),
                    iosIcon: Icon(CupertinoIcons.back,
                        color: iconcolor)),
              ),
          Padding(
            padding: EdgeInsets.fromLTRB(21, 0, 21, 12),
            child: Text(title,style: TextStyle(color: color, fontSize: 21, fontFamily: 'Rubik'),overflow: TextOverflow.ellipsis),
          ),
          Divider(),
        ],
      ),
    );
  }
}