class WordPair {
  final String civilianWord;
  final String imposterWord;
  final int difficulty;

  const WordPair({
    required this.civilianWord,
    required this.imposterWord,
    this.difficulty = 1,
  });

  factory WordPair.fromJson(Map<String, dynamic> json) {
    return WordPair(
      civilianWord: json['civilian_word'] as String,
      imposterWord: json['imposter_word'] as String,
      difficulty: json['difficulty'] as int? ?? 1,
    );
  }
} 