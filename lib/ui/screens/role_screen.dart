import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';
import '../../ui/widgets/double_tap_detector.dart';
import 'clue_instructions_screen.dart';
import '../../data/models/player_role.dart'; // Import added here

class RoleScreen extends StatelessWidget {
  const RoleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gp = Provider.of<GameProvider>(context);
    final name = gp.playerNames[gp.currentIndex];
    final role = gp.roles[name];
    final secret = gp.assignedPlayers[name];
    return Scaffold(
      appBar: AppBar(title: const Text('Tu turno')),
      body: Container(
        decoration: const BoxDecoration(),
        padding: const EdgeInsets.all(16),
        child: DoubleTapDetector(
          onDoubleTap: () {
            // advance to next player or to clue instructions if all seen
            if (gp.currentIndex + 1 >= gp.playerNames.length) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider.value(
                    value: gp,
                    child: const ClueInstructionsScreen(),
                  ),
                ),
              );
            } else {
              gp.nextPlayer();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider.value(
                    value: gp,
                    child: const RoleScreen(),
                  ),
                ),
              );
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/hector_icon.png',
                  height: 120,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink()),
              const SizedBox(height: 16),
              Text(name,
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              if (role == null)
                const SizedBox.shrink()
              else
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    role == PlayerRole.informed
                        ? 'Jugador asignado: ${secret?.name ?? ''}'
                        : (role == PlayerRole.impostor
                            ? 'Eres el impostor'
                            : 'Eres inocente'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              const SizedBox(height: 16),
              const Text(
                  'Haz doble toque para continuar y pasa el móvil al siguiente jugador.',
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
