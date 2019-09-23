// (C) 2019 Haziran Yazılım. All rights reserved.
// Proprietary License.

import 'package:flutter/material.dart';
import 'package:mobile/commons/config.dart';

class NegativeActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const NegativeActionButton({Key key, this.onPressed, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      borderSide: BorderSide(color: Config.COLOR_BLUE_GRAY),
      onPressed: onPressed,
      child: child,
      shape: StadiumBorder(),
      padding: EdgeInsets.all(18),
      color: Config.COLOR_WHITE,
    );
  }
}
