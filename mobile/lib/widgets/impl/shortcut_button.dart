// (C) 2019 Haziran Yazılım. All rights reserved.
// Proprietary License.

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile/commons/config.dart';
import 'package:mobile/themes/theme.dart';
import 'dart:math';

class ShortcutButton extends StatefulWidget {
  final VoidCallback onPressed;
  final ValueChanged<String> onDeleted;
  final bool deletable;
  final String caption;
  final Widget icon;
  final String hiddenKey;
  final double itemMaxWidth;

  const ShortcutButton({
    Key key,
    this.onPressed,
    this.deletable = true,
    this.caption,
    this.icon,
    this.onDeleted,
    this.hiddenKey,
    this.itemMaxWidth,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ShortcutButtonState();
}

class ShortcutButtonState extends State<ShortcutButton> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  bool inDeleteMode = false;
  bool deleted = false;

  initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _handleDeleteMode() {
    print("catch longpress");
    if (widget.deletable != true) {
      return;
    }
    print("yep in delete mode");
    setState(() => inDeleteMode = true);
  }

  @override
  Widget build(BuildContext context) {
    if (deleted) {
      return Container();
    }
    double pp = 0;

    double w = min(widget.itemMaxWidth, 70.0);
    print('w: $w');
    if (widget.itemMaxWidth > 70) {
      pp = (widget.itemMaxWidth - 70) / 2;
      print('pp:$pp');
    }
    //double w = widget.itemMaxWidth;

    return GestureDetector(
      onLongPress: () => _handleDeleteMode(),
      child: FadeTransition(
        opacity: _animation,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.5 + pp),
              child: SizedBox(
                width: w,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: w - 6,
                      width: w - 6,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(w / 2.8)),
                          color: Config.COLOR_WHITE,
                        ),
                        child: IconButton(
                          iconSize: w - 6,
                          icon: widget.icon, //Image.asset("assets/img/add.png", width: 32),
                          onPressed: () => widget.onPressed != null ? widget.onPressed() : null,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 11,
                    ),
                    Text(widget.caption, style: AppTheme.textHintWhite(), textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
            inDeleteMode
                ? Positioned(
                    top: 0,
                    right: 0,
                    height: 25,
                    width: 25,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Config.COLOR_FADED_RED,
                      ),
                      child: GestureDetector(
                        onTap: () => _controller.reverse().then((_) {
                              setState(() => deleted = true);
                              widget.onDeleted != null ? widget.onDeleted(widget.hiddenKey) : null;
                            }),
                        child: Icon(CupertinoIcons.delete, color: Config.COLOR_WHITE),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
