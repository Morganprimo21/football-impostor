import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import '../../data/models/player_pack.dart';
import '../../monetization/purchase_service.dart';
import '../../providers/game_provider.dart';
import '../../providers/premium_provider.dart';
import '../../utils/app_colors.dart';
import 'premium_screen.dart';

/// Pantalla de selección de packs de jugadores
class PlayerPacksScreen extends StatelessWidget {
  const PlayerPacksScreen({Key? key}) : super(key: key);

  bool get _isStorePlatform =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  @override
  Widget build(BuildContext context) {
    final premiumProvider = context.watch<PremiumProvider>();
    final gameProvider = context.watch<GameProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundDeep,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          16.0,
          16.0,
          16.0,
          16.0 + MediaQuery.of(context).padding.bottom,
        ),
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppColors.primaryGlowShadow,
            ),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8E8E8),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset(
                    'assets/hector_logo.svg',
                    fit: BoxFit.contain,
                    placeholderBuilder: (_) => const Icon(Icons.sports_soccer, size: 40, color: Color(0xFF2D4A3E)),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Elige tu pack favorito',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  premiumProvider.isPremium
                      ? '¡Tienes acceso a todos los packs!'
                      : 'Desbloquea ligas individuales o hazte Premium.',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Packs gratuitos
          const Text(
            'PACKS GRATUITOS',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          ...PlayerPack.freePacks.map((pack) {
            final hasAccess = premiumProvider.hasAccessToPack(pack.id);
            final isSelected = gameProvider.currentLeagueKey == pack.id;
            return _buildPackCard(
              context,
              pack,
              hasAccess: hasAccess,
              isSelected: isSelected,
              priceLabel: null,
              onBuyPressed: null,
            );
          }),

          const SizedBox(height: 24),

          // Packs premium
          const Text(
            'PACKS PREMIUM',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          ...PlayerPack.premiumPacks.map((pack) {
            final hasAccess = premiumProvider.hasAccessToPack(pack.id);
            final isSelected = gameProvider.currentLeagueKey == pack.id;
            final priceLabel = _priceForPack(pack.id);
            return _buildPackCard(
              context,
              pack,
              hasAccess: hasAccess,
              isSelected: isSelected,
              priceLabel: priceLabel,
              onBuyPressed: hasAccess
                  ? null
                  : () => _purchasePack(context, pack.id),
            );
          }),

          const SizedBox(height: 24),

          // CTA para Premium global
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PremiumScreen()),
              );
            },
            icon: const Icon(Icons.star),
            label: const Text('Hazte PREMIUM (2,99 €/mes – todo incluido)'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => _restorePacks(context),
            icon: const Icon(Icons.refresh),
            label: const Text('Restaurar compras de packs'),
          ),
        ],
      ),
    );
  }

  String? _priceForPack(String packId) {
    switch (packId) {
      case 'legends':
        return '1,99 €';
      case 'premier':
      case 'laliga':
      case 'seriea':
      case 'bundes':
        return '0,99 €';
      default:
        return null;
    }
  }

  /// Restaura las compras de packs individuales en este dispositivo
  Future<void> _restorePacks(BuildContext context) async {
    if (!_isStorePlatform) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'La restauración solo está disponible en Android/iOS desde la tienda.',
        ),
      ));
      return;
    }

    final purchaseService = PurchaseService();
    final premiumProvider =
        Provider.of<PremiumProvider>(context, listen: false);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Restaurando compras de packs...'),
    ));

    await purchaseService.init(onPurchaseUpdated: (purchase) async {
      String? packId;
      switch (purchase.productID) {
        case StoreProducts.premierPackId:
          packId = 'premier';
          break;
        case StoreProducts.laLigaPackId:
          packId = 'laliga';
          break;
        case StoreProducts.serieAPackId:
          packId = 'seriea';
          break;
        case StoreProducts.bundesPackId:
          packId = 'bundes';
          break;
        case StoreProducts.legendsPackId:
          packId = 'legends';
          break;
        default:
          packId = null;
      }

      if (packId == null) return;

      if (purchase.status == PurchaseStatus.pending) {
        // Nada especial, ya se ha mostrado el mensaje inicial
      } else if (purchase.status == PurchaseStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No se han podido restaurar algunas compras.'),
        ));
      } else if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        // Solo desbloquear el pack específico
        await premiumProvider.addOwnedPack(packId);
        try {
          await InAppPurchase.instance.completePurchase(purchase);
        } catch (_) {
          // Ignorar errores puntuales al completar
        }
      }
    });

    await purchaseService.restorePurchases();
  }

  String? _productIdForPack(String packId) {
    switch (packId) {
      case 'premier':
        return StoreProducts.premierPackId;
      case 'laliga':
        return StoreProducts.laLigaPackId;
      case 'seriea':
        return StoreProducts.serieAPackId;
      case 'bundes':
        return StoreProducts.bundesPackId;
      case 'legends':
        return StoreProducts.legendsPackId;
      default:
        return null;
    }
  }

  Future<void> _purchasePack(BuildContext context, String packId) async {
    final productId = _productIdForPack(packId);
    if (productId == null) return;

    if (!_isStorePlatform) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Las compras solo están disponibles en Android/iOS desde la tienda.',
        ),
      ));
      return;
    }

    final purchaseService = PurchaseService();
    final premiumProvider =
        Provider.of<PremiumProvider>(context, listen: false);

    await purchaseService.init(onPurchaseUpdated: (purchase) async {
      if (purchase.productID != productId) {
        return;
      }

      if (purchase.status == PurchaseStatus.pending) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Compra pendiente...'),
        ));
      } else if (purchase.status == PurchaseStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('La compra ha fallado'),
        ));
        purchaseService.dispose();
      } else if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        try {
          // Solo desbloquear el pack específico comprado
          await premiumProvider.addOwnedPack(packId);
          await InAppPurchase.instance.completePurchase(purchase);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Pack desbloqueado correctamente'),
          ));
        } finally {
          purchaseService.dispose();
        }
      }
    });

    await purchaseService.buyProduct(productId);
  }

  Widget _buildPackCard(
    BuildContext context,
    PlayerPack pack, {
    required bool hasAccess,
    required bool isSelected,
    required String? priceLabel,
    required VoidCallback? onBuyPressed,
  }) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);

    final isLocked = !hasAccess;

    return InkWell(
      onTap: () {
        if (isLocked) {
          if (onBuyPressed != null) onBuyPressed();
        } else {
          gameProvider.setLeagueKey(pack.id);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Pack seleccionado: ${pack.name}'),
          ));
          Navigator.pop(context);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isLocked
              ? AppColors.backgroundCard.withOpacity(0.5)
              : AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.accent
                : (isLocked ? AppColors.border : AppColors.primary),
            width: isSelected ? 3 : (isLocked ? 1 : 2),
          ),
          boxShadow: isLocked
              ? null
              : [
                  BoxShadow(
                    color: AppColors.primaryGlow.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            // Emoji grande
            Text(
              pack.emoji,
              style: TextStyle(
                fontSize: 48,
                color: isLocked ? Colors.grey : null,
              ),
            ),
            const SizedBox(width: 20),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        pack.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isLocked ? Colors.grey : Colors.white,
                        ),
                      ),
                      if (pack.isPremium) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'PREMIUM',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pack.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: isLocked ? Colors.grey.shade600 : Colors.white70,
                    ),
                  ),
                  if (priceLabel != null && pack.isPremium) ...[
                    const SizedBox(height: 4),
                    Text(
                      hasAccess
                          ? 'Incluido con tu compra'
                          : '$priceLabel (compra única)',
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            hasAccess ? Colors.greenAccent : Colors.white70,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Estado (candado / seleccionado / disponible)
            if (isLocked)
              IconButton(
                icon: const Icon(Icons.lock, color: Colors.grey),
                onPressed: onBuyPressed,
              )
            else if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.accent,
                size: 32,
              )
            else
              Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 28,
              ),
          ],
        ),
      ),
    );
  }
}

