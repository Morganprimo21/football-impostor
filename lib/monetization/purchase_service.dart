import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

/// IDs de productos configurados en Play Store / App Store.
///
/// IMPORTANTE: debes crear estos productos en la consola correspondiente y
/// usar exactamente los mismos IDs aquí.
class StoreProducts {
  /// Suscripción mensual Premium (2,99 €/mes, todas las ligas + sin anuncios)
  static const String premiumSubscriptionId = 'premium_all_monthly';

  /// Packs individuales (compra única, 0,99 €)
  static const String premierPackId = 'pack_premier_099';
  static const String laLigaPackId = 'pack_laliga_099';
  static const String serieAPackId = 'pack_seriea_099';
  static const String bundesPackId = 'pack_bundes_099';

  /// Pack Legends (compra única, 1,99 €)
  static const String legendsPackId = 'pack_legends_199';
}

typedef PurchaseUpdatedCallback = Future<void> Function(
    PurchaseDetails purchase);

class PurchaseService {
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _sub;
  PurchaseUpdatedCallback? _onPurchaseUpdated;

  bool get _isSupportedPlatform =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  /// Inicializa el servicio y empieza a escuchar cambios de compra.
  Future<void> init({PurchaseUpdatedCallback? onPurchaseUpdated}) async {
    if (!_isSupportedPlatform) {
      return;
    }
    _onPurchaseUpdated = onPurchaseUpdated;
    try {
      final available = await _iap.isAvailable();
      if (!available) return;
      _sub = _iap.purchaseStream.listen((purchases) async {
        for (final p in purchases) {
          if (_onPurchaseUpdated != null) {
            await _onPurchaseUpdated!(p);
          }
        }
      }, onError: (error) {
        // Podrías registrar el error si lo necesitas
      });
    } catch (_) {
      // En plataformas no soportadas el plugin puede no inicializarse.
    }
  }

  /// Compra genérica de producto no consumible (packs o suscripción).
  Future<void> buyProduct(String productId) async {
    if (!_isSupportedPlatform) return;
    try {
      final available = await _iap.isAvailable();
      if (!available) return;

      final ProductDetailsResponse response =
          await _iap.queryProductDetails({productId});
      if (response.notFoundIDs.isNotEmpty ||
          response.productDetails.isEmpty) return;

      final product = response.productDetails.first;
      final purchaseParam = PurchaseParam(productDetails: product);

      // Para suscripciones y no‑consumibles se usa buyNonConsumable
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (_) {
      // Ignoramos errores por ahora; la UI seguirá igual.
    }
  }

  Future<void> restorePurchases() async {
    if (!_isSupportedPlatform) return;
    try {
      await _iap.restorePurchases();
    } catch (_) {
      // Ignorar errores en plataformas no soportadas.
    }
  }

  void dispose() {
    _sub?.cancel();
    _sub = null;
  }
}
