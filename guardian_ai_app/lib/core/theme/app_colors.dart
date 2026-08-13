import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors (Google + Apple HIG Clean Aesthetic)
  static const Color primaryRoyalBlue = Color(0xFF1D4ED8); // Deep Royal Blue
  static const Color primarySky = Color(0xFF0284C7);
  static const Color primaryLightSky = Color(0xFF38BDF8);
  static const Color secondaryIndigo = Color(0xFF4F46E5); // Soft Indigo
  static const Color accentMint = Color(0xFF10B981); // Mint Green
  static const Color supportSky = Color(0xFF0EA5E9); // Sky Blue

  // Status & Risk Colors
  static const Color riskSafe = Color(0xFF10B981); // Mint / Emerald
  static const Color riskLow = Color(0xFF84CC16); // Lime
  static const Color riskMedium = Color(0xFFF59E0B); // Soft Amber
  static const Color riskHigh = Color(0xFFF97316); // Soft Orange
  static const Color riskCritical = Color(0xFFEF4444); // Soft Red Emergency

  // Light Mode Palette (Default Primary Design Theme)
  static const Color lightBackground = Color(0xFFF7F9FC); // Very Light Gray
  static const Color lightSurface = Color(0xFFFFFFFF); // Pure White
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);

  // Dark Mode Surface & Background Palette (Midnight Slate)
  static const Color darkBackground = Color(0xFF0B0F19);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkCard = Color(0xFF1E293B);
  static const Color darkBorder = Color(0xFF334155);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  // Helper Severity Color
  static Color getSeverityColor(int score) {
    if (score <= 20) return riskSafe;
    if (score <= 40) return riskLow;
    if (score <= 60) return riskMedium;
    if (score <= 80) return riskHigh;
    return riskCritical;
  }
}
