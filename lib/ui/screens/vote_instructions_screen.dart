import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../../monetization/ads_service.dart';
import '../../providers/premium_provider.dart';
import '../../providers/game_provider.dart';
import '../../utils/app_localizations.dart';
import '../../utils/app_colors.dart';
import '../../utils/page_transitions.dart';
import '../widgets/background_with_logo.dart';
import '../widgets/phase_indicator.dart';
import 'reveal_screen.dart';

class VoteInstructionsScreen extends StatefulWidget {
  final bool isQuickGame;
  
  const VoteInstructionsScreen({
    Key? key,
    this.isQuickGame = true, // Por defecto es partida rápida
  }) : super(key: key);

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
    final loc = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BackgroundWithLogo(
        child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Indicador de fase
            PhaseIndicator(currentPhase: GamePhase.voting),
            const SizedBox(height: 24),
            
            // Icono más grande para mejor visibilidad
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.accentGlow,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.how_to_vote, size: 100, color: AppColors.accent),
            ),
            const SizedBox(height: 32),
            
            // Título más grande y con mejor contraste
            Text(
              loc.text('vote_headline'),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      color: AppColors.accentGlow,
                      blurRadius: 10,
                    ),
                  ]),
            ),
            const SizedBox(height: 24),
            
            // Instrucciones con mejor legibilidad
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.backgroundCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border, width: 2),
              ),
              child: Text(
                loc.text('vote_body'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20, 
                  height: 1.6,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Preserve the existing GameProvider when navigating to RevealScreen
                  // La votación se hace completamente hablada, sin registro manual
                  final gp = Provider.of<GameProvider>(context, listen: false);
                  Navigator.pushReplacement(
                    context,
                    PageTransitions.rotateWithFade(
                      ChangeNotifierProvider.value(
                        value: gp,
                        child: RevealScreen(isQuickGame: widget.isQuickGame),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  elevation: 8,
                  shadowColor: AppColors.primaryGlow,
                ),
                child: Text(loc.text('vote_cta'),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
        ),
      ),
    );
  }
}
