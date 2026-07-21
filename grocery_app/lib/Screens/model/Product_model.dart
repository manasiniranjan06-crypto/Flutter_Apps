import 'package:flutter/material.dart';

class ProductModel  extends ChangeNotifier {
  String id;
  String name;
  String category;
  String image; // main image
  double price;
  String unit;
  String? brand;
  final String? description;
  final List<String>? images;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.price,
    required this.unit,
    this.brand,
    this.description,
    this.images,
  });
}

List<ProductModel> allProducts = [
  // ================= FRUITS =================
  ProductModel(
    id: 'p1',
    name: 'Bananas',
    category: 'Fruits',
    image: "assets/banana.png",
    price: 60.0,
    unit: '12 pcs',
    description:
        "Fresh bananas rich in potassium. Ideal for breakfast, snacks, and smoothies.",
    images: [
      "assets/detailpage/banana.png",
    ],
  ),

  ProductModel(
    id: 'p2',
    name: 'Red Apple',
    category: 'Fruits',
    image: "assets/apple.png",
    price: 80.0,
    unit: '1 kg',
    description:
        "Crisp and juicy red apples packed with fiber and antioxidants. Good for heart health and weight management.",
    images: [
      "assets/detailpage/apple.png",
      "assets/detailpage/apple.png",
    ],
  ),

  ProductModel(
    id: 'p8',
    name: 'Watermelon',
    category: 'Fruits',
    image: "assets/watermellon.jpg",
    price: 80.0,
    unit: '1 kg',
    description:
        "Sweet and refreshing watermelon with high water content. Perfect for summer hydration.",
    images: [
      "assets/watermellon.jpg",
    ],
  ),

  // ================= VEGETABLES =================
  ProductModel(
    id: 'p3',
    name: 'Tomato',
    category: 'Vegetables',
    image: "assets/tomato.jpg",
    price: 50.0,
    unit: '1 kg',
    description:
        "Fresh ripe tomatoes ideal for cooking, salads, and sauces. Rich in vitamin C and lycopene.",
    images: [
      "assets/tomato.jpg",
    ],
  ),

  ProductModel(
    id: 'p4',
    name: 'Carrots',
    category: 'Vegetables',
    image: "assets/carrots.jpg",
    price: 40.0,
    unit: '1 kg',
    description:
        "Crunchy fresh carrots loaded with vitamin A. Great for salads, juices, and cooking.",
    images: [
      "assets/carrots.jpg",
    ],
  ),

  ProductModel(
    id: 'p5',
    name: 'Red Bell Pepper',
    category: 'Vegetables',
    image: "assets/redpaper.png",
    price: 60.0,
    unit: '1 kg',
    description:
        "Sweet and colorful red bell peppers perfect for stir-fries, salads, and grilling.",
    images: [
      "assets/redpaper.png",
    ],
  ),

  ProductModel(
    id: 'p6',
    name: 'Ginger',
    category: 'Vegetables',
    image: "assets/ginger.png",
    price: 80.0,
    unit: '250 g',
    description:
        "Fresh aromatic ginger used in cooking, tea, and traditional remedies. Boosts immunity.",
    images: [
      "assets/ginger.png",
    ],
  ),

  // ================= BEVERAGES =================
  ProductModel(
    id: 'p9',
    name: 'Diet Coke',
    category: 'Beverages',
    image: "assets/productpge/cocacola.png",
    price: 40.0,
    unit: '250 ml',
    brand: 'Coca-Cola',
    description:
        "Sugar-free diet coke offering refreshing taste with zero calories.",
    images: [
      "assets/productpge/cocacola.png",
    ],
  ),

  ProductModel(
    id: 'p10',
    name: 'Apple & Grape Juice',
    category: 'Beverages',
    image: "assets/productpge/applejucie.png",
    price: 140.0,
    unit: '500 ml',
    description:
        "Refreshing blend of apple and grape juice with natural fruity flavor.",
    images: [
      "assets/productpge/applejucie.png",
    ],
  ),

  // ================= DAIRY & EGGS =================
  ProductModel(
    id: 'p11',
    name: 'Brown Eggs',
    category: 'Dairy & Eggs',
    image: "assets/productpge/egg1.png",
    price: 140.0,
    unit: '4 pcs',
    description:
        "Farm fresh brown eggs rich in protein. Ideal for breakfast and cooking.",
    images: [
      "assets/productpge/egg1.png",
    ],
  ),

  ProductModel(
    id: 'p12',
    name: 'White Eggs',
    category: 'Dairy & Eggs',
    image: "assets/productpge/egg2.png",
    price: 100.0,
    unit: '6 pcs',
    description:
        "Fresh white eggs perfect for daily protein intake and baking needs.",
    images: [
      "assets/productpge/egg2.png",
    ],
  ),

  ProductModel(
    id: 'p13',
    name: 'Egg Pasta',
    category: 'Dairy & Eggs',
    image: "assets/productpge/egg3.png",
    price: 200.0,
    unit: '500 g',
    description:
        "Delicious egg-based pasta with rich taste and smooth texture.",
    images: [
      "assets/productpge/egg3.png",
    ],
  ),

  ProductModel(
    id: 'p14',
    name: 'Egg Noodles',
    category: 'Dairy & Eggs',
    image: "assets/productpge/egg5.png",
    price: 240.0,
    unit: '1 kg',
    description:
        "Quick-cook egg noodles perfect for Asian-style dishes and stir fries.",
    images: [
      "assets/productpge/egg5.png",
    ],
  ),

  ProductModel(
    id: 'p15',
    name: 'Eggless Mayonnaise',
    category: 'Dairy & Eggs',
    image: "assets/productpge/egg4.png",
    price: 150.0,
    unit: '325 ml',
    description:
        "Creamy eggless mayonnaise perfect for sandwiches, burgers, and salads.",
    images: [
      "assets/productpge/egg4.png",
    ],
  ),

  ProductModel(
    id: 'p16',
    name: 'Egg Noodles Cup',
    category: 'Dairy & Eggs',
    image: "assets/productpge/egg6.png",
    price: 150.0,
    unit: '350 g',
    description:
        "Instant egg noodles cup – quick, tasty, and easy to prepare.",
    images: [
      "assets/productpge/egg6.png",
    ],
  ),
];
