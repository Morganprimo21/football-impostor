import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';

// NOTE: Replace this ID with your real product ID configured in Play Store / App Store.
const String removeAdsProductId = 'remove_ads';

typedef PurchaseUpdatedCallback = Future<void> Function(
    PurchaseDetails purchase);

class PurchaseService {
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _sub;
  PurchaseUpdatedCallback? _onPurchaseUpdated;

  /// Initialize and start listening to purchase updates.
  /// Provide a callback that will be called when a purchase is updated.
  Future<void> init({PurchaseUpdatedCallback? onPurchaseUpdated}) async {
    _onPurchaseUpdated = onPurchaseUpdated;
    final available = await _iap.isAvailable();
    if (!available) return;
    _sub = _iap.purchaseStream.listen((purchases) async {
      for (final p in purchases) {
        if (_onPurchaseUpdated != null) {
          await _onPurchaseUpdated!(p);
        }
      }
    }, onError: (error) {
      // handle stream error if needed
    });
  }

  /// Initiates a non-consumable purchase for remove_ads.
  Future<void> buyRemoveAds() async {
    final available = await _iap.isAvailable();
    if (!available) return;
    final ProductDetailsResponse response =
        await _iap.queryProductDetails({removeAdsProductId});
    if (response.notFoundIDs.isNotEmpty) return;
    final product = response.productDetails.first;
    final purchaseParam = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  void dispose() {
    _sub?.cancel();
    _sub = null;
  }
}
