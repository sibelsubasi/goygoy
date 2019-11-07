// (C) 2019 All rights reserved.
// Proprietary License.

import 'package:flutter/material.dart';
import 'package:mobile/commons/config.dart';
import 'package:mobile/pages/welcome/onboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:mobile/pages/login/photo.dart';


class RedirectPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RedirectPageState();
}

class _RedirectPageState extends State<RedirectPage> {
  Widget _body;

  @override
  void initState() {
    super.initState();
    _doRedirect();
  }

  void _doRedirect() async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (Config.BEHAVIOUR_CLEAR_ALL_DATA_ON_APP_START) {
      preferences.remove(Config.KEY_APPROVED_IMAGE_PATH);
      preferences.remove(Config.KEY_SHARED_FIRST_RUN);
    }

    bool firstRun = true; //preferences.getBool(Config.KEY_SHARED_FIRST_RUN) ?? true;

    if (firstRun) {
      preferences.setBool(Config.KEY_SHARED_FIRST_RUN, false);
      _body = OnBoardPage();
      setState(() => null);
      return;
    }

    bool hasOtherBody = false;

    if (!hasOtherBody) {
      print("return body");
      _body = PhotoUploadPage();
    }
    setState(() => null);
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(body: _body ?? Container());
  }
}
