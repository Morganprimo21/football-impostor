import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';
import '../../providers/premium_provider.dart';
import '../../data/models/player_role.dart';
import '../../utils/app_localizations.dart';
import '../../utils/app_colors.dart';
import '../../utils/page_transitions.dart';
import '../../services/sound_service.dart';
import '../widgets/ad_banner_widget.dart';
import '../widgets/background_with_logo.dart';
import '../widgets/vector_logo.dart';
import 'clue_instructions_screen.dart';

class LobbyScreen extends StatefulWidget {
  final bool isQuickGame;
  
  const LobbyScreen({
    Key? key,
    this.isQuickGame = true, // Por defecto es partida rápida
  }) : super(key: key);

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  final Set<String> _readyPlayers = {};

  void _showRoleDialog(
      BuildContext context, String playerName, GameProvider gp) {
    final role = gp.roles[playerName];
    final secretPlayer = gp.assignedPlayers[playerName];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        bool isRevealed = false;

        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            backgroundColor: const Color(0xFF2D4A3E),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(
                    color: Color(0xFF00A86B), width: 2)),
            title: Text(
              isRevealed ? 'TU MISIÓN' : 'IDENTIFICACIÓN',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isRevealed) ...[
                  Icon(Icons.fingerprint,
                      size: 80,
                      color: Theme.of(context).primaryColor.withAlpha(128)),
                  const SizedBox(height: 20),
                  Text('¿Eres $playerName?',
                      style:
                          const TextStyle(fontSize: 16, color: Colors.white70)),
                  const SizedBox(height: 10),
                  const Text(
                      'Confirma tu identidad para ver tu información secreta.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey)),
                ] else ...[
                  // --- LÓGICA DE VISUALIZACIÓN DE ROLES ---
                  if (role == PlayerRole.impostor) ...[
                    // CASO IMPOSTOR
                    const Icon(Icons.warning_amber_rounded,
                        size: 80, color: Colors.redAccent),
                    const SizedBox(height: 20),
                    const Text('ERES EL IMPOSTOR',
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 19,
                            fontWeight: FontWeight.w900)),
                    const SizedBox(height: 15),
                    const Text(
                        'No conoces al jugador.\nEscucha a los demás y finge saber de quién hablan.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 14)),
                  ] else ...[
                    // CASO INOCENTE / INFORMADO
                    const CircularVectorLogo(size: 100),
                    const SizedBox(height: 20),
                    const Text('AGENTE INOCENTE',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    const Text('El jugador es:',
                        style: TextStyle(color: Colors.white54)),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Column(
                        children: [
                          Text(secretPlayer?.name ?? 'ERROR',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
              ],
            ),
            actions: [
              if (!isRevealed)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      SoundService().playRoleReveal();
                      setStateDialog(() => isRevealed = true);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800]),
                    child: const Text('VER ROL',
                        style: TextStyle(color: Colors.white)),
                  ),
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      SoundService().playButtonSuccess();
                      setState(() => _readyPlayers.add(playerName));
                      Navigator.pop(dialogContext);
                    },
                    child: const Text('ENTENDIDO'),
                  ),
                ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    // Optimizar: usar watch solo para GameProvider que cambia frecuentemente
    final gp = context.watch<GameProvider>();
    // Usar read para valores que no cambian durante el build
    final isPremium = context.read<PremiumProvider>().isPremium;
    final allReady = _readyPlayers.length == gp.playerNames.length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
      ),
      backgroundColor: Colors.transparent,
      body: BackgroundWithLogo(
        child: Column(
          children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              loc.text('lobby_instruction'),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: gp.playerNames.length,
              // Optimizar con keys y RepaintBoundary
              itemBuilder: (context, index) {
                final name = gp.playerNames[index];
                final isReady = _readyPlayers.contains(name);
                
                return RepaintBoundary(
                  key: ValueKey('player_card_$name'),
                  child: GestureDetector(
                  onTap: isReady ? null : () => _showRoleDialog(context, name, gp),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: isReady
                          ? AppColors.successDark.withOpacity(0.3)
                          : AppColors.backgroundCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isReady
                            ? Theme.of(context).primaryColor
                            : Colors.white10,
                        width: isReady ? 2 : 1,
                      ),
                      boxShadow: [
                        if (isReady)
                          BoxShadow(
                              color:
                                  Theme.of(context).primaryColor.withAlpha(77),
                              blurRadius: 8,
                              spreadRadius: 1)
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isReady
                              ? Icons.check_circle_outline
                              : Icons.lock_outline,
                          color: isReady
                              ? Theme.of(context).primaryColor
                              : Colors.white54,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isReady ? Colors.white : Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (isReady)
                          const Text('CONFIRMADO',
                              style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 10,
                                  letterSpacing: 1.5)),
                      ],
                    ),
                  ),
                ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.backgroundSurface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              border: Border(top: BorderSide(color: AppColors.border, width: 1)),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: allReady
                        ? () {
                            // Usar read en lugar de Provider.of con listen: false
                            final gp = context.read<GameProvider>();
                            Navigator.pushReplacement(
                              context,
                              PageTransitions.scaleWithFade(
                                ChangeNotifierProvider.value(
                                  value: gp,
                                  child: ClueInstructionsScreen(isQuickGame: widget.isQuickGame),
                                ),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: allReady
                          ? Theme.of(context).colorScheme.secondary
                          : Colors.grey[800],
                      disabledBackgroundColor: Colors.grey[850],
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      allReady
                          ? (loc.locale.languageCode == 'es' 
                              ? 'INICIAR PARTIDA' 
                              : 'START GAME')
                          : loc.text('lobby_waiting'),
                      style: TextStyle(
                          fontSize: 16,
                          letterSpacing: 1,
                          color: allReady ? Colors.white : Colors.grey[600]),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (!isPremium) const AdBannerWidget(),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }
}
