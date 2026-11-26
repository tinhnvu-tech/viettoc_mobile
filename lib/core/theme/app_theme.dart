import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: ThoCamColors.mist,
      colorScheme: const ColorScheme.light(
        primary: ThoCamColors.pineGreen,
        secondary: ThoCamColors.terracotta,
        tertiary: ThoCamColors.ochre,
        surface: ThoCamColors.mist,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: ThoCamColors.roast,
      ),
      textTheme: GoogleFonts.beVietnamProTextTheme().apply(
        bodyColor: ThoCamColors.roast,
        displayColor: ThoCamColors.roast,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: ThoCamColors.pineGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.beVietnamPro(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: ThoCamColors.border, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ThoCamColors.terracotta,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: GoogleFonts.beVietnamPro(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: ThoCamColors.terracotta,
        unselectedItemColor: ThoCamColors.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
