import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';
import '../../data/models/player_role.dart';
import '../../utils/app_localizations.dart';

class PeekabooButton extends StatelessWidget {
  final String? playerName;

  const PeekabooButton({
    Key? key,
    this.playerName,
  }) : super(key: key);

  void _showPlayerSelector(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final gp = Provider.of<GameProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: const Color(0xFF2C2C2C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                loc.text('peekaboo_select_player'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...gp.playerNames.map((name) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        _showPeekabooDialog(context, name);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: Text(name),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void _showPeekabooDialog(BuildContext context, String playerName) {
    final loc = AppLocalizations.of(context);
    final gp = Provider.of<GameProvider>(context, listen: false);
    final role = gp.roles[playerName];
    final secretPlayer = gp.assignedPlayers[playerName];
    
    // Get player name for display
    final displayName = playerName;

    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: role == PlayerRole.impostor
                  ? [Colors.red.shade900, Colors.red.shade700]
                  : [Colors.blue.shade900, Colors.blue.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: role == PlayerRole.impostor
                  ? Colors.redAccent
                  : Colors.blueAccent,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              role == PlayerRole.impostor
                  ? const Icon(
                      Icons.warning_amber_rounded,
                      size: 64,
                      color: Colors.white,
                    )
                  : Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8E8E8),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        'assets/hector_logo.svg',
                        fit: BoxFit.contain,
                        placeholderBuilder: (_) => const Icon(
                          Icons.sports_soccer,
                          size: 50,
                          color: Color(0xFF2D4A3E),
                        ),
                      ),
                    ),
              const SizedBox(height: 16),
              Text(
                displayName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                role == PlayerRole.impostor
                    ? loc.text('peekaboo_impostor')
                    : loc.text('peekaboo_innocent'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (role != PlayerRole.impostor && secretPlayer != null) ...[
                Text(
                  loc.text('peekaboo_secret_player'),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white30),
                  ),
                  child: Column(
                    children: [
                      Text(
                        secretPlayer.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else if (role == PlayerRole.impostor) ...[
                Text(
                  loc.text('peekaboo_impostor_desc'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: role == PlayerRole.impostor
                        ? Colors.red.shade900
                        : Colors.blue.shade900,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    loc.text('peekaboo_close'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return FloatingActionButton.extended(
      onPressed: () {
        if (playerName != null) {
          _showPeekabooDialog(context, playerName!);
        } else {
          _showPlayerSelector(context);
        }
      },
      icon: const Icon(Icons.remove_red_eye),
      label: Text(loc.text('peekaboo_button')),
      backgroundColor: Colors.blueAccent,
      foregroundColor: Colors.white,
    );
  }
}

