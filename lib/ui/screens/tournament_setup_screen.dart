import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';
import '../../providers/premium_provider.dart';
import '../../data/models/player_pack.dart';
import '../../services/tournament_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_localizations.dart';
import '../../utils/validators.dart';
import '../widgets/ad_banner_widget.dart';
import '../widgets/background_with_logo.dart';
import '../widgets/vector_logo.dart';
import '../widgets/primary_button.dart';
import 'lobby_screen.dart';
import 'player_packs_screen.dart';

class TournamentSetupScreen extends StatefulWidget {
  const TournamentSetupScreen({Key? key}) : super(key: key);

  @override
  State<TournamentSetupScreen> createState() => _TournamentSetupScreenState();
}

class _TournamentSetupScreenState extends State<TournamentSetupScreen> {
  final List<TextEditingController> _controllers = [];
  final TournamentService _tournamentService = TournamentService();
  int _playerCount = 3;
  int _impostorCount = 1;
  int _tournamentRounds = 3;

  @override
  void initState() {
    super.initState();
    _updateControllers();
  }

  void _updateControllers() {
    final loc = AppLocalizations.of(context);
    while (_controllers.length < _playerCount) {
      final playerNumber = _controllers.length + 1;
      _controllers.add(TextEditingController(text: '${loc.text('setup_default_player')} $playerNumber'));
    }
    while (_controllers.length > _playerCount) {
      _controllers.removeLast().dispose();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPremium = Provider.of<PremiumProvider>(context).isPremium;
    final gp = Provider.of<GameProvider>(context);
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BackgroundWithLogo(
        child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header con icono (mismo estilo que Partida Rápida)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.amber.shade700, Colors.amber.shade500],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.emoji_events,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'MODO TORNEO',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Compite en una serie de partidas',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Selected League Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const CircularVectorLogo(size: 40),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                loc.text('setup_league_selected'),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Consumer<GameProvider>(
                                builder: (context, gameProvider, child) {
                                  return Text(
                                    PlayerPack.getById(gameProvider.currentLeagueKey)?.name ?? 'Mixed',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const PlayerPacksScreen()),
                            );
                          },
                          child: Text(loc.text('setup_change')),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tournament Rounds
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.format_list_numbered, color: Colors.white, size: 28),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            loc.text('tournament_rounds'),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.amber, width: 1.5),
                          ),
                          child: DropdownButton<int>(
                            value: _tournamentRounds,
                            underline: const SizedBox(),
                            dropdownColor: AppColors.backgroundCard,
                            items: const [
                              DropdownMenuItem(
                                value: 3,
                                child: Text('Best of 3'),
                              ),
                              DropdownMenuItem(
                                value: 5,
                                child: Text('Best of 5'),
                              ),
                              DropdownMenuItem(
                                value: 7,
                                child: Text('Best of 7'),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _tournamentRounds = val;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Impostor count (NUEVO)
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber, color: Colors.white, size: 28),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            loc.text('setup_impostors'),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.error, width: 1.5),
                          ),
                          child: DropdownButton<int>(
                            value: _impostorCount,
                            underline: const SizedBox(),
                            dropdownColor: AppColors.backgroundCard,
                            items: List.generate(
                              (_playerCount / 2).floor(),
                              (i) => i + 1,
                            ).map((n) => DropdownMenuItem(
                                  value: n,
                                  child: Text(
                                    '$n',
                                    style: TextStyle(
                                      color: AppColors.error,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _impostorCount = val;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Player count (mismo estilo que partida rápida)
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.people, color: Colors.white, size: 28),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            loc.text('setup_players'),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.primary, width: 1.5),
                          ),
                          child: DropdownButton<int>(
                            value: _playerCount,
                            underline: const SizedBox(),
                            dropdownColor: AppColors.backgroundCard,
                            items: List.generate(10, (i) => i + 3)
                                .map((n) => DropdownMenuItem(
                                      value: n,
                                      child: Text(
                                        '$n',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _playerCount = val;
                                  if (_impostorCount > (val / 2).floor()) {
                                    _impostorCount = (val / 2).floor();
                                  }
                                  _updateControllers();
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Player name input fields
                  Text(
                    '${loc.text('setup_player_names')}:',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(_playerCount, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: RepaintBoundary(
                        child: TextField(
                          controller: _controllers[i],
                          decoration: InputDecoration(
                            labelText: '${loc.text('home_player_label')} ${i + 1}',
                            filled: true,
                            fillColor: AppColors.backgroundCard,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 20),

                  // Start Tournament Button
                  SizedBox(
                    height: 56,
                    child: PrimaryButton(
                      label: loc.text('tournament_start'),
                      onPressed: () async {
                        final premiumProvider = Provider.of<PremiumProvider>(context, listen: false);
                        final names = _controllers
                            .take(_playerCount)
                            .map((c) => c.text.trim())
                            .where((name) => name.isNotEmpty)
                            .toList();

                        if (names.length < _playerCount) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(loc.text('home_error_min_players')),
                              backgroundColor: AppColors.error,
                            ),
                          );
                          return;
                        }

                        if (!Validators.areNamesUnique(names)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(loc.text('home_error_unique_names')),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        // Define which leagues can be used in "Mixed" based on packs and Premium
                        final allowedLeagues = <String>{};
                        // Free packs
                        for (final pack in PlayerPack.freePacks) {
                          allowedLeagues.addAll(pack.leagues);
                        }
                        if (premiumProvider.isPremium) {
                          // Premium unlocks all leagues
                          for (final pack in PlayerPack.allPacks) {
                            allowedLeagues.addAll(pack.leagues);
                          }
                        } else {
                          // Add leagues from individually purchased packs
                          for (final packId in premiumProvider.ownedPacks) {
                            final pack = PlayerPack.getById(packId);
                            if (pack != null) {
                              allowedLeagues.addAll(pack.leagues);
                            }
                          }
                        }

                        gp.setAllowedMixedLeagues(allowedLeagues.toList());
                        gp.setPlayerNames(names);
                        gp.setImpostorCount(_impostorCount); // Usar el número seleccionado

                        // Start tournament
                        try {
                          await _tournamentService.startTournament(
                            totalRounds: _tournamentRounds,
                            playerNames: names,
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${loc.text('tournament_error_start')}: $e'),
                              backgroundColor: AppColors.error,
                            ),
                          );
                          return;
                        }

                        // Show loading dialog
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(gp.errorMessage!),
                                backgroundColor: AppColors.error,
                              ),
                            );
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
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Banner ad for non-premium users - at the very bottom
          if (!isPremium) const AdBannerWidget(),
        ],
        ),
      ),
    );
  }
}

