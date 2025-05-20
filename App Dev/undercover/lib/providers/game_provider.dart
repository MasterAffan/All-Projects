import 'package:flutter/foundation.dart';
import '../models/player.dart';
import '../models/word_pair.dart';
import '../services/word_service.dart';

class GameProvider extends ChangeNotifier {
  final WordService _wordService = WordService();
  List<Player> _players = [];
  List<String> _eliminatedPlayers = [];
  WordPair? _currentWordPair;
  bool _gameStarted = false;

  Map<String, int> _votes = {};
  String? _selectedVote;

  List<String> _playerNames = [];
  int _imposterCount = 1;

  List<Player> get players => _players;
  List<String> get eliminatedPlayers => _eliminatedPlayers;
  WordPair? get currentWordPair => _currentWordPair;
  bool get gameStarted => _gameStarted;

  Map<String, int> get votes => _votes;
  String? get selectedVote => _selectedVote;

  // Calculate allowed wrong votes based on player count
  int getAllowedWrongVotes() {
    return (_players.length / 2).floor();
  }

  int get remainingChances => getAllowedWrongVotes() - _eliminatedPlayers.length;

  void startGame(List<String> playerNames, int imposterCount) {
    _playerNames = playerNames;
    _imposterCount = imposterCount;
    _startNewRound();
  }

  void _startNewRound() {
    _currentWordPair = _wordService.getRandomWordPair();
    _eliminatedPlayers = [];

    // Create list of all players
    List<Player> allPlayers = _playerNames
        .map((name) => Player(name: name, isImposter: false))
        .toList();

    // Randomly select imposters
    allPlayers.shuffle();
    for (int i = 0; i < _imposterCount; i++) {
      allPlayers[i] = Player(
        name: allPlayers[i].name,
        isImposter: true,
        word: _currentWordPair?.imposterWord,
      );
    }

    // Assign civilian word to non-imposters
    for (int i = _imposterCount; i < allPlayers.length; i++) {
      allPlayers[i] = allPlayers[i].copyWith(
        word: _currentWordPair?.civilianWord,
      );
    }

    // Shuffle again to randomize imposter positions
    allPlayers.shuffle();
    _players = allPlayers;
    _gameStarted = true;
    resetVotes();
    notifyListeners();
  }

  void playAgain() {
    _startNewRound();
  }

  bool isPlayerEliminated(String playerName) {
    return _eliminatedPlayers.contains(playerName);
  }

  bool processVote(String votedPlayerName) {
    final votedPlayer = _players.firstWhere(
      (player) => player.name == votedPlayerName,
    );

    // Add the voted player to eliminated list
    _eliminatedPlayers.add(votedPlayerName);
    
    // Check if all imposters are caught
    final allImposters = _players.where((p) => p.isImposter).length;
    final caughtImposters = _eliminatedPlayers
        .where((name) => _players.firstWhere((p) => p.name == name).isImposter)
        .length;
    
    final allImpostersFound = caughtImposters == allImposters;

    resetVotes();
    notifyListeners();
    return allImpostersFound; // Return true only when all imposters are caught
  }

  bool shouldGameEnd() {
    // Count total and caught imposters
    final totalImposters = _players.where((p) => p.isImposter).length;
    final caughtImposters = _eliminatedPlayers
        .where((name) => _players.firstWhere((p) => p.name == name).isImposter)
        .length;

    // Game ends if either:
    // 1. All imposters are caught (civilians win)
    // 2. No more chances left (imposters win)
    return (caughtImposters == totalImposters) || remainingChances <= 0;
  }

  bool didCiviliansWin() {
    // Count total and caught imposters
    final totalImposters = _players.where((p) => p.isImposter).length;
    final caughtImposters = _eliminatedPlayers
        .where((name) => _players.firstWhere((p) => p.name == name).isImposter)
        .length;

    // Civilians win only if all imposters are caught
    return caughtImposters == totalImposters;
  }

  void resetGame() {
    _players = [];
    _playerNames = [];
    _imposterCount = 1;
    _eliminatedPlayers = [];
    _currentWordPair = null;
    _gameStarted = false;
    resetVotes();
    notifyListeners();
  }

  void vote(String playerName) {
    if (_selectedVote == playerName) {
      _selectedVote = null;
      _votes.remove(playerName);
    } else {
      if (_selectedVote != null) {
        _votes.remove(_selectedVote);
      }
      _selectedVote = playerName;
      _votes[playerName] = (_votes[playerName] ?? 0) + 1;
    }
    notifyListeners();
  }

  String? getMostVotedPlayer() {
    if (_votes.isEmpty) return null;

    final sortedVotes = _votes.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedVotes.first.key;
  }

  void resetVotes() {
    _votes = {};
    _selectedVote = null;
    notifyListeners();
  }
}