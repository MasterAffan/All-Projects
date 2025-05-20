import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/game_result.dart';
import '../services/storage_service.dart';
import '../widgets/statistics_card.dart';
import '../widgets/game_history_item.dart';

class StatisticsScreen extends StatelessWidget {
  final StorageService _storageService = StorageService();

  StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Statistics'),
        backgroundColor: AppColors.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: AppColors.surface,
                  title: const Text(
                    'Clear History',
                    style: TextStyle(color: AppColors.onSurface),
                  ),
                  content: const Text(
                    'Are you sure you want to clear all game history?',
                    style: TextStyle(color: AppColors.onSurface),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        _storageService.clearGameResults();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Clear',
                        style: TextStyle(color: AppColors.error),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<GameResult>>(
        future: _storageService.getGameResults(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No games played yet',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.onBackground,
                ),
              ),
            );
          }

          final results = snapshot.data!;
          final totalGames = results.length;
          final civilianWins = results.where((r) => r.civiliansWon).length;
          final imposterWins = totalGames - civilianWins;
          final averagePlayers =
              results.map((r) => r.playerCount).reduce((a, b) => a + b) /
                  totalGames;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: StatisticsCard(
                        title: 'Total Games',
                        value: totalGames.toString(),
                        icon: Icons.games,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: StatisticsCard(
                        title: 'Civilian Wins',
                        value: '$civilianWins',
                        icon: Icons.people,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: StatisticsCard(
                        title: 'Imposter Wins',
                        value: '$imposterWins',
                        icon: Icons.person_off,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: StatisticsCard(
                  title: 'Average Players',
                  value: averagePlayers.toStringAsFixed(1),
                  icon: Icons.groups,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Game History',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onBackground,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    return GameHistoryItem(result: results[index]);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
} 