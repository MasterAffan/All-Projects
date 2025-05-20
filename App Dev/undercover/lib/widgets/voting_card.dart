import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/player.dart';

class VotingCard extends StatelessWidget {
  final Player player;
  final bool isSelected;
  final bool isEliminated;
  final VoidCallback? onTap;

  const VotingCard({
    super.key,
    required this.player,
    required this.isSelected,
    this.isEliminated = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? AppColors.primary : AppColors.surface,
      child: InkWell(
        onTap: isEliminated ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                isEliminated ? Icons.close : (isSelected ? Icons.check_circle : Icons.person),
                color: isEliminated 
                    ? AppColors.error 
                    : (isSelected ? AppColors.onPrimary : AppColors.onSurface),
                size: 28,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  player.name,
                  style: TextStyle(
                    fontSize: 18,
                    color: isEliminated 
                        ? AppColors.error
                        : (isSelected ? AppColors.onPrimary : AppColors.onSurface),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    decoration: isEliminated ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 