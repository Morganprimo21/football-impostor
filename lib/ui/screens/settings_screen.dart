import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../providers/locale_provider.dart';
import '../../providers/settings_provider.dart';
import '../../utils/app_localizations.dart';
import '../../utils/app_colors.dart';
import 'tournament_screen.dart';
import 'player_packs_screen.dart';
import 'achievements_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundDeep,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          16.0,
          16.0,
          16.0,
          16.0 + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _sectionCard(
              child: SwitchListTile(
                title: Text(loc.locale.languageCode == 'es'
                    ? 'Idioma: Español'
                    : 'Language: English'),
                subtitle: Text(loc.locale.languageCode == 'es'
                    ? 'Cambiar a inglés'
                    : 'Switch to Spanish'),
                value: loc.locale.languageCode == 'es',
                onChanged: (bool value) {
                  final newLocale = value
                      ? const Locale('es', 'ES')
                      : const Locale('en', 'US');
                  Provider.of<LocaleProvider>(context, listen: false)
                      .setLocale(newLocale);
                },
              ),
            ),
            const SizedBox(height: 12),
            
            // Sonidos
            _sectionCard(
              child: SwitchListTile(
                title: Text(
                  loc.locale.languageCode == 'es' ? 'Efectos de sonido' : 'Sound Effects',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  loc.locale.languageCode == 'es'
                      ? 'Activar/desactivar sonidos'
                      : 'Enable/disable sounds',
                ),
                value: settingsProvider.soundsEnabled,
                onChanged: (value) {
                  settingsProvider.setSoundsEnabled(value);
                },
              ),
            ),
            const SizedBox(height: 12),
            
            // Torneos
            _sectionCard(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.emoji_events)),
                title: Text(
                  loc.locale.languageCode == 'es' ? 'Torneos' : 'Tournaments',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  loc.locale.languageCode == 'es'
                      ? 'Gestiona y juega torneos'
                      : 'Manage and play tournaments',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TournamentScreen()),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            
            // Logros
            _sectionCard(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.military_tech)),
                title: Text(
                  loc.locale.languageCode == 'es' ? 'Logros' : 'Achievements',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  loc.locale.languageCode == 'es'
                      ? 'Ver logros desbloqueados'
                      : 'View unlocked achievements',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AchievementsScreen()),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            
            // Packs de jugadores
            _sectionCard(
              child: ListTile(
                leading: SizedBox(
                  width: 40,
                  height: 40,
                  child: SvgPicture.asset(
                    'assets/hector_logo.svg',
                    fit: BoxFit.contain,
                    placeholderBuilder: (_) => const Icon(Icons.sports_soccer, color: Colors.white),
                  ),
                ),
                title: Text(
                  loc.locale.languageCode == 'es'
                      ? 'Packs de Jugadores'
                      : 'Player Packs',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  loc.locale.languageCode == 'es'
                      ? 'Ver packs disponibles'
                      : 'View available packs',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PlayerPacksScreen()),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }

}


