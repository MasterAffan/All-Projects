class GameResult {
  final DateTime date;
  final int playerCount;
  final int imposterCount;
  final bool civiliansWon;
  final String civilianWord;
  final String imposterWord;

  const GameResult({
    required this.date,
    required this.playerCount,
    required this.imposterCount,
    required this.civiliansWon,
    required this.civilianWord,
    required this.imposterWord,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'playerCount': playerCount,
      'imposterCount': imposterCount,
      'civiliansWon': civiliansWon,
      'civilianWord': civilianWord,
      'imposterWord': imposterWord,
    };
  }

  factory GameResult.fromJson(Map<String, dynamic> json) {
    return GameResult(
      date: DateTime.parse(json['date']),
      playerCount: json['playerCount'],
      imposterCount: json['imposterCount'],
      civiliansWon: json['civiliansWon'],
      civilianWord: json['civilianWord'],
      imposterWord: json['imposterWord'],
    );
  }
} 