import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../../providers/premium_provider.dart';
import '../../monetization/ads_service.dart';

/// Widget que muestra un banner publicitario
/// Se oculta automáticamente si el usuario es Premium
class AdBannerWidget extends StatefulWidget {
  const AdBannerWidget({Key? key}) : super(key: key);

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    final premiumProvider = Provider.of<PremiumProvider>(context, listen: false);
    
    // No cargar anuncios si el usuario es premium
    if (premiumProvider.isPremium) {
      return;
    }

    _bannerAd = AdsService().createBannerAdUnit();
    _bannerAd!.load().then((_) {
      if (mounted) {
        setState(() {
          _isAdLoaded = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final premiumProvider = Provider.of<PremiumProvider>(context);

    // No mostrar nada si el usuario es premium
    if (premiumProvider.isPremium) {
      return const SizedBox.shrink();
    }

    // No mostrar nada si el anuncio no está cargado
    if (!_isAdLoaded || _bannerAd == null) {
      return const SizedBox(
        height: 50,
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    return Container(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      color: Colors.black,
      child: AdWidget(ad: _bannerAd!),
    );
  }
}

