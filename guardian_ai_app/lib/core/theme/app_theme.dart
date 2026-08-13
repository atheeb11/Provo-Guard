import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryRoyalBlue,
        secondary: AppColors.secondaryIndigo,
        tertiary: AppColors.accentMint,
        surface: AppColors.lightSurface,
        background: AppColors.lightBackground,
        error: AppColors.riskCritical,
        onPrimary: Colors.white,
        onSurface: AppColors.textPrimaryLight,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).copyWith(
        displayLarge: GoogleFonts.poppins(color: AppColors.textPrimaryLight, fontWeight: FontWeight.bold, fontSize: 30),
        titleLarge: GoogleFonts.poppins(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w600, fontSize: 20),
        titleMedium: GoogleFonts.poppins(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w600, fontSize: 16),
        bodyLarge: GoogleFonts.inter(color: AppColors.textPrimaryLight, fontSize: 15),
        bodyMedium: GoogleFonts.inter(color: AppColors.textSecondaryLight, fontSize: 13),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightCard,
        elevation: 1.5,
        shadowColor: Colors.black.withOpacity(0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.lightBorder, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textPrimaryLight),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        selectedItemColor: AppColors.primaryRoyalBlue,
        unselectedItemColor: AppColors.textSecondaryLight,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryLightSky,
        secondary: AppColors.secondaryIndigo,
        surface: AppColors.darkSurface,
        background: AppColors.darkBackground,
        error: AppColors.riskCritical,
        onPrimary: Colors.black,
        onSurface: AppColors.textPrimaryDark,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.poppins(color: AppColors.textPrimaryDark, fontWeight: FontWeight.bold, fontSize: 30),
        titleLarge: GoogleFonts.poppins(color: AppColors.textPrimaryDark, fontWeight: FontWeight.w600, fontSize: 20),
        titleMedium: GoogleFonts.poppins(color: AppColors.textPrimaryDark, fontWeight: FontWeight.w600, fontSize: 16),
        bodyLarge: GoogleFonts.inter(color: AppColors.textPrimaryDark, fontSize: 15),
        bodyMedium: GoogleFonts.inter(color: AppColors.textSecondaryDark, fontSize: 13),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.darkBorder, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.primaryLightSky,
        unselectedItemColor: AppColors.textSecondaryDark,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
