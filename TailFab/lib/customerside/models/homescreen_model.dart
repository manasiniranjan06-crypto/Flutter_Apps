
// Models
class CarouselItem {
  final String title;
  final String subtitle;
  final String image;
  final String action;

  CarouselItem({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.action,
  });
}

class Category {
  final String name;
  final String image;
  final String id;

  Category({
    required this.name,
    required this.image,
    required this.id,
  });
}

class Shop {
  final String name;
  final String image;
  final double rating;
  final int reviews;
  final double distance;
  final bool isOpen;
  final String category;
  final String id;
  final String description;

  Shop({
    required this.name,
    required this.image,
    required this.rating,
    required this.reviews,
    required this.distance,
    required this.isOpen,
    required this.category,
    required this.id,
    required this.description,
  });
}