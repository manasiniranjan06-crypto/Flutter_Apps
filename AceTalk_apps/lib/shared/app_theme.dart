// lib/shared/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color bgDark       = Color(0xFF040C18);
  static const Color surface1     = Color(0xFF0B1A2E);
  static const Color surface2     = Color(0xFF0F2340);
  static const Color accentCyan   = Color(0xFF00E5FF);
  static const Color accentBlue   = Color(0xFF2979FF);
  static const Color accentGold   = Color(0xFFFFD740);
  static const Color accentGreen  = Color(0xFF00E676);
  static const Color accentRed    = Color(0xFFFF3D57);
  static const Color textPrimary  = Color(0xFFE8F4FD);
  static const Color textSecondary= Color(0xFF6B9AB8);
  static const Color javaColor    = Color(0xFFFF6F00);
  static const Color flutterColor = Color(0xFF00B0FF);
  static const Color cppColor     = Color(0xFF7B61FF);
  static const Color pythonColor  = Color(0xFF00E676);

  static const LinearGradient mainGradient = LinearGradient(
    colors: [Color(0xFF1565C0), Color(0xFF2979FF), Color(0xFF00B0FF)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}