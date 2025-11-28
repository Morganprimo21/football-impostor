import 'package:flutter/material.dart';

/// Constantes globales de la aplicación
class AppConstants {
  AppConstants._();

  // Colores del tema - Usar AppColors en su lugar
  @Deprecated('Use AppColors instead')
  static const primaryColor = 0xFF00E676; // Neon Green
  @Deprecated('Use AppColors instead')
  static const secondaryColor = 0xFF2979FF; // Neon Blue
  @Deprecated('Use AppColors instead')
  static const backgroundColor = 0xFF121212;
  @Deprecated('Use AppColors instead')
  static const surfaceColor = 0xFF1E1E1E;
  @Deprecated('Use AppColors instead')
  static const cardColor = 0xFF2C2C2C;

  // Configuración de juego
  static const minPlayers = 3;
  static const maxPlayers = 12;
  static const defaultPlayerCount = 4;

  // Configuración de anuncios
  static const String testBannerAdUnitId =
      'ca-app-pub-3940256099942544/6300978111';
  static const String testInterstitialAdUnitId =
      'ca-app-pub-3940256099942544/1033173712';
  static const String testAppOpenAdUnitId =
      'ca-app-pub-3940256099942544/3419835294';

  // Configuración de compras
  static const String removeAdsProductId = 'remove_ads';

  // SharedPreferences keys
  static const String prefKeyPremium = 'is_premium';
  static const String prefKeyLocale = 'app_locale';
  static const String prefKeySounds = 'sounds_enabled';
  static const String prefKeyTutorialSeen = 'has_seen_tutorial';
  static const String prefKeyGamesPlayed = 'games_played';
  static const String prefKeyGamesWon = 'games_won';
  static const String prefKeyImpostorWins = 'impostor_wins';
  static const String prefKeyImpostorHistory = 'impostor_history';
  static const String prefKeySecretPlayerHistory = 'secret_player_history';

  // Assets paths
  static const String assetPlayersJson = 'assets/players.json';
  static const String assetLogo = 'assets/hector_logo.svg';
  static const String assetIcon = 'assets/hector_logo.svg';
  static const String assetBackground = 'assets/hector_background.jpg';
  static const String assetBanner = 'assets/hector_banner.png';

  // Animaciones
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  static const Curve defaultAnimationCurve = Curves.easeOut;

  // Validaciones
  static const int minNameLength = 1;
  static const int maxNameLength = 20;
}

/// Mensajes de error localizados
class ErrorMessages {
  ErrorMessages._();

  static String playerPoolEmpty(String locale) {
    return locale == 'es'
        ? 'No hay jugadores disponibles. Por favor, reinicia la aplicación.'
        : 'No players available. Please restart the app.';
  }

  static String invalidPlayerCount(String locale) {
    return locale == 'es'
        ? 'El número de jugadores debe estar entre ${AppConstants.minPlayers} y ${AppConstants.maxPlayers}.'
        : 'Player count must be between ${AppConstants.minPlayers} and ${AppConstants.maxPlayers}.';
  }

  static String invalidName(String locale) {
    return locale == 'es'
        ? 'El nombre debe tener entre ${AppConstants.minNameLength} y ${AppConstants.maxNameLength} caracteres.'
        : 'Name must be between ${AppConstants.minNameLength} and ${AppConstants.maxNameLength} characters.';
  }

  static String gameInitializationFailed(String locale) {
    return locale == 'es'
        ? 'Error al inicializar el juego. Por favor, intenta de nuevo.'
        : 'Failed to initialize game. Please try again.';
  }
}

