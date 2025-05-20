import 'package:flutter/material.dart';
import '../constants/colors.dart';

Future<bool> showExitConfirmationDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text(
        'Exit Game?',
        style: TextStyle(
          color: AppColors.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        'Are you sure you want to exit? Any unsaved progress will be lost.',
        style: TextStyle(
          color: AppColors.onSurface,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: AppColors.textLight,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            'Exit',
            style: TextStyle(
              color: AppColors.error,
            ),
          ),
        ),
      ],
    ),
  );
  
  return result ?? false;
} 