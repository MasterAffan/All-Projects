import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/game_result.dart';
import 'package:intl/intl.dart';

class GameHistoryItem extends StatelessWidget {
  final GameResult result;

  const GameHistoryItem({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, y HH:mm');
    
    return Card(
      color: AppColors.surface,
      child: ExpansionTile(
        title: Row(
          children: [
            Icon(
              result.civiliansWon ? Icons.people : Icons.person_off,
              color: result.civiliansWon ? AppColors.primary : AppColors.error,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.civiliansWon ? 'Civilians Won' : 'Imposters Won',
                  style: TextStyle(
                    color: result.civiliansWon
                        ? AppColors.primary
                        : AppColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  dateFormat.format(result.date),
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Players', result.playerCount.toString()),
                _buildDetailRow('Imposters', result.imposterCount.toString()),
                _buildDetailRow('Civilian Word', result.civilianWord),
                _buildDetailRow('Imposter Word', result.imposterWord),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              color: AppColors.onSurface,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
} 