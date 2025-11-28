import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../monetization/ads_service.dart';
import '../../providers/game_provider.dart';
import '../../providers/premium_provider.dart';
import '../../utils/app_localizations.dart';
import '../../utils/app_colors.dart';
import '../../services/stats_service.dart';
import '../../services/share_service.dart';
import '../../services/achievement_service.dart';
import '../../services/tournament_service.dart';
import '../../data/models/player_role.dart';
import '../widgets/ad_banner_widget.dart';
import '../widgets/app_logo.dart';
import '../widgets/background_with_logo.dart';
import '../widgets/phase_indicator.dart';
import 'home_screen.dart';
import 'tournament_screen.dart';
import 'tournament_round_result_screen.dart';
import 'tournament_podium_screen.dart';

class RevealScreen extends StatefulWidget {
  final bool isQuickGame;
  
  const RevealScreen({
    Key? key,
    this.isQuickGame = true, // Por defecto es partida rápida
  }) : super(key: key);

  @override
  State<RevealScreen> createState() => _RevealScreenState();
}

class _RevealScreenState extends State<RevealScreen> 
    with SingleTickerProviderStateMixin {
  final StatsService _statsService = StatsService();
  final ShareService _shareService = ShareService();
  final AchievementService _achievementService = AchievementService();
  final TournamentService _tournamentService = TournamentService();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _hasTournamentActive = false;
  bool _tournamentRoundSaved = false;

  @override
  void initState() {
    super.initState();
    
    // Inicializar animaciones
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5),
      ),
    );
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadStats();
      _recordGameHistory();
      await _checkAchievements();
      _loadTournamentInfo();
      _animationController.forward();
    });
  }
  
  Future<void> _loadTournamentInfo() async {
    // Solo cargar info del torneo si NO es partida rápida
    if (!widget.isQuickGame) {
      await _tournamentService.loadTournament();
      if (!mounted) return;
      setState(() {
        _hasTournamentActive = _tournamentService.hasTournamentActive;
      });
    } else {
      // En partida rápida, forzar que no hay torneo activo
      setState(() {
        _hasTournamentActive = false;
      });
    }
  }

  Future<void> _recordTournamentRound({required bool agentsWon}) async {
    await _tournamentService.loadTournament();

    if (_tournamentService.hasTournamentActive) {
      final gp = Provider.of<GameProvider>(context, listen: false);
      final impostors = gp.roles.entries
          .where((e) => e.value == PlayerRole.impostor)
          .map((e) => e.key)
          .toList();

      await _tournamentService.recordRound(
        impostor: impostors.join(', '),
        secretPlayer: gp.secretFootballer?.name ?? 'Unknown',
        agentsWon: agentsWon,
      );

      if (mounted) {
        setState(() {
          _tournamentRoundSaved = true;
        });
      }
    }
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  Future<void> _checkAchievements() async {
    await _achievementService.loadAchievements();
    
    // Desbloquear "primera partida" si es la primera
    if (_statsService.gamesPlayed == 1) {
      await _achievementService.unlockAchievement('first_game');
    }
    
    // Actualizar progreso de maratón
    await _achievementService.updateProgress('marathon_5', _statsService.gamesPlayed);
    await _achievementService.updateProgress('marathon_10', _statsService.gamesPlayed);
    await _achievementService.updateProgress('veteran', _statsService.gamesPlayed);
    await _achievementService.updateProgress('legend', _statsService.gamesPlayed);
  }

  Future<void> _loadStats() async {
    await _statsService.loadStats();
  }

  void _recordGameHistory() {
    final gp = Provider.of<GameProvider>(context, listen: false);
    String impostorName = '';
    String secretPlayer = '';
    
    // Encontrar el impostor
    for (final entry in gp.roles.entries) {
      if (entry.value.toString().contains('impostor')) {
        impostorName = entry.key;
        break;
      }
    }
    
    // Encontrar el jugador secreto
    for (final entry in gp.assignedPlayers.entries) {
      if (entry.value != null) {
        secretPlayer = entry.value!.name;
        break;
      }
    }
    
    // Registrar en el historial
    if (impostorName.isNotEmpty && secretPlayer.isNotEmpty) {
      _statsService.recordGameHistory(
        impostorName: impostorName,
        secretPlayerName: secretPlayer,
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isPremium = Provider.of<PremiumProvider>(context).isPremium;
    if (!isPremium) {
      AdsService().loadAndShowInterstitial(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final gp = Provider.of<GameProvider>(context);
    String secretPlayer = '';
    
    // Get the secret player from any innocent player (not the impostor)
    for (final entry in gp.assignedPlayers.entries) {
      if (entry.value != null) {
        secretPlayer = entry.value!.name;
        break;
      }
    }
    // Encontrar todos los impostores (puede haber múltiples)
    final impostors = <String>[];
    for (final entry in gp.roles.entries) {
      if (entry.value == PlayerRole.impostor) {
        impostors.add(entry.key);
      }
    }
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BackgroundWithLogo(
        child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          20.0,
          20.0,
          20.0,
          20.0 + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          children: [
            // Indicador de fase
            PhaseIndicator(currentPhase: GamePhase.results),
            const SizedBox(height: 24),
            
            // Card principal con información del impostor - CON ANIMACIONES
            FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                  decoration: BoxDecoration(
                    gradient: AppColors.accentGradient,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: AppColors.accentGlowShadow,
                    border: Border.all(
                        color: AppColors.accent.withOpacity(0.5),
                        width: 3),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icono con rotación
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 1500),
                        curve: Curves.elasticOut,
                        builder: (context, value, child) {
                          return Transform.rotate(
                            angle: value * 6.28, // 360 grados
                            child: child,
                          );
                        },
                        child: const AppLogo(
                          size: 120,
                          useWhiteLogo: true,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        loc.text('reveal_impostor_label'),
                        style: const TextStyle(
                            letterSpacing: 4,
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 16),
                      // Mostrar todos los impostores con animación
                      ...impostors.asMap().entries.map((entry) => 
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: Duration(milliseconds: 800 + (entry.key * 200)),
                          curve: Curves.elasticOut,
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  entry.value,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 56,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    shadows: [
                                      BoxShadow(
                                          blurRadius: 20,
                                          color: AppColors.accentGlow,
                                          offset: const Offset(0, 4))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Jugador secreto con mejor visibilidad
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text(
                              loc.text('reveal_secret_player'),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              secretPlayer,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Información adicional de la partida
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.backgroundCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.locale.languageCode == 'es' 
                        ? 'RESUMEN DE LA PARTIDA' 
                        : 'GAME SUMMARY',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSummaryRow(
                    loc.locale.languageCode == 'es' ? 'Jugadores:' : 'Players:',
                    '${gp.playerNames.length}',
                  ),
                  _buildSummaryRow(
                    loc.locale.languageCode == 'es' ? 'Impostores:' : 'Impostors:',
                    '${impostors.length}',
                  ),
                  _buildSummaryRow(
                    loc.locale.languageCode == 'es' ? 'Jugador:' : 'Player:',
                    secretPlayer,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Botón para seleccionar ganador en modo torneo (pantalla separada)
            if (_hasTournamentActive && !_tournamentRoundSaved) ...[
              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TournamentRoundResultScreen(
                          impostor: impostors.join(', '),
                          secretPlayer: secretPlayer,
                          playerCount: gp.playerNames.length,
                          impostorCount: impostors.length,
                          onAgentsWon: () => Navigator.pop(context, true),
                          onImpostorWon: () => Navigator.pop(context, false),
                        ),
                      ),
                    );
                    
                    if (result != null && mounted) {
                      await _recordTournamentRound(agentsWon: result);
                    }
                  },
                  icon: const Icon(Icons.emoji_events, size: 28),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 8,
                  ),
                  label: Text(
                    loc.locale.languageCode == 'es'
                        ? 'SELECCIONAR GANADOR'
                        : 'SELECT WINNER',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
            
            // Botón compartir - SOLO en partidas rápidas o al finalizar torneo completo
            if (!_hasTournamentActive || _tournamentService.isTournamentComplete) ...[
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    _shareService.copyToClipboard(
                      context: context,
                      impostor: impostors.join(', '),
                      secretPlayer: secretPlayer,
                      totalPlayers: gp.playerNames.length,
                      impostorCount: impostors.length,
                    );
                  },
                  icon: const Icon(Icons.share, size: 24),
                  label: Text(
                    loc.locale.languageCode == 'es'
                        ? 'COMPARTIR RESULTADO'
                        : 'SHARE RESULT',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Botón torneo en progreso, podio al finalizar, o nueva partida
            if (_tournamentService.hasTournamentActive &&
                !_tournamentService.isTournamentComplete)
              // Torneo en progreso: botón para ver torneo
              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton.icon(
                  onPressed: _tournamentRoundSaved
                      ? () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const TournamentScreen()),
                            (route) => false,
                          );
                        }
                      : null,
                  icon: const Icon(Icons.emoji_events, size: 28),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _tournamentRoundSaved
                        ? Colors.amber
                        : Colors.grey.shade800,
                    foregroundColor: _tournamentRoundSaved
                        ? Colors.black
                        : Colors.grey.shade600,
                    disabledBackgroundColor: Colors.grey.shade800,
                    disabledForegroundColor: Colors.grey.shade600,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: _tournamentRoundSaved ? 8 : 0,
                  ),
                  label: Text(
                    _tournamentRoundSaved
                        ? (loc.locale.languageCode == 'es'
                            ? 'VER TORNEO'
                            : 'VIEW TOURNAMENT')
                        : (loc.locale.languageCode == 'es'
                            ? 'PRIMERO SELECCIONA GANADOR ↑'
                            : 'FIRST SELECT WINNER ↑'),
                    style: TextStyle(
                      fontSize: _tournamentRoundSaved ? 15 : 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: _tournamentRoundSaved ? 0.8 : 0.5,
                    ),
                  ),
                ),
              )
            else if (_hasTournamentActive && _tournamentService.isTournamentComplete)
              // Torneo completado: mostrar podio
              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await _tournamentService.loadTournament();
                    final tournament = _tournamentService.currentTournament;
                    if (tournament != null && mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TournamentPodiumScreen(
                            topPlayers: tournament.leaderboard.take(3).toList(),
                          ),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.emoji_events, size: 28),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 8,
                  ),
                  label: Text(
                    loc.locale.languageCode == 'es'
                        ? 'VER PODIO FINAL'
                        : 'VIEW FINAL PODIUM',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              )
            else
              // Partida rápida: nueva partida
              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.home, size: 28),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 8,
                    shadowColor: AppColors.accentGlow,
                  ),
                  label: Text(
                    loc.text('reveal_new_game'),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Consumer<PremiumProvider>(
                builder: (context, p, _) => p.isPremium
                    ? const SizedBox.shrink()
                    : const AdBannerWidget()),
          ],
        ),
        ),
      ),
    );
  }
  
  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
