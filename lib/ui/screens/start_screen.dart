import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/premium_provider.dart';
import '../../utils/app_localizations.dart';
import '../widgets/primary_button.dart';
import '../widgets/ad_banner_widget.dart';
import 'home_screen.dart';
import 'premium_screen.dart';
import 'settings_screen.dart';
import 'tutorial_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> 
    with SingleTickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoAnimation;

  @override
  void initState() {
    super.initState();
    
    // Animación del logo
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.elasticOut,
      ),
    );
    
    _logoController.forward();
    _maybeShowTutorial();
  }
  
  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  Future<void> _maybeShowTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('has_seen_tutorial') ?? false;
    if (!seen && mounted) {
      // Esperar un momento antes de mostrar tutorial
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const TutorialScreen()),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final isPremium = Provider.of<PremiumProvider>(context).isPremium;
    final loc = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
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
                  // Logo con animación
                  ScaleTransition(
                    scale: _logoAnimation,
                    child: SvgPicture.asset('assets/hector_logo.svg',
                        height: 140,
                        placeholderBuilder: (_) => const SizedBox.shrink()),
                  ),
                  const SizedBox(height: 20),
                  // Título con fade
                  FadeTransition(
                    opacity: _logoAnimation,
                    child: Text(
                      loc.text('title'),
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FadeTransition(
                    opacity: _logoAnimation,
                    child: Text(
                      loc.text('start_subtitle'),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                PrimaryButton(
                  label: loc.text('start_play'),
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()));
                  },
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  icon: SvgPicture.asset('assets/hector_logo.svg',
                      height: 18,
                      placeholderBuilder: (_) => const SizedBox.shrink()),
                  label: Text(loc.text('start_remove_ads')),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const PremiumScreen())),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TutorialScreen(showSkip: true),
                      ),
                    );
                  },
                  child: Text(loc.text('start_how_to_play')),
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
