import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import '../providers/settings_provider.dart';
import '../utils/logger.dart';

/// Servicio para gestionar efectos de sonido en la aplicación
class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  final AudioPlayer _player = AudioPlayer();
  SettingsProvider? _settingsProvider;
  bool _isInitialized = false;

  // Rutas de los sonidos (se crearán archivos de ejemplo)
  static const String _soundButtonClick = 'assets/sounds/button_click.mp3';
  static const String _soundButtonSuccess = 'assets/sounds/button_success.mp3';
  static const String _soundButtonError = 'assets/sounds/button_error.mp3';
  static const String _soundPageTransition = 'assets/sounds/page_transition.mp3';
  static const String _soundRoleReveal = 'assets/sounds/role_reveal.mp3';
  static const String _soundVote = 'assets/sounds/vote.mp3';
  static const String _soundWin = 'assets/sounds/win.mp3';
  static const String _soundLose = 'assets/sounds/lose.mp3';
  static const String _soundImpostorReveal = 'assets/sounds/impostor_reveal.mp3';

  /// Inicializa el servicio con el provider de configuración
  void initialize(SettingsProvider settingsProvider) {
    _settingsProvider = settingsProvider;
    _isInitialized = true;
    AppLogger.info('SoundService initialized');
  }

  /// Verifica si los sonidos están habilitados
  bool get _soundsEnabled {
    if (!_isInitialized || _settingsProvider == null) return true;
    return _settingsProvider!.soundsEnabled;
  }

  /// Reproduce un sonido si están habilitados
  Future<void> _playSound(String soundPath, {double volume = 0.5}) async {
    if (!_soundsEnabled) return;
    if (kIsWeb) return; // Los sonidos pueden no funcionar bien en web

    try {
      await _player.play(AssetSource(soundPath.replaceFirst('assets/', '')));
      await _player.setVolume(volume);
    } catch (e) {
      // Silenciar errores de sonido para no interrumpir la experiencia
      AppLogger.debug('Failed to play sound: $soundPath', e);
    }
  }

  /// Sonido de clic en botón normal
  Future<void> playButtonClick() async {
    await _playSound(_soundButtonClick, volume: 0.3);
  }

  /// Sonido de éxito (botón de acción positiva)
  Future<void> playButtonSuccess() async {
    await _playSound(_soundButtonSuccess, volume: 0.4);
  }

  /// Sonido de error
  Future<void> playButtonError() async {
    await _playSound(_soundButtonError, volume: 0.4);
  }

  /// Sonido de transición de página
  Future<void> playPageTransition() async {
    await _playSound(_soundPageTransition, volume: 0.3);
  }

  /// Sonido al revelar rol
  Future<void> playRoleReveal() async {
    await _playSound(_soundRoleReveal, volume: 0.5);
  }

  /// Sonido de votación
  Future<void> playVote() async {
    await _playSound(_soundVote, volume: 0.4);
  }

  /// Sonido de victoria
  Future<void> playWin() async {
    await _playSound(_soundWin, volume: 0.6);
  }

  /// Sonido de derrota
  Future<void> playLose() async {
    await _playSound(_soundLose, volume: 0.6);
  }

  /// Sonido al revelar impostor
  Future<void> playImpostorReveal() async {
    await _playSound(_soundImpostorReveal, volume: 0.6);
  }

  /// Detiene todos los sonidos
  Future<void> stopAll() async {
    try {
      await _player.stop();
    } catch (e) {
      AppLogger.debug('Failed to stop sounds', e);
    }
  }

  /// Libera recursos
  void dispose() {
    _player.dispose();
  }
}

