import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/premium_provider.dart';
import '../widgets/primary_button.dart';
import '../widgets/ad_banner_widget.dart';
import 'home_screen.dart';
import 'premium_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPremium = Provider.of<PremiumProvider>(context).isPremium;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            // Use the hector background if available
            ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/hector_logo.png',
                      height: 140,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink()),
                  const SizedBox(height: 20),
                  const Text('Football Impostor',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  const Text(
                      'Pass & Play — Todo hablado. Doble toque para avanzar.',
                      textAlign: TextAlign.center),
                ],
              ),
            ),
            Column(
              children: [
                PrimaryButton(
                  label: 'Comenzar',
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()));
                  },
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  icon: Image.asset('assets/hector_icon.png',
                      height: 18,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink()),
                  label: const Text('Quitar anuncios'),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const PremiumScreen())),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Cómo jugar'),
                        content: const Text(
                            'Modo Pass & Play. Introduce los nombres en la siguiente pantalla. Durante la partida, todo se hace hablado y las pantallas secretas avanzan solo con doble toque.'),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cerrar'))
                        ],
                      ),
                    );
                  },
                  child: const Text('Cómo jugar'),
                ),
                const SizedBox(height: 12),
                if (!isPremium) const AdBannerWidget(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
