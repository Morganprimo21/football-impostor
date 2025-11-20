import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../monetization/ads_service.dart';
import '../../providers/game_provider.dart';
import '../../providers/premium_provider.dart';
import '../widgets/ad_banner_widget.dart';

class RevealScreen extends StatefulWidget {
  const RevealScreen({Key? key}) : super(key: key);

  @override
  State<RevealScreen> createState() => _RevealScreenState();
}

class _RevealScreenState extends State<RevealScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isPremium = Provider.of<PremiumProvider>(context).isPremium;
    if (!isPremium) {
      AdsService().loadAndShowInterstitial(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final gp = Provider.of<GameProvider>(context);
    String impostorName = '';
    String secretPlayer = '';
    for (final entry in gp.roles.entries) {
      if (entry.value.toString().contains('impostor')) {
        impostorName = entry.key;
        break;
      }
    }
    // pick a secret from assignedPlayers of the impostor (if any)
    if (gp.assignedPlayers.containsKey(impostorName)) {
      secretPlayer = gp.assignedPlayers[impostorName]?.name ?? '';
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Revelar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Large modern impostor card
            Expanded(
              flex: 6,
              child: Center(
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 760),
                  padding:
                      const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1F1B24), Color(0xFF2A2430)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withAlpha(128),
                          blurRadius: 24,
                          offset: const Offset(0, 12)),
                    ],
                    border: Border.all(
                        color:
                            Theme.of(context).colorScheme.primary.withAlpha(60),
                        width: 2),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/hector_icon.png',
                          height: 96,
                          errorBuilder: (_, __, ___) =>
                              const SizedBox.shrink()),
                      const SizedBox(height: 18),
                      const Text('IMPOSTOR',
                          style: TextStyle(
                              letterSpacing: 4,
                              color: Colors.white70,
                              fontSize: 14)),
                      const SizedBox(height: 12),
                      Text(
                        impostorName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).colorScheme.primary,
                          shadows: [
                            BoxShadow(
                                blurRadius: 20,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withAlpha(80),
                                offset: const Offset(0, 6))
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('Jugador secreto: $secretPlayer',
                          style: const TextStyle(color: Colors.white70)),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text('Pulsa "Nueva partida" para reiniciar',
                            style: TextStyle(color: Colors.grey[400])),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // No participants list per user's request — show only impostor card

            const SizedBox(height: 12),
            Consumer<PremiumProvider>(
                builder: (context, p, _) => p.isPremium
                    ? const SizedBox.shrink()
                    : const AdBannerWidget()),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text('Nueva partida'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
