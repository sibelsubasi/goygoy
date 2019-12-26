
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

abstract class Analytics {
  static FirebaseAnalytics _analytics;
  static FirebaseAnalyticsObserver _observer;

  static FirebaseAnalytics getFirebaseAnalyticsInstance() {
    return _analytics;
  }

  static FirebaseAnalyticsObserver getFirebaseAnalyticsObserverInstance() {
    return _observer;
  }

  static void init(FirebaseAnalytics analytics, FirebaseAnalyticsObserver observer) {
    if (_analytics != null || _observer != null) {
      return;
      //throw Exception("Init should be called once!");
    }
    Analytics._analytics = analytics;
    Analytics._observer = observer;
  }

  static void logPageShow(String screenName, {String screenClassOverride}) async {
    await _analytics.setCurrentScreen(
      screenName: screenName,
      screenClassOverride: screenClassOverride ?? "GoyGoy",
    );
  }

  static void logApplicationStart() async {
    await _analytics.logAppOpen();
  }

  static void logTutorialBegin() async {
    await _analytics.logTutorialBegin();
  }

  static void logTutorialComplete() async {
    await _analytics.logTutorialComplete();
  }

  static void logLogin() async {
    await _analytics.logLogin();
  }
}
