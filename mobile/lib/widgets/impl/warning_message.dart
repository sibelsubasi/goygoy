// (C) 2019 Haziran Yazılım. All rights reserved.
// Proprietary License.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/commons/config.dart';
import 'package:mobile/themes/theme.dart';

class WarningMessage extends StatelessWidget {
  final String title;
  final String description;
  final TextStyle titleStyle;
  final TextStyle descriptionStyle;

  const WarningMessage({Key key, this.title, this.description, this.titleStyle, this.descriptionStyle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Divider(height: 4),
        Container(
          padding: EdgeInsets.fromLTRB(25, 8, 25, 8),
          color: Config.COLOR_WHITE_GRAY,
          child: ListTile(

            contentPadding: EdgeInsets.all(0),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.info_outline, color: Config.COLOR_LIGHT_GRAY),
                SizedBox(width: 15.0),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 2),
                      this.title != "" ? Text(title, style: titleStyle,) : Container(),
                      this.title != "" ? SizedBox(height: 8) : SizedBox(height: 0),
                      Text(description, style: descriptionStyle,),
                  ],
                ),
                ),
              ],
            ),
          ),
        ),
        Divider(height: 4),
        //SizedBox(height: 10),
      ],
    );
  }
}
