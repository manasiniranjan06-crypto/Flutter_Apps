// models/tailorhome_model.dart
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

class ServiceCategory {
  final String name;
  final String icon;
  final String id;

  ServiceCategory({
    required this.name,
    required this.icon,
    required this.id,
  });
}

class TailorService {
  final String id;
  final String name;
  final String image;
  final double rating;
  final int reviews;
  final double price;
  final String category;
  final String description;
  final String duration;

  TailorService({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.category,
    required this.description,
    required this.duration,
  });
}

class RecentCustomer {
  final String id;
  final String name;
  final String image;
  final String service;
  final String status;
  final DateTime date;

  RecentCustomer({
    required this.id,
    required this.name,
    required this.image,
    required this.service,
    required this.status,
    required this.date,
  });
}

class Order {
  final String id;
  final String customerName;
  final String customerImage;
  final String service;
  final double price;
  final String status;
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final String measurements;
  final String specialInstructions;

  Order({
    required this.id,
    required this.customerName,
    required this.customerImage,
    required this.service,
    required this.price,
    required this.status,
    required this.orderDate,
    this.deliveryDate,
    required this.measurements,
    required this.specialInstructions,
  });
}