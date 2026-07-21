import 'package:firebaseauth/customerside/components/gradient_scaffold.dart';
import 'package:firebaseauth/customerside/models/homescreen_model.dart';
import 'package:firebaseauth/customerside/screens/addtocartpage.dart';
import 'package:firebaseauth/customerside/screens/chackoutbottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Main Women's Page with Enhanced Functionality
class WomensPage extends StatefulWidget {
  final String? initialCategory;
  final String? initialSubcategory;

  const WomensPage({
    Key? key,
    this.initialCategory,
    this.initialSubcategory,
  }) : super(key: key);

  @override
  State<WomensPage> createState() => _WomensPageState();
}

class _WomensPageState extends State<WomensPage> {
  String selectedCategory = 'All';
  final List<String> categories = ['All', 'Sarees', 'Kurtis', 'Dresses', 'Lehengas', 'Tops', 'Gowns', 'Suits'];
  
  final List<Shop> availableShops = [
    Shop(
      id: '1',
      name: 'Fashion Boutique',
      image: 'https://images.unsplash.com/photo-1560493676-04071c5f467b',
      rating: 4.7,
      reviews: 230,
      distance: 1.8,
      isOpen: true,
      category: 'Women Fashion',
      description: 'Premium women fashion destination with latest trends',
    ),
    Shop(
      id: '2',
      name: 'Ethnic Elegance',
      image: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8',
      rating: 4.5,
      reviews: 156,
      distance: 2.1,
      isOpen: true,
      category: 'Ethnic Wear',
      description: 'Contemporary ethnic fashion studio',
    ),
    Shop(
      name: 'Designer Studio',
      rating: 4.9,
      reviews: 342,
      image: 'https://images.unsplash.com/photo-1469334031218-e382a71b716b?w=200',
      distance: 3.2,
      isOpen: true,
      category: 'Designer Wear',
      id: '3',
      description: 'A premium boutique known for modern designs and seasonal trends.',
    ),
    Shop(
      name: 'Royal Couture',
      rating: 4.8,
      reviews: 189,
      image: 'https://images.unsplash.com/photo-1558769132-cb1f96b8d050?w=200',
      distance: 1.5,
      isOpen: true,
      category: 'Luxury Fashion',
      id: '4',
      description: 'Exclusive collection of handcrafted ethnic and western outfits.',
    ),
  ];

  final List<Map<String, dynamic>> womensFabrics = [
    {
      'name': 'Pure Silk Saree Material',
      'price': 3599,
      'image': 'https://images.unsplash.com/photo-1566174053879-31528523f8ae?w=500',
      'category': 'Sarees',
      'material': 'Pure Silk',
      'colors': ['Red', 'Green', 'Blue', 'Pink', 'Purple'],
      'description': 'Luxurious pure silk fabric with natural sheen, perfect for traditional sarees. Excellent drape and elegant appearance for special occasions.',
      'inStock': true,
      'rating': 4.8,
      'reviews': 189,
      'fabricOptions': [
        {
          'name': 'Banarasi Silk',
          'description': 'Traditional Banarasi silk with intricate zari work',
          'priceMultiplier': 1.8,
          'properties': ['Luxurious', 'Traditional', 'Zari Work']
        },
        {
          'name': 'Kanjivaram Silk',
          'description': 'Authentic South Indian silk with rich colors',
          'priceMultiplier': 2.0,
          'properties': ['Rich', 'Durable', 'Traditional']
        },
        {
          'name': 'Pure Mulberry Silk',
          'description': 'Finest quality mulberry silk with natural sheen',
          'priceMultiplier': 1.5,
          'properties': ['Soft', 'Lustrous', 'Elegant']
        }
      ]
    },
    {
      'name': 'Designer Kurti Fabric',
      'price': 1599,
      'image': 'https://images.unsplash.com/photo-1581044777550-4cfa60707c03?w=500',
      'category': 'Kurtis',
      'material': 'Cotton Silk',
      'colors': ['White', 'Black', 'Yellow', 'Orange', 'Peach'],
      'description': 'Premium cotton silk blend perfect for designer kurtis. Comfortable for daily wear with elegant drape and easy maintenance.',
      'inStock': true,
      'rating': 4.5,
      'reviews': 234,
      'fabricOptions': [
        {
          'name': 'Chanderi Cotton Silk',
          'description': 'Lightweight Chanderi fabric with silk blend',
          'priceMultiplier': 1.4,
          'properties': ['Lightweight', 'Elegant', 'Comfortable']
        },
        {
          'name': 'Printed Cotton Silk',
          'description': 'Digital printed cotton silk with vibrant patterns',
          'priceMultiplier': 1.2,
          'properties': ['Vibrant', 'Comfortable', 'Modern']
        },
        {
          'name': 'Standard Cotton Silk',
          'description': 'Quality cotton silk blend for daily wear',
          'priceMultiplier': 1.0,
          'properties': ['Comfortable', 'Durable', 'Versatile']
        }
      ]
    },
    {
      'name': 'Party Dress Material',
      'price': 2299,
      'image': 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=500',
      'category': 'Dresses',
      'material': 'Georgette',
      'colors': ['Black', 'Red', 'Navy', 'Purple', 'Emerald'],
      'description': 'Flowy georgette fabric perfect for party dresses. Excellent drape with crease-resistant properties for elegant evening wear.',
      'inStock': true,
      'rating': 4.6,
      'reviews': 167,
      'fabricOptions': [
        {
          'name': 'Pure Georgette',
          'description': '100% pure georgette with excellent drape',
          'priceMultiplier': 1.3,
          'properties': ['Flowy', 'Elegant', 'Drapeable']
        },
        {
          'name': 'Sequined Georgette',
          'description': 'Georgette with sequin work for parties',
          'priceMultiplier': 1.6,
          'properties': ['Sparkling', 'Elegant', 'Party Wear']
        },
        {
          'name': 'Printed Georgette',
          'description': 'Georgette with designer prints',
          'priceMultiplier': 1.1,
          'properties': ['Printed', 'Flowy', 'Versatile']
        }
      ]
    },
    {
      'name': 'Wedding Lehenga Fabric',
      'price': 6999,
      'image': 'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?w=500',
      'category': 'Lehengas',
      'material': 'Heavy Silk',
      'colors': ['Red', 'Maroon', 'Pink', 'Gold', 'Royal Blue'],
      'description': 'Opulent heavy silk fabric for wedding lehengas. Rich texture with excellent fall, perfect for bridal and special occasion wear.',
      'inStock': true,
      'rating': 4.9,
      'reviews': 278,
      'fabricOptions': [
        {
          'name': 'Heavy Banarasi Silk',
          'description': 'Traditional heavy Banarasi silk for weddings',
          'priceMultiplier': 2.2,
          'properties': ['Heavy', 'Luxurious', 'Traditional']
        },
        {
          'name': 'Velvet Silk Blend',
          'description': 'Rich velvet silk blend for winter weddings',
          'priceMultiplier': 1.8,
          'properties': ['Rich', 'Warm', 'Luxurious']
        },
        {
          'name': 'Embroidered Silk',
          'description': 'Heavy silk with intricate embroidery',
          'priceMultiplier': 1.5,
          'properties': ['Embroidered', 'Elegant', 'Traditional']
        }
      ]
    },
    {
      'name': 'Casual Top Material',
      'price': 899,
      'image': 'https://images.unsplash.com/photo-1583496661160-fb5886a13d77?w=500',
      'category': 'Tops',
      'material': 'Cotton',
      'colors': ['White', 'Black', 'Grey', 'Blue', 'Mint'],
      'description': 'Soft breathable cotton perfect for casual tops. Skin-friendly fabric with excellent comfort for daily wear.',
      'inStock': true,
      'rating': 4.4,
      'reviews': 312,
      'fabricOptions': [
        {
          'name': 'Organic Cotton',
          'description': 'Eco-friendly organic cotton, gentle on skin',
          'priceMultiplier': 1.3,
          'properties': ['Eco-friendly', 'Soft', 'Breathable']
        },
        {
          'name': 'Stretch Cotton',
          'description': 'Cotton with stretch for better fit',
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
      'name': 'Designer Gown Fabric',
      'price': 4299,
      'image': 'https://images.unsplash.com/photo-1539008835657-9e8e9680c956?w=500',
      'category': 'Gowns',
      'material': 'Satin',
      'colors': ['Black', 'White', 'Red', 'Blue', 'Burgundy'],
      'description': 'Luxurious satin fabric for designer gowns. Smooth texture with elegant sheen, perfect for formal events and parties.',
      'inStock': true,
      'rating': 4.7,
      'reviews': 145,
      'fabricOptions': [
        {
          'name': 'Pure Silk Satin',
          'description': 'Luxury silk satin for premium gowns',
          'priceMultiplier': 1.8,
          'properties': ['Luxurious', 'Smooth', 'Elegant']
        },
        {
          'name': 'Duchess Satin',
          'description': 'Heavy satin for structured gowns',
          'priceMultiplier': 1.5,
          'properties': ['Structured', 'Heavy', 'Formal']
        },
        {
          'name': 'Standard Satin',
          'description': 'Quality satin for designer gowns',
          'priceMultiplier': 1.0,
          'properties': ['Smooth', 'Elegant', 'Versatile']
        }
      ]
    },
    {
      'name': 'Anarkali Suit Fabric',
      'price': 2899,
      'image': 'https://images.unsplash.com/photo-1585487000113-4e0c6b14f5a5?w=500',
      'category': 'Suits',
      'material': 'Chiffon',
      'colors': ['Pink', 'Purple', 'Blue', 'White', 'Peach'],
      'description': 'Flowy chiffon fabric perfect for Anarkali suits. Lightweight and elegant with beautiful drape for traditional wear.',
      'inStock': true,
      'rating': 4.6,
      'reviews': 198,
      'fabricOptions': [
        {
          'name': 'Pure Chiffon',
          'description': '100% pure chiffon for elegant drape',
          'priceMultiplier': 1.4,
          'properties': ['Flowy', 'Lightweight', 'Elegant']
        },
        {
          'name': 'Sequined Chiffon',
          'description': 'Chiffon with sequin detailing',
          'priceMultiplier': 1.7,
          'properties': ['Sparkling', 'Elegant', 'Festive']
        },
        {
          'name': 'Printed Chiffon',
          'description': 'Chiffon with designer prints',
          'priceMultiplier': 1.2,
          'properties': ['Printed', 'Flowy', 'Versatile']
        }
      ]
    },
    {
      'name': 'Palazzo Suit Material',
      'price': 1799,
      'image': 'https://images.unsplash.com/photo-1518531933037-8b19108b9a5a?w=500',
      'category': 'Suits',
      'material': 'Rayon',
      'colors': ['Yellow', 'Green', 'Orange', 'Pink', 'Turquoise'],
      'description': 'Comfortable rayon fabric perfect for palazzo suits. Soft texture with excellent drape, ideal for casual and semi-formal wear.',
      'inStock': true,
      'rating': 4.5,
      'reviews': 223,
      'fabricOptions': [
        {
          'name': 'Premium Rayon',
          'description': 'High-quality rayon with silk-like feel',
          'priceMultiplier': 1.3,
          'properties': ['Soft', 'Drapeable', 'Comfortable']
        },
        {
          'name': 'Printed Rayon',
          'description': 'Rayon with vibrant digital prints',
          'priceMultiplier': 1.1,
          'properties': ['Vibrant', 'Comfortable', 'Modern']
        },
        {
          'name': 'Standard Rayon',
          'description': 'Quality rayon for daily wear',
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
      'Sarees': 'Sarees',
      'Kurtis': 'Kurtis',
      'Lehengas': 'Lehengas',
      'Dresses': 'Dresses',
      'Tops': 'Tops',
      'Gowns': 'Gowns',
      'Suits': 'Suits',
      'Salwar Kameez': 'Suits',
      'Anarkali': 'Suits',
      'Palazzo': 'Suits',
      'Ethnic Sets': 'Suits',
      'Party Gowns': 'Gowns',
      'Cocktail Dress': 'Dresses',
      'Designer Wear': 'Dresses',
    };
    return subcategoryMap[subcategory] ?? 'All';
  }

  List<Map<String, dynamic>> get filteredFabrics {
    if (selectedCategory == 'All') return womensFabrics;
    return womensFabrics.where((f) => f['category'] == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        title: Text(
          widget.initialSubcategory ?? widget.initialCategory ?? "Women's Collection",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFEC4899),
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
                color: isSelected ? const Color(0xFFEC4899) : Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: Color(0xFFEC4899).withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ] : [],
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
            builder: (context) => WomensProductDetailPage(
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
                            color: Color(0xFFEC4899).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.favorite_border,
                            size: 18,
                            color: Color(0xFFEC4899),
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
                            color: const Color(0xFFEC4899),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFEC4899), Color(0xFFF59E0B)],
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

// Women's Product Detail Page
class WomensProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> product;
  final List<Shop> availableShops;

  const WomensProductDetailPage({
    Key? key, 
    required this.product,
    required this.availableShops,
  }) : super(key: key);

  @override
  State<WomensProductDetailPage> createState() => _WomensProductDetailPageState();
}

class _WomensProductDetailPageState extends State<WomensProductDetailPage> {
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
          builder: (context) => WomensFabricSelectionScreen(
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
        backgroundColor: Color(0xFFEC4899),
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
                              color: isFavorite ? Color(0xFFEC4899) : Colors.black54,
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
                            color: const Color(0xFFEC4899),
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
                                    color: isSelected ? const Color(0xFFEC4899).withOpacity(0.1) : Colors.grey[50],
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelected ? const Color(0xFFEC4899) : Colors.grey[300]!,
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
                              backgroundColor: const Color(0xFFEC4899),
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
                              color: const Color(0xFFEC4899).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEC4899).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.texture,
                                    color: const Color(0xFFEC4899),
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
                                  color: isSelected ? const Color(0xFFEC4899) : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected ? const Color(0xFFEC4899) : Colors.grey[300]!,
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
                                    color: const Color(0xFFEC4899),
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
                                    color: const Color(0xFFEC4899),
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
                                color: const Color(0xFFEC4899),
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
                      backgroundColor: const Color(0xFFEC4899),
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
                      colors: [Color(0xFFEC4899), Color(0xFFF59E0B)],
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

// Women's Fabric Selection Screen with Enhanced Design
class WomensFabricSelectionScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  final Shop shop;
  final Map<String, dynamic>? selectedFabric;
  final Function(Map<String, dynamic>) onFabricSelected;

  const WomensFabricSelectionScreen({
    Key? key,
    required this.product,
    required this.shop,
    this.selectedFabric,
    required this.onFabricSelected,
  }) : super(key: key);

  @override
  State<WomensFabricSelectionScreen> createState() => _WomensFabricSelectionScreenState();
}

class _WomensFabricSelectionScreenState extends State<WomensFabricSelectionScreen> {
  Map<String, dynamic>? selectedFabric;
  int _currentFeatureIndex = 0;

  // Enhanced fabric data for women's clothing
  final List<Map<String, dynamic>> _allFabrics = [
    {
      'name': 'Pure Silk',
      'description': 'Luxurious & smooth with natural shimmer for special occasions',
      'properties': ['Luxurious', 'Smooth', 'Elegant', 'Breathable'],
      'priceMultiplier': 2.5,
      'color': Color(0xFFE91E63),
      'icon': Icons.star,
      'bestFor': ['Sarees', 'Lehengas', 'Evening Wear'],
      'care': 'Dry clean only',
      'season': ['All Seasons'],
    },
    {
      'name': 'Cotton Silk',
      'description': 'Perfect blend of cotton comfort and silk elegance',
      'properties': ['Comfortable', 'Elegant', 'Breathable', 'Versatile'],
      'priceMultiplier': 1.4,
      'color': Color(0xFF4CAF50),
      'icon': Icons.air,
      'bestFor': ['Kurtis', 'Suits', 'Daily Wear'],
      'care': 'Machine wash gentle',
      'season': ['Spring', 'Summer', 'Fall'],
    },
    {
      'name': 'Georgette',
      'description': 'Flowy & lightweight perfect for party wear',
      'properties': ['Flowy', 'Lightweight', 'Drapeable', 'Elegant'],
      'priceMultiplier': 1.3,
      'color': Color(0xFF9C27B0),
      'icon': Icons.waves,
      'bestFor': ['Dresses', 'Anarkalis', 'Evening Gowns'],
      'care': 'Dry clean recommended',
      'season': ['Summer', 'Spring'],
    },
    {
      'name': 'Chiffon',
      'description': 'Sheer & elegant with beautiful drape',
      'properties': ['Sheer', 'Elegant', 'Flowy', 'Lightweight'],
      'priceMultiplier': 1.7,
      'color': Color(0xFF00BCD4),
      'icon': Icons.filter_vintage,
      'bestFor': ['Sarees', 'Dupattas', 'Evening Wear'],
      'care': 'Hand wash cold',
      'season': ['Spring', 'Summer'],
    },
    {
      'name': 'Satin',
      'description': 'Smooth & glossy for formal and party wear',
      'properties': ['Smooth', 'Glossy', 'Elegant', 'Formal'],
      'priceMultiplier': 1.8,
      'color': Color(0xFF2196F3),
      'icon': Icons.lightbulb,
      'bestFor': ['Gowns', 'Evening Dresses', 'Formal Wear'],
      'care': 'Dry clean only',
      'season': ['All Seasons'],
    },
    {
      'name': 'Velvet',
      'description': 'Plush & luxurious for winter special occasions',
      'properties': ['Luxurious', 'Soft', 'Warm', 'Elegant'],
      'priceMultiplier': 2.2,
      'color': Color(0xFF795548),
      'icon': Icons.king_bed,
      'bestFor': ['Lehengas', 'Blazers', 'Winter Wear'],
      'care': 'Dry clean only',
      'season': ['Winter', 'Fall'],
    },
    {
      'name': 'Linen',
      'description': 'Crisp & breathable perfect for summer outfits',
      'properties': ['Breathable', 'Crisp', 'Natural', 'Summer-friendly'],
      'priceMultiplier': 1.3,
      'color': Color(0xFF8BC34A),
      'icon': Icons.wb_sunny,
      'bestFor': ['Summer Dresses', 'Tops', 'Suits'],
      'care': 'Machine wash cold',
      'season': ['Summer'],
    },
    {
      'name': 'Rayon',
      'description': 'Soft & drapeable with silk-like feel',
      'properties': ['Soft', 'Drapeable', 'Comfortable', 'Versatile'],
      'priceMultiplier': 1.1,
      'color': Color(0xFFFF9800),
      'icon': Icons.style,
      'bestFor': ['Kurtis', 'Dresses', 'Casual Wear'],
      'care': 'Machine wash cool',
      'season': ['All Seasons'],
    },
  ];

  final List<Map<String, dynamic>> _fabricFeatures = [
    {
      'icon': Icons.celebration,
      'title': 'Occasion Ready',
      'description': 'Perfect fabrics for every special moment'
    },
    {
      'icon': Icons.thermostat,
      'title': 'Season Perfect',
      'description': 'Find the ideal fabric for any weather'
    },
    {
      'icon': Icons.cleaning_services,
      'title': 'Easy Care',
      'description': 'Low maintenance for busy lifestyles'
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
          'Choose Your Fabric',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFEC4899),
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
          colors: [Color(0xFFEC4899), Color(0xFFF59E0B)],
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
                backgroundColor: selectedFabric?['color'] ?? Color(0xFFEC4899),
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