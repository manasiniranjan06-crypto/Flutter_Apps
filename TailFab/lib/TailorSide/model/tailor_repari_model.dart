
// Supporting Classes and Enums
class RepairService {
  final String name;
  final double price;
  final String duration;
  final String description;
  final String image;
  final String urgency;
  final RepairCategory category;
  final double popularity;
  final List<String> features;
  final List<String> materials;
  final String skillLevel;
  final List<String> toolsRequired;

  RepairService({
    required this.name,
    required this.price,
    required this.duration,
    required this.description,
    required this.image,
    required this.urgency,
    required this.category,
    required this.popularity,
    required this.features,
    required this.materials,
    required this.skillLevel,
    required this.toolsRequired,
  });

  RepairService copyWith({
    String? name,
    double? price,
    String? duration,
    String? description,
    String? image,
    String? urgency,
    RepairCategory? category,
    double? popularity,
    List<String>? features,
    List<String>? materials,
    String? skillLevel,
    List<String>? toolsRequired,
  }) {
    return RepairService(
      name: name ?? this.name,
      price: price ?? this.price,
      duration: duration ?? this.duration,
      description: description ?? this.description,
      image: image ?? this.image,
      urgency: urgency ?? this.urgency,
      category: category ?? this.category,
      popularity: popularity ?? this.popularity,
      features: features ?? this.features,
      materials: materials ?? this.materials,
      skillLevel: skillLevel ?? this.skillLevel,
      toolsRequired: toolsRequired ?? this.toolsRequired,
    );
  }
}

class RepairOrder {
  final String id;
  final String serviceName;
  final String customerName;
  final double price;
  final RepairStatus status;
  final DateTime deadline;
  final String customerPhone;
  final DateTime orderDate;
  final String customerAddress;
  final String garmentType;
  final String specialInstructions;

  RepairOrder({
    required this.id,
    required this.serviceName,
    required this.customerName,
    required this.price,
    required this.status,
    required this.deadline,
    required this.customerPhone,
    required this.orderDate,
    this.customerAddress = '',
    this.garmentType = '',
    this.specialInstructions = '',
  });

  RepairOrder copyWith({
    String? id,
    String? serviceName,
    String? customerName,
    double? price,
    RepairStatus? status,
    DateTime? deadline,
    String? customerPhone,
    DateTime? orderDate,
    String? customerAddress,
    String? garmentType,
    String? specialInstructions,
  }) {
    return RepairOrder(
      id: id ?? this.id,
      serviceName: serviceName ?? this.serviceName,
      customerName: customerName ?? this.customerName,
      price: price ?? this.price,
      status: status ?? this.status,
      deadline: deadline ?? this.deadline,
      customerPhone: customerPhone ?? this.customerPhone,
      orderDate: orderDate ?? this.orderDate,
      customerAddress: customerAddress ?? this.customerAddress,
      garmentType: garmentType ?? this.garmentType,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }
}

enum RepairStatus {
  pending,
  inProgress,
  completed,
  delivered,
}

enum RepairCategory {
  all,
  zippers,
  fabric,
  accessories,
  structural,
  alterations,
  creative,
}
