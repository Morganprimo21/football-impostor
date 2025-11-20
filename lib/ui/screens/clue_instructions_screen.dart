import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';
import 'vote_instructions_screen.dart';

class ClueInstructionsScreen extends StatelessWidget {
  const ClueInstructionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(title: const Text('FASE DE DISCUSIÓN')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icono o ilustración central
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .primaryColor
                    .withAlpha(26), // 0.1 * 255 ≈ 26
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.record_voice_over_outlined,
                  size: 80, color: Theme.of(context).primaryColor),
            ),
            const SizedBox(height: 40),

            const Text(
              '¡DEBATE ABIERTO!',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: const Text(
                '1. Hablad por turnos y dad pistas sutiles sobre vuestro jugador.\n\n'
                '2. El impostor debe mentir para encajar.\n\n'
                '3. Los inocentes deben descubrir quién no sabe de qué habla.',
                textAlign: TextAlign.left,
                style:
                    TextStyle(fontSize: 16, height: 1.5, color: Colors.white70),
              ),
            ),

            const Spacer(),

            const Text('Cuando hayáis terminado de debatir:',
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final gp = Provider.of<GameProvider>(context, listen: false);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChangeNotifierProvider.value(
                        value: gp,
                        child: const VoteInstructionsScreen(),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
                child: const Text('PROCEDER A VOTACIÓN',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
