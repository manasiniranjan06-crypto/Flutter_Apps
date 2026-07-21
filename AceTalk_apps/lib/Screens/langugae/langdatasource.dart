// lib/features/language_select/data/datasources/language_local_datasource.dart
import 'package:ai_interview_app/Screens/langugae/lqngugaecard.dart';
import 'package:flutter/material.dart';
//import '../../domain/entities/language_entity.dart';

class LanguageLocalDatasource {
  static const List<LanguageEntity> languages = [
    LanguageEntity(
      id: 'java',
      name: 'Java Interview',
      imagePath: 'assets/images/java.png',
      detail: 'Core Java • OOPs • Collections',
      accentColor: Color(0xFFFF6F00),
      icon: Icons.coffee_rounded,
      tag: 'Popular',
      difficulty: 'Medium',
      totalQuestions: 120,
    ),
    LanguageEntity(
      id: 'flutter',
      name: 'Flutter Interview',
      imagePath: 'assets/images/flutter.png',
      detail: 'Dart • Widgets • State Management',
      accentColor: Color(0xFF00B0FF),
      icon: Icons.flutter_dash,
      tag: 'Popular',
      difficulty: 'Medium',
      totalQuestions: 95,
    ),
    LanguageEntity(
      id: 'cpp',
      name: 'C++ Interview',
      imagePath: 'assets/images/cc.png',
      detail: 'Memory • STL • DSA',
      accentColor: Color(0xFF7B61FF),
      icon: Icons.memory_rounded,
      tag: 'Advanced',
      difficulty: 'Hard',
      totalQuestions: 80,
    ),
    LanguageEntity(
      id: 'python',
      name: 'Python Interview',
      imagePath: 'assets/images/python.png',
      detail: 'Logic • OOP • Real Use Cases',
      accentColor: Color(0xFF00E676),
      icon: Icons.auto_awesome_rounded,
      tag: 'Beginner',
      difficulty: 'Easy',
      totalQuestions: 110,
    ),
  ];

  List<LanguageEntity> getAll() => languages;

  List<LanguageEntity> search(String query) {
    final q = query.toLowerCase();
    return languages
        .where((l) =>
            l.name.toLowerCase().contains(q) ||
            l.detail.toLowerCase().contains(q))
        .toList();
  }

  List<LanguageEntity> filterByTag(String tag) {
    if (tag == 'All') return languages;
    return languages.where((l) => l.tag == tag).toList();
  }
}