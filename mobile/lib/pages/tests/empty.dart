// (C) 2019 Haziran Yazılım. All rights reserved.
// Proprietary License.

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:mobile/commons/config.dart';
import 'package:mobile/widgets/widgets.dart';
import 'package:mobile/themes/theme.dart';
import 'package:mobile/commons/analytics.dart';
import 'package:mobile/widgets/dialogs.dart';

/// @To_Team:
/// Every page should extend from StatefulWidget and also should and with a Page suffix
/// @TODO: remove this comments when u do this.
class EmptyPage extends StatefulWidget {
  //@TODO: Give right path name here. When you do, delete this comment.
  final String screenName = "/tests/empty";

  @override
  State<StatefulWidget> createState() => _EmptyPageState();
}

/// @To_Team:
/// Always use _XxxPageState naming.
/// In Dart, _ means its private. As Page state always private to its page, it is important to do that way.
/// @TODO: remove this comments when u do this.
class _EmptyPageState extends State<EmptyPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool _isLoading = false;
  /// Always call initialize methods in initState,
  /// do not write codes in it, just call them.
  ///@TODO: Delete this comment lines when you read it.
  @override
  void initState() {
    super.initState();
    Analytics.logPageShow(widget.screenName);
  }

  ///Some widgets needs to be disposed. Like Animation.
  ///If you have widget or object which needs to be disposed. Do it here.
  ///@TODO: Delete this comment lines when you read it.
  @override
  void dispose() {
    super.dispose();
  }

  ///Write all methods below this line. First two method always be initState and dispose.
  ///@TODO: Delete this comment lines when you read it.

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      key: _scaffoldKey,
      appBar: PlatformAppBar(
        title: Text("Empty Page"),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            ListView(
              padding: EdgeInsets.all(12.0),
              children: <Widget>[
                ListTile(
                  title: Text("This is a empty page."),
                  subtitle: Text("Copy, change its name and begin development."),
                ),
              ],
            ),
            _isLoading ? Dialogs.aotIndicator(context) : Container(),
          ],
        ),
      ),
    );
  }
}
