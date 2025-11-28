import 'dart:math';
import 'package:flutter/material.dart';
import '../services/game_service.dart';
import '../services/role_service.dart';
import '../data/models/player.dart';
import '../data/models/player_role.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';
import '../utils/logger.dart';

class GameProvider with ChangeNotifier {
  final GameService _gameService = GameService();
  final RoleService _roleService = RoleService();

  List<String> playerNames = [];
  Map<String, PlayerRole> roles = {};

  // Mapa que asocia NombreJugador -> FutbolistaAsignado
  // El impostor tendrá null o un valor vacío aquí.
  Map<String, Player?> assignedPlayers = {};

  int currentIndex = 0;
  int impostorCount = 1; // Número de impostores (1-3)
  String _currentLeagueKey = 'mixed'; // Pack/liga seleccionada
  Player? secretFootballer;
  List<String> _mixedAllowedLeagues = [];
  
  String? _errorMessage;
  bool _isLoading = false;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  String get currentLeagueKey => _currentLeagueKey;
  List<String> get mixedAllowedLeagues => List.unmodifiable(_mixedAllowedLeagues);

  Future<void> loadPlayersAsset() async {
    await _gameService.loadPlayersFromAssets();
  }

  /// Define la liga/pack actual (mixed, premier, laliga, seriea, bundes, legends...).
  void setLeagueKey(String leagueKey) {
    _currentLeagueKey = leagueKey;
    _gameService.clearLeagueCache();
    AppLogger.info('League pack selected: $leagueKey');
    notifyListeners();
  }

  /// Define qué ligas reales pueden aparecer cuando se juega en modo "mixed".
  /// Solo se usarán si [_currentLeagueKey] == 'mixed'.
  void setAllowedMixedLeagues(List<String> leagues) {
    _mixedAllowedLeagues = List.from(leagues);
    AppLogger.info(
        'Allowed mixed leagues: ${_mixedAllowedLeagues.join(', ')}');
  }

  void setPlayerNames(List<String> names) {
    // Normalizar y validar nombres
    final normalized = names.map((n) => Validators.normalizePlayerName(n)).toList();
    
    // Validar que todos los nombres sean únicos
    if (!Validators.areNamesUnique(normalized)) {
      _errorMessage = 'Los nombres deben ser únicos';
      AppLogger.warning('Duplicate player names detected');
      notifyListeners();
      return;
    }

    playerNames = normalized;
    _errorMessage = null;
    AppLogger.info('Set ${playerNames.length} player names');
    notifyListeners();
  }

  void setImpostorCount(int count) {
    impostorCount = count.clamp(1, 3);
    notifyListeners();
  }

  void resetForNewGame() {
    secretFootballer = null;
  }

  Future<void> assignRolesAndSecrets() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Validar que hay suficientes jugadores
      if (playerNames.length < AppConstants.minPlayers) {
        throw Exception('Se requieren al menos ${AppConstants.minPlayers} jugadores');
      }

      // Asegurar que los jugadores están cargados
      if (!_gameService.isLoaded) {
        await _gameService.loadPlayersFromAssets();
      }

      // Validar número de impostores
      if (impostorCount > playerNames.length) {
        throw Exception('No puede haber más impostores que jugadores');
      }

      // 1. Asignar roles (quién es impostor, quién inocente)
      roles = _roleService.assignRoles(playerNames, impostorCount);
      assignedPlayers = {};

      // 2. Elegir EL jugador secreto de la ronda (común para todos los inocentes)
      secretFootballer = _gameService.getRandomPlayerForLeague(
        _currentLeagueKey,
        allowedLeagues:
            _currentLeagueKey == 'mixed' ? _mixedAllowedLeagues : null,
      );

      // 3. Asignar el futbolista según el rol
      for (final name in playerNames) {
        final role = roles[name];
        if (role == PlayerRole.impostor) {
          // El impostor NO sabe quién es el futbolista
          assignedPlayers[name] = null;
        } else {
          // Inocentes e Informados ven al mismo futbolista
          assignedPlayers[name] = secretFootballer;
        }
      }

      // 4. Elegir aleatoriamente quién empieza a dar pistas
      final random = Random();
      currentIndex = random.nextInt(playerNames.length);
      
      AppLogger.info('Roles assigned: ${roles.length} players, impostors: $impostorCount');
      AppLogger.info('First player to give clues: ${playerNames[currentIndex]} (index: $currentIndex)');
      _isLoading = false;
      notifyListeners();
    } catch (e, stackTrace) {
      _isLoading = false;
      _errorMessage = e.toString();
      AppLogger.error('Failed to assign roles and secrets', e, stackTrace);
      notifyListeners();
      rethrow;
    }
  }

  void nextPlayer() {
    currentIndex = (currentIndex + 1) % playerNames.length;
    notifyListeners();
  }
}
