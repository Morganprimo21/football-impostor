import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import '../../monetization/purchase_service.dart';
import '../../providers/premium_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_localizations.dart';

/// Pantalla para contratar Premium mensual (todas las ligas + sin anuncios).
class PremiumScreen extends StatefulWidget {
  const PremiumScreen({Key? key}) : super(key: key);

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  final PurchaseService _purchaseService = PurchaseService();
  bool _loading = false;

  bool get _isStorePlatform =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  @override
  void initState() {
    super.initState();
    if (_isStorePlatform) {
      _purchaseService.init(onPurchaseUpdated: (purchase) async {
        // Solo manejamos aquí la suscripción Premium mensual.
        if (purchase.productID != StoreProducts.premiumSubscriptionId) {
          return;
        }

        if (purchase.status == PurchaseStatus.pending) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context).text('premium_pending'))),
            );
          }
        } else if (purchase.status == PurchaseStatus.error) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context).text('premium_failed'))),
            );
          }
        } else if (purchase.status == PurchaseStatus.purchased ||
            purchase.status == PurchaseStatus.restored) {
          try {
            // Activar Premium (todas las ligas + sin anuncios)
            await Provider.of<PremiumProvider>(context, listen: false)
                .setPremium(value: true);
            // Completar la compra en la store
            await InAppPurchase.instance.completePurchase(purchase);
            if (mounted) Navigator.pop(context);
          } catch (_) {
            // Ignorar errores puntuales
          }
        }
      });
    }
  }

  Future<void> _buy(BuildContext context) async {
    if (!_isStorePlatform) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          AppLocalizations.of(context).text('premium_only_stores'),
        ),
      ));
      return;
    }
    setState(() => _loading = true);
    await _purchaseService.buyProduct(StoreProducts.premiumSubscriptionId);
    // El resultado real se gestiona en el listener de init()
    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _purchaseService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isPremium = Provider.of<PremiumProvider>(context).isPremium;
    return Scaffold(
      backgroundColor: AppColors.backgroundDeep,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          20.0,
          20.0,
          20.0,
          20.0 + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.amber.shade700, Colors.amber.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.star,
                      size: 64,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Football Impostor',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'PREMIUM',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      loc.text('premium_price'),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Benefits Section
            Text(
              loc.text('premium_what_includes'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Benefit 1: All Leagues
            _buildBenefitCard(
              icon: Icons.emoji_events,
              iconColor: AppColors.primary,
              title: loc.text('premium_all_leagues'),
              description: loc.text('premium_all_leagues_desc'),
              gradient: LinearGradient(
                colors: [AppColors.primary.withOpacity(0.2), AppColors.primary.withOpacity(0.05)],
              ),
            ),
            const SizedBox(height: 12),

            // Benefit 2: No Ads
            _buildBenefitCard(
              icon: Icons.block,
              iconColor: AppColors.error,
              title: loc.text('premium_no_ads'),
              description: loc.text('premium_no_ads_desc'),
              gradient: LinearGradient(
                colors: [AppColors.error.withOpacity(0.2), AppColors.error.withOpacity(0.05)],
              ),
            ),
            const SizedBox(height: 12),

            // Benefit 3: Uninterrupted
            _buildBenefitCard(
              icon: Icons.celebration,
              iconColor: AppColors.accent,
              title: loc.text('premium_ideal_parties'),
              description: loc.text('premium_ideal_parties_desc'),
              gradient: LinearGradient(
                colors: [AppColors.accent.withOpacity(0.2), AppColors.accent.withOpacity(0.05)],
              ),
            ),
            const SizedBox(height: 12),

            // Benefit 4: Cancel Anytime
            _buildBenefitCard(
              icon: Icons.verified_user,
              iconColor: AppColors.success,
              title: loc.text('premium_cancel_anytime'),
              description: loc.text('premium_cancel_anytime_desc'),
              gradient: LinearGradient(
                colors: [AppColors.success.withOpacity(0.2), AppColors.success.withOpacity(0.05)],
              ),
            ),
            const SizedBox(height: 32),

            // Status or Buy Button
            if (isPremium)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.success, width: 2),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: AppColors.success, size: 32),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Premium activo\n¡Disfruta de todas las funciones!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else if (_isStorePlatform) ...[
              SizedBox(
                height: 64,
                child: ElevatedButton(
                  onPressed: _loading ? null : () => _buy(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    elevation: 8,
                    shadowColor: Colors.amber.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.star, size: 24),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                loc.text('premium_activate'),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () async {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Restaurando compras...')),
                  );
                  await _purchaseService.restorePurchases();
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: AppColors.primary, width: 2),
                ),
                child: Text(
                  loc.text('premium_restore'),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ] else
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange, width: 1.5),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.info, color: Colors.orange),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Las compras in-app solo funcionan en Android/iOS desde la tienda.',
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required Gradient gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: iconColor.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
