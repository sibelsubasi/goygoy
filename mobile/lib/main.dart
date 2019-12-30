// (C) 2019 Haziran Yazılım. All rights reserved.
// Proprietary License.
import 'dart:async';
import 'dart:io';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/app.dart';
import 'package:mobile/commons/config.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';

void main2() {
  runApp(AOTMobileApp());
}

//@WATCH_OUT: removed async on main, and await FlutterCrashlytics().initialize();
// it was making black flickering on app start.
void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    if (Config.DEBUG) {
      // In development mode simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode report to the application zone to report to
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  FlutterCrashlytics().initialize();

  runZoned<Future<Null>>(() async {
    SystemChrome.setPreferredOrientations(Config.SUPPORTED_SCREEN_ORIENTATIONS).then((_) {

      /* GOOGLE ADMOB */
      const String APP_ID_IOS = 'ca-app-pub-7026258186722315~8694725930'; // INTO Info.plist
      const String APP_ID_ANDROID = 'ca-app-pub-7026258186722315~5508437197'; // INTO AndroidManifest
      FirebaseAdMob.instance.initialize(appId: Platform.isAndroid ? APP_ID_ANDROID:APP_ID_IOS); //TODO ?????
      /* End of Admob */

      runApp(AOTMobileApp());
    });
    // runApp(YKMobileHrApp());
  }, onError: (error, stackTrace) async {
    // Whenever an error occurs, call the `reportCrash` function. This will send
    // Dart errors to our dev console or Crashlytics depending on the environment.
    debugPrint(error.toString());
    await FlutterCrashlytics().reportCrash(error, stackTrace, forceCrash: false);
  });
}
