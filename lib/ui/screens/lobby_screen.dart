import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';
import '../../providers/premium_provider.dart';
import '../../data/models/player_role.dart';
import '../widgets/ad_banner_widget.dart';
import 'clue_instructions_screen.dart';

class LobbyScreen extends StatefulWidget {
  const LobbyScreen({Key? key}) : super(key: key);

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
            backgroundColor: const Color(0xFF2C2C2C),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                    color: Theme.of(context).primaryColor, width: 2)),
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
                          const TextStyle(fontSize: 18, color: Colors.white70)),
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
                            fontSize: 22,
                            fontWeight: FontWeight.w900)),
                    const SizedBox(height: 15),
                    const Text(
                        'No conoces al jugador secreto.\nEscucha a los demás y finge saber de quién hablan.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 16)),
                  ] else ...[
                    // CASO INOCENTE / INFORMADO
                    const Icon(Icons.sports_soccer,
                        size: 80, color: Colors.blueAccent),
                    const SizedBox(height: 20),
                    const Text('AGENTE INOCENTE',
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    const Text('El jugador secreto es:',
                        style: TextStyle(color: Colors.white54)),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withAlpha(51),
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: Colors.blueAccent.withAlpha(128)),
                      ),
                      child: Column(
                        children: [
                          Text(secretPlayer?.name ?? 'ERROR',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold)),
                          Text(secretPlayer?.club ?? '',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 14)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (role == PlayerRole.informed)
                      const Text(
                        'INFO EXTRA: Como informado, intenta guiar a los demás sin que el impostor te descubra.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.orangeAccent,
                            fontSize: 12,
                            fontStyle: FontStyle.italic),
                      ),
                  ],
                ],
              ],
            ),
            actions: [
              if (!isRevealed)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => setStateDialog(() => isRevealed = true),
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
    final gp = Provider.of<GameProvider>(context);
    final isPremium = Provider.of<PremiumProvider>(context).isPremium;
    final allReady = _readyPlayers.length == gp.playerNames.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SALA DE REUNIÓN'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Toca tu tarjeta para recibir tu identidad y el jugador secreto.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16),
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
              itemBuilder: (context, index) {
                final name = gp.playerNames[index];
                final isReady = _readyPlayers.contains(name);

                return GestureDetector(
                  onTap:
                      isReady ? null : () => _showRoleDialog(context, name, gp),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: isReady
                          ? const Color(0xFF1B5E20)
                          : const Color(0xFF2C2C2C),
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
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF1E1E1E),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: allReady
                        ? () {
                            final gp = Provider.of<GameProvider>(context,
                                listen: false);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChangeNotifierProvider.value(
                                  value: gp,
                                  child: const ClueInstructionsScreen(),
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
                      allReady ? 'INICIAR MISIÓN' : 'ESPERANDO CONFIRMACIÓN...',
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
    );
  }
}
