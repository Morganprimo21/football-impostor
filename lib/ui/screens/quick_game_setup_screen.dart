import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';
import '../../providers/premium_provider.dart';
import '../../data/models/player_pack.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_localizations.dart';
import '../../utils/validators.dart';
import '../widgets/ad_banner_widget.dart';
import '../widgets/background_with_logo.dart';
import '../widgets/vector_logo.dart';
import '../widgets/primary_button.dart';
import 'lobby_screen.dart';
import 'player_packs_screen.dart';

class QuickGameSetupScreen extends StatefulWidget {
  const QuickGameSetupScreen({Key? key}) : super(key: key);

  @override
  State<QuickGameSetupScreen> createState() => _QuickGameSetupScreenState();
}

class _QuickGameSetupScreenState extends State<QuickGameSetupScreen> {
  final List<TextEditingController> _controllers = [];
  int _playerCount = 3;
  int _impostorCount = 1;

  @override
  void initState() {
    super.initState();
    _updateControllers();
  }

  void _updateControllers() {
    while (_controllers.length < _playerCount) {
      final playerNumber = _controllers.length + 1;
      _controllers.add(TextEditingController(text: 'Jugador $playerNumber'));
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
                  // Header con icono
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: AppColors.primaryGlowShadow,
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
                            Icons.play_arrow,
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
                                'PARTIDA RÁPIDA',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Configura y empieza a jugar',
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
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryGlow.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const CircularVectorLogo(size: 40),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Liga seleccionada',
                                style: TextStyle(
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
                          child: const Text('Cambiar'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Player count
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
                        const Expanded(
                          child: Text(
                            'Jugadores:',
                            style: TextStyle(
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
                            items: List.generate(8, (i) => i + 3)
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
                  const SizedBox(height: 12),

                  // Impostor count
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.person_off, color: Colors.white, size: 28),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Text(
                            'Impostores:',
                            style: TextStyle(
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
                            items: List.generate((_playerCount / 2).floor(), (i) => i + 1)
                                .map((n) => DropdownMenuItem(
                                      value: n,
                                      child: Text(
                                        '$n',
                                        style: TextStyle(
                                          color: AppColors.error,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _impostorCount = val);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Player name input fields
                  Row(
                    children: [
                      const Icon(Icons.edit, color: Colors.white, size: 24),
                      const SizedBox(width: 12),
                      const Text(
                        'Nombres de jugadores',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(_playerCount, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: RepaintBoundary(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryGlow.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _controllers[i],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              labelText: '${loc.text('home_player_label')} ${i + 1}',
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                              filled: true,
                              fillColor: AppColors.backgroundCard,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: AppColors.border),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: AppColors.border, width: 1.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: AppColors.primary, width: 2),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 20),

                  // Start Game Button
                  SizedBox(
                    height: 56,
                    child: PrimaryButton(
                      label: 'INICIAR PARTIDA',
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
                            const SnackBar(
                              content: Text('Los nombres deben ser únicos'),
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
                        gp.setImpostorCount(_impostorCount);

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
                                  child: const LobbyScreen(isQuickGame: true),
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

