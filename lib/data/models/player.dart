class Player {
  final String name;
  final String club;
  final String nationality;
  final String position;
  final List<String> keywords;

  Player({
    required this.name,
    required this.club,
    required this.nationality,
    required this.position,
    required this.keywords,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      name: json['name'] ?? '',
      club: json['club'] ?? '',
      nationality: json['nationality'] ?? '',
      position: json['position'] ?? '',
      keywords: List<String>.from(json['keywords'] ?? []),
    );
  }
}
