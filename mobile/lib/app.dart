// (C) 2019 Haziran Yazılım. All rights reserved.
// Proprietary License.
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:mobile/commons/config.dart';
import 'package:mobile/locale/turkish_cupertino_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mobile/routes.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:mobile/commons/analytics.dart';
import 'package:package_info/package_info.dart';

import 'package:mobile/pages/etc/unknown_route.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unique_identifier/unique_identifier.dart';

class AOTMobileApp extends StatelessWidget {

  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);
  static FirebasePerformance performance = FirebasePerformance.instance;
  bool _testAlertShowed = false;

  AOTMobileApp() {
    _changePlatform();
    Analytics.init(analytics, observer);
    performance.setPerformanceCollectionEnabled(true);
  }

  _changePlatform() {
    switch (Config.DEF_PREF_LOOK_AND_FEEL) {
      case "ios":
        if (Config.DEBUG) {
          print("Application will run as (forced: 'Cupertino App')");
        }
        changeToCupertinoPlatform();
        break;
      case "android":
        if (Config.DEBUG) {
          print("Application will run as (forced: 'Material App')");
        }
        changeToMaterialPlatform();
        break;
      default:
        Config.DEF_PREF_LOOK_AND_FEEL = Platform.operatingSystem.toLowerCase();
        if (Config.DEBUG) {
          print("Application will run as (normal: '${Platform.operatingSystem} app')");
        }
        changeToAutoDetectPlatform();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlatformApp(
      title: Config.STR_APPLICATION_TITLE,
      supportedLocales: [
        const Locale('tr', 'TR'),
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        TurkishCupertinoLocalizations.delegate,
      ],
      //routes: ROUTES
      onUnknownRoute: (RouteSettings setting) {
        String unknownRoute = setting.name;
        return platformPageRoute(builder: (BuildContext context) {
          return UnknownPage(routePath: setting.name);
        });
      },
      onGenerateRoute: (RouteSettings settings) {
        if (Config.DEBUG) {
          print("Generating Platform Named Route: ${settings.name} with arguments: ${settings.arguments.toString()}");
        }
        if (ROUTES[settings.name] != null) {
          return platformPageRoute(builder: (BuildContext context) {
            return ROUTES[settings.name](settings);
          });
        }
      },
    );
  }
}
