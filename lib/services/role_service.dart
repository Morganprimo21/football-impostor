import 'dart:math';
import '../data/models/player_role.dart';

class RoleService {
  final Random _rnd = Random();

  Map<String, PlayerRole> assignRoles(
      List<String> playerNames, int impostorCount) {
    // Asignar roles según número de impostores (máximo 3)
    final Map<String, PlayerRole> roles = {};
    if (playerNames.isEmpty) return roles;

    // Validar número de impostores
    final validImpostorCount = impostorCount.clamp(1, 3);
    if (validImpostorCount > playerNames.length) {
      throw Exception('No puede haber más impostores que jugadores');
    }

    // Inicializar todos como inocentes
    for (final name in playerNames) {
      roles[name] = PlayerRole.innocent;
    }

    // Asignar impostores
    final impostorIndices = <int>{};
    while (impostorIndices.length < validImpostorCount) {
      impostorIndices.add(_rnd.nextInt(playerNames.length));
    }
    for (final idx in impostorIndices) {
      roles[playerNames[idx]] = PlayerRole.impostor;
    }

    // Asignar informados (1 si hay >=4 jugadores, 2 si hay >=6)
    if (playerNames.length >= 4) {
      int informedCount = playerNames.length >= 6 ? 2 : 1;
      final used = Set<int>.from(impostorIndices);
      
      while (informedCount > 0 && used.length < playerNames.length) {
        var idx = _rnd.nextInt(playerNames.length);
        if (!used.contains(idx)) {
          roles[playerNames[idx]] = PlayerRole.informed;
          used.add(idx);
          informedCount--;
        }
      }
    }

    return roles;
  }
}
