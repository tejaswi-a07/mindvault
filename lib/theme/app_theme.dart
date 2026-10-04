import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryViolet = Color(0xFF5B4DFF);
  static const Color primaryVioletLight = Color(0xFF7E72FF);
  static const Color primaryVioletDark = Color(0xFF3F32DF);
  static const Color secondaryLavender = Color(0xFFB8ACFF);
  static const Color secondaryLavenderLight = Color(0xFFEDE9FE);
  static const Color lightBackground = Color(0xFFF8F9FD);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceSubtle = Color(0xFFF1F3F9);
  static const Color lightTextPrimary = Color(0xFF14151F);
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color lightBorder = Color(0xFFE5E7EB);
  static const Color darkBackground = Color(0xFF0D0E15);
  static const Color darkSurface = Color(0xFF171822);
  static const Color darkSurfaceSubtle = Color(0xFF222332);
  static const Color darkTextPrimary = Color(0xFFF3F4F6);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);
  static const Color darkBorder = Color(0xFF2E3044);

  static const Map<String, Color> categoryColors = {
    'Personal': Color(0xFFEC4899),
    'Study': Color(0xFF3B82F6),
    'Ideas': Color(0xFFF59E0B),
    'Work': Color(0xFF10B981),
    'Travel': Color(0xFF06B6D4),
    'Goals': Color(0xFF8B5CF6),
    'All': Color(0xFF5B4DFF),
  };

  static Color getCategoryColor(String category) =>
      categoryColors[category] ?? primaryViolet;

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
      visualDensity: VisualDensity.standard,
      splashFactory: InkSparkle.splashFactory,
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
      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: lightBorder, width: 1),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: lightBorder,
        thickness: 1,
        space: 1,
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        elevation: 8,
        backgroundColor: lightSurface,
        indicatorColor: secondaryLavenderLight,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 11,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? primaryVioletDark
                : lightTextSecondary,
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: lightSurface,
        indicatorColor: secondaryLavenderLight,
        selectedIconTheme: const IconThemeData(color: primaryVioletDark),
        unselectedIconTheme: const IconThemeData(color: lightTextSecondary),
        selectedLabelTextStyle: const TextStyle(
          color: primaryVioletDark,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelTextStyle: const TextStyle(
          color: lightTextSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: lightSurfaceSubtle,
        selectedColor: secondaryLavenderLight,
        side: const BorderSide(color: lightBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryViolet,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryViolet,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
        hintStyle: const TextStyle(color: lightTextSecondary, fontSize: 14),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: lightSurface,
        elevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titleTextStyle: const TextStyle(
          color: lightTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        showDragHandle: false,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: lightTextPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 13),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryViolet,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

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
      visualDensity: VisualDensity.standard,
      splashFactory: InkSparkle.splashFactory,
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
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: darkBorder, width: 1),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: darkBorder,
        thickness: 1,
        space: 1,
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        elevation: 8,
        backgroundColor: darkSurface,
        indicatorColor: darkSurfaceSubtle,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 11,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? secondaryLavender
                : darkTextSecondary,
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: darkSurface,
        indicatorColor: darkSurfaceSubtle,
        selectedIconTheme: const IconThemeData(color: secondaryLavender),
        unselectedIconTheme: const IconThemeData(color: darkTextSecondary),
        selectedLabelTextStyle: const TextStyle(
          color: secondaryLavender,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelTextStyle: const TextStyle(
          color: darkTextSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: darkSurfaceSubtle,
        selectedColor: const Color(0xFF302C62),
        side: const BorderSide(color: darkBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryViolet,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryVioletLight,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
        hintStyle: const TextStyle(color: darkTextSecondary, fontSize: 14),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: darkSurface,
        elevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titleTextStyle: const TextStyle(
          color: darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        showDragHandle: false,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: darkSurfaceSubtle,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        contentTextStyle: const TextStyle(color: darkTextPrimary, fontSize: 13),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryViolet,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
