import 'package:flutter/material.dart';
import '../constants/colors.dart';

class ThemeUtils {
  static BoxDecoration get gradientBackground => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.primary.withOpacity(0.15),
        AppColors.background,
        AppColors.background,
      ],
    ),
  );

  static AppBar modernAppBar(String title, {List<Widget>? actions}) => AppBar(
    title: Text(
      title,
      style: TextStyle(
        color: AppColors.onPrimary,
        fontWeight: FontWeight.bold,
      ),
    ),
    backgroundColor: AppColors.primary,
    elevation: 0,
    iconTheme: IconThemeData(color: AppColors.onPrimary),
    actions: actions,
  );

  static ButtonStyle get primaryButton => ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.onPrimary,
    padding: const EdgeInsets.symmetric(
      horizontal: 32,
      vertical: 16,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    elevation: 8,
    shadowColor: AppColors.primary.withOpacity(0.5),
  );

  static ButtonStyle get secondaryButton => TextButton.styleFrom(
    foregroundColor: AppColors.textLight,
    padding: EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 12,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
      side: BorderSide(
        color: AppColors.primary.withOpacity(0.3),
        width: 2,
      ),
    ),
  );

  static BoxDecoration get cardDecoration => BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: AppColors.primary.withOpacity(0.2),
      width: 1,
    ),
    boxShadow: [
      BoxShadow(
        color: AppColors.primary.withOpacity(0.1),
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
    ],
  );

  static TextStyle get titleStyle => TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textLight,
  );

  static TextStyle get subtitleStyle => TextStyle(
    fontSize: 16,
    color: AppColors.textLight.withOpacity(0.7),
    letterSpacing: 1.2,
  );

  static TextStyle get bodyStyle => TextStyle(
    fontSize: 16,
    color: AppColors.textLight.withOpacity(0.8),
    height: 1.4,
  );
} 