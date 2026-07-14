import 'package:firebaseauth/fabricSide/model/fabricmodel.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class FabricController with ChangeNotifier {
  late AnimationController _floatingController;
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late PageController _pageController;

  int _currentPage = 0;
  int _selectedNavIndex = 0;
  String _searchQuery = '';

  // Color Scheme
  final Color primaryColor = Color(0xFF6B4E71);
  final Color accentColor = Color(0xFFD4A574);
  final Color backgroundColor = Color(0xFFFAF9F6);
  final Color cardColor = Colors.white;
  final Color textPrimary = Color(0xFF2C2C2C);
  final Color textSecondary = Color(0xFF757575);
  final Color successColor = Color(0xFF2ECC71);

  // Getters
  int get currentPage => _currentPage;
  int get selectedNavIndex => _selectedNavIndex;
  String get searchQuery => _searchQuery;
  PageController get pageController => _pageController;
  AnimationController get floatingController => _floatingController;
  AnimationController get scaleController => _scaleController;
  AnimationController get rotationController => _rotationController;

  // Data
  final List<FabricCategory2> categories = [
    FabricCategory2(
      name: 'Cotton',
      description: 'Soft & breathable',
      image: 'https://i.pinimg.com/736x/cb/82/33/cb8233606d40d5a7ed9345c888cbe94a.jpg',
      color: Color.fromARGB(255, 139, 195, 74),
    ),
    // ... other categories
  ];

  final List<FeaturedCollection> featuredCollections = [
    FeaturedCollection(
      title: 'Summer Collection',
      subtitle: 'Light & Breezy Fabrics',
      image: 'https://wildlinens.com/cdn/shop/products/tropikala13-1402102.jpg?v=1666708231',
      gradient: [Color.fromARGB(255, 3, 21, 103), Color(0xFF764BA2)],
    ),
    // ... other collections
  ];

  final List<TrendingFabric> trendingFabrics = [
    TrendingFabric(
      name: 'Premium Cotton Voile',
      type: 'Cotton',
      price: '₹450/meter',
      rating: 4.8,
      reviews: 234,
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgb4DGyFqTEQ7SdZBf5N_18cHEwcYuw6XYSQ&s',
    ),
    // ... other trending fabrics
  ];

  void initializeControllers(TickerProvider vsync) {
    _floatingController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: vsync,
    )..repeat();

    _scaleController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: vsync,
    )..repeat();

    _rotationController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: vsync,
    )..repeat();

    _pageController = PageController(viewportFraction: 0.85);

    // Auto-slide for carousel
    Future.delayed(Duration(seconds: 3), _autoSlide);
  }

  void _autoSlide() {
    if (_currentPage < featuredCollections.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      _pageController.animateToPage(
        0,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
    Future.delayed(Duration(seconds: 3), _autoSlide);
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void updateSelectedNavIndex(int index) {
    _selectedNavIndex = index;
    notifyListeners();
  }

  void updateCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void disposeControllers() {
    _floatingController.dispose();
    _scaleController.dispose();
    _rotationController.dispose();
    _pageController.dispose();
  }

  // Image picker methods
  Future<void> pickImageFromGallery() async {
    // Implementation for gallery picker
  }

  Future<void> takePhoto() async {
    // Implementation for camera
  }
}