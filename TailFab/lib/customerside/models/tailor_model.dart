class TailorProfile {
  final String id;
  final String name;
  final String shopName;
  final String address;
  final String phone;
  final double rating;
  final int totalOrders;
  final String imageUrl;
  final List<String> specialties;
  final bool homeVisitAvailable;

  TailorProfile({
    required this.id,
    required this.name,
    required this.shopName,
    required this.address,
    required this.phone,
    required this.rating,
    required this.totalOrders,
    this.imageUrl = '',
    required this.specialties,
    required this.homeVisitAvailable,
  });

  factory TailorProfile.fromJson(Map<String, dynamic> json) {
    return TailorProfile(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      shopName: json['shopName'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalOrders: json['totalOrders'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      specialties: List<String>.from(json['specialties'] ?? []),
      homeVisitAvailable: json['homeVisitAvailable'] ?? false,
    );
  }
}