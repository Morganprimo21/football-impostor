import 'dart:math';
import '../data/models/player_role.dart';

class RoleService {
  final Random _rnd = Random();

  Map<String, PlayerRole> assignRoles(List<String> playerNames) {
    // Simple: 1 impostor, rest innocents, and 1 informed if players >=4
    final Map<String, PlayerRole> roles = {};
    if (playerNames.isEmpty) return roles;
    final impostorIndex = _rnd.nextInt(playerNames.length);
    for (var i = 0; i < playerNames.length; i++) {
      roles[playerNames[i]] = PlayerRole.innocent;
    }
    roles[playerNames[impostorIndex]] = PlayerRole.impostor;
    if (playerNames.length >= 4) {
      // pick informed different from impostor
      int idx;
      do {
        idx = _rnd.nextInt(playerNames.length);
      } while (idx == impostorIndex);
      roles[playerNames[idx]] = PlayerRole.informed;
    }
    return roles;
  }
}
