import 'package:flutter/material.dart';

class ValentineTheme {
  // Primary Valentine colors based on typical Valentine's Day color schemes
  static const Color primaryPink = Color(0xFFE91E63); // Deep pink
  static const Color primaryRed = Color(0xFFF44336); // Valentine red
  static const Color accentPink = Color(0xFFFF69B4); // Hot pink
  static const Color softPink = Color(0xFFFFC1CC); // Light pink
  static const Color creamWhite = Color(0xFFFFF8DC); // Cream white
  static const Color darkRose = Color(0xFF8B4B6B); // Dark rose
  static const Color lightRose = Color(0xFFFDE7E9); // Very light rose
  static const Color goldAccent = Color(0xFFFFD700); // Gold for accents

  // Text colors
  static const Color primaryText = Color(0xFF2D1B2E); // Dark purple-brown
  static const Color secondaryText = Color(0xFF5D4E5E); // Medium purple-brown
  static const Color lightText = Color(0xFFFFFFFF); // White
  static const Color accentText = Color(0xFFE91E63); // Pink text

  // Background colors
  static const Color primaryBackground = Color(0xFFFFF8F8); // Very light pink
  static const Color secondaryBackground = Color(0xFFFDEDF0); // Light pink background
  static const Color cardBackground = Color(0xFFFFFFFF); // White cards
  static const Color surfaceBackground = Color(0xFFFDF2F8); // Pink surface

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: primaryPink,
        secondary: primaryRed,
        tertiary: accentPink,
        surface: cardBackground,
        onPrimary: lightText,
        onSecondary: lightText,
        onTertiary: lightText,
        onSurface: primaryText,
        error: primaryRed,
        outline: darkRose,
        outlineVariant: softPink,
        surfaceContainerHighest: secondaryBackground,
        onSurfaceVariant: secondaryText,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryPink,
        foregroundColor: lightText,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPink,
          foregroundColor: lightText,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryPink,
          side: const BorderSide(color: primaryPink, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryPink,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightRose,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: softPink),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: softPink),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryPink, width: 2),
        ),
        labelStyle: const TextStyle(color: secondaryText),
        hintStyle: const TextStyle(color: secondaryText),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryPink,
        foregroundColor: lightText,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: lightRose,
        labelStyle: const TextStyle(color: primaryText),
        selectedColor: primaryPink,
        disabledColor: softPink.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: cardBackground,
        selectedItemColor: primaryPink,
        unselectedItemColor: secondaryText,
        type: BottomNavigationBarType.fixed,
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: primaryPink,
        unselectedLabelColor: secondaryText,
        indicatorColor: primaryPink,
      ),
      dividerTheme: const DividerThemeData(
        color: softPink,
        thickness: 1,
      ),
      scaffoldBackgroundColor: primaryBackground,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: primaryText,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: primaryText,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: primaryText,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: TextStyle(
          color: primaryText,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: primaryText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: primaryText,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: primaryText,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: primaryText,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          color: primaryText,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: primaryText,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: TextStyle(
          color: primaryText,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        bodySmall: TextStyle(
          color: secondaryText,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        labelLarge: TextStyle(
          color: lightText,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: TextStyle(
          color: primaryText,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          color: secondaryText,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: accentPink,
        secondary: primaryRed,
        tertiary: softPink,
        surface: Color(0xFF2D1B2E),
        onPrimary: Color(0xFF1A1A1A),
        onSecondary: lightText,
        onTertiary: Color(0xFF1A1A1A),
        onSurface: lightText,
        error: primaryRed,
        outline: darkRose,
        outlineVariant: Color(0xFF3D2D3E),
        surfaceContainerHighest: Color(0xFF2D1B2E),
        onSurfaceVariant: Color(0xFFCCCCCC),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF2D1B2E),
        foregroundColor: lightText,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentPink,
          foregroundColor: Color(0xFF1A1A1A),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accentPink,
          side: const BorderSide(color: accentPink, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentPink,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF3D2D3E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkRose),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkRose),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentPink, width: 2),
        ),
        labelStyle: const TextStyle(color: Color(0xFFCCCCCC)),
        hintStyle: const TextStyle(color: Color(0xFFCCCCCC)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accentPink,
        foregroundColor: Color(0xFF1A1A1A),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF3D2D3E),
        labelStyle: const TextStyle(color: lightText),
        selectedColor: accentPink,
        disabledColor: const Color(0xFF3D2D3E).withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF2D1B2E),
        selectedItemColor: accentPink,
        unselectedItemColor: Color(0xFFCCCCCC),
        type: BottomNavigationBarType.fixed,
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: accentPink,
        unselectedLabelColor: Color(0xFFCCCCCC),
        indicatorColor: accentPink,
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF3D2D3E),
        thickness: 1,
      ),
      scaffoldBackgroundColor: const Color(0xFF1A1A1A),
    );
  }
}