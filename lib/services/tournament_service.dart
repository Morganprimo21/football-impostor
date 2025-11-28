import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../utils/logger.dart';

/// Servicio para gestionar torneos (best of 3/5/7)
class TournamentService {
  static final TournamentService _instance = TournamentService._internal();
  factory TournamentService() => _instance;
  TournamentService._internal();

  static const String _prefKeyTournament = 'current_tournament';

  Tournament? _currentTournament;

  Tournament? get currentTournament => _currentTournament;
  bool get hasTournamentActive => _currentTournament != null;

  Future<void> loadTournament() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_prefKeyTournament);
      
      if (json != null) {
        _currentTournament = Tournament.fromJson(jsonDecode(json));
        AppLogger.info('Tournament loaded: ${_currentTournament!.totalRounds} rounds');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to load tournament', e, stackTrace);
    }
  }

  Future<void> startTournament({
    required int totalRounds,
    required List<String> playerNames,
  }) async {
    _currentTournament = Tournament(
      totalRounds: totalRounds,
      currentRound: 0,
      playerNames: playerNames,
      playerScores: {for (var name in playerNames) name: 0},
      roundHistory: [],
    );
    
    await _saveTournament();
    AppLogger.info('Tournament started: $totalRounds rounds');
  }

  Future<void> recordRound({
    required String impostor,
    required String secretPlayer,
    required bool agentsWon,
  }) async {
    if (_currentTournament == null) return;

    final round = TournamentRound(
      roundNumber: _currentTournament!.currentRound + 1,
      impostor: impostor,
      secretPlayer: secretPlayer,
      agentsWon: agentsWon,
    );

    _currentTournament!.roundHistory.add(round);
    _currentTournament!.currentRound++;

    // Actualizar puntos (ejemplo simple: 1 punto por victoria)
    if (agentsWon) {
      // Dar puntos a todos menos al impostor
      for (final name in _currentTournament!.playerNames) {
        if (name != impostor) {
          _currentTournament!.playerScores[name] = 
            (_currentTournament!.playerScores[name] ?? 0) + 1;
        }
      }
    } else {
      // Dar puntos al impostor
      _currentTournament!.playerScores[impostor] = 
        (_currentTournament!.playerScores[impostor] ?? 0) + 2;
    }

    await _saveTournament();
    AppLogger.info('Round ${round.roundNumber} recorded');
  }

  bool get isTournamentComplete {
    if (_currentTournament == null) return false;
    return _currentTournament!.currentRound >= _currentTournament!.totalRounds;
  }

  String? get tournamentWinner {
    if (_currentTournament == null || !isTournamentComplete) return null;

    var maxScore = 0;
    String? winner;

    _currentTournament!.playerScores.forEach((name, score) {
      if (score > maxScore) {
        maxScore = score;
        winner = name;
      }
    });

    return winner;
  }

  Future<void> endTournament() async {
    _currentTournament = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefKeyTournament);
    AppLogger.info('Tournament ended');
  }

  Future<void> _saveTournament() async {
    if (_currentTournament == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _prefKeyTournament,
        jsonEncode(_currentTournament!.toJson()),
      );
    } catch (e, stackTrace) {
      AppLogger.error('Failed to save tournament', e, stackTrace);
    }
  }
}

class Tournament {
  final int totalRounds;
  int currentRound;
  final List<String> playerNames;
  final Map<String, int> playerScores;
  final List<TournamentRound> roundHistory;

  Tournament({
    required this.totalRounds,
    required this.currentRound,
    required this.playerNames,
    required this.playerScores,
    required this.roundHistory,
  });

  factory Tournament.fromJson(Map<String, dynamic> json) {
    return Tournament(
      totalRounds: json['totalRounds'] as int,
      currentRound: json['currentRound'] as int,
      playerNames: List<String>.from(json['playerNames']),
      playerScores: Map<String, int>.from(json['playerScores']),
      roundHistory: (json['roundHistory'] as List)
          .map((e) => TournamentRound.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalRounds': totalRounds,
      'currentRound': currentRound,
      'playerNames': playerNames,
      'playerScores': playerScores,
      'roundHistory': roundHistory.map((r) => r.toJson()).toList(),
    };
  }

  List<MapEntry<String, int>> get leaderboard {
    final entries = playerScores.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries;
  }
}

class TournamentRound {
  final int roundNumber;
  final String impostor;
  final String secretPlayer;
  final bool agentsWon;

  TournamentRound({
    required this.roundNumber,
    required this.impostor,
    required this.secretPlayer,
    required this.agentsWon,
  });

  factory TournamentRound.fromJson(Map<String, dynamic> json) {
    return TournamentRound(
      roundNumber: json['roundNumber'] as int,
      impostor: json['impostor'] as String,
      secretPlayer: json['secretPlayer'] as String,
      agentsWon: json['agentsWon'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roundNumber': roundNumber,
      'impostor': impostor,
      'secretPlayer': secretPlayer,
      'agentsWon': agentsWon,
    };
  }
}

