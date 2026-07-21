// Models
import 'dart:ui';

class FabricCategory2 {
  final String name;
  //final String emoji;
  final String description;
  final String image;
  final Color color;

  FabricCategory2({
    required this.name,
   // required this.emoji,
    required this.description,
    required this.image,
    required this.color,
  });
}

class FeaturedCollection {
  final String title;
  final String subtitle;
  final String image;
  final List<Color> gradient;

  FeaturedCollection({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.gradient,
  });
}

class TrendingFabric {
  final String name;
  final String type;
  final String price;
  final double rating;
  final int reviews;
  final String image;

  TrendingFabric({
    required this.name,
    required this.type,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.image,
  });
}