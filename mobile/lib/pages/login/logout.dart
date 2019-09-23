import 'package:flutter/material.dart';
import 'package:mobile/commons/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/services/settings.dart';
import 'package:mobile/entities/device.dart';

Future<void> doLogout(BuildContext context) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  //String fbTokenToSave = deviceEntity.deviceType + Config.TOKEN_GLUE + deviceEntity.deviceToken;
  String fbTokenToParse = preferences.getString(Config.KEY_FIREBASE_TOKEN);
  if (fbTokenToParse != null && fbTokenToParse.contains(Config.TOKEN_GLUE)) {
    List<String> temp = fbTokenToParse.split(Config.TOKEN_GLUE);
    DeviceEntity d = DeviceEntity.map({
      'deviceType': temp[0],
      'deviceToken': temp[1],
    });
    SettingsService().removeDeviceToken(d);
  }

  //TODO: YK will give service to remove user token on their side.

  preferences.remove(Config.KEY_SEARCH_HISTORY);
  preferences.remove(Config.KEY_APPROVED_IMAGE_PATH);
  preferences.remove(Config.KEY_SHARED_SAVED_TOKEN);
  preferences.remove(Config.KEY_SHARED_SHORTCUTS);

  Navigator.of(context).pushNamedAndRemoveUntil("/login/login", (Route<dynamic> route) => false);
}
