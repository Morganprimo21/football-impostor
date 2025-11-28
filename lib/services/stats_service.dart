import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import '../utils/logger.dart';

/// Servicio para gestionar estadísticas del juego
class StatsService {
  static final StatsService _instance = StatsService._internal();
  factory StatsService() => _instance;
  StatsService._internal();

  int _gamesPlayed = 0;
  int _gamesWon = 0;
  int _impostorWins = 0;
  List<String> _impostorHistory = [];
  List<String> _secretPlayerHistory = [];

  int get gamesPlayed => _gamesPlayed;
  int get gamesWon => _gamesWon;
  int get impostorWins => _impostorWins;
  List<String> get impostorHistory => List.unmodifiable(_impostorHistory);
  List<String> get secretPlayerHistory => List.unmodifiable(_secretPlayerHistory);

  double get winRate {
    if (_gamesPlayed == 0) return 0.0;
    return (_gamesWon / _gamesPlayed) * 100;
  }

  double get impostorWinRate {
    if (_gamesPlayed == 0) return 0.0;
    return (_impostorWins / _gamesPlayed) * 100;
  }

  Future<void> loadStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _gamesPlayed = prefs.getInt(AppConstants.prefKeyGamesPlayed) ?? 0;
      _gamesWon = prefs.getInt(AppConstants.prefKeyGamesWon) ?? 0;
      _impostorWins = prefs.getInt(AppConstants.prefKeyImpostorWins) ?? 0;
      
      // Cargar historiales
      final impostorHistoryJson = prefs.getString(AppConstants.prefKeyImpostorHistory);
      if (impostorHistoryJson != null) {
        _impostorHistory = List<String>.from(json.decode(impostorHistoryJson));
      }
      
      final secretPlayerHistoryJson = prefs.getString(AppConstants.prefKeySecretPlayerHistory);
      if (secretPlayerHistoryJson != null) {
        _secretPlayerHistory = List<String>.from(json.decode(secretPlayerHistoryJson));
      }
      
      AppLogger.info('Stats loaded: $_gamesPlayed games, $_gamesWon wins');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to load stats', e, stackTrace);
    }
  }

  Future<void> recordGame({required bool agentsWon}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _gamesPlayed++;
      
      // Si los agentes ganaron, incrementar victorias de agentes
      // Si no ganaron, significa que el impostor ganó
      if (agentsWon) {
        _gamesWon++;
      } else {
        _impostorWins++;
      }

      await prefs.setInt(AppConstants.prefKeyGamesPlayed, _gamesPlayed);
      await prefs.setInt(AppConstants.prefKeyGamesWon, _gamesWon);
      await prefs.setInt(AppConstants.prefKeyImpostorWins, _impostorWins);
      
      AppLogger.info('Game recorded: agentsWon=$agentsWon');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to record game', e, stackTrace);
    }
  }

  Future<void> recordGameHistory({
    required String impostorName,
    required String secretPlayerName,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Agregar al historial (máximo 50 entradas)
      _impostorHistory.insert(0, impostorName);
      _secretPlayerHistory.insert(0, secretPlayerName);
      
      // Limitar a 50 entradas
      if (_impostorHistory.length > 50) {
        _impostorHistory = _impostorHistory.sublist(0, 50);
      }
      if (_secretPlayerHistory.length > 50) {
        _secretPlayerHistory = _secretPlayerHistory.sublist(0, 50);
      }
      
      // Guardar en SharedPreferences
      await prefs.setString(
        AppConstants.prefKeyImpostorHistory,
        json.encode(_impostorHistory),
      );
      await prefs.setString(
        AppConstants.prefKeySecretPlayerHistory,
        json.encode(_secretPlayerHistory),
      );
      
      AppLogger.info('Game history recorded: impostor=$impostorName, secret=$secretPlayerName');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to record game history', e, stackTrace);
    }
  }

  Future<void> resetStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _gamesPlayed = 0;
      _gamesWon = 0;
      _impostorWins = 0;
      _impostorHistory.clear();
      _secretPlayerHistory.clear();
      
      await prefs.setInt(AppConstants.prefKeyGamesPlayed, 0);
      await prefs.setInt(AppConstants.prefKeyGamesWon, 0);
      await prefs.setInt(AppConstants.prefKeyImpostorWins, 0);
      await prefs.remove(AppConstants.prefKeyImpostorHistory);
      await prefs.remove(AppConstants.prefKeySecretPlayerHistory);
      
      AppLogger.info('Stats reset');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to reset stats', e, stackTrace);
    }
  }
}

