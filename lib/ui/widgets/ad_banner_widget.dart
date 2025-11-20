import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../monetization/ads_service.dart';
import '../../providers/premium_provider.dart';

class AdBannerWidget extends StatefulWidget {
  const AdBannerWidget({Key? key}) : super(key: key);

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  BannerAd? _banner;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initBanner();
  }

  void _initBanner() {
    final isPremium = Provider.of<PremiumProvider>(context).isPremium;
    final bool isMobile = !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);
    if (isPremium || !isMobile) return;
    try {
      _banner?.dispose();
      _banner = BannerAd(
        size: AdSize.banner,
        adUnitId: AdsService.bannerAdUnitId,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            if (mounted) setState(() {});
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            debugPrint('Ad failed to load: $error');
            if (mounted) setState(() => _banner = null);
          },
        ),
      );
      _banner?.load();
    } catch (e) {
      debugPrint('Error cargando anuncios: $e');
    }
  }

  @override
  void dispose() {
    _banner?.dispose();
    _banner = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPremium = Provider.of<PremiumProvider>(context).isPremium;
    if (isPremium) return const SizedBox.shrink();
    if (_banner == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Image.asset('assets/hector_banner.png',
            fit: BoxFit.contain,
            height: 50,
            errorBuilder: (_, __, ___) => const SizedBox.shrink()),
      );
    }
    return SizedBox(
      width: _banner!.size.width.toDouble(),
      height: _banner!.size.height.toDouble(),
      child: AdWidget(ad: _banner!),
    );
  }
}
