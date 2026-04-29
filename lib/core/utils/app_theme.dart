import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData light() {
    return _buildTheme(Brightness.light);
  }

  static ThemeData dark() {
    return _buildTheme(Brightness.dark);
  }

  static ThemeData _buildTheme(Brightness brightness) {
    const seedColor = Color(0xFF1B4965);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );

    final textTheme = GoogleFonts.interTextTheme(
      ThemeData(brightness: brightness).textTheme,
    ).apply(
      bodyColor: AppColors.textPrimary(brightness),
      displayColor: AppColors.textPrimary(brightness),
    );

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      brightness: brightness,
      textTheme: textTheme,
      scaffoldBackgroundColor: AppColors.background(brightness),
      cardColor: AppColors.card(brightness),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.card(brightness),
        border: const OutlineInputBorder(),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background(brightness),
        foregroundColor: AppColors.textPrimary(brightness),
        elevation: 0,
      ),
    );
  }
}
