import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryViolet = Color(0xFF5B4DFF);
  static const Color primaryVioletLight = Color(0xFF7E72FF);
  static const Color primaryVioletDark = Color(0xFF3F32DF);

  static const Color secondaryLavender = Color(0xFFB8ACFF);
  static const Color secondaryLavenderLight = Color(0xFFEDE9FE);

  // Neutral Colors - Light
  static const Color lightBackground = Color(0xFFF8F9FD);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceSubtle = Color(0xFFF1F3F9);
  static const Color lightTextPrimary = Color(0xFF14151F);
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color lightBorder = Color(0xFFE5E7EB);

  // Neutral Colors - Dark
  static const Color darkBackground = Color(0xFF0D0E15);
  static const Color darkSurface = Color(0xFF171822);
  static const Color darkSurfaceSubtle = Color(0xFF222332);
  static const Color darkTextPrimary = Color(0xFFF3F4F6);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);
  static const Color darkBorder = Color(0xFF2E3044);

  // Category Colors
  static const Map<String, Color> categoryColors = {
    'Personal': Color(0xFFEC4899),
    'Study': Color(0xFF3B82F6),
    'Ideas': Color(0xFFF59E0B),
    'Work': Color(0xFF10B981),
    'Travel': Color(0xFF06B6D4),
    'Goals': Color(0xFF8B5CF6),
    'All': Color(0xFF5B4DFF),
  };

  static Color getCategoryColor(String category) {
    return categoryColors[category] ?? primaryViolet;
  }

  // Light Theme Data
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.light(
      primary: primaryViolet,
      onPrimary: Colors.white,
      primaryContainer: secondaryLavenderLight,
      onPrimaryContainer: primaryVioletDark,
      secondary: const Color(0xFF6366F1),
      onSecondary: Colors.white,
      surface: lightSurface,
      onSurface: lightTextPrimary,
      error: const Color(0xFFEF4444),
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: lightBackground,
      fontFamily: 'Inter',
      appBarTheme: const AppBarTheme(
        backgroundColor: lightBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: lightTextPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: lightTextPrimary),
      ),
      cardTheme: CardTheme(
        color: lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: lightBorder, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryViolet,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurfaceSubtle,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryViolet, width: 1.5),
        ),
        hintStyle: const TextStyle(
          color: lightTextSecondary,
          fontSize: 14,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryViolet,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  // Dark Theme Data
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.dark(
      primary: primaryVioletLight,
      onPrimary: Colors.black,
      primaryContainer: darkSurfaceSubtle,
      onPrimaryContainer: secondaryLavender,
      secondary: const Color(0xFF818CF8),
      onSecondary: Colors.black,
      surface: darkSurface,
      onSurface: darkTextPrimary,
      error: const Color(0xFFF87171),
      onError: Colors.black,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: darkBackground,
      fontFamily: 'Inter',
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: darkTextPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: darkTextPrimary),
      ),
      cardTheme: CardTheme(
        color: darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: darkBorder, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryViolet,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurfaceSubtle,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryVioletLight, width: 1.5),
        ),
        hintStyle: const TextStyle(
          color: darkTextSecondary,
          fontSize: 14,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryViolet,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
