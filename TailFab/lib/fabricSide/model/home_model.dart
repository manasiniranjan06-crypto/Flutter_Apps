// models/carousel_model.dart
import 'dart:ui';

import 'package:flutter/material.dart';

class CarouselItem {
  final String title;
  final String subtitle;
  final String image;
  final List gradient;

  CarouselItem({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.gradient,
  });
}

// models/category_model.dart
class Category {
  final String name;
  final IconData icon;
  final Color color;
  final String image;

  Category({
    required this.name,
    required this.icon,
    required this.color,
    required this.image,
  });
}

// models/shop_model.dart
class Shop {
  final String name;
  final double rating;
  final String reviews;
  final String image;

  Shop({
    required this.name,
    required this.rating,
    required this.reviews,
    required this.image, required double distance,
  });
}

// models/app_state.dart
class AppState {
  final int currentPage;
  final int selectedNavIndex;
  final String searchQuery;

  AppState({
    required this.currentPage,
    required this.selectedNavIndex,
    required this.searchQuery,
  });

  AppState copyWith({
    int? currentPage,
    int? selectedNavIndex,
    String? searchQuery,
  }) {
    return AppState(
      currentPage: currentPage ?? this.currentPage,
      selectedNavIndex: selectedNavIndex ?? this.selectedNavIndex,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}