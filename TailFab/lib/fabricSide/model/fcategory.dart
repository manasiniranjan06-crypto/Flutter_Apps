
import 'dart:ui';

class FabricCategory {
  final String name;
  //final String emoji;
  final String description;
  final String image;
  final Color color;
  final List<String> properties;
  final List<String> uses;
  final String care;
  final int popularity;
  final List<String> subCategories;

  FabricCategory({
    required this.name,
   // required this.emoji,
    required this.description,
    required this.image,
    required this.color,
    required this.properties,
    required this.uses,
    required this.care,
    required this.popularity,
    required this.subCategories,
  });
}