
// Enhanced Supporting Classes and Enums
class DesignService {
  final String name;
  final double startingPrice;
  final String duration;
  final String description;
  final String image;
  final String complexity;
  final DesignCategory category;
  final double popularity;
  final List<String> features;
  final List<String> materials;
  final String skillLevel;
  final List<String> toolsRequired;
  final String designTime;
  final List<String> measurements;
  final int revisions;

  DesignService({
    required this.name,
    required this.startingPrice,
    required this.duration,
    required this.description,
    required this.image,
    required this.complexity,
    required this.category,
    required this.popularity,
    required this.features,
    required this.materials,
    required this.skillLevel,
    required this.toolsRequired,
    required this.designTime,
    required this.measurements,
    required this.revisions,
  });

  DesignService copyWith({
    String? name,
    double? startingPrice,
    String? duration,
    String? description,
    String? image,
    String? complexity,
    DesignCategory? category,
    double? popularity,
    List<String>? features,
    List<String>? materials,
    String? skillLevel,
    List<String>? toolsRequired,
    String? designTime,
    List<String>? measurements,
    int? revisions,
  }) {
    return DesignService(
      name: name ?? this.name,
      startingPrice: startingPrice ?? this.startingPrice,
      duration: duration ?? this.duration,
      description: description ?? this.description,
      image: image ?? this.image,
      complexity: complexity ?? this.complexity,
      category: category ?? this.category,
      popularity: popularity ?? this.popularity,
      features: features ?? this.features,
      materials: materials ?? this.materials,
      skillLevel: skillLevel ?? this.skillLevel,
      toolsRequired: toolsRequired ?? this.toolsRequired,
      designTime: designTime ?? this.designTime,
      measurements: measurements ?? this.measurements,
      revisions: revisions ?? this.revisions,
    );
  }
}

class DesignProject {
  final String id;
  final String serviceName;
  final String clientName;
  final double price;
  final DesignProjectStatus status;
  final DateTime deadline;
  final String clientPhone;
  final DateTime orderDate;
  final String clientEmail;
  final Map<String, String> measurements;
  final String fabricChoice;
  final String designNotes;
  final int progress;

  DesignProject({
    required this.id,
    required this.serviceName,
    required this.clientName,
    required this.price,
    required this.status,
    required this.deadline,
    required this.clientPhone,
    required this.orderDate,
    required this.clientEmail,
    required this.measurements,
    required this.fabricChoice,
    required this.designNotes,
    required this.progress,
  });

  DesignProject copyWith({
    String? id,
    String? serviceName,
    String? clientName,
    double? price,
    DesignProjectStatus? status,
    DateTime? deadline,
    String? clientPhone,
    DateTime? orderDate,
    String? clientEmail,
    Map<String, String>? measurements,
    String? fabricChoice,
    String? designNotes,
    int? progress,
  }) {
    return DesignProject(
      id: id ?? this.id,
      serviceName: serviceName ?? this.serviceName,
      clientName: clientName ?? this.clientName,
      price: price ?? this.price,
      status: status ?? this.status,
      deadline: deadline ?? this.deadline,
      clientPhone: clientPhone ?? this.clientPhone,
      orderDate: orderDate ?? this.orderDate,
      clientEmail: clientEmail ?? this.clientEmail,
      measurements: measurements ?? this.measurements,
      fabricChoice: fabricChoice ?? this.fabricChoice,
      designNotes: designNotes ?? this.designNotes,
      progress: progress ?? this.progress,
    );
  }
}

class DesignPortfolio {
  final String id;
  final String title;
  final String description;
  final List<String> images;
  final DesignCategory category;
  final int likes;
  final DateTime completionDate;

  DesignPortfolio({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    required this.category,
    required this.likes,
    required this.completionDate,
  });
}

enum DesignProjectStatus {
  consultation,
  measurement,
  designing,
  production,
  fitting,
  completed,
  delivered,
}

enum DesignCategory {
  all,
  bridal,
  evening,
  traditional,
  formal,
  casual,
  consultation,
}
