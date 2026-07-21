import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseauth/TailorSide/model/tailorhome_model.dart';
import 'package:firebaseauth/customerside/components/gradient_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PopularServicesScreen extends StatefulWidget {
  const PopularServicesScreen({Key? key}) : super(key: key);

  @override
  State<PopularServicesScreen> createState() => _PopularServicesScreenState();
}

class _PopularServicesScreenState extends State<PopularServicesScreen>
    with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late AnimationController _animationController;
  final TextEditingController _searchController = TextEditingController();

  List<TailorService> _allServices = [];
  List<TailorService> _filteredServices = [];
  List<String> _categories = ['All', 'Alteration', 'Custom', 'Repairs', 'Design'];
  String _selectedCategory = 'All';
  String _sortBy = 'popularity'; // popularity, price_low, price_high, rating
  bool _isLoading = true;
  bool _isGridView = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _loadServices();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadServices() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final querySnapshot = await _firestore
          .collection('tailor_services')
          .where('isActive', isEqualTo: true)
          .get();

      _allServices = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return TailorService(
          id: doc.id,
          name: data['name'] ?? 'Tailoring Service',
          image: data['image'] ?? 'https://images.unsplash.com/photo-1594736797933-d0c1382d7c2e',
          rating: (data['rating'] ?? 4.5).toDouble(),
          reviews: data['reviewCount'] ?? 0,
          price: (data['price'] ?? 50.0).toDouble(),
          category: data['category'] ?? 'Alteration',
          description: data['description'] ?? 'Professional tailoring service',
          duration: data['duration'] ?? '3-5 days',
        );
      }).toList();

      if (_allServices.isEmpty) {
        _allServices = _getDefaultServices();
      }

      _applyFiltersAndSort();
    } catch (e) {
      print('Error loading services: $e');
      _allServices = _getDefaultServices();
      _applyFiltersAndSort();
    }

    setState(() {
      _isLoading = false;
    });
  }

  List<TailorService> _getDefaultServices() {
    return [
      TailorService(
        id: '1',
        name: 'Pant Alteration',
        image: 'https://images.unsplash.com/photo-1594736797933-d0c1382d7c2e',
        rating: 4.8,
        reviews: 45,
        price: 25.0,
        category: 'Alteration',
        description: 'Professional pant length and width adjustments',
        duration: '2-3 days',
      ),
      TailorService(
        id: '2',
        name: 'Shirt Fitting',
        image: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
        rating: 4.9,
        reviews: 38,
        price: 35.0,
        category: 'Custom',
        description: 'Custom shirt fitting and adjustments',
        duration: '3-4 days',
      ),
      TailorService(
        id: '3',
        name: 'Dress Alteration',
        image: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8',
        rating: 4.7,
        reviews: 52,
        price: 45.0,
        category: 'Alteration',
        description: 'Dress length and fitting adjustments',
        duration: '4-5 days',
      ),
      TailorService(
        id: '4',
        name: 'Suit Customization',
        image: 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea',
        rating: 5.0,
        reviews: 28,
        price: 120.0,
        category: 'Custom',
        description: 'Complete suit fitting and customization',
        duration: '5-7 days',
      ),
      TailorService(
        id: '5',
        name: 'Zipper Replacement',
        image: 'https://images.unsplash.com/photo-1489987707025-afc232f7ea0f',
        rating: 4.6,
        reviews: 62,
        price: 15.0,
        category: 'Repairs',
        description: 'Quick and reliable zipper replacement',
        duration: '1-2 days',
      ),
      TailorService(
        id: '6',
        name: 'Button Fixing',
        image: 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d',
        rating: 4.5,
        reviews: 89,
        price: 10.0,
        category: 'Repairs',
        description: 'Professional button replacement and fixing',
        duration: '1 day',
      ),
      TailorService(
        id: '7',
        name: 'Custom Design',
        image: 'https://images.unsplash.com/photo-1558769132-cb1aea3c1c5d',
        rating: 4.9,
        reviews: 34,
        price: 150.0,
        category: 'Design',
        description: 'Create unique designs from scratch',
        duration: '7-10 days',
      ),
      TailorService(
        id: '8',
        name: 'Embroidery Work',
        image: 'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446',
        rating: 4.8,
        reviews: 41,
        price: 80.0,
        category: 'Design',
        description: 'Intricate embroidery and embellishments',
        duration: '5-7 days',
      ),
    ];
  }

  void _applyFiltersAndSort() {
    List<TailorService> filtered = _allServices;

    // Apply category filter
    if (_selectedCategory != 'All') {
      filtered = filtered
          .where((service) => service.category == _selectedCategory)
          .toList();
    }

    // Apply search filter
    final searchQuery = _searchController.text.toLowerCase();
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((service) {
        return service.name.toLowerCase().contains(searchQuery) ||
            service.description.toLowerCase().contains(searchQuery) ||
            service.category.toLowerCase().contains(searchQuery);
      }).toList();
    }

    // Apply sorting
    switch (_sortBy) {
      case 'price_low':
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'rating':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'popularity':
      default:
        filtered.sort((a, b) => b.reviews.compareTo(a.reviews));
        break;
    }

    setState(() {
      _filteredServices = filtered;
    });
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Sort By',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildSortOption('Popularity', 'popularity', Icons.trending_up),
            _buildSortOption('Price: Low to High', 'price_low', Icons.arrow_upward),
            _buildSortOption('Price: High to Low', 'price_high', Icons.arrow_downward),
            _buildSortOption('Highest Rated', 'rating', Icons.star),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String label, String value, IconData icon) {
    final isSelected = _sortBy == value;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? const Color(0xFF8075FF) : Colors.grey,
      ),
      title: Text(
        label,
        style: GoogleFonts.poppins(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected ? const Color(0xFF8075FF) : Colors.black87,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check, color: Color(0xFF8075FF))
          : null,
      onTap: () {
        setState(() {
          _sortBy = value;
        });
        _applyFiltersAndSort();
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Popular Services',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isGridView ? Icons.view_list : Icons.grid_view,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildSearchBar(),
          const SizedBox(height: 20),
          _buildCategoryFilter(),
          const SizedBox(height: 20),
          _buildResultsHeader(),
          const SizedBox(height: 15),
          Expanded(
            child: _isLoading
                ? _buildLoadingState()
                : _filteredServices.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _loadServices,
                        child: _isGridView
                            ? _buildGridView()
                            : _buildListView(),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) => _applyFiltersAndSort(),
          decoration: InputDecoration(
            hintText: "Search services...",
            prefixIcon: const Icon(Icons.search, color: Color(0xFF8075FF)),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      _searchController.clear();
                      _applyFiltersAndSort();
                    },
                  )
                : null,
            hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 17),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
              _applyFiltersAndSort();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF8075FF)
                    : Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? const Color(0xFF8075FF).withOpacity(0.3)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                category,
                style: GoogleFonts.poppins(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${_filteredServices.length} Services Found',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          GestureDetector(
            onTap: _showSortBottomSheet,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.sort, color: Color(0xFF8075FF), size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'Sort',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF8075FF),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
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

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Color(0xFF8075FF)),
          const SizedBox(height: 20),
          Text(
            'Loading Services...',
            style: GoogleFonts.poppins(color: Colors.white),
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
            color: Colors.white.withOpacity(0.5),
          ),
          const SizedBox(height: 20),
          Text(
            'No Services Found',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Try adjusting your filters or search terms',
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _filteredServices.length,
      itemBuilder: (context, index) {
        return _buildServiceListCard(_filteredServices[index]);
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: _filteredServices.length,
      itemBuilder: (context, index) {
        return _buildServiceGridCard(_filteredServices[index]);
      },
    );
  }

  Widget _buildServiceListCard(TailorService service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Navigate to service details
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Hero(
                  tag: 'service_${service.id}',
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8075FF).withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        service.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFF8075FF).withOpacity(0.1),
                            child: const Icon(
                              Icons.work_outline,
                              color: Color(0xFF8075FF),
                              size: 40,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.name,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        service.description,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.schedule, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            service.duration,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF8075FF).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 12,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '${service.rating}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF8075FF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '₹${service.price}',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF8075FF),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceGridCard(TailorService service) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Navigate to service details
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'service_grid_${service.id}',
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      Image.network(
                        service.image,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 120,
                            color: const Color(0xFF8075FF).withOpacity(0.1),
                            child: const Icon(
                              Icons.work_outline,
                              color: Color(0xFF8075FF),
                              size: 40,
                            ),
                          );
                        },
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star, size: 12, color: Colors.amber),
                              const SizedBox(width: 2),
                              Text(
                                '${service.rating}',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      service.description,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.schedule, size: 12, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            service.duration,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '₹${service.price}',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF8075FF),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}