

import 'package:firebaseauth/fabricSide/model/fcategory.dart';
import 'package:firebaseauth/fabricSide/practice/fabricproductdetail.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class FabricCollectionPage extends StatefulWidget {
  final FabricCategory category;
  final Color primaryColor;
  final Color accentColor;
  final Color cardColor;
  final Color textPrimary;
  final Color textSecondary;

  const FabricCollectionPage({
    required this.category,
    required this.primaryColor,
    required this.accentColor,
    required this.cardColor,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  State<FabricCollectionPage> createState() => _FabricCollectionPageState();
}

class _FabricCollectionPageState extends State<FabricCollectionPage> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isGridView = true;
  String selectedSort = 'Popular';
  Set<int> favoriteItems = {};
  
  // Filter states
  Set<String> selectedPriceRanges = {};
  Set<String> selectedRatings = {};
  Set<String> selectedProperties = {};
  String searchQuery = '';
  
  final List<String> sortOptions = [
    'Popular', 
    'Price: Low to High', 
    'Price: High to Low', 
    'Newest',
    'Rating: High to Low',
    'Name: A to Z'
  ];

  // Enhanced product data with actual fabric images
  late List<Map<String, dynamic>> products;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.category.subCategories.length, 
      vsync: this
    );
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
    
    // Initialize products
    products = List.generate(
      20,
      (index) => {
        'id': index,
        'name': '${[
          'Silk Brocade',
          'Handwoven Khadi',
          'Velvet Fabric',
          'Pure Linen',
          'Floral Georgette',
          'Chanderi Cotton',
          'Banarasi Silk',
          'Tussar Silk',
          'Sheer Organza',
          'Silk Chiffon',
        ][index % 10]} ${index + 1}',
        'price': 250 + (index * 75) + ((index % 3) * 100),
        'rating': 3.5 + (index % 5) * 0.3,
        'reviews': 25 + (index * 5) + ((index % 4) * 10),
        'image': _getCategorySpecificImage(index),
        'discount': index % 4 == 0 ? 15 : (index % 5 == 0 ? 20 : null),
        'popularity': 100 - (index * 3) + ((index % 2) * 20),
        'dateAdded': DateTime.now().subtract(Duration(days: index * 7)),
        'properties': _getRandomProperties(index),
      },
    );
  }

  String _getCategorySpecificImage(int index) {
    final fabricImages = {
      'Silk Brocade': [
        'https://i.pinimg.com/1200x/4a/9b/83/4a9b8377d56530489133a05d1fcbc03d.jpg',
        'https://i.pinimg.com/1200x/20/45/35/204535b6503c434300d7fedcff66b544.jpg',
      ],
      'Handwoven Khadi': [
         'https://i.pinimg.com/1200x/39/e9/4e/39e94e72f1afa31cd91595ba6ee426d5.jpg',
        'https://i.pinimg.com/1200x/39/e9/4e/39e94e72f1afa31cd91595ba6ee426d5.jpg',
      ],
      'Velvet Fabric': [
        'https://i.pinimg.com/1200x/39/e9/4e/39e94e72f1afa31cd91595ba6ee426d5.jpg',
        'https://i.pinimg.com/1200x/39/e9/4e/39e94e72f1afa31cd91595ba6ee426d5.jpg',
      ],
      'Pure Linen': [
        'https://i.pinimg.com/1200x/39/e9/4e/39e94e72f1afa31cd91595ba6ee426d5.jpg',
        'https://i.pinimg.com/1200x/39/e9/4e/39e94e72f1afa31cd91595ba6ee426d5.jpg',
      ],
      'Floral Georgette': [
         'https://i.pinimg.com/1200x/39/e9/4e/39e94e72f1afa31cd91595ba6ee426d5.jpg',
        'https://i.pinimg.com/1200x/39/e9/4e/39e94e72f1afa31cd91595ba6ee426d5.jpg',
      ],
      'Chanderi Cotton': [
         'https://i.pinimg.com/1200x/39/e9/4e/39e94e72f1afa31cd91595ba6ee426d5.jpg',
        'https://i.pinimg.com/1200x/39/e9/4e/39e94e72f1afa31cd91595ba6ee426d5.jpg',
      ],
      'Banarasi Silk': [
        'https://i.pinimg.com/1200x/39/e9/4e/39e94e72f1afa31cd91595ba6ee426d5.jpg',
        'https://i.pinimg.com/1200x/39/e9/4e/39e94e72f1afa31cd91595ba6ee426d5.jpg',
      ],
      'Tussar Silk': [
         'https://i.pinimg.com/1200x/39/e9/4e/39e94e72f1afa31cd91595ba6ee426d5.jpg',
        'https://i.pinimg.com/1200x/39/e9/4e/39e94e72f1afa31cd91595ba6ee426d5.jpg',
      ],
      'Sheer Organza': [
        'https://i.pinimg.com/1200x/39/e9/4e/39e94e72f1afa31cd91595ba6ee426d5.jpg',
        'https://i.pinimg.com/1200x/39/e9/4e/39e94e72f1afa31cd91595ba6ee426d5.jpg',
      ],
      'Silk Chiffon': [
         'https://i.pinimg.com/1200x/39/e9/4e/39e94e72f1afa31cd91595ba6ee426d5.jpg',
        'https://i.pinimg.com/1200x/39/e9/4e/39e94e72f1afa31cd91595ba6ee426d5.jpg',
      ],
    };

    final fabricNames = [
      'Silk Brocade',
      'Handwoven Khadi',
      'Velvet Fabric',
      'Pure Linen',
      'Floral Georgette',
      'Chanderi Cotton',
      'Banarasi Silk',
      'Tussar Silk',
      'Sheer Organza',
      'Silk Chiffon',
    ];
    
    final fabricName = fabricNames[index % 10];
    final images = fabricImages[fabricName] ?? [
      'https://images.unsplash.com/photo-1551248429-40975aa4de74?w=400&h=500&fit=crop'
    ];
    
    return images[index % images.length];
  }

  static List<String> _getRandomProperties(int index) {
    final allProps = ['Soft', 'Durable', 'Lightweight', 'Premium', 'Handwoven', 'Eco-friendly'];
    return allProps.where((p) => (index + allProps.indexOf(p)) % 3 == 0).toList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleFavorite(int id) {
    setState(() {
      if (favoriteItems.contains(id)) {
        favoriteItems.remove(id);
        _showSnackBar('Removed from favorites', Icons.favorite_border);
      } else {
        favoriteItems.add(id);
        _showSnackBar('Added to favorites', Icons.favorite, Colors.red);
      }
    });
  }

  void _showSnackBar(String message, IconData icon, [Color? color]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: color ?? Colors.white, size: 20),
            SizedBox(width: 8),
            Text(message, style: GoogleFonts.poppins()),
          ],
        ),
        backgroundColor: widget.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: Duration(seconds: 2),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredAndSortedProducts() {
    var filteredProducts = List<Map<String, dynamic>>.from(products);

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      filteredProducts = filteredProducts.where((product) {
        return product['name'].toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    // Apply price range filter
    if (selectedPriceRanges.isNotEmpty) {
      filteredProducts = filteredProducts.where((product) {
        int price = product['price'];
        return selectedPriceRanges.any((range) {
          if (range == 'Under ₹500') return price < 500;
          if (range == '₹500 - ₹1000') return price >= 500 && price <= 1000;
          if (range == '₹1000 - ₹2000') return price >= 1000 && price <= 2000;
          if (range == 'Above ₹2000') return price > 2000;
          return false;
        });
      }).toList();
    }

    // Apply rating filter
    if (selectedRatings.isNotEmpty) {
      filteredProducts = filteredProducts.where((product) {
        double rating = product['rating'];
        return selectedRatings.any((ratingFilter) {
          if (ratingFilter == '4★ & above') return rating >= 4.0;
          if (ratingFilter == '3★ & above') return rating >= 3.0;
          if (ratingFilter == '2★ & above') return rating >= 2.0;
          return true;
        });
      }).toList();
    }

    // Apply properties filter
    if (selectedProperties.isNotEmpty) {
      filteredProducts = filteredProducts.where((product) {
        List<String> productProps = product['properties'];
        return selectedProperties.any((prop) => productProps.contains(prop));
      }).toList();
    }

    // Apply sorting
    switch (selectedSort) {
      case 'Price: Low to High':
        filteredProducts.sort((a, b) => a['price'].compareTo(b['price']));
        break;
      case 'Price: High to Low':
        filteredProducts.sort((a, b) => b['price'].compareTo(a['price']));
        break;
      case 'Rating: High to Low':
        filteredProducts.sort((a, b) => b['rating'].compareTo(a['rating']));
        break;
      case 'Newest':
        filteredProducts.sort((a, b) => b['dateAdded'].compareTo(a['dateAdded']));
        break;
      case 'Name: A to Z':
        filteredProducts.sort((a, b) => a['name'].compareTo(b['name']));
        break;
      case 'Popular':
      default:
        filteredProducts.sort((a, b) => b['popularity'].compareTo(a['popularity']));
        break;
    }

    return filteredProducts;
  }

  @override
  Widget build(BuildContext context) {
    final displayProducts = _getFilteredAndSortedProducts();
    
    return Scaffold(
      backgroundColor: widget.cardColor,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(child: _buildFiltersSection()),
          
          // Results count
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${displayProducts.length} Products Found',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: widget.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (selectedPriceRanges.isNotEmpty || 
                      selectedRatings.isNotEmpty || 
                      selectedProperties.isNotEmpty)
                    TextButton.icon(
                      onPressed: _clearAllFilters,
                      icon: Icon(Icons.clear, size: 16),
                      label: Text('Clear Filters'),
                      style: TextButton.styleFrom(
                        foregroundColor: widget.primaryColor,
                        textStyle: GoogleFonts.poppins(fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          // Products Grid/List
          displayProducts.isEmpty
              ? SliverFillRemaining(child: _buildEmptyState())
              : SliverPadding(
                  padding: EdgeInsets.all(16),
                  sliver: isGridView 
                      ? _buildProductsGrid(displayProducts) 
                      : _buildProductsList(displayProducts),
                ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: widget.textSecondary.withOpacity(0.3),
          ),
          SizedBox(height: 16),
          Text(
            'No products found',
            style: GoogleFonts.playfairDisplay(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: widget.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your filters or search terms',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: widget.textSecondary,
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _clearAllFilters,
            icon: Icon(Icons.refresh),
            label: Text('Clear All Filters'),
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _clearAllFilters() {
    setState(() {
      selectedPriceRanges.clear();
      selectedRatings.clear();
      selectedProperties.clear();
      searchQuery = '';
    });
    _showSnackBar('Filters cleared', Icons.filter_alt_off);
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: widget.primaryColor,
      leading: IconButton(
        icon: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.arrow_back, color: Colors.white, size: 20),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isGridView ? Icons.view_list : Icons.grid_view,
              color: Colors.white,
              size: 20,
            ),
          ),
          onPressed: () {
            setState(() {
              isGridView = !isGridView;
            });
            _showSnackBar(
              isGridView ? 'Grid view' : 'List view',
              isGridView ? Icons.grid_view : Icons.view_list,
            );
          },
        ),
        IconButton(
          icon: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.filter_list, color: Colors.white, size: 20),
              ),
              if (selectedPriceRanges.isNotEmpty || 
                  selectedRatings.isNotEmpty || 
                  selectedProperties.isNotEmpty)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${selectedPriceRanges.length + selectedRatings.length + selectedProperties.length}',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          onPressed: _showFilterSheet,
        ),
        SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.category.name,
          style: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 10),
            ],
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(widget.category.image, fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    widget.primaryColor.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Container(
          color: widget.primaryColor,
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.6),
            labelStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            tabs: widget.category.subCategories.map((subCat) {
              return Tab(text: subCat);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      padding: EdgeInsets.all(16),
      color: widget.cardColor,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => _buildSortBottomSheet(),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: widget.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: widget.primaryColor.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.sort, size: 20, color: widget.primaryColor),
                        SizedBox(width: 8),
                        Text(
                          selectedSort,
                          style: GoogleFonts.poppins(
                            color: widget.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.expand_more, color: widget.primaryColor),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          GestureDetector(
            onTap: () => _showSearchDialog(),
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widget.primaryColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: widget.primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(Icons.search, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortBottomSheet() {
    return Container(
      decoration: BoxDecoration(
        color: widget.cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sort By',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: widget.textPrimary,
                  ),
                ),
                SizedBox(height: 16),
                ...sortOptions.map((option) {
                  final isSelected = selectedSort == option;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedSort = option;
                      });
                      Navigator.pop(context);
                      _showSnackBar('Sorted by $option', Icons.sort);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      margin: EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? widget.primaryColor.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected 
                              ? widget.primaryColor
                              : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _getSortIcon(option),
                            color: isSelected 
                                ? widget.primaryColor 
                                : widget.textSecondary,
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              option,
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: isSelected 
                                    ? FontWeight.w600 
                                    : FontWeight.w500,
                                color: isSelected 
                                    ? widget.primaryColor 
                                    : widget.textPrimary,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: widget.primaryColor,
                              size: 22,
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getSortIcon(String option) {
    switch (option) {
      case 'Popular':
        return Icons.trending_up;
      case 'Price: Low to High':
        return Icons.arrow_upward;
      case 'Price: High to Low':
        return Icons.arrow_downward;
      case 'Newest':
        return Icons.new_releases;
      case 'Rating: High to Low':
        return Icons.star;
      case 'Name: A to Z':
        return Icons.sort_by_alpha;
      default:
        return Icons.sort;
    }
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: widget.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Search Products',
          style: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.bold,
            color: widget.textPrimary,
          ),
        ),
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Enter product name...',
            hintStyle: GoogleFonts.poppins(color: widget.textSecondary),
            prefixIcon: Icon(Icons.search, color: widget.primaryColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: widget.primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: widget.primaryColor, width: 2),
            ),
          ),
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
          onSubmitted: (value) {
            Navigator.pop(context);
            if (value.isNotEmpty) {
              _showSnackBar('Searching for "$value"', Icons.search);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                searchQuery = '';
              });
              Navigator.pop(context);
            },
            child: Text(
              'Clear',
              style: GoogleFonts.poppins(color: widget.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (searchQuery.isNotEmpty) {
                _showSnackBar('Searching for "$searchQuery"', Icons.search);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Search',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsGrid(List<Map<String, dynamic>> displayProducts) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => _buildProductCard(displayProducts[index]),
        childCount: displayProducts.length,
      ),
    );
  }

  Widget _buildProductsList(List<Map<String, dynamic>> displayProducts) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => _buildProductListItem(displayProducts[index]),
        childCount: displayProducts.length,
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    final isFavorite = favoriteItems.contains(product['id']);
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => 
              FabricProductDetailPage(
                product: product,
                primaryColor: widget.primaryColor,
                accentColor: widget.accentColor,
                cardColor: widget.cardColor,
                textPrimary: widget.textPrimary,
                textSecondary: widget.textSecondary,
              ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(0.0, 0.1),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  )),
                  child: child,
                ),
              );
            },
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: widget.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.network(
                      product['image'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (product['discount'] != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.red[700]!, Colors.red[500]!],
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.3),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Text(
                        '${product['discount']}% OFF',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => _toggleFavorite(product['id']),
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['name'],
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: widget.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 14),
                            SizedBox(width: 4),
                            Text(
                              '${product['rating'].toStringAsFixed(1)}',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: widget.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              '(${product['reviews']})',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: widget.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '₹${product['price']}',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: widget.primaryColor,
                          ),
                        ),
                        if (product['discount'] != null) ...[
                          SizedBox(width: 6),
                          Text(
                            '₹${(product['price'] / (1 - product['discount'] / 100)).round()}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              decoration: TextDecoration.lineThrough,
                              color: widget.textSecondary,
                            ),
                          ),
                        ],
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

  Widget _buildProductListItem(Map<String, dynamic> product) {
    final isFavorite = favoriteItems.contains(product['id']);
    
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: widget.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => 
                FabricProductDetailPage(
                  product: product,
                  primaryColor: widget.primaryColor,
                  accentColor: widget.accentColor,
                  cardColor: widget.cardColor,
                  textPrimary: widget.textPrimary,
                  textSecondary: widget.textSecondary,
                ),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(0.0, 0.1),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    )),
                    child: child,
                  ),
                );
              },
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      product['image'],
                      width: 100,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (product['discount'] != null)
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.red[700]!, Colors.red[500]!],
                          ),
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Text(
                          '${product['discount']}%',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'],
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: widget.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        SizedBox(width: 4),
                        Text(
                          '${product['rating'].toStringAsFixed(1)}',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: widget.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          '(${product['reviews']} reviews)',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: widget.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '₹${product['price']}',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: widget.primaryColor,
                          ),
                        ),
                        if (product['discount'] != null) ...[
                          SizedBox(width: 8),
                          Text(
                            '₹${(product['price'] / (1 - product['discount'] / 100)).round()}',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              decoration: TextDecoration.lineThrough,
                              color: widget.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _showSnackBar(
                                'Added ${product['name']} to cart',
                                Icons.shopping_cart,
                              );
                            },
                            icon: Icon(Icons.shopping_cart_outlined, size: 16),
                            label: Text(
                              'Add to Cart',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.primaryColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              GestureDetector(
                onTap: () => _toggleFavorite(product['id']),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isFavorite 
                      ? Colors.red.withOpacity(0.1) 
                      : widget.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : widget.primaryColor,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: widget.cardColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filters',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: widget.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setModalState(() {
                          selectedPriceRanges.clear();
                          selectedRatings.clear();
                          selectedProperties.clear();
                        });
                        setState(() {
                          selectedPriceRanges.clear();
                          selectedRatings.clear();
                          selectedProperties.clear();
                        });
                      },
                      child: Text(
                        'Clear All',
                        style: GoogleFonts.poppins(
                          color: widget.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFilterSection(
                        'Price Range',
                        ['Under ₹500', '₹500 - ₹1000', '₹1000 - ₹2000', 'Above ₹2000'],
                        selectedPriceRanges,
                        setModalState,
                      ),
                      SizedBox(height: 20),
                      _buildFilterSection(
                        'Rating',
                        ['4★ & above', '3★ & above', '2★ & above', 'All'],
                        selectedRatings,
                        setModalState,
                      ),
                      SizedBox(height: 20),
                      _buildFilterSection(
                        'Properties',
                        widget.category.properties,
                        selectedProperties,
                        setModalState,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: widget.cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {});
                      Navigator.pop(context);
                      _showSnackBar('Filters applied', Icons.check_circle);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      'Apply Filters (${selectedPriceRanges.length + selectedRatings.length + selectedProperties.length})',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection(
    String title, 
    List<String> options, 
    Set<String> selectedSet,
    StateSetter setModalState,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: widget.textPrimary,
              ),
            ),
            if (selectedSet.isNotEmpty) ...[
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: widget.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${selectedSet.length}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selectedSet.contains(option);
            return FilterChip(
              label: Text(option),
              labelStyle: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : widget.textPrimary,
              ),
              selected: isSelected,
              onSelected: (bool selected) {
                setModalState(() {
                  if (selected) {
                    selectedSet.add(option);
                  } else {
                    selectedSet.remove(option);
                  }
                });
              },
              backgroundColor: widget.primaryColor.withOpacity(0.1),
              selectedColor: widget.primaryColor,
              checkmarkColor: Colors.white,
              labelPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: isSelected 
                      ? widget.primaryColor 
                      : widget.primaryColor.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
