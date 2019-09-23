// (C) 2019 Haziran Yazılım. All rights reserved.
// Proprietary License.

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class RoundedCheckBox extends StatelessWidget {
  final bool value;
  final GestureTapCallback onTap;

  const RoundedCheckBox({
    Key key,
    this.value,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: this.value
            ? Icon(Icons.check_circle, size: 24.0, color: Colors.blue,)
            : Icon(Icons.radio_button_unchecked, size: 24.0, color: Colors.blueGrey[200],),
      ),
    );
  }
}
