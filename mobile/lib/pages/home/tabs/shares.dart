// (C) 2019 All rights reserved.
// Proprietary License.

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile/commons/config.dart';
import 'package:mobile/utils/utils.dart';
import 'package:mobile/widgets/widgets.dart';
import 'package:mobile/commons/analytics.dart';
import 'package:mobile/widgets/dialogs.dart';


class ShareTab extends StatefulWidget {
  final String screenName = "/home/tabs/share";

  @override
  State<StatefulWidget> createState() => ShareTabState();
}

class ShareTabState extends State<ShareTab> {
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
    return SafeArea(
      child: Stack(
        children: <Widget>[
          GradientPageHeader(
            title: "Paylaş",
          ),
          Container(
            color: Colors.white,
            margin: EdgeInsets.only(top: 75),
            child: ListView(
              padding: EdgeInsets.all(25.0),
              children: <Widget>[
                Text("Share tab....."),
              ],
            ),
          ),
          _isLoading ? Dialogs.aotIndicator(context) : Container(),
        ],
      ),
    );
  }
}
