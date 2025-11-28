/// Define un pack de jugadores temático
class PlayerPack {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final bool isPremium;
  final List<String> leagues;

  const PlayerPack({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    this.isPremium = false,
    this.leagues = const [],
  });

  static const PlayerPack mixed = PlayerPack(
    id: 'mixed',
    name: 'Mixed',
    description: 'Jugadores de todas las ligas',
    emoji: '🌍',
    isPremium: false,
    leagues: [],
  );

  static const PlayerPack premierLeague = PlayerPack(
    id: 'premier',
    name: 'Premier League',
    description: 'Estrellas de la Premier League',
    emoji: '🏴󠁧󠁢󠁥󠁮󠁧󠁿',
    isPremium: false,
    leagues: ['Premier'],
  );

  static const PlayerPack laLiga = PlayerPack(
    id: 'laliga',
    name: 'LaLiga',
    description: 'Leyendas de LaLiga',
    emoji: '🇪🇸',
    isPremium: false,
    leagues: ['LaLiga'],
  );

  static const PlayerPack legends = PlayerPack(
    id: 'legends',
    name: 'Legends',
    description: 'Leyendas retiradas del fútbol',
    emoji: '⭐',
    isPremium: true,
    leagues: ['Legends'],
  );

  static const PlayerPack serieA = PlayerPack(
    id: 'seriea',
    name: 'Serie A',
    description: 'Estrellas de Italia',
    emoji: '🇮🇹',
    isPremium: true,
    leagues: ['SerieA'],
  );

  static const PlayerPack bundesliga = PlayerPack(
    id: 'bundes',
    name: 'Bundesliga',
    description: 'Jugadores de Alemania',
    emoji: '🇩🇪',
    isPremium: true,
    leagues: ['Bundes'],
  );

  static const List<PlayerPack> allPacks = [
    mixed,
    premierLeague,
    laLiga,
    legends,
    serieA,
    bundesliga,
  ];

  static List<PlayerPack> get freePacks {
    return allPacks.where((p) => !p.isPremium).toList();
  }

  static List<PlayerPack> get premiumPacks {
    return allPacks.where((p) => p.isPremium).toList();
  }

  static PlayerPack? getById(String id) {
    try {
      return allPacks.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}

