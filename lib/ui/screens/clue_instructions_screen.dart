import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';
import '../../utils/app_localizations.dart';
import '../../utils/app_colors.dart';
import '../../utils/page_transitions.dart';
import '../widgets/background_with_logo.dart';
import '../widgets/phase_indicator.dart';
import 'vote_instructions_screen.dart';

class ClueInstructionsScreen extends StatefulWidget {
  final bool isQuickGame;
  
  const ClueInstructionsScreen({
    Key? key,
    this.isQuickGame = true, // Por defecto es partida rápida
  }) : super(key: key);

  @override
  State<ClueInstructionsScreen> createState() => _ClueInstructionsScreenState();
}

class _ClueInstructionsScreenState extends State<ClueInstructionsScreen> {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final gp = context.watch<GameProvider>();
    final firstPlayerName = gp.playerNames.isNotEmpty && gp.currentIndex < gp.playerNames.length
        ? gp.playerNames[gp.currentIndex]
        : '';
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BackgroundWithLogo(
        child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          24.0,
          24.0,
          24.0,
          24.0 + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Indicador de fase
            const PhaseIndicator(currentPhase: GamePhase.discussion),
            const SizedBox(height: 24),
            
            // Icono o ilustración central - Más grande para legibilidad
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primaryGlow,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.record_voice_over_outlined,
                  size: 100, color: AppColors.primary),
            ),
            const SizedBox(height: 32),

            // Título más grande y con mejor contraste
            Text(
              loc.text('clue_headline'),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                  shadows: [
                    Shadow(
                      color: AppColors.primaryGlow,
                      blurRadius: 10,
                    ),
                  ]),
            ),
            const SizedBox(height: 32),

            // Instrucciones con mejor legibilidad
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.backgroundCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border, width: 2),
                boxShadow: AppColors.primaryGlowShadow,
              ),
              child: Text(
                loc.text('clue_body'),
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontSize: 20, 
                    height: 1.8, 
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            ),

            const SizedBox(height: 32),

            // Mostrar quién empieza - diseño compacto horizontal
            if (firstPlayerName.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.accent, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentGlow,
                      blurRadius: 8,
                      spreadRadius: 0.5,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.play_circle_filled,
                      color: AppColors.accent,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      loc.locale.languageCode == 'es' 
                          ? 'COMIENZA:' 
                          : 'STARTS:',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      firstPlayerName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accent,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            Text(
              loc.text('clue_next_hint'),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              )),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final gp = Provider.of<GameProvider>(context, listen: false);
                  Navigator.pushReplacement(
                    context,
                    PageTransitions.slideAndFadeFromRight(
                      ChangeNotifierProvider.value(
                        value: gp,
                        child: VoteInstructionsScreen(isQuickGame: widget.isQuickGame),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  elevation: 8,
                  shadowColor: AppColors.accentGlow,
                ),
                child: Text(loc.text('clue_next_cta'),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
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
