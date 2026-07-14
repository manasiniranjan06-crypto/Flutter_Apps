
import 'package:firebaseauth/fabricSide/model/fcategory.dart';
import 'package:firebaseauth/fabricSide/practice/catsheet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;



class FabricCategoryScreen extends StatefulWidget {
  @override
  State<FabricCategoryScreen> createState() => _FabricCategoryScreenState();
}

class _FabricCategoryScreenState extends State<FabricCategoryScreen> 
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _rotationController;
  
  final Color primaryColor = Color(0xFF6B4E71);
  final Color accentColor = Color(0xFFD4A574);
  final Color backgroundColor = Color(0xFFFAF9F6);
  final Color cardColor = Colors.white;
  final Color textPrimary = Color(0xFF2C2C2C);
  final Color textSecondary = Color(0xFF757575);
  final Color successColor = Color(0xFF2ECC71);

  List<FabricCategory> fabricCategories = [];
  String _searchQuery = '';
  int _selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    
    _scaleController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    )..forward();
    
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    )..forward();
    
    _slideController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    )..forward();
    
    _rotationController = AnimationController(
      duration: Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _initializeCategories();
  }

  void _initializeCategories() {
    fabricCategories = [
      FabricCategory(
        name: 'Cotton',
        description: 'Soft, breathable & versatile for everyday wear',
        image: 'https://i.pinimg.com/1200x/f8/ff/a8/f8ffa8318021e19de6f350998f637115.jpg',
        color: primaryColor,
        properties: ['Breathable', 'Soft', 'Absorbent', 'Durable'],
        uses: ['T-shirts', 'Dresses', 'Bedding', 'Towels'],
        care: 'Machine washable, can shrink',
        popularity: 95,
        subCategories: [
          'Organic Cotton',
          'Egyptian Cotton',
          'Pima Cotton',
          'Canvas Cotton'
        ],
      ),
      FabricCategory(
        name: 'Linen',
        description: 'Lightweight & crisp perfect for warm weather',
        image: 'https://i.pinimg.com/1200x/c0/73/71/c07371b14b3ea53ece91c36436afe8b3.jpg',
        color: Color(0xFF8BC34A),
        properties: ['Breathable', 'Crisp', 'Strong', 'Absorbent'],
        uses: ['Summer Clothing', 'Tablecloths', 'Curtains'],
        care: 'Machine wash cool, iron when damp',
        popularity: 85,
        subCategories: [
          'Pure Linen',
          'Linen Blend',
          'Stonewashed Linen'
        ],
      ),
      FabricCategory(
        name: 'Silk',
        description: 'Luxurious & smooth with natural shimmer',
        image: 'https://i.pinimg.com/1200x/43/02/12/4302129567959d6fde0364c3869615ca.jpg',
        color: Color(0xFFE91E63),
        properties: ['Smooth', 'Lustrous', 'Strong', 'Lightweight'],
        uses: ['Evening Wear', 'Scarves', 'Lingerie'],
        care: 'Dry clean or hand wash gently',
        popularity: 90,
        subCategories: [
          'Mulberry Silk',
          'Charmeuse',
          'Chiffon',
          'Dupioni'
        ],
      ),
      FabricCategory(
        name: 'Polyester',
        description: 'Durable & wrinkle-resistant synthetic fabric',
        image: 'https://i.pinimg.com/736x/c5/3d/ab/c53daba4cf613613eb82b9cdde95a0e0.jpg',
        color: Color(0xFF2196F3),
        properties: ['Durable', 'Wrinkle-resistant', 'Quick-drying'],
        uses: ['Sportswear', 'Outerwear', 'Uniforms'],
        care: 'Machine washable, low iron heat',
        popularity: 88,
        subCategories: [
          'Microfiber',
          'Fleece',
          'Satin Polyester'
        ],
      ),
      FabricCategory(
        name: 'Wool',
        description: 'Warm & resilient natural fiber for cold weather',
        image: 'https://i.pinimg.com/736x/d3/13/e6/d313e68841c5e8eaca820bf6cb50d8a9.jpg',
        color: Color(0xFF795548),
        properties: ['Warm', 'Resilient', 'Absorbent', 'Fire-resistant'],
        uses: ['Sweaters', 'Coats', 'Blankets', 'Suits'],
        care: 'Hand wash or dry clean, lay flat to dry',
        popularity: 82,
        subCategories: [
          'Merino Wool',
          'Cashmere',
          'Shetland Wool',
          'Alpaca'
        ],
      ),
      FabricCategory(
        name: 'Velvet',
        description: 'Luxurious & soft with dense pile surface',
        image: 'https://i.pinimg.com/736x/40/34/b7/4034b7d0f17db69c029a3254b7c2ee1e.jpg',
        color: Color(0xFF9C27B0),
        properties: ['Soft', 'Luxurious', 'Warm', 'Drapes well'],
        uses: ['Evening Gowns', 'Curtains', 'Upholstery'],
        care: 'Dry clean recommended',
        popularity: 78,
        subCategories: [
          'Crushed Velvet',
          'Stretch Velvet',
          'Velveteen'
        ],
      ),
      FabricCategory(
        name: 'Denim',
        description: 'Durable cotton twill for casual wear',
        image: 'https://i.pinimg.com/1200x/03/ac/42/03ac42e14326d34aac91f6a829e3f664.jpg',
        color: Color(0xFF3F51B5),
        properties: ['Durable', 'Comfortable', 'Versatile'],
        uses: ['Jeans', 'Jackets', 'Shirts'],
        care: 'Machine washable, may fade',
        popularity: 92,
        subCategories: [
          'Raw Denim',
          'Stretch Denim',
          'Selvedge Denim'
        ],
      ),
      FabricCategory(
        name: 'Jersey',
        description: 'Soft knit fabric with excellent stretch',
        image: 'https://i.pinimg.com/1200x/aa/f3/d3/aaf3d304f25aba8f8257ced58d712f12.jpg',
        color: Color(0xFF4CAF50),
        properties: ['Stretchy', 'Soft', 'Comfortable', 'Breathable'],
        uses: ['T-shirts', 'Dresses', 'Sportswear'],
        care: 'Machine washable, low tumble dry',
        popularity: 87,
        subCategories: [
          'Cotton Jersey',
          'Stretch Jersey',
          'Interlock Jersey'
        ],
      ),
    ];
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  List<FabricCategory> get filteredCategories {
    if (_searchQuery.isEmpty) return fabricCategories;
    return fabricCategories.where((category) =>
      category.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      category.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      category.properties.any((prop) => prop.toLowerCase().contains(_searchQuery.toLowerCase()))
    ).toList();
  }

  void _showCategoryDetails(FabricCategory category, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CategoryDetailSheet(
        category: category,
        index: index,
        primaryColor: primaryColor,
        accentColor: accentColor,
        cardColor: cardColor,
        textPrimary: textPrimary,
        textSecondary: textSecondary,
      ),
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Background decorative elements
          Positioned(
            top: -100,
            right: -100,
            child: AnimatedBuilder(
              animation: _rotationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationController.value * 2 * math.pi,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [primaryColor.withOpacity(0.1), Colors.transparent],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withOpacity(0.05),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                _buildSearchBar(),
                _buildCategoryStats(),
                Expanded(
                  child: _buildCategoryList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(0, -1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: Curves.elasticOut,
      )),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: primaryColor),
              onPressed: () => Navigator.pop(context),
            ),
            Column(
              children: [
                Text(
                  'Fabric Categories',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                Text(
                  'Discover Perfect Materials',
                  style: GoogleFonts.poppins(
                    color: textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.filter_list_rounded, color: primaryColor),
              onPressed: _showFilterOptions,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return FadeTransition(
      opacity: _fadeController,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, -0.5),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _slideController,
          curve: Curves.easeOutCubic,
        )),
        child: Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: accentColor, size: 24),
              SizedBox(width: 12),
              Expanded(
                child: TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: "Search fabrics...",
                    hintStyle: GoogleFonts.poppins(
                      color: textSecondary,
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              if (_searchQuery.isNotEmpty)
                IconButton(
                  icon: Icon(Icons.clear, color: textSecondary, size: 20),
                  onPressed: () => setState(() => _searchQuery = ''),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryStats() {
    return FadeTransition(
      opacity: _fadeController,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('${fabricCategories.length}', 'Categories', Icons.category_rounded),
            _buildStatItem('8', 'Types', Icons.style_rounded),
            _buildStatItem('95%', 'Popular', Icons.trending_up_rounded),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: primaryColor),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryList() {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollEndNotification) {
          _scaleController.forward();
        }
        return false;
      },
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: filteredCategories.length,
        itemBuilder: (context, index) => _buildCategoryListItem(filteredCategories[index], index),
      ),
    );
  }

  Widget _buildCategoryListItem(FabricCategory category, int index) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.9,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _scaleController,
        curve: Interval(
          index * 0.1,
          1.0,
          curve: Curves.elasticOut,
        ),
      )),
      child: FadeTransition(
        opacity: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: _fadeController,
          curve: Interval(
            index * 0.1,
            1.0,
            curve: Curves.easeIn,
          ),
        )),
        child: Container(
          margin: EdgeInsets.only(bottom: 15),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => _showCategoryDetails(category, index),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        category.color.withOpacity(0.1),
                        category.color.withOpacity(0.05),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Section - Image and Popularity
                        Column(
                          children: [
                            // Circular Image Container
                            Container(
                              width: 60,
                              height: 60,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: category.color.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: category.color.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    category.image,
                                    fit: BoxFit.cover,
                                    width: 44,
                                    height: 44,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              category.color,
                                              category.color.withOpacity(0.6),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              category.color,
                                              category.color.withOpacity(0.6),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        // child: Icon(
                                        //  // Icons.fabric,
                                        //   color: Colors.white,
                                        //   size: 20,
                                        // ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: category.popularity > 85 ? accentColor.withOpacity(0.2) : textSecondary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.star, size: 12, color: accentColor),
                                  SizedBox(width: 4),
                                  Text(
                                    '${category.popularity}%',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(width: 16),
                        
                        // Middle Section - Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: textPrimary,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                category.description,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: textSecondary,
                                  height: 1.4,
                                ),
                              ),
                              SizedBox(height: 12),
                              
                              // Properties
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: category.properties.take(3).map((property) => Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: category.color.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: category.color.withOpacity(0.3)),
                                  ),
                                  child: Text(
                                    property,
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: category.color,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                )).toList(),
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(width: 16),
                        
                        // Right Section - Action
                        Column(
                          children: [
                            // View Button
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showFilterOptions() {
    Map<String, dynamic> _selectedFilters = {
      'priceRange': RangeValues(0, 5000),
      'categories': [],
      'colors': [],
      'patterns': [],
      'materials': [],
      'availability': 'all',
      'sortBy': 'popular',
      'rating': 0.0,
      'sustainability': false,
      'discountOnly': false,
    };

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 40,
                  offset: Offset(0, -10),
                ),
              ],
            ),
            child: Column(
              children: [
                // Header with animated handle
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          width: 60,
                          height: 4,
                          decoration: BoxDecoration(
                            color: textSecondary.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(2),
                            gradient: LinearGradient(
                              colors: [primaryColor, accentColor],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Filter & Sort',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: textPrimary,
                            ),
                          ),
                          Row(
                            children: [
                              // Results count badge
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${filteredCategories.length} results',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              GestureDetector(
                                onTap: () {
                                  setModalState(() {
                                    _selectedFilters = {
                                      'priceRange': RangeValues(0, 5000),
                                      'categories': [],
                                      'colors': [],
                                      'patterns': [],
                                      'materials': [],
                                      'availability': 'all',
                                      'sortBy': 'popular',
                                      'rating': 0.0,
                                      'sustainability': false,
                                      'discountOnly': false,
                                    };
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.restart_alt_rounded,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Filter Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Quick Filters Chips
                        _buildQuickFilters(setModalState, _selectedFilters),

                        // Price Range Filter
                        _buildPriceRangeFilter(setModalState, _selectedFilters),

                        // Categories Filter
                        _buildCategoriesFilter(setModalState, _selectedFilters),

                        // Color Filter
                        _buildColorFilter(setModalState, _selectedFilters),

                        // Pattern Filter
                        _buildPatternFilter(setModalState, _selectedFilters),

                        // Advanced Filters
                        _buildAdvancedFilters(setModalState, _selectedFilters),

                        // Sort Options
                        _buildSortOptions(setModalState, _selectedFilters),
                      ],
                    ),
                  ),
                ),

                // Action Buttons
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            side: BorderSide(color: textSecondary.withOpacity(0.3)),
                          ),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: textSecondary,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _applyFilters(_selectedFilters);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                            shadowColor: primaryColor.withOpacity(0.3),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.filter_alt_rounded, size: 20, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Apply Filters',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickFilters(Function setModalState, Map<String, dynamic> filters) {
    final quickFilters = [
      {'icon': Icons.local_fire_department_rounded, 'label': 'Trending', 'key': 'trending'},
      {'icon': Icons.eco_rounded, 'label': 'Eco-Friendly', 'key': 'sustainability'},
      {'icon': Icons.discount_rounded, 'label': 'On Sale', 'key': 'discountOnly'},
      {'icon': Icons.star_rounded, 'label': 'Top Rated', 'key': 'topRated'},
      {'icon': Icons.new_releases_rounded, 'label': 'New Arrivals', 'key': 'newArrivals'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Filters',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: quickFilters.map((filter) {
            final isActive = filters[filter['key']] == true;
            return FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
               //   Icon(filter['icon']!, size: 16),
                  SizedBox(width: 4),
                 // Text(filter['label']!),
                ],
              ),
              selected: isActive,
              onSelected: (selected) {
                setModalState(() {
                //  filters[filter['key']!] = selected;
                });
              },
              backgroundColor: backgroundColor,
              selectedColor: primaryColor.withOpacity(0.15),
              checkmarkColor: primaryColor,
              labelStyle: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isActive ? primaryColor : textSecondary,
              ),
              shape: StadiumBorder(
                side: BorderSide(
                  color: isActive ? primaryColor : Colors.grey.shade300,
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _buildPriceRangeFilter(Function setModalState, Map<String, dynamic> filters) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Price Range',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
            Text(
              '₹${filters['priceRange'].start.round()} - ₹${filters['priceRange'].end.round()}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        RangeSlider(
          values: filters['priceRange'],
          min: 0,
          max: 10000,
          divisions: 20,
          activeColor: primaryColor,
          inactiveColor: Colors.grey.shade300,
          labels: RangeLabels(
            '₹${filters['priceRange'].start.round()}',
            '₹${filters['priceRange'].end.round()}',
          ),
          onChanged: (values) {
            setModalState(() {
              filters['priceRange'] = values;
            });
          },
        ),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _buildCategoriesFilter(Function setModalState, Map<String, dynamic> filters) {
    final categories = ['Cotton', 'Linen', 'Silk', 'Velvet', 'Wool', 'Polyester', 'Denim', 'Chiffon'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fabric Type',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((category) {
            final isSelected = (filters['categories'] as List).contains(category);
            return ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setModalState(() {
                  if (selected) {
                    (filters['categories'] as List).add(category);
                  } else {
                    (filters['categories'] as List).remove(category);
                  }
                });
              },
              backgroundColor: backgroundColor,
              selectedColor: primaryColor.withOpacity(0.15),
              labelStyle: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? primaryColor : textSecondary,
              ),
              shape: StadiumBorder(
                side: BorderSide(
                  color: isSelected ? primaryColor : Colors.grey.shade300,
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _buildColorFilter(Function setModalState, Map<String, dynamic> filters) {
    final colors = [
      {'name': 'White', 'color': Colors.white, 'border': Colors.grey.shade400},
      {'name': 'Black', 'color': Colors.black},
      {'name': 'Red', 'color': Colors.red},
      {'name': 'Blue', 'color': Colors.blue},
      {'name': 'Green', 'color': Colors.green},
      {'name': 'Yellow', 'color': Colors.yellow},
      {'name': 'Purple', 'color': Colors.purple},
      {'name': 'Pink', 'color': Colors.pink},
      {'name': 'Multi', 'color': Colors.transparent, 'gradient': true},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: colors.map((colorData) {
            final isSelected = (filters['colors'] as List).contains(colorData['name']);
            return GestureDetector(
              onTap: () {
                setModalState(() {
                  if (isSelected) {
                    (filters['colors'] as List).remove(colorData['name']);
                  } else {
                    (filters['colors'] as List).add(colorData['name']!);
                  }
                });
              },
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                 // color: colorData['gradient'] == true ? null : colorData['color'],
                  gradient: colorData['gradient'] == true 
                      ? LinearGradient(
                          colors: [Colors.red, Colors.blue, Colors.green],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  shape: BoxShape.circle,
                  border: Border.all(
                  //  color: isSelected ? primaryColor : (colorData['border'] ?? colorData['color']!),
                    width: isSelected ? 3 : 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: colorData['gradient'] == true
                    ? Center(
                        child: Text(
                          '🌈',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _buildPatternFilter(Function setModalState, Map<String, dynamic> filters) {
    final patterns = [
      {'name': 'Solid', 'emoji': '🔲'},
      {'name': 'Striped', 'emoji': '💈'},
      {'name': 'Floral', 'emoji': '🌺'},
      {'name': 'Geometric', 'emoji': '🔷'},
      {'name': 'Plaid', 'emoji': '🎯'},
      {'name': 'Polka Dot', 'emoji': '⭕'},
      {'name': 'Animal Print', 'emoji': '🐆'},
      {'name': 'Abstract', 'emoji': '🎨'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pattern',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: patterns.map((pattern) {
            final isSelected = (filters['patterns'] as List).contains(pattern['name']);
            return FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(pattern['emoji']!),
                  SizedBox(width: 6),
                  Text(pattern['name']!),
                ],
              ),
              selected: isSelected,
              onSelected: (selected) {
                setModalState(() {
                  if (selected) {
                    (filters['patterns'] as List).add(pattern['name']!);
                  } else {
                    (filters['patterns'] as List).remove(pattern['name']!);
                  }
                });
              },
              backgroundColor: backgroundColor,
              selectedColor: primaryColor.withOpacity(0.15),
              checkmarkColor: primaryColor,
              labelStyle: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? primaryColor : textSecondary,
              ),
              shape: StadiumBorder(
                side: BorderSide(
                  color: isSelected ? primaryColor : Colors.grey.shade300,
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _buildAdvancedFilters(Function setModalState, Map<String, dynamic> filters) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Advanced Filters',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
        SizedBox(height: 16),
        
        // Rating Filter
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Minimum Rating',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: textPrimary,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '${filters['rating']}+',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Slider(
              value: filters['rating'],
              min: 0,
              max: 5,
              divisions: 5,
              activeColor: Colors.amber,
              inactiveColor: Colors.grey.shade300,
              onChanged: (value) {
                setModalState(() {
                  filters['rating'] = value;
                });
              },
            ),
          ],
        ),
        
        SizedBox(height: 20),
        
        // Toggle Filters
        Column(
          children: [
            _buildToggleFilter(
              'Sustainable Materials Only',
              filters['sustainability'],
              (value) {
                setModalState(() {
                  filters['sustainability'] = value;
                });
              },
              Icons.eco_rounded,
            ),
            SizedBox(height: 12),
            _buildToggleFilter(
              'Show Only Discounted Items',
              filters['discountOnly'],
              (value) {
                setModalState(() {
                  filters['discountOnly'] = value;
                });
              },
              Icons.discount_rounded,
            ),
          ],
        ),
        
        SizedBox(height: 24),
      ],
    );
  }

  Widget _buildToggleFilter(String title, bool value, Function(bool) onChanged, IconData icon) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18, color: primaryColor),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: textPrimary,
                ),
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: 48,
              height: 28,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: value ? primaryColor : Colors.grey.shade400,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 300),
                    left: value ? 20 : 2,
                    top: 2,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOptions(Function setModalState, Map<String, dynamic> filters) {
    final sortOptions = [
      {'value': 'popular', 'label': 'Most Popular', 'icon': Icons.trending_up_rounded},
      {'value': 'newest', 'label': 'Newest First', 'icon': Icons.new_releases_rounded},
      {'value': 'price_low', 'label': 'Price: Low to High', 'icon': Icons.arrow_upward_rounded},
      {'value': 'price_high', 'label': 'Price: High to Low', 'icon': Icons.arrow_downward_rounded},
      {'value': 'rating', 'label': 'Highest Rated', 'icon': Icons.star_rounded},
      {'value': 'name', 'label': 'Alphabetical', 'icon': Icons.sort_by_alpha_rounded},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sort By',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
        SizedBox(height: 12),
        ...sortOptions.map((option) {
          final isSelected = filters['sortBy'] == option['value'];
          return GestureDetector(
            onTap: () {
              setModalState(() {
                filters['sortBy'] = option['value'];
              });
            },
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 8),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected ? primaryColor.withOpacity(0.1) : backgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? primaryColor : Colors.grey.shade200,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    option['icon'] as IconData,
                    size: 20,
                    color: isSelected ? primaryColor : textSecondary,
                  ),
                  SizedBox(width: 12),
                  Text(
                    option['label'] as String,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? primaryColor : textPrimary,
                    ),
                  ),
                  Spacer(),
                  if (isSelected)
                    Icon(
                      Icons.check_circle_rounded,
                      color: primaryColor,
                      size: 20,
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  void _applyFilters(Map<String, dynamic> filters) {
    // Count active filters
    int activeFilterCount = 0;
    if (filters['priceRange'].start > 0 || filters['priceRange'].end < 10000) activeFilterCount++;
    if ((filters['categories'] as List).isNotEmpty) activeFilterCount++;
    if ((filters['colors'] as List).isNotEmpty) activeFilterCount++;
    if ((filters['patterns'] as List).isNotEmpty) activeFilterCount++;
    if (filters['rating'] > 0) activeFilterCount++;
    if (filters['sustainability']) activeFilterCount++;
    if (filters['discountOnly']) activeFilterCount++;
    
    _showSnackBar(
      '✅ ${activeFilterCount} filter${activeFilterCount == 1 ? '' : 's'} applied successfully!'
    );
    
    // Here you would typically update your data based on filters
    print('Applied filters: $filters');
  }
}