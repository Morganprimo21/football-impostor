import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../providers/premium_provider.dart';

class AdsService {
  static final AdsService _instance = AdsService._internal();
  factory AdsService() => _instance;
  AdsService._internal();

  bool get _isMobile =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  // Test ad unit IDs (Google test ids)
  static const String testBannerAdUnitId =
      'ca-app-pub-3940256099942544/6300978111';
  static const String testInterstitialAdUnitId =
      'ca-app-pub-3940256099942544/1033173712';
  static const String testAppOpenAdUnitId =
      'ca-app-pub-3940256099942544/3419835294';

  // Use test IDs by default for development. Replace with real IDs before release.
  static const String bannerAdUnitId = testBannerAdUnitId;
  static const String interstitialAdUnitId = testInterstitialAdUnitId;
  static const String appOpenAdUnitId = testAppOpenAdUnitId;

  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  AppOpenAd? _appOpenAd;

  static const List<String> testDeviceIds = <String>['EMULATOR'];

  Future<InitializationStatus?> initialize() {
    if (!_isMobile) return Future.value(null);
    final requestConfiguration =
        RequestConfiguration(testDeviceIds: testDeviceIds);
    MobileAds.instance.updateRequestConfiguration(requestConfiguration);
    final init = MobileAds.instance.initialize();
    init.then((_) => loadAppOpenAd());
    return init;
  }

  BannerAd createBannerAdUnit() {
    return BannerAd(
      size: AdSize.banner,
      adUnitId: bannerAdUnitId,
      request: const AdRequest(),
      listener: const BannerAdListener(),
    );
  }

  Future<void> loadBanner() async {
    if (!_isMobile) return;
    _bannerAd?.dispose();
    _bannerAd = createBannerAdUnit();
    _bannerAd?.load();
  }

  BannerAd? get bannerAd => _bannerAd;

  void disposeBanner() {
    _bannerAd?.dispose();
    _bannerAd = null;
  }

  Future<void> loadAndShowInterstitial(BuildContext context) async {
    if (!_isMobile) return;
    final premium =
        Provider.of<PremiumProvider>(context, listen: false).isPremium;
    if (premium) return;
    await InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialAd?.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
            },
          );
          _interstitialAd?.show();
        },
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial failed to load: $error');
        },
      ),
    );
  }

  void loadAppOpenAd() {
    if (!_isMobile) return;
    try {
      AppOpenAd.load(
        adUnitId: appOpenAdUnitId,
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            _appOpenAd = ad;
            _appOpenAd?.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
                _appOpenAd = null;
                loadAppOpenAd();
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                ad.dispose();
                _appOpenAd = null;
                loadAppOpenAd();
              },
            );
          },
          onAdFailedToLoad: (error) {
            debugPrint('AppOpenAd failed to load: $error');
            _appOpenAd = null;
          },
        ),
      );
    } catch (e) {
      debugPrint('Error loading AppOpenAd: $e');
    }
  }

  void showAppOpenAdIfAvailable() {
    if (!_isMobile) return;
    if (_appOpenAd != null) {
      try {
        _appOpenAd?.show();
      } catch (e) {
        debugPrint('Error showing AppOpenAd: $e');
      }
    } else {
      loadAppOpenAd();
    }
  }
}
