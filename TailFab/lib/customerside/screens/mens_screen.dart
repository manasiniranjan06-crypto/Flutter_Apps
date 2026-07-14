
import 'package:firebaseauth/customerside/components/gradient_scaffold.dart';
import 'package:firebaseauth/customerside/screens/addtocartpage.dart';
import 'package:firebaseauth/customerside/screens/chackoutbottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Main Men's Page with Column Layout
class MensPage extends StatefulWidget {
  final String? initialCategory;
  final String? initialSubcategory;

  const MensPage({
    Key? key,
    this.initialCategory,
    this.initialSubcategory,
  }) : super(key: key);

  @override
  State<MensPage> createState() => _MensPageState();
}

class _MensPageState extends State<MensPage> {
  String selectedCategory = 'All';
  final List<String> categories = ['All', 'Shirts', 'Pants', 'Kurtas', 'Suits', 'Blazers', 'T-Shirts'];
  
  final List<Shop> availableShops = [
    Shop(
      id: '1',
      name: 'Fashion Hub',
      image: 'https://images.unsplash.com/photo-1560493676-04071c5f467b',
      rating: 4.5,
      reviews: 120,
      distance: 2.5,
      isOpen: true,
      category: 'Fashion',
      description: 'Premium fashion destination with latest trends',
    ),
    Shop(
      id: '2',
      name: 'Style Studio',
      image: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8',
      rating: 4.3,
      reviews: 89,
      distance: 1.8,
      isOpen: true,
      category: 'Lifestyle',
      description: 'Contemporary fashion studio',
    ),
    Shop(
      name: 'Trend Setters',
      rating: 4.7,
      reviews: 125,
      image: 'https://images.unsplash.com/photo-1469334031218-e382a71b716b?w=200',
      distance: 1.8,
      isOpen: true,
      category: 'Designer Wear',
      id: '3',
      description: 'A premium boutique known for modern tailoring and seasonal trends.',
    ),
    Shop(
      name: 'Elite Boutique',
      rating: 4.9,
      reviews: 2100,
      image: 'https://images.unsplash.com/photo-1558769132-cb1f96b8d050?w=200',
      distance: 2.3,
      isOpen: true,
      category: 'Trending Hub',
      id: '4',
      description: 'Exclusive collection of handcrafted ethnic and western outfits.',
    ),
  ];

  final List<Map<String, dynamic>> mensFabrics = [
    {
      'name': 'Premium Cotton Shirt',
      'price': 899,
      'image': 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=500',
      'category': 'Shirts',
      'material': 'Cotton',
      'colors': ['White', 'Blue', 'Black'],
      'description': 'High-quality breathable cotton fabric perfect for formal and casual shirts. Soft texture with excellent durability.',
      'inStock': true,
      'rating': 4.5,
      'reviews': 128,
      'fabricOptions': [
        {
          'name': 'Premium Egyptian Cotton',
          'description': 'Luxury long-staple cotton with superior softness',
          'priceMultiplier': 1.2,
          'properties': ['Breathable', 'Soft', 'Durable']
        },
        {
          'name': 'Organic Cotton',
          'description': 'Eco-friendly organic cotton, gentle on skin',
          'priceMultiplier': 1.1,
          'properties': ['Eco-friendly', 'Hypoallergenic', 'Soft']
        },
        {
          'name': 'Standard Cotton',
          'description': 'High-quality regular cotton blend',
          'priceMultiplier': 1.0,
          'properties': ['Comfortable', 'Affordable', 'Breathable']
        }
      ]
    },
    {
      'name': 'Formal Pant Fabric',
      'price': 1299,
      'image': 'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=500',
      'category': 'Pants',
      'material': 'Polyester',
      'colors': ['Black', 'Grey', 'Navy'],
      'description': 'Premium polyester blend for wrinkle-free formal pants. Maintains sharp creases and professional appearance.',
      'inStock': true,
      'rating': 4.3,
      'reviews': 95,
      'fabricOptions': [
        {
          'name': 'Wool Blend',
          'description': 'Premium wool-polyester blend for formal wear',
          'priceMultiplier': 1.3,
          'properties': ['Wrinkle-resistant', 'Professional', 'Warm']
        },
        {
          'name': 'Stretch Polyester',
          'description': 'Comfort stretch with formal appearance',
          'priceMultiplier': 1.1,
          'properties': ['Stretch', 'Comfortable', 'Formal']
        },
        {
          'name': 'Standard Polyester',
          'description': 'Classic polyester for everyday formal wear',
          'priceMultiplier': 1.0,
          'properties': ['Durable', 'Affordable', 'Easy care']
        }
      ]
    },
    {
      'name': 'Silk Kurta Material',
      'price': 1599,
      'image': 'https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?w=500',
      'category': 'Kurtas',
      'material': 'Silk',
      'colors': ['White', 'Cream', 'Gold'],
      'description': 'Luxurious pure silk fabric ideal for traditional kurtas. Elegant drape with natural sheen.',
      'inStock': true,
      'rating': 4.8,
      'reviews': 203,
      'fabricOptions': [
        {
          'name': 'Pure Mulberry Silk',
          'description': 'Finest quality mulberry silk with natural sheen',
          'priceMultiplier': 1.5,
          'properties': ['Luxurious', 'Natural Sheen', 'Breathable']
        },
        {
          'name': 'Silk Cotton Blend',
          'description': 'Perfect blend of silk comfort and cotton practicality',
          'priceMultiplier': 1.2,
          'properties': ['Comfortable', 'Practical', 'Elegant']
        },
        {
          'name': 'Art Silk',
          'description': 'High-quality artificial silk alternative',
          'priceMultiplier': 1.0,
          'properties': ['Affordable', 'Silk-like', 'Easy maintenance']
        }
      ]
    },
    {
      'name': 'Wedding Suit Fabric',
      'price': 2999,
      'image': 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=500',
      'category': 'Suits',
      'material': 'Wool Blend',
      'colors': ['Black', 'Navy', 'Grey'],
      'description': 'Premium wool blend for sophisticated wedding suits. Temperature regulating with superior finish.',
      'inStock': true,
      'rating': 4.9,
      'reviews': 156,
      'fabricOptions': [
        {
          'name': 'Super 120s Wool',
          'description': 'Ultra-fine wool for luxury wedding suits',
          'priceMultiplier': 1.8,
          'properties': ['Luxurious', 'Fine Texture', 'Elegant Drape']
        },
        {
          'name': 'Wool-Silk Blend',
          'description': 'Premium blend with silk for special occasions',
          'priceMultiplier': 1.4,
          'properties': ['Luxurious', 'Natural Sheen', 'Comfortable']
        },
        {
          'name': 'Standard Wool Blend',
          'description': 'Quality wool blend for wedding occasions',
          'priceMultiplier': 1.0,
          'properties': ['Classic', 'Durable', 'Professional']
        }
      ]
    },
    {
      'name': 'Casual Shirt Fabric',
      'price': 699,
      'image': 'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=500',
      'category': 'Shirts',
      'material': 'Linen',
      'colors': ['Blue', 'White', 'Beige'],
      'description': 'Lightweight linen perfect for summer shirts. Natural breathability with relaxed texture.',
      'inStock': true,
      'rating': 4.4,
      'reviews': 87,
      'fabricOptions': [
        {
          'name': 'Pure Linen',
          'description': '100% pure linen for ultimate comfort',
          'priceMultiplier': 1.3,
          'properties': ['Breathable', 'Natural', 'Summer-friendly']
        },
        {
          'name': 'Linen-Cotton Blend',
          'description': 'Perfect balance of comfort and durability',
          'priceMultiplier': 1.1,
          'properties': ['Comfortable', 'Durable', 'Versatile']
        },
        {
          'name': 'Standard Linen',
          'description': 'Quality linen for casual wear',
          'priceMultiplier': 1.0,
          'properties': ['Lightweight', 'Breathable', 'Casual']
        }
      ]
    },
    {
      'name': 'Denim Pant Material',
      'price': 999,
      'image': 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=500',
      'category': 'Pants',
      'material': 'Denim',
      'colors': ['Blue', 'Black', 'Grey'],
      'description': 'Durable stretch denim with comfort fit. Perfect for casual jeans with modern appeal.',
      'inStock': true,
      'rating': 4.6,
      'reviews': 174,
      'fabricOptions': [
        {
          'name': 'Premium Selvedge Denim',
          'description': 'Traditional selvedge denim for denim enthusiasts',
          'priceMultiplier': 1.6,
          'properties': ['Premium', 'Durable', 'Classic']
        },
        {
          'name': 'Stretch Denim',
          'description': 'Modern stretch denim for comfort',
          'priceMultiplier': 1.2,
          'properties': ['Comfortable', 'Flexible', 'Modern']
        },
        {
          'name': 'Standard Denim',
          'description': 'Classic denim for everyday wear',
          'priceMultiplier': 1.0,
          'properties': ['Classic', 'Durable', 'Versatile']
        }
      ]
    },
    {
      'name': 'Designer Blazer Fabric',
      'price': 2499,
      'image': 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=500',
      'category': 'Blazers',
      'material': 'Wool',
      'colors': ['Navy', 'Black', 'Brown'],
      'description': 'Fine wool fabric for tailored blazers. Structured yet comfortable with elegant texture.',
      'inStock': true,
      'rating': 4.7,
      'reviews': 112,
      'fabricOptions': [
        {
          'name': 'Cashmere Blend',
          'description': 'Ultra-luxury cashmere-wool blend',
          'priceMultiplier': 2.0,
          'properties': ['Ultra-soft', 'Luxurious', 'Warm']
        },
        {
          'name': 'Super 150s Wool',
          'description': 'Extra-fine wool for premium blazers',
          'priceMultiplier': 1.5,
          'properties': ['Fine', 'Elegant', 'Professional']
        },
        {
          'name': 'Standard Wool',
          'description': 'Quality wool for designer blazers',
          'priceMultiplier': 1.0,
          'properties': ['Structured', 'Durable', 'Classic']
        }
      ]
    },
    {
      'name': 'Cotton T-Shirt Material',
      'price': 499,
      'image': 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500',
      'category': 'T-Shirts',
      'material': 'Cotton',
      'colors': ['White', 'Black', 'Grey', 'Blue'],
      'description': 'Soft combed cotton for comfortable t-shirts. Excellent color retention and skin-friendly.',
      'inStock': true,
      'rating': 4.5,
      'reviews': 245,
      'fabricOptions': [
        {
          'name': 'Supima Cotton',
          'description': 'Extra-long staple cotton for premium feel',
          'priceMultiplier': 1.4,
          'properties': ['Soft', 'Durable', 'Premium']
        },
        {
          'name': 'Organic Combed Cotton',
          'description': 'Eco-friendly combed cotton for softness',
          'priceMultiplier': 1.2,
          'properties': ['Eco-friendly', 'Soft', 'Breathable']
        },
        {
          'name': 'Standard Cotton',
          'description': 'Quality cotton for everyday t-shirts',
          'priceMultiplier': 1.0,
          'properties': ['Comfortable', 'Affordable', 'Versatile']
        }
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialSubcategory != null) {
      selectedCategory = _mapSubcategoryToCategory(widget.initialSubcategory!);
    } else if (widget.initialCategory != null) {
      selectedCategory = 'All';
    }
  }

  String _mapSubcategoryToCategory(String subcategory) {
    final Map<String, String> subcategoryMap = {
      'Shirts': 'Shirts',
      'Pants': 'Pants', 
      'Kurtas': 'Kurtas',
      'Suits': 'Suits',
      'Blazers': 'Blazers',
      'T-Shirts': 'T-Shirts',
      'Business Suits': 'Suits',
      'Formal Shirts': 'Shirts',
      'Trousers': 'Pants',
      'Casual Shirts': 'Shirts',
      'Jeans': 'Pants',
      'Shorts': 'Pants',
    };
    return subcategoryMap[subcategory] ?? 'All';
  }

  List<Map<String, dynamic>> get filteredFabrics {
    if (selectedCategory == 'All') return mensFabrics;
    return mensFabrics.where((f) => f['category'] == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        title: Text(
          widget.initialSubcategory ?? widget.initialCategory ?? "Men's Collection",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      child: Column(
        children: [
          // Category Tabs
          SizedBox(
            height: 60,
            child: _buildCategoryTabs(),
          ),
          const SizedBox(height: 8),
          // Products in Column Layout
          Expanded(
            child: _buildProductColumn(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        bool isSelected = selectedCategory == categories[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          child: GestureDetector(
            onTap: () => setState(() => selectedCategory = categories[index]),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF667EEA) : Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  categories[index],
                  style: GoogleFonts.poppins(
                    color: isSelected ? Colors.white : Colors.black54,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductColumn() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredFabrics.length,
      itemBuilder: (context, index) {
        return _buildProductCard(filteredFabrics[index]);
      },
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(
              product: product,
              availableShops: availableShops,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
              child: Image.network(
                product['image'],
                height: 140,
                width: 140,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) => Container(
                  height: 140,
                  width: 140,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image, size: 40, color: Colors.grey),
                ),
              ),
            ),
            // Product Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product['name'],
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.pink[50],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.favorite_border,
                            size: 18,
                            color: Colors.pink[400],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.texture, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          product['material'],
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          '${product['rating']} (${product['reviews']})',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₹${product['price']}',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF667EEA),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.shopping_bag_outlined, size: 16, color: Colors.white),
                              const SizedBox(width: 4),
                              Text(
                                'View',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Shop Model
class Shop {
  final String id;
  final String name;
  final String image;
  final double rating;
  final int reviews;
  final double distance;
  final bool isOpen;
  final String category;
  final String description;

  Shop({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.reviews,
    required this.distance,
    required this.isOpen,
    required this.category,
    required this.description,
  });
}

// Product Detail Page
class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> product;
  final List<Shop> availableShops;

  const ProductDetailPage({
    Key? key, 
    required this.product,
    required this.availableShops,
  }) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String? selectedColor;
  int quantity = 1;
  bool isFavorite = false;
  Map<String, dynamic>? selectedFabric;
  Shop? selectedShop;
  
  double get currentPrice {
    double basePrice = widget.product['price'].toDouble();
    if (selectedFabric != null) {
      return basePrice * selectedFabric!['priceMultiplier'];
    }
    return basePrice;
  }

  double get totalPrice => currentPrice * quantity;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.product['colors'][0];
    // Set default fabric option
    if (widget.product['fabricOptions'] != null && widget.product['fabricOptions'].isNotEmpty) {
      selectedFabric = widget.product['fabricOptions'][0];
    }
    // Set default shop
    if (widget.availableShops.isNotEmpty) {
      selectedShop = widget.availableShops[0];
    }
  }

  void _navigateToFabricSelection() {
    if (selectedShop != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FabricSelectionScreen(
            product: widget.product,
            shop: selectedShop!,
            selectedFabric: selectedFabric,
            onFabricSelected: (fabric) {
              setState(() {
                selectedFabric = fabric;
              });
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select a shop first',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  // In ProductDetailPage's _addToCart method:
  void _addToCart() {
    final cartItem = {
      'id': '${widget.product['name']}_${selectedFabric?['name'] ?? 'standard'}_${DateTime.now().millisecondsSinceEpoch}',
      'itemName': widget.product['name'],
      'tailorName': selectedShop?.name ?? 'Unknown Shop',
      'tailorImage': selectedShop?.image ?? '',
      'itemImage': widget.product['image'],
      'price': currentPrice.toDouble(),
      'quantity': quantity,
      'size': 'Custom',
      'color': selectedColor ?? widget.product['colors'][0],
      'customization': selectedFabric?['name'] ?? 'Standard Fabric',
      'fabricDetails': selectedFabric,
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(initialItems: [cartItem]),
      ),
    );
  }

  void _buyNow() {
    // Show checkout bottom sheet first
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CheckoutBottomSheet(
        product: widget.product,
        selectedFabric: selectedFabric,
        selectedShop: selectedShop,
        selectedColor: selectedColor,
        quantity: quantity,
        totalPrice: totalPrice,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        title: Text(
          'Product Details',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  Stack(
                    children: [
                      Container(
                        height: 350,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                          child: Image.network(
                            widget.product['image'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stack) => Container(
                              color: Colors.grey[200],
                              child: const Icon(Icons.image, size: 80, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: GestureDetector(
                          onTap: () => setState(() => isFavorite = !isFavorite),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.black54,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Name & Rating
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.product['name'],
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.amber[50],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.star, size: 16, color: Colors.amber),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${widget.product['rating']}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    ' (${widget.product['reviews']} reviews)',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.check_circle, size: 16, color: Colors.green[700]),
                                  const SizedBox(width: 4),
                                  Text(
                                    'In Stock',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Price
                        Text(
                          '₹${currentPrice.toStringAsFixed(0)}',
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF667EEA),
                          ),
                        ),
                        if (selectedFabric != null && selectedFabric!['priceMultiplier'] != 1.0)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'Base price: ₹${widget.product['price']}',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[600],
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ),
                        const SizedBox(height: 20),
                        
                        // Shop Selection
                        Text(
                          'Available at',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.availableShops.length,
                            itemBuilder: (context, index) {
                              final shop = widget.availableShops[index];
                              bool isSelected = selectedShop?.id == shop.id;
                              return GestureDetector(
                                onTap: () => setState(() => selectedShop = shop),
                                child: Container(
                                  width: 200,
                                  margin: EdgeInsets.only(right: 12),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isSelected ? const Color(0xFF667EEA).withOpacity(0.1) : Colors.grey[50],
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelected ? const Color(0xFF667EEA) : Colors.grey[300]!,
                                      width: 2,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundImage: NetworkImage(shop.image),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              shop.name,
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(Icons.star, size: 14, color: Colors.amber),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${shop.rating}',
                                            style: GoogleFonts.poppins(fontSize: 12),
                                          ),
                                          Text(
                                            ' (${shop.reviews})',
                                            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(Icons.location_on, size: 14, color: Colors.grey),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${shop.distance} km',
                                            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Fabric Selection Button
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _navigateToFabricSelection,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF667EEA),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.texture, color: Colors.white, size: 24),
                                const SizedBox(width: 8),
                                Text(
                                  'Select Fabric',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Selected Fabric Display
                        if (selectedFabric != null)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF667EEA).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF667EEA).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.texture,
                                    color: const Color(0xFF667EEA),
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Selected Fabric: ${selectedFabric!['name']}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        selectedFabric!['description'],
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 20),

                        // Description
                        Text(
                          'Description',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.product['description'],
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Material
                        Row(
                          children: [
                            Icon(Icons.texture, size: 20, color: Colors.grey[600]),
                            const SizedBox(width: 8),
                            Text(
                              'Material: ',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              widget.product['material'],
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Color Selection
                        Text(
                          'Select Color',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          children: (widget.product['colors'] as List<String>).map((color) {
                            bool isSelected = selectedColor == color;
                            return GestureDetector(
                              onTap: () => setState(() => selectedColor = color),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFF667EEA) : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected ? const Color(0xFF667EEA) : Colors.grey[300]!,
                                    width: 2,
                                  ),
                                ),
                                child: Text(
                                  color,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? Colors.white : Colors.black54,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                        // Quantity Selector
                        Text(
                          'Quantity',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      if (quantity > 1) setState(() => quantity--);
                                    },
                                    icon: const Icon(Icons.remove),
                                    color: const Color(0xFF667EEA),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Text(
                                      '$quantity',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => setState(() => quantity++),
                                    icon: const Icon(Icons.add),
                                    color: const Color(0xFF667EEA),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              'Total: ₹${totalPrice.toStringAsFixed(0)}',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF667EEA),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _addToCart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF667EEA),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.shopping_cart, color: Colors.white, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          'Add to Cart',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ElevatedButton(
                    onPressed: _buyNow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Buy Now',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// // Fabric Selection Screen
// class FabricSelectionScreen extends StatefulWidget {
//   final Map<String, dynamic> product;
//   final Shop shop;
//   final Map<String, dynamic>? selectedFabric;
//   final Function(Map<String, dynamic>) onFabricSelected;

//   const FabricSelectionScreen({
//     Key? key,
//     required this.product,
//     required this.shop,
//     this.selectedFabric,
//     required this.onFabricSelected,
//   }) : super(key: key);

//   @override
//   State<FabricSelectionScreen> createState() => _FabricSelectionScreenState();
// }

// class _FabricSelectionScreenState extends State<FabricSelectionScreen> {
//   Map<String, dynamic>? selectedFabric;

//   @override
//   void initState() {
//     super.initState();
//     selectedFabric = widget.selectedFabric;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GradientScaffold(
//       appBar: AppBar(
//         title: Text(
//           'Select Fabric',
//           style: GoogleFonts.poppins(
//             color: Colors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       child: Column(
//         children: [
//           // Shop Info
//           Container(
//             margin: const EdgeInsets.all(16),
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 10,
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 CircleAvatar(
//                   radius: 30,
//                   backgroundImage: NetworkImage(widget.shop.image),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         widget.shop.name,
//                         style: GoogleFonts.poppins(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Row(
//                         children: [
//                           Icon(Icons.star, size: 16, color: Colors.amber),
//                           const SizedBox(width: 4),
//                           Text(
//                             '${widget.shop.rating} (${widget.shop.reviews} reviews)',
//                             style: GoogleFonts.poppins(fontSize: 12),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 4),
//                       Row(
//                         children: [
//                           Icon(Icons.location_on, size: 16, color: Colors.grey),
//                           const SizedBox(width: 4),
//                           Text(
//                             '${widget.shop.distance} km away',
//                             style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Product Info
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 16),
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 10,
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: Image.network(
//                     widget.product['image'],
//                     width: 60,
//                     height: 60,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         widget.product['name'],
//                         style: GoogleFonts.poppins(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       Text(
//                         'Base Price: ₹${widget.product['price']}',
//                         style: GoogleFonts.poppins(
//                           fontSize: 14,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 20),
//           // Fabric Options
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Text(
//               'Available Fabric Options',
//               style: GoogleFonts.poppins(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               itemCount: widget.product['fabricOptions'].length,
//               itemBuilder: (context, index) {
//                 final fabric = widget.product['fabricOptions'][index];
//                 bool isSelected = selectedFabric?['name'] == fabric['name'];
//                 double finalPrice = widget.product['price'] * fabric['priceMultiplier'];
                
//                 return GestureDetector(
//                   onTap: () => setState(() => selectedFabric = fabric),
//                   child: Container(
//                     margin: const EdgeInsets.only(bottom: 16),
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: isSelected ? const Color(0xFF667EEA).withOpacity(0.1) : Colors.white,
//                       borderRadius: BorderRadius.circular(16),
//                       border: Border.all(
//                         color: isSelected ? const Color(0xFF667EEA) : Colors.grey[300]!,
//                         width: 2,
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.05),
//                           blurRadius: 8,
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               fabric['name'],
//                               style: GoogleFonts.poppins(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                             Container(
//                               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFF667EEA),
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Text(
//                                 '₹${finalPrice.toStringAsFixed(0)}',
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           fabric['description'],
//                           style: GoogleFonts.poppins(
//                             fontSize: 14,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         Wrap(
//                           spacing: 8,
//                           runSpacing: 4,
//                           children: (fabric['properties'] as List<String>).map((property) {
//                             return Container(
//                               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFF667EEA).withOpacity(0.1),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Text(
//                                 property,
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 10,
//                                   color: const Color(0xFF667EEA),
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                         const SizedBox(height: 8),
//                         if (fabric['priceMultiplier'] != 1.0)
//                           Text(
//                             '${((fabric['priceMultiplier'] - 1) * 100).toInt()}% premium over base fabric',
//                             style: GoogleFonts.poppins(
//                               fontSize: 12,
//                               color: Colors.orange,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           // Confirm Button
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 10,
//                   offset: const Offset(0, -5),
//                 ),
//               ],
//             ),
//             child: SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: selectedFabric != null
//                     ? () {
//                         widget.onFabricSelected(selectedFabric!);
//                         Navigator.pop(context);
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text(
//                               'Fabric selected: ${selectedFabric!['name']}',
//                               style: GoogleFonts.poppins(),
//                             ),
//                             backgroundColor: Colors.green,
//                           ),
//                         );
//                       }
//                     : null,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF667EEA),
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                 ),
//                 child: Text(
//                   'Confirm Fabric Selection',
//                   style: GoogleFonts.poppins(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }






















// Fabric Selection Screen with Enhanced Design
class FabricSelectionScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  final Shop shop;
  final Map<String, dynamic>? selectedFabric;
  final Function(Map<String, dynamic>) onFabricSelected;

  const FabricSelectionScreen({
    Key? key,
    required this.product,
    required this.shop,
    this.selectedFabric,
    required this.onFabricSelected,
  }) : super(key: key);

  @override
  State<FabricSelectionScreen> createState() => _FabricSelectionScreenState();
}

class _FabricSelectionScreenState extends State<FabricSelectionScreen> {
  Map<String, dynamic>? selectedFabric;
  int _currentFeatureIndex = 0;

  // Enhanced fabric data with more options
  final List<Map<String, dynamic>> _allFabrics = [
    {
      'name': 'Cotton',
      'description': 'Soft, breathable & versatile for everyday wear',
      'properties': ['Breathable', 'Soft', 'Absorbent', 'Durable'],
      'priceMultiplier': 1.0,
      'color': Color(0xFF4CAF50),
      'icon': Icons.air,
      'bestFor': ['T-shirts', 'Dresses', 'Bedding', 'Towels'],
      'care': 'Machine wash warm',
      'season': ['Spring', 'Summer', 'Fall'],
      'texture': 'assets/fabrics/cotton_texture.jpg',
    },
    {
      'name': 'Linen',
      'description': 'Lightweight & crisp perfect for warm weather',
      'properties': ['Breathable', 'Crisp', 'Strong', 'Natural'],
      'priceMultiplier': 1.3,
      'color': Color(0xFF8BC34A),
      'icon': Icons.wb_sunny,
      'bestFor': ['Summer Shirts', 'Pants', 'Dresses'],
      'care': 'Machine wash cold',
      'season': ['Summer'],
      'texture': 'assets/fabrics/linen_texture.jpg',
    },
    {
      'name': 'Silk',
      'description': 'Luxurious & smooth with natural shimmer',
      'properties': ['Smooth', 'Lustrous', 'Strong', 'Elegant'],
      'priceMultiplier': 2.5,
      'color': Color(0xFFE91E63),
      'icon': Icons.star,
      'bestFor': ['Evening Wear', 'Scarves', 'Lingerie'],
      'care': 'Dry clean only',
      'season': ['All Seasons'],
      'texture': 'assets/fabrics/silk_texture.jpg',
    },
    {
      'name': 'Wool',
      'description': 'Warm & resilient ideal for cold weather',
      'properties': ['Warm', 'Resilient', 'Wrinkle-resistant', 'Natural'],
      'priceMultiplier': 1.8,
      'color': Color(0xFFFF9800),
      'icon': Icons.ac_unit,
      'bestFor': ['Sweaters', 'Coats', 'Winter Wear'],
      'care': 'Dry clean recommended',
      'season': ['Winter', 'Fall'],
      'texture': 'assets/fabrics/wool_texture.jpg',
    },
    {
      'name': 'Polyester',
      'description': 'Durable & quick-drying synthetic fabric',
      'properties': ['Durable', 'Quick-dry', 'Wrinkle-resistant', 'Strong'],
      'priceMultiplier': 0.8,
      'color': Color(0xFF2196F3),
      'icon': Icons.flash_on,
      'bestFor': ['Sportswear', 'Outerwear', 'Uniforms'],
      'care': 'Machine wash cool',
      'season': ['All Seasons'],
      'texture': 'assets/fabrics/polyester_texture.jpg',
    },
    {
      'name': 'Denim',
      'description': 'Rugged cotton twill for casual wear',
      'properties': ['Durable', 'Sturdy', 'Classic', 'Versatile'],
      'priceMultiplier': 1.2,
      'color': Color(0xFF3F51B5),
      'icon': Icons.style,
      'bestFor': ['Jeans', 'Jackets', 'Shirts'],
      'care': 'Machine wash cold',
      'season': ['All Seasons'],
      'texture': 'assets/fabrics/denim_texture.jpg',
    },
    {
      'name': 'Velvet',
      'description': 'Plush & luxurious with soft pile surface',
      'properties': ['Luxurious', 'Soft', 'Elegant', 'Warm'],
      'priceMultiplier': 2.2,
      'color': Color(0xFF9C27B0),
      'icon': Icons.king_bed,
      'bestFor': ['Evening Gowns', 'Blazers', 'Decor'],
      'care': 'Dry clean only',
      'season': ['Winter', 'Fall'],
      'texture': 'assets/fabrics/velvet_texture.jpg',
    },
    {
      'name': 'Chiffon',
      'description': 'Sheer & lightweight with elegant drape',
      'properties': ['Sheer', 'Lightweight', 'Flowy', 'Elegant'],
      'priceMultiplier': 1.7,
      'color': Color(0xFF00BCD4),
      'icon': Icons.waves,
      'bestFor': ['Evening Dresses', 'Scarves', 'Blouses'],
      'care': 'Hand wash cold',
      'season': ['Spring', 'Summer'],
      'texture': 'assets/fabrics/chiffon_texture.jpg',
    },
  ];

  final List<Map<String, dynamic>> _fabricFeatures = [
    {
      'icon': Icons.thermostat,
      'title': 'Season Guide',
      'description': 'Find the perfect fabric for any weather'
    },
    {
      'icon': Icons.cleaning_services,
      'title': 'Easy Care',
      'description': 'Low maintenance fabrics for busy lifestyles'
    },
    {
      'icon': Icons.attach_money,
      'title': 'Budget Friendly',
      'description': 'Great quality at affordable prices'
    },
  ];

  @override
  void initState() {
    super.initState();
    selectedFabric = widget.selectedFabric;
    // Start feature carousel
    _startFeatureCarousel();
  }

  void _startFeatureCarousel() {
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _currentFeatureIndex = (_currentFeatureIndex + 1) % _fabricFeatures.length;
        });
        _startFeatureCarousel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        title: Text(
          'Choose Your Fabric',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: _showFabricGuide,
          ),
        ],
      ),
      child: Column(
        children: [
          // Feature Carousel
          _buildFeatureCarousel(),
          
          // Shop & Product Info Card
          _buildShopProductCard(),
          
          // Fabric Selection Header
          _buildSelectionHeader(),
          
          // Fabric Grid
          Expanded(
            child: _buildFabricGrid(),
          ),
          
          // Confirm Button
          _buildConfirmButton(),
        ],
      ),
    );
  }

  Widget _buildFeatureCarousel() {
    final feature = _fabricFeatures[_currentFeatureIndex];
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(feature['icon'], size: 40, color: Colors.white),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature['title'],
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  feature['description'],
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Carousel Indicators
          Column(
            children: List.generate(_fabricFeatures.length, (index) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 2),
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentFeatureIndex == index 
                      ? Colors.white 
                      : Colors.white.withOpacity(0.5),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildShopProductCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          // Shop Info
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(widget.shop.image),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.shop.name,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, size: 14, color: Colors.amber),
                        SizedBox(width: 4),
                        Text(
                          '${widget.shop.rating} (${widget.shop.reviews})',
                          style: GoogleFonts.poppins(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          // Product Info
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.product['image'],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product['name'],
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Base Price: ₹${widget.product['price']}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Available Fabrics',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${_allFabrics.length} options',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFabricGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: _allFabrics.length,
      itemBuilder: (context, index) {
        final fabric = _allFabrics[index];
        bool isSelected = selectedFabric?['name'] == fabric['name'];
        double finalPrice = widget.product['price'] * fabric['priceMultiplier'];
        
        return _buildFabricCard(fabric, isSelected, finalPrice);
      },
    );
  }

  Widget _buildFabricCard(Map<String, dynamic> fabric, bool isSelected, double finalPrice) {
    return GestureDetector(
      onTap: () => setState(() => selectedFabric = fabric),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isSelected ? fabric['color'].withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? fabric['color'] : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isSelected ? 0.15 : 0.05),
              blurRadius: isSelected ? 12 : 8,
              offset: Offset(0, isSelected ? 4 : 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: fabric['color'],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '₹${finalPrice.toStringAsFixed(0)}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fabric Icon and Name
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: fabric['color'].withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          fabric['icon'],
                          size: 16,
                          color: fabric['color'],
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          fabric['name'],
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  
                  // Description
                  Text(
                    fabric['description'],
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  
                  // Properties
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: (fabric['properties'] as List<String>).take(2).map((property) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: fabric['color'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          property,
                          style: GoogleFonts.poppins(
                            fontSize: 8,
                            color: fabric['color'],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  
                  Spacer(),
                  
                  // Price Multiplier Indicator
                  if (fabric['priceMultiplier'] != 1.0)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: fabric['priceMultiplier'] > 1.0 
                            ? Colors.orange.withOpacity(0.1)
                            : Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        fabric['priceMultiplier'] > 1.0
                            ? '+${((fabric['priceMultiplier'] - 1) * 100).toInt()}%'
                            : '-${((1 - fabric['priceMultiplier']) * 100).toInt()}%',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: fabric['priceMultiplier'] > 1.0 ? Colors.orange : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
            
            // Selected Checkmark
            if (isSelected)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: fabric['color'],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check, size: 12, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          if (selectedFabric != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Selected:',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  selectedFabric!['name'],
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: selectedFabric!['color'],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
          ],
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: selectedFabric != null ? _confirmSelection : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedFabric?['color'] ?? Color(0xFF667EEA),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Confirm Fabric Selection',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmSelection() {
    widget.onFabricSelected(selectedFabric!);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text(
              '${selectedFabric!['name']} fabric selected!',
              style: GoogleFonts.poppins(),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showFabricGuide() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Fabric Guide',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: _allFabrics.length,
                itemBuilder: (context, index) {
                  final fabric = _allFabrics[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: fabric['color'].withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: fabric['color'].withOpacity(0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(fabric['icon'], color: fabric['color']),
                            SizedBox(width: 8),
                            Text(
                              fabric['name'],
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: fabric['color'],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          fabric['description'],
                          style: GoogleFonts.poppins(fontSize: 12),
                        ),
                        SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          children: (fabric['properties'] as List<String>).map((prop) {
                            return Chip(
                              label: Text(prop),
                              backgroundColor: fabric['color'].withOpacity(0.1),
                              labelStyle: GoogleFonts.poppins(fontSize: 10),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}