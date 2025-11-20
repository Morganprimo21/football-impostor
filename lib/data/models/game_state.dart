import 'player.dart';
import 'player_role.dart';

class GameState {
  final List<String> playerNames;
  final Map<String, Player>
      assignedPlayers; // mapping playerName -> Player (secret)
  final Map<String, PlayerRole> roles; // mapping playerName -> role

  GameState({
    required this.playerNames,
    required this.assignedPlayers,
    required this.roles,
  });
}
