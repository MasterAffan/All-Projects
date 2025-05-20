import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_result.dart';

class StorageService {
  static const String _gameResultsKey = 'game_results';

  Future<void> saveGameResult(GameResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final results = await getGameResults();
    results.add(result);

    final jsonList = results.map((r) => r.toJson()).toList();
    await prefs.setString(_gameResultsKey, jsonEncode(jsonList));
  }

  Future<List<GameResult>> getGameResults() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_gameResultsKey);
    if (jsonString == null) return [];

    final jsonList = jsonDecode(jsonString) as List;
    return jsonList
        .map((json) => GameResult.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> clearGameResults() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_gameResultsKey);
  }
} 