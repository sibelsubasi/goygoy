// (C) 2019 Haziran Yazılım. All rights reserved.
// Proprietary License.

import 'package:flutter/material.dart';

enum IconBadgePosition { left, right }

class IconWithBadge extends StatelessWidget {
  final String text;
  final Color badgeColor;
  final Color textColor;
  final IconBadgePosition position;
  final bool hideIfEmpty;
  final Widget icon;
  final double size;

  const IconWithBadge({
    Key key,
    @required this.text,
    @required this.icon,
    this.badgeColor = Colors.red,
    this.textColor = Colors.white,
    this.position = IconBadgePosition.left,
    this.hideIfEmpty = true,
    this.size = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (hideIfEmpty && text.isEmpty) {
      return this.icon;
    }
    return Stack(
      children: <Widget>[
        Padding(child: this.icon, padding: EdgeInsets.symmetric(vertical: 2, horizontal: 12)),
        Positioned(
          right: this.position == IconBadgePosition.right ? 0 : null,
          left: this.position == IconBadgePosition.left ? 0 : null,
          child: new Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(1),
            decoration: new BoxDecoration(
              color: this.badgeColor,
              borderRadius: BorderRadius.circular(size / 2),
            ),
            constraints: BoxConstraints(
              minWidth: size,
              minHeight: size,
            ),
            child: new Text(this.text, style: new TextStyle(color: this.textColor, fontSize: 8), textAlign: TextAlign.center),
          ),
        )
      ],
    );
  }
}
