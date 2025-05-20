import 'package:flutter/material.dart';
import '../constants/colors.dart';

class PlayerNameInput extends StatelessWidget {
  final TextEditingController controller;
  final int playerNumber;

  const PlayerNameInput({
    super.key,
    required this.controller,
    required this.playerNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: controller,
        style: TextStyle(
          color: AppColors.textLight,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors.secondary,
              width: 2,
            ),
          ),
          prefixIcon: Container(
            margin: EdgeInsets.all(8),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                playerNumber.toString(),
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          hintText: 'Enter player name',
          hintStyle: TextStyle(
            color: AppColors.textMuted,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
} 