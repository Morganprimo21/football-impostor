import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/premium_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/game_provider.dart';
import 'services/sound_service.dart';
import 'monetization/ads_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar AdMob
  await AdsService().initialize();
  
  final premiumProvider = PremiumProvider();
  final localeProvider = LocaleProvider();
  final settingsProvider = SettingsProvider();
  final gameProvider = GameProvider();
  await premiumProvider.loadPremiumStatus();
  await localeProvider.loadLocale();
  await settingsProvider.load();
  await gameProvider.loadPlayersAsset();
  
  // Inicializar servicio de sonidos
  SoundService().initialize(settingsProvider);
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<PremiumProvider>.value(value: premiumProvider),
        ChangeNotifierProvider<LocaleProvider>.value(value: localeProvider),
        ChangeNotifierProvider<SettingsProvider>.value(value: settingsProvider),
        ChangeNotifierProvider<GameProvider>.value(value: gameProvider),
      ],
      child: const MyAppWrapper(),
    ),
  );
}
