// (C) 2019 Haziran Yazılım. All rights reserved.
// Proprietary License.

import 'package:flutter/material.dart';
import 'package:mobile/commons/config.dart';
import 'package:mobile/themes/theme.dart';

class GradientPageHeader extends StatelessWidget {
  final String title;

  const GradientPageHeader({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topCenter,
          end: AlignmentDirectional.bottomCenter,
          colors: [
            Config.COLOR_GRADIENT_BEGIN,
            Config.COLOR_GRADIENT_END,
          ],
        ),
      ),
      //color: Config.COLOR_YK_BLUE,
      width: double.maxFinite,
      height: 75,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
            child: Text(this.title, style: AppTheme.textHeaderStyle()),
          ),
          //Divider(),
        ],
      ),
    );
  }
}
