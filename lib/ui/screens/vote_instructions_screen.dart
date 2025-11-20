import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../../monetization/ads_service.dart';
import '../../providers/premium_provider.dart';
import '../../providers/game_provider.dart';
import 'reveal_screen.dart';

class VoteInstructionsScreen extends StatefulWidget {
  const VoteInstructionsScreen({Key? key}) : super(key: key);

  @override
  State<VoteInstructionsScreen> createState() => _VoteInstructionsScreenState();
}

class _VoteInstructionsScreenState extends State<VoteInstructionsScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isPremium =
        Provider.of<PremiumProvider>(context, listen: false).isPremium;
    // Solo mostramos intersticiales en móvil para evitar errores en Windows/Web
    bool isMobile = !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);

    if (!isPremium && isMobile) {
      AdsService().loadAndShowInterstitial(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HORA DE VOTAR')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.how_to_vote, size: 100, color: Colors.redAccent),
            const SizedBox(height: 40),
            const Text(
              'SEÑALEN AL SOSPECHOSO',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              'A la cuenta de 3, señalad con el dedo a quién creéis que es el impostor.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Preserve the existing GameProvider when navigating to RevealScreen
                  final gp = Provider.of<GameProvider>(context, listen: false);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChangeNotifierProvider.value(
                        value: gp,
                        child: const RevealScreen(),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
                child: const Text('VER RESULTADOS',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
