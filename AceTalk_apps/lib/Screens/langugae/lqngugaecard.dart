
// lib/features/language_select/domain/entities/language_entity.dart
import 'package:flutter/material.dart';

class LanguageEntity {
  final String id;
  final String name;
  final String imagePath;
  final String detail;
  final Color accentColor;
  final IconData icon;
  final String tag;      // Popular | Beginner | Advanced
  final String difficulty; // Easy | Medium | Hard
  final int totalQuestions;

  const LanguageEntity({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.detail,
    required this.accentColor,
    required this.icon,
    required this.tag,
    required this.difficulty,
    required this.totalQuestions,
  });
}