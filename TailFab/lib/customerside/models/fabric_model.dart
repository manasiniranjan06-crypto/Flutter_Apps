class FabricItem {
  final String id;
  final String name;
  final String category;
  final double price;
  final String imageUrl;
  final String material;
  final List<String> colors;

  FabricItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.material,
    required this.colors,
  });

  factory FabricItem.fromJson(Map<String, dynamic> json) {
    return FabricItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] ?? '',
      material: json['material'] ?? '',
      colors: List<String>.from(json['colors'] ?? []),
    );
  }
}