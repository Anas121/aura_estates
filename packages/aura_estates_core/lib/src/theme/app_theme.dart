import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.noir,
      brightness: Brightness.dark,
      fontFamily: 'Roboto',
      colorScheme: const ColorScheme.dark(
        primary: AppColors.or,
        surface: AppColors.surface,
        error: AppColors.erreur,
      ),

      // AppBar : Plate
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.blanc,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
        iconTheme: IconThemeData(color: AppColors.or),
      ),

      // Bouton : Massif, doré, texte noir — Le CTA Premium
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.or,
          foregroundColor: AppColors.orAttenu,
          disabledBackgroundColor: AppColors.orPale,
          // minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
      ),

      // Champs de texte : Sobres, bordure or au focus
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceElevee,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.bordure),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.or, width: 1.5),
        ),
        labelStyle: const TextStyle(color: AppColors.orPale),
        hintStyle: const TextStyle(color: AppColors.or),
      ),

      // Dividers discrets
      dividerTheme: const DividerThemeData(
        color: AppColors.surfaceElevee,
        thickness: 1,
      ),
    );
  }
}
