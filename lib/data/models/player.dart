class Player {
  final String name;
  final String club;
  final String nationality;
  final String position;
  final List<String> keywords;
  final String league;

  Player({
    required this.name,
    required this.club,
    required this.nationality,
    required this.position,
    required this.keywords,
    required this.league,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      name: json['name'] ?? '',
      club: json['club'] ?? '',
      nationality: json['nationality'] ?? '',
      position: json['position'] ?? '',
      keywords: List<String>.from(json['keywords'] ?? []),
      league: json['league'] ?? 'mixed',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'club': club,
      'nationality': nationality,
      'position': position,
      'keywords': keywords,
      'league': league,
    };
  }
}
