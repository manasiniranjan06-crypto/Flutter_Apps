import 'dart:async';
import 'package:flutter/material.dart';
import '../models/carousel_model.dart';
import '../models/category_model.dart';
import '../models/shop_model.dart';

class HomeController extends ChangeNotifier {
  final TickerProvider vsync;
  
  // Animation controllers
  late AnimationController floatingController;
  late AnimationController scaleController;
  late AnimationController rotationController;
  
  // Page controller for carousel
  late PageController pageController;
  
  // Timer for auto-slide
  Timer? _autoSlideTimer;
  
  // Current page index
  int _currentPage = 0;
  int get currentPage => _currentPage;
  
  // Selected navigation index
  int _selectedNavIndex = 0;
  int get selectedNavIndex => _selectedNavIndex;
  
  // Search query
  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  
  // Colors
  Color primaryWhite = const Color(0xFFFAFAFA);
  Color secondaryWhite = const Color(0xFFF5F5F5);
  Color cardColor = Colors.white;
  Color accentColor = const Color(0xFF667eea);
  Color textPrimary = const Color(0xFF2D3142);
  Color textSecondary = const Color(0xFF9CA3AF);
  
  // Carousel items
  List<CarouselItem> carouselItems = [
    CarouselItem(
      title: 'Summer Sale',
      subtitle: 'Up to 50% OFF',
      image: 'https://i.pinimg.com/736x/3f/50/dc/3f50dc11de0c352f8ef7d5e046e476ee.jpg',
      gradient: [const Color(0xFFFF6B6B), const Color(0xFFFF8E53)],
    ),
    CarouselItem(
      title: 'New Arrivals',
      subtitle: 'Latest Fashion',
      image: 'https://i.pinimg.com/1200x/df/80/f1/df80f1ce0224da2d93322d0c3d1acd73.jpg',
      gradient: [const Color(0xFF667eea), const Color(0xFF764ba2)],
    ),
    CarouselItem(
      title: 'Best Deals',
      subtitle: 'Limited Time Offer',
      image: 'https://i.pinimg.com/736x/34/ee/42/34ee42435653d071036d878e33ba2535.jpg',
      gradient: [const Color(0xFF11998e), const Color(0xFF38ef7d)],
    ),
  ];
  
  // Categories
  final List<Category> categories = [
    Category(name: 'Men', icon: Icons.person, color: const Color(0xFF667EEA), image: '👔'),
    Category(name: 'Women', icon: Icons.female, color: const Color(0xFFF093FB), image: '👗'),
    Category(name: 'Kids', icon: Icons.child_care, color: const Color(0xFF4FACFE), image: '👶'),
  ];
  
  // Top shops
  final List<HomeShop> topShops = [
    HomeShop(name: 'Fashion Hub', rating: 4.9, reviews: '2.3k', image: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=200'),
    HomeShop(name: 'Style Studio', rating: 4.8, reviews: '1.8k', image: 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=200'),
    HomeShop(name: 'Trend Setters', rating: 4.7, reviews: '1.5k', image: 'https://images.unsplash.com/photo-1469334031218-e382a71b716b?w=200'),
    HomeShop(name: 'Elite Boutique', rating: 4.9, reviews: '2.1k', image: 'https://images.unsplash.com/photo-1558769132-cb1f96b8d050?w=200'),
  ];
  
  HomeController(this.vsync) {
    // Initialize animation controllers
    floatingController = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 3),
    )..repeat();
    
    scaleController = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    rotationController = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 8),
    )..repeat();
    
    // Initialize page controller with infinite scroll capability
    pageController = PageController(viewportFraction: 0.85);
    
    // Set initial page to a large number for infinite loop
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final initialPage = carouselItems.length * 1000;
      pageController.jumpToPage(initialPage);
      _currentPage = initialPage % carouselItems.length;
    });
  }
  
  void startAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (carouselItems.isEmpty) return;
      
      final nextPage = pageController.page!.toInt() + 1;
      
      pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }
  
  void updateCurrentPage(int page) {
    // Calculate the actual page index for the indicator
    _currentPage = page % carouselItems.length;
    notifyListeners();
  }
  
  void updateNavIndex(int index) {
    _selectedNavIndex = index;
    notifyListeners();
  }
  
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
  
  // Navigation methods for different pages
  void navigateToHome() {
    _selectedNavIndex = 0;
    notifyListeners();
  }
  
  void navigateToCategories() {
    _selectedNavIndex = 1;
    notifyListeners();
  }
  
  void navigateToOrders() {
    _selectedNavIndex = 2;
    notifyListeners();
  }
  
  void navigateToFavorites() {
    _selectedNavIndex = 3;
    notifyListeners();
  }
  
  void navigateToProfile() {
    _selectedNavIndex = 4;
    notifyListeners();
  }
  
  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    floatingController.dispose();
    scaleController.dispose();
    rotationController.dispose();
    pageController.dispose();
    super.dispose();
  }
}