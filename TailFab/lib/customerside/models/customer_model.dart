class CustomerProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String profileImageUrl;
  final int totalOrders;
  final int activeOrders;
  final List<Measurement> measurements;

  CustomerProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.profileImageUrl = '',
    required this.totalOrders,
    required this.activeOrders,
    required this.measurements,
  });

  factory CustomerProfile.fromJson(Map<String, dynamic> json) {
    return CustomerProfile(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      totalOrders: json['totalOrders'] ?? 0,
      activeOrders: json['activeOrders'] ?? 0,
      measurements: (json['measurements'] as List<dynamic>?)
              ?.map((m) => Measurement.fromJson(m))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'profileImageUrl': profileImageUrl,
      'totalOrders': totalOrders,
      'activeOrders': activeOrders,
      'measurements': measurements.map((m) => m.toJson()).toList(),
    };
  }

  String get initial => name.isNotEmpty ? name[0].toUpperCase() : 'U';

  CustomerProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? profileImageUrl,
    int? totalOrders,
    int? activeOrders,
    List<Measurement>? measurements,
  }) {
    return CustomerProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      totalOrders: totalOrders ?? this.totalOrders,
      activeOrders: activeOrders ?? this.activeOrders,
      measurements: measurements ?? this.measurements,
    );
  }
}

class Measurement {
  final String id;
  final String type;
  final Map<String, String> dimensions;
  final DateTime createdAt;

  Measurement({
    required this.id,
    required this.type,
    required this.dimensions,
    required this.createdAt,
  });

  factory Measurement.fromJson(Map<String, dynamic> json) {
    return Measurement(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      dimensions: Map<String, String>.from(json['dimensions'] ?? {}),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'dimensions': dimensions,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  String get formattedMeasurements {
    return dimensions.entries.map((e) => '${e.key}: ${e.value}').join(', ');
  }
}