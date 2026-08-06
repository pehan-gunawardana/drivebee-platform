import 'package:flutter/material.dart';

class AppTheme {
  // Premium Brand Colors
  static const Color primary = Color(0xFFFF9F1C);      // Amber
  static const Color background = Color(0xFFF8F9FA);   // Light Grayish White
  static const Color surface = Color(0xFFFFFFFF);      // White
  static const Color textPrimary = Color(0xFF212529);  // Charcoal Dark
  static const Color textSecondary = Color(0xFF6C757D);// Slate Gray
  static const Color success = Color(0xFF2ECC71);      // Verified Green
  static const Color charcoal = Color(0xFF1E2124);     // Dark Theme accents

  static ThemeData get themeData => lightTheme;

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: background,
    primaryColor: primary,
    colorScheme: const ColorScheme.light(
      primary: primary,
      background: background,
      surface: surface,
      onPrimary: Colors.white,
      onBackground: textPrimary,
      onSurface: textPrimary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      foregroundColor: textPrimary,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: textPrimary),
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(color: textPrimary),
      bodyMedium: TextStyle(color: textSecondary),
    ),
  );
}