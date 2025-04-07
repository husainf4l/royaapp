import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // AI blue color palette
  static const Color primaryBlue = Color(0xFF2962FF);
  static const Color lightBlue = Color(0xFF82B1FF);
  static const Color darkBlue = Color(0xFF0039CB);
  static const Color accentTeal = Color(0xFF00E5FF);
  static const Color darkBackground = Color(0xFF121212);
  static const Color surfaceColor = Color(0xFF1E1E1E);
  static const Color errorColor = Color(0xFFCF6679);

  // Text colors
  static const Color primaryTextColor = Color(0xFFE0E0E0);
  static const Color secondaryTextColor = Color(0xFFBDBDBD);
  static const Color headlineTextColor = Color(
    0xFFBBDEFB,
  ); // Light blue for headlines

  static ThemeData darkTheme() {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: darkBackground,
      primaryColor: primaryBlue,
      colorScheme: const ColorScheme.dark(
        primary: primaryBlue, // Blue for primary actions
        secondary: accentTeal, // Teal for accent elements
        surface: surfaceColor, // Slightly lighter than background
        error: errorColor, // Soft red for errors
      ),
      cardColor: surfaceColor,
      dividerColor: Colors.white12,
      textTheme: GoogleFonts.cairoTextTheme(
        const TextTheme(
          headlineMedium: TextStyle(
            color: headlineTextColor,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(color: primaryTextColor),
          bodyMedium: TextStyle(color: secondaryTextColor),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColor,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
