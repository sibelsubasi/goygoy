import 'dart:io';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:mobile/commons/addCommons.dart';


class AdmobAd {

    static const bool TEST_MODE = true; /* TODO: False on prod!!! */

    static const List<String> ADMOB_TESTDEVICES = ['B713C0E2C99277356B96BD5D55D4BB87']; //5f1f2d8b91097b02
    static const List<String> ADMOB_KEYWORDS = ['picture', 'speech', 'bubble', 'editor'];
    //static const String APP_ID_IOS = 'ca-app-pub-7026258186722315~8694725930'; // INTO Info.plist
    //static const String APP_ID_ANDROID = 'ca-app-pub-7026258186722315~5508437197'; // INTO AndroidManifest

    static const String BANNER_AD_UNIT_ID_IOS = 'ca-app-pub-7026258186722315/2380037943';
    static const String BANNER_AD_UNIT_ID_ANDROID = 'ca-app-pub-7026258186722315/9328589674';
    static const String INTERSTITIAL_AD_UNIT_ID_IOS = 'ca-app-pub-7026258186722315/9678319322';
    static const String INTERSTITIAL_AD_UNIT_ID_ANDROID = 'ca-app-pub-7026258186722315/5185482496';

    final String _bannerAd_AdUnitId = Platform.isAndroid ? BANNER_AD_UNIT_ID_ANDROID : BANNER_AD_UNIT_ID_IOS;
    final String _interstitialAd_AdUnitId = Platform.isAndroid ? INTERSTITIAL_AD_UNIT_ID_ANDROID : INTERSTITIAL_AD_UNIT_ID_IOS;


    static final AdmobAd _instance = AdmobAd._internal();
    factory AdmobAd() => _instance;

    MobileAdTargetingInfo _targetingInfo;
    InterstitialAd _interstitialAd;
    BannerAd _bannerAd;
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

    showBannerAd(){
      _bannerAd = BannerAd(
          adUnitId: TEST_MODE ? BannerAd.testAdUnitId : _bannerAd_AdUnitId,
          size: AdSize.banner,
          targetingInfo: _targetingInfo,
          listener: (MobileAdEvent event) {
            print("BANNER EVENT: $event");

            try {
              if (event == MobileAdEvent.loaded) {
                AddCommon.isAdShown = true;
              } else if (event == MobileAdEvent.failedToLoad) {
                AddCommon.isAdShown = false;
              }
            } on Exception catch (error) {
              print('BANNER HATA!, ${error.toString()}');
            }

          }
      );
      _bannerAd..load()..show(anchorType: AnchorType.top);
    }

    void disposeBannerAd() {

      try{
        _bannerAd.dispose();
      }catch(e){
        print("ERRROOOOOOOOOOOOOOOR");
        print(e);
      }

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
