// models/alteration_models.dart

class AlterationService {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final String category;
  final String duration;
  final double rating;
  final int reviewCount;
  final List<String> features;
  final bool isPopular;

  AlterationService({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    required this.duration,
    required this.rating,
    required this.reviewCount,
    required this.features,
    required this.isPopular,
  });
}

class AlterationRequest {
  final String id;
  final String serviceId;
  final String customerName;
  final String customerImage;
  final String serviceName;
  final DateTime requestDate;
  final String status; // pending, accepted, in_progress, completed, cancelled
  final String description;
  final List<String> images;
  final String measurements;
  final String specialInstructions;
  final double quotedPrice;
  final DateTime? deadline;

  AlterationRequest({
    required this.id,
    required this.serviceId,
    required this.customerName,
    required this.customerImage,
    required this.serviceName,
    required this.requestDate,
    required this.status,
    required this.description,
    required this.images,
    required this.measurements,
    required this.specialInstructions,
    required this.quotedPrice,
    this.deadline,
  });
}

class AlterationCategory {
  final String id;
  final String name;
  final String icon;
  final int serviceCount;

  AlterationCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.serviceCount,
  });
}

