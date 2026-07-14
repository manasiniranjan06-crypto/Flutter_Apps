// utils/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors
  static const Color primaryColor = Color(0xFF8075FF);
  static const Color primaryLight = Color(0xFFA89EFF);
  static const Color primaryDark = Color(0xFF6B5EF0);

  // Background Gradients
  static Gradient get backgroundGradient => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF8075FF), Colors.white],
        stops: [0.0, 0.6],
      );

  static Gradient get cardGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF8075FF), Color(0xFFA89EFF)],
      );

  // Glassmorphism Effects
  static BoxDecoration get glassCard => BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      );

  static BoxDecoration get glassNavBar => BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      );

  static BoxDecoration get glassButton => BoxDecoration(
        gradient: cardGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      );

  // Text Styles
  static TextStyle get titleStyle => const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );

  static TextStyle get subtitleStyle => const TextStyle(
        fontSize: 16,
        color: Colors.white,
      );

  static TextStyle get bodyStyle => const TextStyle(
        fontSize: 14,
        color: Colors.black87,
      );

  // App Bar Theme
  static AppBarTheme get appBarTheme => const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );

  // Remove the TabBarTheme getter for now to fix the error
  // We'll handle tab bars individually in each screen
}