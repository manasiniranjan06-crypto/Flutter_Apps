import 'package:firebaseauth/customerside/components/gradient_scaffold.dart';
import 'package:firebaseauth/customerside/models/homescreen_model.dart';
import 'package:firebaseauth/customerside/screens/addtocartpage.dart';
import 'package:firebaseauth/customerside/screens/chackoutbottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Main Kids Page with Blue Theme (Same as Men's Page)
class KidsPage extends StatefulWidget {
  final String? initialCategory;
  final String? initialSubcategory;

  const KidsPage({
    Key? key,
    this.initialCategory,
    this.initialSubcategory,
  }) : super(key: key);

  @override
  State<KidsPage> createState() => _KidsPageState();
}

class _KidsPageState extends State<KidsPage> {
  String selectedCategory = 'All';
  final List<String> categories = ['All', 'Boys', 'Girls', 'Ethnic', 'Party Wear', 'Casual', 'Infants'];
  
  final List<Shop> availableShops = [
    Shop(
      id: '1',
      name: 'Kids Fashion Hub',
      image: 'https://images.unsplash.com/photo-1560493676-04071c5f467b',
      rating: 4.6,
      reviews: 180,
      distance: 1.5,
      isOpen: true,
      category: 'Kids Fashion',
      description: 'Premium kids fashion destination with latest trends',
    ),
    Shop(
      id: '2',
      name: 'Little Stars Boutique',
      image: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8',
      rating: 4.8,
      reviews: 234,
      distance: 2.2,
      isOpen: true,
      category: 'Kids Wear',
      description: 'Contemporary kids fashion studio',
    ),
    Shop(
      name: 'Tiny Trendsetters',
      rating: 4.9,
      reviews: 156,
      image: 'https://images.unsplash.com/photo-1469334031218-e382a71b716b?w=200',
      distance: 1.8,
      isOpen: true,
      category: 'Designer Kids Wear',
      id: '3',
      description: 'A premium boutique known for modern kids clothing and seasonal trends.',
    ),
    Shop(
      name: 'Kids Paradise',
      rating: 4.7,
      reviews: 189,
      image: 'https://images.unsplash.com/photo-1558769132-cb1f96b8d050?w=200',
      distance: 2.5,
      isOpen: true,
      category: 'Kids Collection',
      id: '4',
      description: 'Exclusive collection of handcrafted ethnic and western kids outfits.',
    ),
  ];

  final List<Map<String, dynamic>> kidsFabrics = [
    {
      'name': 'Boys Casual Shirt Fabric',
      'price': 599,
      'image': 'https://images.unsplash.com/photo-1519457431-44ccd64a579b?w=500',
      'category': 'Boys',
      'material': 'Cotton',
      'colors': ['Blue', 'Green', 'Red', 'Yellow', 'Navy'],
      'description': 'Soft breathable cotton perfect for boys casual shirts. Skin-friendly fabric with excellent comfort for daily wear and play.',
      'inStock': true,
      'rating': 4.5,
      'reviews': 128,
      'fabricOptions': [
        {
          'name': 'Organic Cotton',
          'description': 'Eco-friendly organic cotton, gentle on sensitive skin',
          'priceMultiplier': 1.3,
          'properties': ['Eco-friendly', 'Soft', 'Hypoallergenic']
        },
        {
          'name': 'Stretch Cotton',
          'description': 'Cotton with stretch for active movement',
          'priceMultiplier': 1.2,
          'properties': ['Stretch', 'Comfortable', 'Flexible']
        },
        {
          'name': 'Standard Cotton',
          'description': 'High-quality regular cotton blend',
          'priceMultiplier': 1.0,
          'properties': ['Comfortable', 'Breathable', 'Affordable']
        }
      ]
    },
    {
      'name': 'Girls Party Dress Material',
      'price': 1299,
      'image': 'https://images.unsplash.com/photo-1519238263530-99c0a46067d3?w=500',
      'category': 'Girls',
      'material': 'Satin',
      'colors': ['Pink', 'Purple', 'White', 'Red', 'Gold'],
      'description': 'Luxurious satin fabric for girls party dresses. Smooth texture with elegant sheen, perfect for special occasions and celebrations.',
      'inStock': true,
      'rating': 4.7,
      'reviews': 156,
      'fabricOptions': [
        {
          'name': 'Premium Satin',
          'description': 'High-quality satin with extra sheen',
          'priceMultiplier': 1.4,
          'properties': ['Luxurious', 'Smooth', 'Elegant']
        },
        {
          'name': 'Stretch Satin',
          'description': 'Satin with stretch for comfort',
          'priceMultiplier': 1.2,
          'properties': ['Comfortable', 'Flexible', 'Elegant']
        },
        {
          'name': 'Standard Satin',
          'description': 'Quality satin for party wear',
          'priceMultiplier': 1.0,
          'properties': ['Smooth', 'Elegant', 'Versatile']
        }
      ]
    },
    {
      'name': 'Kids Ethnic Kurta Fabric',
      'price': 899,
      'image': 'https://images.unsplash.com/photo-1604917019118-2042de641afe?w=500',
      'category': 'Ethnic',
      'material': 'Silk Cotton',
      'colors': ['Red', 'Gold', 'Green', 'Blue', 'Orange'],
      'description': 'Premium silk cotton blend perfect for traditional kids kurtas. Comfortable for festivals with elegant drape and easy maintenance.',
      'inStock': true,
      'rating': 4.6,
      'reviews': 142,
      'fabricOptions': [
        {
          'name': 'Chanderi Silk Cotton',
          'description': 'Lightweight Chanderi fabric with silk blend',
          'priceMultiplier': 1.4,
          'properties': ['Lightweight', 'Elegant', 'Comfortable']
        },
        {
          'name': 'Printed Silk Cotton',
          'description': 'Silk cotton with festive prints',
          'priceMultiplier': 1.2,
          'properties': ['Festive', 'Comfortable', 'Traditional']
        },
        {
          'name': 'Standard Silk Cotton',
          'description': 'Quality silk cotton for ethnic wear',
          'priceMultiplier': 1.0,
          'properties': ['Comfortable', 'Traditional', 'Versatile']
        }
      ]
    },
    {
      'name': 'Party Wear Suit Material',
      'price': 1599,
      'image': 'https://images.unsplash.com/photo-1519457431-44ccd64a579b?w=500',
      'category': 'Party Wear',
      'material': 'Velvet',
      'colors': ['Black', 'Navy', 'Maroon', 'Royal Blue', 'Burgundy'],
      'description': 'Plush velvet fabric for kids party suits. Luxurious and warm with elegant texture, perfect for weddings and special events.',
      'inStock': true,
      'rating': 4.8,
      'reviews': 134,
      'fabricOptions': [
        {
          'name': 'Premium Velvet',
          'description': 'High-quality velvet with rich texture',
          'priceMultiplier': 1.5,
          'properties': ['Luxurious', 'Soft', 'Warm']
        },
        {
          'name': 'Stretch Velvet',
          'description': 'Velvet with stretch for comfort',
          'priceMultiplier': 1.3,
          'properties': ['Comfortable', 'Flexible', 'Luxurious']
        },
        {
          'name': 'Standard Velvet',
          'description': 'Quality velvet for party wear',
          'priceMultiplier': 1.0,
          'properties': ['Soft', 'Warm', 'Elegant']
        }
      ]
    },
    {
      'name': 'Kids T-Shirt Material',
      'price': 399,
      'image': 'https://images.unsplash.com/photo-1519457431-44ccd64a579b?w=500',
      'category': 'Casual',
      'material': 'Cotton',
      'colors': ['White', 'Black', 'Grey', 'Blue', 'Yellow'],
      'description': 'Soft combed cotton for comfortable kids t-shirts. Excellent color retention and skin-friendly, perfect for daily wear and play.',
      'inStock': true,
      'rating': 4.4,
      'reviews': 267,
      'fabricOptions': [
        {
          'name': 'Organic Combed Cotton',
          'description': 'Eco-friendly combed cotton for softness',
          'priceMultiplier': 1.3,
          'properties': ['Eco-friendly', 'Soft', 'Breathable']
        },
        {
          'name': 'Stretch Cotton Jersey',
          'description': 'Cotton jersey with stretch for active kids',
          'priceMultiplier': 1.2,
          'properties': ['Stretch', 'Comfortable', 'Durable']
        },
        {
          'name': 'Standard Cotton',
          'description': 'Quality cotton for everyday t-shirts',
          'priceMultiplier': 1.0,
          'properties': ['Comfortable', 'Affordable', 'Versatile']
        }
      ]
    },
    {
      'name': 'School Uniform Fabric',
      'price': 699,
      'image': 'https://images.unsplash.com/photo-1519457431-44ccd64a579b?w=500',
      'category': 'Boys',
      'material': 'Poly Cotton',
      'colors': ['White', 'Blue', 'Grey', 'Navy', 'Light Blue'],
      'description': 'Durable poly-cotton blend perfect for school uniforms. Wrinkle-resistant and easy to maintain with excellent durability.',
      'inStock': true,
      'rating': 4.5,
      'reviews': 189,
      'fabricOptions': [
        {
          'name': 'Premium Poly-Cotton',
          'description': 'High-quality blend with better durability',
          'priceMultiplier': 1.3,
          'properties': ['Durable', 'Wrinkle-resistant', 'Long-lasting']
        },
        {
          'name': 'Stretch Poly-Cotton',
          'description': 'Blend with stretch for comfort',
          'priceMultiplier': 1.2,
          'properties': ['Comfortable', 'Flexible', 'Durable']
        },
        {
          'name': 'Standard Poly-Cotton',
          'description': 'Quality blend for school wear',
          'priceMultiplier': 1.0,
          'properties': ['Durable', 'Affordable', 'Easy care']
        }
      ]
    },
    {
      'name': 'Girls Frock Material',
      'price': 999,
      'image': 'https://images.unsplash.com/photo-1519238263530-99c0a46067d3?w=500',
      'category': 'Girls',
      'material': 'Cotton',
      'colors': ['Pink', 'Yellow', 'White', 'Green', 'Lavender'],
      'description': 'Soft floral cotton perfect for girls frocks. Lightweight and comfortable with beautiful prints, ideal for parties and daily wear.',
      'inStock': true,
      'rating': 4.6,
      'reviews': 178,
      'fabricOptions': [
        {
          'name': 'Premium Printed Cotton',
          'description': 'High-quality cotton with designer prints',
          'priceMultiplier': 1.4,
          'properties': ['Designer', 'Soft', 'Elegant']
        },
        {
          'name': 'Organic Cotton',
          'description': 'Eco-friendly organic cotton',
          'priceMultiplier': 1.3,
          'properties': ['Eco-friendly', 'Soft', 'Hypoallergenic']
        },
        {
          'name': 'Standard Cotton',
          'description': 'Quality cotton for frocks',
          'priceMultiplier': 1.0,
          'properties': ['Comfortable', 'Breathable', 'Versatile']
        }
      ]
    },
    {
      'name': 'Infant Romper Material',
      'price': 799,
      'image': 'https://images.unsplash.com/photo-1604917019118-2042de641afe?w=500',
      'category': 'Infants',
      'material': 'Soft Cotton',
      'colors': ['Pastel Pink', 'Baby Blue', 'Cream', 'Mint', 'Peach'],
      'description': 'Ultra-soft cotton specially designed for infant clothing. Gentle on delicate skin with excellent breathability for baby comfort.',
      'inStock': true,
      'rating': 4.8,
      'reviews': 203,
      'fabricOptions': [
        {
          'name': 'Organic Baby Cotton',
          'description': '100% organic cotton for sensitive skin',
          'priceMultiplier': 1.5,
          'properties': ['Hypoallergenic', 'Ultra-soft', 'Safe']
        },
        {
          'name': 'Bamboo Cotton Blend',
          'description': 'Bamboo-cotton blend for extra softness',
          'priceMultiplier': 1.3,
          'properties': ['Ultra-soft', 'Breathable', 'Antibacterial']
        },
        {
          'name': 'Standard Baby Cotton',
          'description': 'Quality soft cotton for infants',
          'priceMultiplier': 1.0,
          'properties': ['Soft', 'Comfortable', 'Breathable']
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
      'Boys': 'Boys',
      'Girls': 'Girls',
      'Ethnic': 'Ethnic',
      'Party Wear': 'Party Wear',
      'Casual': 'Casual',
      'Infants': 'Infants',
      'School Uniform': 'Boys',
      'Baby Clothes': 'Infants',
      'Traditional Wear': 'Ethnic',
      'Festive Wear': 'Party Wear',
    };
    return subcategoryMap[subcategory] ?? 'All';
  }

  List<Map<String, dynamic>> get filteredFabrics {
    if (selectedCategory == 'All') return kidsFabrics;
    return kidsFabrics.where((f) => f['category'] == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        title: Text(
          widget.initialSubcategory ?? widget.initialCategory ?? "Kids Collection",
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
            builder: (context) => KidsProductDetailPage(
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

// Kids Product Detail Page with Blue Theme
class KidsProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> product;
  final List<Shop> availableShops;

  const KidsProductDetailPage({
    Key? key, 
    required this.product,
    required this.availableShops,
  }) : super(key: key);

  @override
  State<KidsProductDetailPage> createState() => _KidsProductDetailPageState();
}

class _KidsProductDetailPageState extends State<KidsProductDetailPage> {
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
          builder: (context) => KidsFabricSelectionScreen(
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

// Kids Fabric Selection Screen with Blue Theme
class KidsFabricSelectionScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  final Shop shop;
  final Map<String, dynamic>? selectedFabric;
  final Function(Map<String, dynamic>) onFabricSelected;

  const KidsFabricSelectionScreen({
    Key? key,
    required this.product,
    required this.shop,
    this.selectedFabric,
    required this.onFabricSelected,
  }) : super(key: key);

  @override
  State<KidsFabricSelectionScreen> createState() => _KidsFabricSelectionScreenState();
}

class _KidsFabricSelectionScreenState extends State<KidsFabricSelectionScreen> {
  Map<String, dynamic>? selectedFabric;
  int _currentFeatureIndex = 0;

  // Enhanced fabric data for kids clothing with blue theme
  final List<Map<String, dynamic>> _allFabrics = [
    {
      'name': 'Soft Cotton',
      'description': 'Gentle & breathable perfect for sensitive skin',
      'properties': ['Breathable', 'Soft', 'Hypoallergenic', 'Comfortable'],
      'priceMultiplier': 1.0,
      'color': Color(0xFF2196F3),
      'icon': Icons.child_care,
      'bestFor': ['T-shirts', 'Onesies', 'Pajamas', 'Daily Wear'],
      'care': 'Machine wash warm',
      'season': ['All Seasons'],
    },
    {
      'name': 'Organic Cotton',
      'description': 'Chemical-free & eco-friendly for delicate skin',
      'properties': ['Eco-friendly', 'Ultra-soft', 'Safe', 'Natural'],
      'priceMultiplier': 1.4,
      'color': Color(0xFF1976D2),
      'icon': Icons.eco,
      'bestFor': ['Infant Wear', 'Sensitive Skin', 'Premium Clothing'],
      'care': 'Machine wash gentle',
      'season': ['All Seasons'],
    },
    {
      'name': 'Jersey Cotton',
      'description': 'Stretchy & comfortable for active movement',
      'properties': ['Stretchy', 'Comfortable', 'Durable', 'Flexible'],
      'priceMultiplier': 1.2,
      'color': Color(0xFF42A5F5),
      'icon': Icons.directions_run,
      'bestFor': ['Active Wear', 'Play Clothes', 'Sportswear'],
      'care': 'Machine wash cool',
      'season': ['All Seasons'],
    },
    {
      'name': 'Flannel',
      'description': 'Warm & cozy perfect for cold weather',
      'properties': ['Warm', 'Cozy', 'Soft', 'Comfortable'],
      'priceMultiplier': 1.3,
      'color': Color(0xFF1565C0),
      'icon': Icons.ac_unit,
      'bestFor': ['Winter Wear', 'Pajamas', 'Cold Weather'],
      'care': 'Machine wash warm',
      'season': ['Winter', 'Fall'],
    },
    {
      'name': 'Corduroy',
      'description': 'Durable & textured for stylish outfits',
      'properties': ['Durable', 'Textured', 'Warm', 'Stylish'],
      'priceMultiplier': 1.5,
      'color': Color(0xFF0D47A1),
      'icon': Icons.texture,
      'bestFor': ['Pants', 'Jackets', 'Winter Wear'],
      'care': 'Machine wash cool',
      'season': ['Winter', 'Fall'],
    },
    {
      'name': 'Fleece',
      'description': 'Ultra-soft & warm for maximum comfort',
      'properties': ['Ultra-soft', 'Warm', 'Lightweight', 'Comfortable'],
      'priceMultiplier': 1.4,
      'color': Color(0xFF64B5F6),
      'icon': Icons.weekend,
      'bestFor': ['Jackets', 'Hoodies', 'Winter Wear'],
      'care': 'Machine wash cool',
      'season': ['Winter'],
    },
    {
      'name': 'Denim',
      'description': 'Rugged & durable for casual wear',
      'properties': ['Durable', 'Sturdy', 'Classic', 'Versatile'],
      'priceMultiplier': 1.3,
      'color': Color(0xFF1E88E5),
      'icon': Icons.style,
      'bestFor': ['Jeans', 'Jackets', 'Casual Wear'],
      'care': 'Machine wash cold',
      'season': ['All Seasons'],
    },
    {
      'name': 'Satin',
      'description': 'Smooth & shiny for special occasions',
      'properties': ['Smooth', 'Shiny', 'Elegant', 'Special Occasion'],
      'priceMultiplier': 1.6,
      'color': Color(0xFF90CAF9),
      'icon': Icons.celebration,
      'bestFor': ['Party Wear', 'Special Occasions', 'Festive Wear'],
      'care': 'Dry clean recommended',
      'season': ['All Seasons'],
    },
  ];

  final List<Map<String, dynamic>> _fabricFeatures = [
    {
      'icon': Icons.child_friendly,
      'title': 'Kid-Friendly',
      'description': 'Soft fabrics perfect for delicate skin'
    },
    {
      'icon': Icons.cleaning_services,
      'title': 'Easy Care',
      'description': 'Low maintenance for busy parents'
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
          'Choose Fabric',
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
                    'Kids Fabric Guide',
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