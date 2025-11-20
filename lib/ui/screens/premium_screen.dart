import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../monetization/purchase_service.dart';
import '../../providers/premium_provider.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({Key? key}) : super(key: key);

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  final PurchaseService _purchaseService = PurchaseService();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _purchaseService.init(onPurchaseUpdated: (purchase) async {
      // Handle completed purchases
      if (purchase.status == PurchaseStatus.pending) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Purchase pending...')));
        }
      } else if (purchase.status == PurchaseStatus.error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Purchase failed')));
        }
      } else if (purchase.status == PurchaseStatus.purchased || purchase.status == PurchaseStatus.restored) {
        try {
          // mark premium
          await Provider.of<PremiumProvider>(context, listen: false).setPremium(value: true);
          // complete the purchase
          await InAppPurchase.instance.completePurchase(purchase);
          if (mounted) Navigator.pop(context);
        } catch (e) {
          // ignore errors here
        }
      }
    });
  }

  Future<void> _buy(BuildContext context) async {
    setState(() => _loading = true);
    await _purchaseService.buyRemoveAds();
    // purchase result will be handled by the listener
    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _purchaseService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quitar anuncios')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Text('Quitar anuncios',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text(
                'Compra "remove_ads" para eliminar banners e interstitials. Todo se guarda localmente.'),
            const SizedBox(height: 20),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () => _buy(context),
                    child: const Text('Comprar quitar anuncios'),
                  ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Restoring purchases...')));
                await _purchaseService.restorePurchases();
              },
              child: const Text('Restaurar compras'),
            ),
          ],
        ),
      ),
    );
  }
}
