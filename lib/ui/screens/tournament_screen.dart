import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/player_pack.dart';
import '../../providers/game_provider.dart';
import '../../providers/premium_provider.dart';
import '../../services/tournament_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_localizations.dart';
import 'home_screen.dart';
import 'lobby_screen.dart';

/// Pantalla para visualizar torneo en progreso o crear nuevo
class TournamentScreen extends StatefulWidget {
  const TournamentScreen({Key? key}) : super(key: key);

  @override
  State<TournamentScreen> createState() => _TournamentScreenState();
}

class _TournamentScreenState extends State<TournamentScreen> {
  final TournamentService _tournamentService = TournamentService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTournament();
  }

  Future<void> _loadTournament() async {
    setState(() => _isLoading = true);
    await _tournamentService.loadTournament();
    setState(() => _isLoading = false);
  }

  Future<void> _continueTournamentRound() async {
    final tournament = _tournamentService.currentTournament;
    if (tournament == null || _tournamentService.isTournamentComplete) {
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
      return;
    }

    final gp = Provider.of<GameProvider>(context, listen: false);
    final premiumProvider =
        Provider.of<PremiumProvider>(context, listen: false);

    // Usar los mismos nombres del torneo
    final names = List<String>.from(tournament.playerNames);

    // Respetar las ligas pagadas para Mixed
    final allowedLeagues = <String>{};
    for (final pack in PlayerPack.freePacks) {
      allowedLeagues.addAll(pack.leagues);
    }
    if (premiumProvider.isPremium) {
      for (final pack in PlayerPack.premiumPacks) {
        allowedLeagues.addAll(pack.leagues);
      }
    } else {
      for (final packId in premiumProvider.ownedPacks) {
        final pack = PlayerPack.getById(packId);
        if (pack != null) {
          allowedLeagues.addAll(pack.leagues);
        }
      }
    }

    gp.setAllowedMixedLeagues(allowedLeagues.toList());
    gp.setPlayerNames(names);
    // El número de impostores se mantiene como esté configurado en GameProvider

    bool dialogClosed = false;
    final navigator = Navigator.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => WillPopScope(
        onWillPop: () async => false,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );

    try {
      await gp.assignRolesAndSecrets();

      if (gp.errorMessage != null) {
        if (!dialogClosed && mounted) {
          dialogClosed = true;
          navigator.pop();
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(gp.errorMessage!),
              backgroundColor: AppColors.error,
            ),
          );
        }
        return;
      }

      if (!dialogClosed && mounted) {
        dialogClosed = true;
        navigator.pop();
      }

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider.value(
              value: gp,
              child: const LobbyScreen(isQuickGame: false),
            ),
          ),
        );
      }
    } catch (e) {
      if (!dialogClosed) {
        try {
          dialogClosed = true;
          navigator.pop();
        } catch (_) {}
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _endTournament() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Terminar torneo?'),
        content: const Text('Se perderá todo el progreso del torneo actual.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('TERMINAR'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _tournamentService.endTournament();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final tournament = _tournamentService.currentTournament;

    if (tournament == null) {
      return _buildNoTournamentScreen();
    }

    final isComplete = _tournamentService.isTournamentComplete;
    final leaderboard = tournament.leaderboard;

    return Scaffold(
      backgroundColor: AppColors.backgroundDeep,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (!isComplete)
            IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: _endTournament,
              tooltip: 'Terminar torneo',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          16.0,
          16.0,
          16.0,
          16.0 + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          children: [
            // Header del torneo
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppColors.primaryGlowShadow,
              ),
              child: Column(
                children: [
                  Text(
                    isComplete ? loc.text('tournament_finished') : loc.text('tournament_in_progress'),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${loc.text('tournament_best_of')} ${tournament.totalRounds}',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${loc.text('tournament_round')} ${tournament.currentRound} / ${tournament.totalRounds}',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Barra de progreso
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: tournament.currentRound / tournament.totalRounds,
                      minHeight: 12,
                      backgroundColor: Colors.white24,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Leaderboard
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.backgroundCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.leaderboard, color: AppColors.accent, size: 28),
                      const SizedBox(width: 12),
                          Text(
                        loc.text('tournament_classification'),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ...leaderboard.asMap().entries.map((entry) {
                    final position = entry.key + 1;
                    final player = entry.value.key;
                    final score = entry.value.value;
                    final isWinner = isComplete && position == 1;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isWinner
                            ? AppColors.accent.withOpacity(0.2)
                            : AppColors.backgroundElevated,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isWinner ? AppColors.accent : AppColors.border,
                          width: isWinner ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Posición
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: position == 1
                                  ? Colors.amber
                                  : position == 2
                                      ? Colors.grey[400]
                                      : position == 3
                                          ? Colors.brown[400]
                                          : Colors.grey[700],
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                position == 1
                                    ? '🥇'
                                    : position == 2
                                        ? '🥈'
                                        : position == 3
                                            ? '🥉'
                                            : '$position',
                                style: TextStyle(
                                  fontSize: position <= 3 ? 20 : 16,
                                  fontWeight: FontWeight.bold,
                                  color: position <= 3 ? null : Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Nombre
                          Expanded(
                            child:                               Text(
                              player,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isWinner ? FontWeight.bold : FontWeight.w500,
                                color: isWinner ? AppColors.accent : Colors.white,
                              ),
                            ),
                          ),
                          // Puntos
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.primary),
                            ),
                            child: Text(
                              '$score pts',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Historial de rondas
            if (tournament.roundHistory.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.backgroundCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.history, color: AppColors.secondary, size: 28),
                        const SizedBox(width: 12),
                          Text(
                          loc.text('tournament_history'),
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...tournament.roundHistory.reversed.take(5).map((round) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundElevated,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border, width: 1.5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${loc.text('tournament_round')} ${round.roundNumber}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.accent,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: round.agentsWon
                                        ? AppColors.success.withOpacity(0.2)
                                        : AppColors.error.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: round.agentsWon
                                          ? AppColors.success
                                          : AppColors.error,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Text(
                                    round.agentsWon ? '✓ Agentes' : '✗ Impostor',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: round.agentsWon
                                          ? AppColors.success
                                          : AppColors.error,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: AppColors.error,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  loc.text('tournament_impostor_label'),
                                  style: const TextStyle(
                                    color: Colors.white60,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    round.impostor,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.groups,
                                  color: AppColors.primary,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  loc.text('tournament_player_label'),
                                  style: const TextStyle(
                                    color: Colors.white60,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    round.secretPlayer,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                    if (tournament.roundHistory.length > 5)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Center(
                          child: Text(
                            '+ ${tournament.roundHistory.length - 5} partidas más',
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Botones de acción
            if (!isComplete) ...[
              const Text(
                '💡 Continúa jugando partidas para completar el torneo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _continueTournamentRound,
                  icon: const Icon(Icons.play_arrow, size: 22),
                  label: const Text(
                    'SEGUIR JUGANDO',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNoTournamentScreen() {
    return Scaffold(
      backgroundColor: AppColors.backgroundDeep,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.emoji_events,
                size: 120,
                color: AppColors.accent.withOpacity(0.5),
              ),
              const SizedBox(height: 32),
              const Text(
                'No hay torneo activo',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Crea un torneo desde la pantalla principal para competir en múltiples rondas',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  },
                  icon: const Icon(Icons.home, size: 20),
                  label: const Text(
                    'IR A INICIO',
                    style: TextStyle(fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
