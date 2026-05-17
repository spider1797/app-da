import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primaryBlue = Color(0xFF0056D2);
  static const Color primaryBlueDark = Color(0xFF003C9E);
  static const Color alertRed = Color(0xFFE53935);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color safeGreen = Color(0xFF4CAF50);
  static const Color backgroundLight = Color(0xFFF7F7F9);
  static const Color cardWhite = Colors.white;
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color borderLight = Color(0xFFE0E0E0);

  // Aliases used by screens
  static const Color textDark = Color(0xFF212121);
  static const Color textLight = Color(0xFF757575);

  // Text styles
  static TextStyle get headingStyle => const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: textDark,
      );

  static TextStyle get bodyStyle => const TextStyle(
        fontSize: 14,
        color: textLight,
        height: 1.5,
      );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundLight,
      colorScheme: ColorScheme.light(
        primary: primaryBlue,
        secondary: primaryBlueDark,
        error: alertRed,
        surface: cardWhite,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.inter(color: textPrimary, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.inter(color: textPrimary, fontWeight: FontWeight.bold),
        titleLarge: GoogleFonts.inter(color: textPrimary, fontWeight: FontWeight.bold),
        titleMedium: GoogleFonts.inter(color: textPrimary, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.inter(color: textPrimary),
        bodyMedium: GoogleFonts.inter(color: textPrimary),
        labelLarge: GoogleFonts.inter(color: textPrimary, fontWeight: FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundLight,
        elevation: 0,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: GoogleFonts.inter(
          color: textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: cardWhite,
        selectedItemColor: primaryBlue,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      cardTheme: CardThemeData(
        color: cardWhite,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
