import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../data/models/player.dart';

class GameService {
  final Random _rnd = Random();
  List<Player> _pool = [];

  Future<void> loadPlayersFromAssets() async {
    final raw = await rootBundle.loadString('assets/players.json');
    final list = json.decode(raw) as List<dynamic>;
    _pool =
        list.map((e) => Player.fromJson(e as Map<String, dynamic>)).toList();
  }

  Player getRandomPlayer() {
    if (_pool.isEmpty) throw Exception('Player pool is empty');
    return _pool[_rnd.nextInt(_pool.length)];
  }

  List<Player> pickUniquePlayers(int count) {
    final picked = <Player>[];
    final copy = List<Player>.from(_pool);
    copy.shuffle(_rnd);
    for (var i = 0; i < count && i < copy.length; i++) {
      picked.add(copy[i]);
    }
    return picked;
  }
}
