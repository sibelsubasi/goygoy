// (C) 2019 Haziran Yazılım. All rights reserved.
// Proprietary License.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:mobile/widgets/widgets.dart';
import 'package:mobile/themes/theme.dart';
import 'package:mobile/commons/analytics.dart';
import 'package:mobile/widgets/dialogs.dart';

class DayClosingSuccessPage extends StatefulWidget {
  final String screenName = "/dayclosing/success";

  @override
  State<StatefulWidget> createState() => _DayClosingSuccessPageState();
}

class _DayClosingSuccessPageState extends State<DayClosingSuccessPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Analytics.logPageShow(widget.screenName);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(48, 24, 45, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MessageWithImage(
                    width: 280,
                    height: 210,
                    title: "Gün uzatma talebiniz alınmıştır.",
                    path: "assets/img/successIcon.png",
                  ),
                  SizedBox(height: 62),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: PositiveActionButton(
                            child: Text("Anasayfaya Dön",
                                style: AppTheme.textButtonPositive()),
                            onPressed: () {
                              Navigator.of(context).pushNamed("/home/home");
                            }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _isLoading ? Dialogs.aotIndicator(context) : Container(),
          ],
        ),
      ),
    );
  }
}
