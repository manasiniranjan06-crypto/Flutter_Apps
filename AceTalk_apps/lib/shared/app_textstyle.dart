// lib/shared/theme/app_text_styles.dart
import 'package:ai_interview_app/shared/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class AppTextStyles {
  AppTextStyles._();

  static TextStyle heading1 = GoogleFonts.dmSans(
    color: AppColors.textPrimary,
    fontSize: 26,
    fontWeight: FontWeight.w900,
    letterSpacing: 0.2,
  );

  static TextStyle heading2 = GoogleFonts.dmSans(
    color: AppColors.textPrimary,
    fontSize: 20,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.2,
  );

  static TextStyle heading3 = GoogleFonts.dmSans(
    color: AppColors.textPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w800,
  );

  static TextStyle body = GoogleFonts.dmSans(
    color: AppColors.textPrimary,
    fontSize: 14.5,
  );

  static TextStyle bodySecondary = GoogleFonts.dmSans(
    color: AppColors.textSecondary,
    fontSize: 13,
  );

  static TextStyle label = GoogleFonts.dmSans(
    color: AppColors.textSecondary,
    fontSize: 12.5,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
  );

  static TextStyle monoLarge = GoogleFonts.spaceMono(
    color: AppColors.accentCyan,
    fontSize: 40,
    fontWeight: FontWeight.w900,
  );

  static TextStyle monoSmall = GoogleFonts.spaceMono(
    color: AppColors.textPrimary,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  static TextStyle btnText = GoogleFonts.dmSans(
    color: Colors.white,
    fontSize: 17,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.3,
  );
}