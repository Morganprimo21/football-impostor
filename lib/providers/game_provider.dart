import 'package:flutter/material.dart';
import '../services/game_service.dart';
import '../services/role_service.dart';
import '../data/models/player.dart';
import '../data/models/player_role.dart';

class GameProvider with ChangeNotifier {
  final GameService _gameService = GameService();
  final RoleService _roleService = RoleService();

  List<String> playerNames = [];
  Map<String, PlayerRole> roles = {};

  // Mapa que asocia NombreJugador -> FutbolistaAsignado
  // El impostor tendrá null o un valor vacío aquí.
  Map<String, Player?> assignedPlayers = {};

  int currentIndex = 0;

  Future<void> loadPlayersAsset() async {
    await _gameService.loadPlayersFromAssets();
  }

  void setPlayerNames(List<String> names) {
    playerNames = names;
    notifyListeners();
  }

  void assignRolesAndSecrets() {
    // 1. Asignar roles (quién es impostor, quién inocente)
    roles = _roleService.assignRoles(playerNames);
    assignedPlayers = {};

    // 2. Elegir EL jugador secreto de la ronda (común para todos los inocentes)
    final secretFootballer = _gameService.getRandomPlayer();

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

    currentIndex = 0;
    notifyListeners();
  }

  void nextPlayer() {
    currentIndex = (currentIndex + 1) % playerNames.length;
    notifyListeners();
  }
}
