class Player {
  final String name;
  final bool isImposter;
  String? word;

  Player({
    required this.name,
    this.isImposter = false,
    this.word,
  });

  Player copyWith({
    String? name,
    bool? isImposter,
    String? word,
  }) {
    return Player(
      name: name ?? this.name,
      isImposter: isImposter ?? this.isImposter,
      word: word ?? this.word,
    );
  }
} 