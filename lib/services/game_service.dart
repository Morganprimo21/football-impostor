import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../data/models/player.dart';
import '../utils/constants.dart';
import '../utils/logger.dart';

class GameService {
  final Random _rnd = Random();
  List<Player> _pool = [];
  bool _isLoaded = false;
  
  // Caché para filtros de liga para evitar recalcular
  final Map<String, List<Player>> _leagueCache = {};

  Future<void> loadPlayersFromAssets() async {
    if (_isLoaded && _pool.isNotEmpty) {
      AppLogger.debug('Players already loaded, skipping');
      return;
    }

    try {
      AppLogger.info('Loading players from assets...');
      final raw = await rootBundle.loadString(AppConstants.assetPlayersJson);
      final list = json.decode(raw) as List<dynamic>;
      _pool =
          list.map((e) => Player.fromJson(e as Map<String, dynamic>)).toList();
      _isLoaded = true;
      AppLogger.info('Loaded ${_pool.length} players');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to load players', e, stackTrace);
      rethrow;
    }
  }

  Player getRandomPlayerForLeague(
    String leagueKey, {
    List<String>? allowedLeagues,
  }) {
    if (_pool.isEmpty) {
      AppLogger.error('Player pool is empty');
      throw Exception(ErrorMessages.playerPoolEmpty('en'));
    }

    // Usar caché si está disponible
    List<Player> filtered;
    if (leagueKey == 'mixed') {
      // Mezcla de todas las ligas permitidas (según packs comprados)
      if (allowedLeagues == null || allowedLeagues.isEmpty) {
        filtered = _pool;
      } else {
        final allowed = allowedLeagues.map((e) => e.toLowerCase()).toSet();
        filtered = _pool
            .where((p) => allowed.contains(p.league.toLowerCase()))
            .toList();
        if (filtered.isEmpty) {
          AppLogger.warning(
              'No players found for mixed with allowed leagues $allowedLeagues, using all players');
          filtered = List.from(_pool);
        }
      }
    } else {
      // Verificar caché primero
      if (_leagueCache.containsKey(leagueKey)) {
        filtered = _leagueCache[leagueKey]!;
      } else {
        // Filtrar por liga real del JSON
        filtered = <Player>[];
        // Mapeo de keys a valores de liga en JSON
        final leagueMap = {
          'premier': 'Premier',
          'laliga': 'LaLiga',
          'seriea': 'SerieA',
          'bundes': 'Bundes',
          'ligue1': 'Ligue1',
        };
        
        final targetLeague = leagueMap[leagueKey] ?? '';
        
        if (targetLeague.isNotEmpty) {
          filtered.addAll(_pool.where((p) => 
            p.league.toLowerCase() == targetLeague.toLowerCase() ||
            p.league.toLowerCase() == leagueKey.toLowerCase()
          ));
        }
        
        // Si no hay jugadores de esa liga, usar todos
        if (filtered.isEmpty) {
          AppLogger.warning('No players found for league $leagueKey, using all players');
          filtered = List.from(_pool);
        }
        
        // Guardar en caché
        _leagueCache[leagueKey] = filtered;
      }
    }

    return filtered[_rnd.nextInt(filtered.length)];
  }
  
  /// Limpia la caché de ligas (útil si se actualiza el pool de jugadores)
  void clearLeagueCache() {
    _leagueCache.clear();
  }

  List<Player> pickUniquePlayers(int count) {
    if (_pool.isEmpty) {
      AppLogger.warning('Player pool is empty, returning empty list');
      return [];
    }

    final picked = <Player>[];
    final copy = List<Player>.from(_pool);
    copy.shuffle(_rnd);
    
    final maxCount = count < copy.length ? count : copy.length;
    for (var i = 0; i < maxCount; i++) {
      picked.add(copy[i]);
    }
    
    AppLogger.debug('Picked $maxCount unique players');
    return picked;
  }

  int get playerCount => _pool.length;
  bool get isLoaded => _isLoaded;
}
