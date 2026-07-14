
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:villageappp/model/home_model.dart';

// class HomeController extends ChangeNotifier {
//   final TickerProvider vsync;
  
//   // Animation controllers
//   late AnimationController floatingController;
//   late AnimationController scaleController;
//   late AnimationController rotationController;
  
//   // Page controller for carousel
//   late PageController pageController;
  
//   // Timer for auto-slide
//   Timer? _autoSlideTimer;
  
//   // Current page index
//   int _currentPage = 0;
//   int get currentPage => _currentPage;
  
//   // Selected navigation index
//   int _selectedNavIndex = 0;
//   int get selectedNavIndex => _selectedNavIndex;
  
//   // Search query
//   String _searchQuery = '';
//   String get searchQuery => _searchQuery;
  
//   // Colors
//   Color primaryWhite = Color(0xFFFAFAFA);
//   Color secondaryWhite = Color(0xFFF5F5F5);
//   Color cardColor = Colors.white;
//   Color accentColor = Color(0xFF667eea);
//   Color textPrimary = Color(0xFF2D3142);
//   Color textSecondary = Color(0xFF9CA3AF);
  
//   // Carousel items
//   List<CarouselItem> carouselItems = [
//     CarouselItem(
//       title: 'Summer Sale',
//       subtitle: 'Up to 50% OFF',
//       image: 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=800',
//       gradient: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
//     ),
//     CarouselItem(
//       title: 'New Arrivals',
//       subtitle: 'Latest Fashion',
//       image: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800',
//       gradient: [Color(0xFF667eea), Color(0xFF764ba2)],
//     ),
//     CarouselItem(
//       title: 'Best Deals',
//       subtitle: 'Limited Time Offer',
//       image: 'https://images.unsplash.com/photo-1472851294608-062f824d29cc?w=800',
//       gradient: [Color(0xFF11998e), Color(0xFF38ef7d)],
//     ),
//   ];
  
//   // Categories
//    final List<Category> categories = [
//     Category(name: 'Men', icon: Icons.person, color: Color(0xFF667EEA), image: '👔'),
//     Category(name: 'Women', icon: Icons.female, color: Color(0xFFF093FB), image: '👗'),
//     Category(name: 'Kids', icon: Icons.child_care, color: Color(0xFF4FACFE), image: '👶'),
//   ];
  
//   // Top shops
//     final List<Shop> topShops = [
//     Shop(name: 'Fashion Hub', rating: 4.9, reviews: '2.3k', image: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=200'),
//     Shop(name: 'Style Studio', rating: 4.8, reviews: '1.8k', image: 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=200'),
//     Shop(name: 'Trend Setters', rating: 4.7, reviews: '1.5k', image: 'https://images.unsplash.com/photo-1469334031218-e382a71b716b?w=200'),
//     Shop(name: 'Elite Boutique', rating: 4.9, reviews: '2.1k', image: 'https://images.unsplash.com/photo-1558769132-cb1f96b8d050?w=200'),
//   ];
  
//   HomeController(this.vsync) {
//     // Initialize animation controllers
//     floatingController = AnimationController(
//       vsync: vsync,
//       duration: Duration(seconds: 3),
//     )..repeat();
    
//     scaleController = AnimationController(
//       vsync: vsync,
//       duration: Duration(seconds: 2),
//     )..repeat(reverse: true);
    
//     rotationController = AnimationController(
//       vsync: vsync,
//       duration: Duration(seconds: 8),
//     )..repeat();
    
//     // Initialize page controller
//     pageController = PageController(viewportFraction: 0.85);
//   }
  
//   void startAutoSlide() {
//     _autoSlideTimer?.cancel();
//     _autoSlideTimer = Timer.periodic(Duration(seconds: 3), (timer) {
//       if (carouselItems.isEmpty) return;
      
//       int nextPage = (_currentPage + 1) % carouselItems.length;
      
//       pageController.animateToPage(
//         nextPage,
//         duration: Duration(milliseconds: 500),
//         curve: Curves.easeInOut,
//       );
//     });
//   }
  
//   void updateCurrentPage(int page) {
//     _currentPage = page;
//     notifyListeners();
//   }
  
//   void updateNavIndex(int index) {
//     _selectedNavIndex = index;
//     notifyListeners();
//   }
  
//   void updateSearchQuery(String query) {
//     _searchQuery = query;
//     notifyListeners();
//   }
  
//   @override
//   void dispose() {
//     _autoSlideTimer?.cancel();
//     floatingController.dispose();
//     scaleController.dispose();
//     rotationController.dispose();
//     pageController.dispose();
//     super.dispose();
//   }
// }