import 'dart:io';
import 'package:firebase_admob/firebase_admob.dart';


class AdmobAd {

    static const bool TEST_MODE = true;
    static const List<String> ADMOB_TESTDEVICES = ['B713C0E2C99277356B96BD5D55D4BB87']; //5f1f2d8b91097b02
    static const List<String> ADMOB_KEYWORDS = ['picture', 'speech', 'bubble', 'editor'];
    //static const String APP_ID_IOS = 'ca-app-pub-7026258186722315~8694725930'; // INTO Info.plist
    //static const String APP_ID_ANDROID = 'ca-app-pub-7026258186722315~5508437197'; // INTO AndroidManifest
    static const String AD_UNIT_ID_IOS = 'ca-app-pub-7026258186722315/9678319322';
    static const String AD_UNIT_ID_ANDROID = 'ca-app-pub-7026258186722315/5185482496';

    final String _interstitialAd_AdUnitId = Platform.isAndroid ? AD_UNIT_ID_ANDROID : AD_UNIT_ID_IOS;


    static final AdmobAd _instance = AdmobAd._internal();
    factory AdmobAd() => _instance;

    MobileAdTargetingInfo _targetingInfo;
    InterstitialAd _interstitialAd;
    bool isAdLoaded = false;


    AdmobAd._internal(){
      _targetingInfo = new MobileAdTargetingInfo();

      /*
      _targetingInfo = new MobileAdTargetingInfo(
        testDevices: ADMOB_TESTDEVICES != null? ADMOB_TESTDEVICES : null,
        keywords: ADMOB_KEYWORDS,
      );
      */
    }

    showInterstitialAd(){
      _interstitialAd = InterstitialAd(
          adUnitId: TEST_MODE ? InterstitialAd.testAdUnitId : _interstitialAd_AdUnitId,
          targetingInfo: _targetingInfo,
          listener: (MobileAdEvent event) {
            print("INTERSTITIAL EVENT: $event");

            if (event == MobileAdEvent.loaded) {
              isAdLoaded = true;
            } else if (event == MobileAdEvent.failedToLoad) {
              isAdLoaded = false;
            }
          }
      );
      _interstitialAd..load()..show();
    }

    disposeInterstitialAd(){
      _interstitialAd.dispose();
    }

}
