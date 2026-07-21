import 'dart:async';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseauth/TailorSide/model/tailorhome_model.dart';
import 'package:firebaseauth/TailorSide/view/TailorCustomscreen.dart';
import 'package:firebaseauth/TailorSide/view/tailopopular_services.dart';
import 'package:firebaseauth/TailorSide/view/tailorAlternation.dart';
import 'package:firebaseauth/TailorSide/view/tailorDesginScreen.dart' hide TailorService;
import 'package:firebaseauth/TailorSide/view/tailorOrderScreen.dart';
import 'package:firebaseauth/TailorSide/view/tailorReparies.dart';
import 'package:firebaseauth/TailorSide/view/tailor_ProfileScreen.dart';

import 'package:firebaseauth/customerside/components/gradient_scaffold.dart';

import 'package:firebaseauth/customerside/sharedpreferences/hooms_preferences.dart';
import 'package:firebaseauth/message/chat_screen.dart';
import 'package:firebaseauth/message/receiverscreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// 

// // Home Controller for Tailor
class TailorHomeController extends ChangeNotifier {
  final TickerProvider vsync;
  late AnimationController rotationController;
  late AnimationController scaleController;
  late AnimationController floatingController;
  late PageController pageController;
  
  int _currentPage = 0;
  String _searchQuery = '';
  Timer? _autoSlideTimer;

  int get currentPage => _currentPage;
  String get searchQuery => _searchQuery;

  TailorHomeController(this.vsync) {
    rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: vsync,
    )..repeat();

    scaleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: vsync,
    )..repeat(reverse: true);

    floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: vsync,
    )..repeat(reverse: true);

    pageController = PageController(viewportFraction: 0.8);
  }

  void startAutoSlide() {
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (pageController.hasClients) {
        final nextPage = _currentPage + 1;
        pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void updateCurrentPage(int page) {
    _currentPage = page % 3;
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  @override
  void dispose() {
    rotationController.dispose();
    scaleController.dispose();
    floatingController.dispose();
    pageController.dispose();
    _autoSlideTimer?.cancel();
    super.dispose();
  }
}

// Main Tailor Home Screen
class TailorHomeScreen extends StatefulWidget {
  const TailorHomeScreen({Key? key}) : super(key: key);

  @override
  State<TailorHomeScreen> createState() => _TailorHomeScreenState();
}

class _TailorHomeScreenState extends State<TailorHomeScreen> with TickerProviderStateMixin {
  late TailorHomeController _controller;
  int _currentIndex = 0;
  
  // Services
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late SharedPreferencesService _prefsService;
  
  // Data
  List<CarouselItem> _carouselItems = [];
  List<ServiceCategory> _serviceCategories = [];
  List<TailorService> _popularServices = [];
  List<RecentCustomer> _recentCustomers = [];
  List<String> _searchHistory = [];
  String _tailorName = 'Tailor';
  String _shopName = 'My Tailor Shop';
  String _location = 'Pune';
  
  // Stats
  int _pendingOrders = 0;
  int _completedOrders = 0;
  double _totalEarnings = 0.0;
  
  // State
  bool _isLoading = true;
  String _errorMessage = '';
  bool _showSearchHistory = false;

  @override
  void initState() {
    super.initState();
    _controller = TailorHomeController(this);
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      _prefsService = await SharedPreferencesService.getInstance();
      await _loadCachedData();
      _controller.startAutoSlide();
      await _loadTailorData();
      await _loadHomeData();
      await _updateLastAppUsage();
    } catch (e) {
      print('Error initializing app: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to initialize app. Please restart.';
      });
    }
  }

  Future<void> _loadCachedData() async {
    setState(() {
      _tailorName = _prefsService.getUserName();
      _location = _prefsService.getUserLocation();
      _searchHistory = _prefsService.getSearchHistory();
    });
  }

  Future<void> _loadTailorData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final tailorDoc = await _firestore.collection('tailors').doc(user.uid).get();
        if (tailorDoc.exists) {
          final data = tailorDoc.data()!;
          final String tailorName = data['name'] ?? 'Tailor';
          final String shopName = data['shopName'] ?? 'My Tailor Shop';
          final String location = data['location'] ?? 'Pune';
          
          await _prefsService.setUserName(tailorName);
          await _prefsService.setUserLocation(location);
          
          setState(() {
            _tailorName = tailorName;
            _shopName = shopName;
            _location = location;
          });
        }
      }
    } catch (e) {
      print('Error loading tailor data: $e');
      // Continue with cached data
    }
  }

  Future<void> _updateLastAppUsage() async {
    await _prefsService.setLastAppUsage(DateTime.now());
  }

  Future<void> _loadHomeData() async {
    try {
      await Future.wait([
        _loadCarouselItems(),
        _loadServiceCategories(),
        _loadPopularServices(),
        _loadRecentCustomers(),
        _loadStats(),
      ]);
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading home data: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load data. Please check your connection.';
      });
    }
  }

  Future<void> _loadCarouselItems() async {
    try {
      final querySnapshot = await _firestore
          .collection('tailor_carousel')
          .where('isActive', isEqualTo: true)
          .orderBy('order')
          .get();

      _carouselItems = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return CarouselItem(
          title: data['title'] ?? 'Premium Tailoring',
          subtitle: data['subtitle'] ?? 'Custom fits for perfect style',
          image: data['image'] ?? 'https://images.unsplash.com/photo-1594736797933-d0c1382d7c2e',
          action: data['action'] ?? 'explore_services',
        );
      }).toList();

      if (_carouselItems.isEmpty) {
        _carouselItems = _getDefaultCarouselItems();
      }
    } catch (e) {
      print('Error loading carousel: $e');
      _carouselItems = _getDefaultCarouselItems();
    }
  }

  List<CarouselItem> _getDefaultCarouselItems() {
    return [
      CarouselItem(
        title: 'Premium Tailoring',
        subtitle: 'Custom fits for perfect style',
        image: 'https://i.pinimg.com/1200x/34/ec/25/34ec255d9702a04af9e9fc17e8e64049.jpg',
        action: 'explore_services',
      ),
      CarouselItem(
        title: 'Fast Delivery',
        subtitle: 'Quick turnaround on all orders',
        image: 'https://i.pinimg.com/736x/8b/b4/f4/8bb4f43179c783ab2f53ad76b40a0662.jpg',
        action: 'view_orders',
      ),
      CarouselItem(
        title: 'Quality Assurance',
        subtitle: 'Perfect stitching every time',
        image: 'https://i.pinimg.com/1200x/e4/87/2e/e4872e187d5b0d605d1c645d375896e3.jpg',
        action: 'explore_services',
      ),
    ];
  }

  Future<void> _loadServiceCategories() async {
    try {
      final querySnapshot = await _firestore
          .collection('tailor_categories')
          .where('isActive', isEqualTo: true)
          .orderBy('order')
          .get();

      _serviceCategories = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return ServiceCategory(
          name: data['name'] ?? 'Service',
          icon: data['icon'] ?? '✂',
          id: doc.id,
        );
      }).toList();

      if (_serviceCategories.isEmpty) {
        _serviceCategories = _getDefaultServiceCategories();
      }
    } catch (e) {
      print('Error loading categories: $e');
      _serviceCategories = _getDefaultServiceCategories();
    }
  }

  List<ServiceCategory> _getDefaultServiceCategories() {
    return [
      ServiceCategory(name: 'Alteration', icon: '👖', id: 'alteration'),
      ServiceCategory(name: 'Custom', icon: '👔', id: 'custom'),
      ServiceCategory(name: 'Repairs', icon: '🪡', id: 'repairs'),
      ServiceCategory(name: 'Design', icon: '🎨', id: 'design'),
    ];
  }

  Future<void> _loadPopularServices() async {
    try {
      final querySnapshot = await _firestore
          .collection('tailor_services')
          .where('isActive', isEqualTo: true)
          .orderBy('popularity', descending: true)
          .limit(4)
          .get();

      _popularServices = querySnapshot.docs.map((doc) {
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

      if (_popularServices.isEmpty) {
        _popularServices = _getDefaultServices();
      }
    } catch (e) {
      print('Error loading services: $e');
      _popularServices = _getDefaultServices();
    }
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
    ];
  }

  Future<void> _loadRecentCustomers() async {
    try {
      final querySnapshot = await _firestore
          .collection('tailor_orders')
          .where('tailorId', isEqualTo: _auth.currentUser?.uid)
          .orderBy('orderDate', descending: true)
          .limit(5)
          .get();

      _recentCustomers = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return RecentCustomer(
          id: doc.id,
          name: data['customerName'] ?? 'Customer',
          image: data['customerImage'] ?? 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e',
          service: data['serviceName'] ?? 'Tailoring Service',
          status: data['status'] ?? 'In Progress',
          date: (data['orderDate'] as Timestamp).toDate(),
        );
      }).toList();

      if (_recentCustomers.isEmpty) {
        _recentCustomers = _getDefaultCustomers();
      }
    } catch (e) {
      print('Error loading customers: $e');
      _recentCustomers = _getDefaultCustomers();
    }
  }

  List<RecentCustomer> _getDefaultCustomers() {
    return [
      RecentCustomer(
        id: '1',
        name: 'Raj Sharma',
        image: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e',
        service: 'Pant Alteration',
        status: 'Completed',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      RecentCustomer(
        id: '2',
        name: 'Priya Patel',
        image: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80',
        service: 'Dress Fitting',
        status: 'In Progress',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }

  Future<void> _loadStats() async {
    try {
      // Simulate loading stats
      await Future.delayed(const Duration(milliseconds: 500));
      
      setState(() {
        _pendingOrders = 12;
        _completedOrders = 45;
        _totalEarnings = 2345.67;
      });
    } catch (e) {
      print('Error loading stats: $e');
    }
  }

  void _updateSearchQuery(String query) {
    _controller.updateSearchQuery(query);
    
    if (query.trim().isNotEmpty) {
      _prefsService.addToSearchHistory(query.trim());
      setState(() {
        _searchHistory = _prefsService.getSearchHistory();
      });
    }
  }

  void _clearSearchHistory() async {
    await _prefsService.setSearchHistory([]);
    setState(() {
      _searchHistory = [];
    });
  }

  void _refreshData() {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    _loadHomeData();
  }
// In the _TailorHomeScreenState class, update the _navigateToCategory method:

void _navigateToCategory(String categoryName) {
  switch (categoryName) {
    case 'Alteration':
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AlterationsScreen(),
        ),
      );
      break;
    case 'Custom':
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TailorCustomOrdersScreen(),
        ),
      );
      break;
    case 'Repairs':
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RepairsScreen(),
        ),
      );
      break;
    case 'Design':
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DesignScreen(),
        ),
      );
      break;
  }
}

// Also update the navigation for other tabs in _navigateToScreen method:
void _navigateToScreen(int index) {
  setState(() {
    _currentIndex = index;
  });
  
  switch (index) {
    case 0:
      // Already on home screen
      break;
    case 1:
   //  Navigator.push(context, MaterialPageRoute(builder: (context) => const TailorServicesScreen())); // Navigate to services overview or keep on home
      break;
    case 2:
      // Navigate to orders screen (you can create this)
      Navigator.push(context, MaterialPageRoute(builder: (context) =>  OrderScreen(tailorId: "",)));
      break;
    case 3:
      // Navigate to messages screen (you can create this)
       Navigator.push(context, MaterialPageRoute(builder: (context) => const ReceiverScreen()));
      break;
    case 4:
      // Navigate to profile screen (you can create this)
       Navigator.push(context, MaterialPageRoute(builder: (context) => const TailorProfileScreen()));
      break;
  }
}

  // void _navigateToCategory(String categoryName) {
  //   // Navigate to specific service category
  //   // Navigator.push(
  //   //   context,
  //   //   MaterialPageRoute(
  //   //     builder: (context) => AlterationsScreen(initialCategory: categoryName),
  //   //   ),
  //   // );
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, $_tailorName',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                Text(
                  _shopName,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            _buildNotificationIcon(),
          ],
        ),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 20),
              _buildSearchBar(),
              Expanded(
                child: _isLoading
                    ? _buildLoadingState()
                    : _errorMessage.isNotEmpty
                        ? _buildErrorState()
                        : RefreshIndicator(
                            onRefresh: _loadHomeData,
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20),
                                  _buildCarousel(),
                                  const SizedBox(height: 30),
                                  _buildServiceCategories(),
                                  const SizedBox(height: 30),
                                  _buildPopularServices(),
                                  const SizedBox(height: 30),
                                  _buildRecentCustomers(),
                                  const SizedBox(height: 100),
                                ],
                              ),
                            ),
                          ),
              ),
            ],
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: _buildFloatingNavBar(),
          ),
          if (_showSearchHistory && _searchHistory.isNotEmpty)
            _buildSearchHistoryOverlay(),
        ],
      ),
    );
  }

  Widget _buildNotificationIcon() {
    return GestureDetector(
      onTap: () {
      //  Navigator.push(context, MaterialPageRoute(builder: (context) => const TailorNotificationsScreen()));
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('tailor_notifications')
              .where('tailorId', isEqualTo: _auth.currentUser?.uid)
              .where('isRead', isEqualTo: false)
              .snapshots(),
          builder: (context, snapshot) {
            final unreadCount = snapshot.data?.docs.length ?? 0;
            return Stack(
              children: [
                const Icon(
                  Icons.notifications_outlined,
                  size: 24,
                  color: Color(0xFF8075FF),
                ),
                if (unreadCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        unreadCount > 9 ? '9+' : '$unreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Container(
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
              onChanged: _updateSearchQuery,
              onTap: () {
                setState(() {
                  _showSearchHistory = true;
                });
              },
              decoration: InputDecoration(
                hintText: "Search orders, customers...",
                prefixIcon: const Icon(Icons.search, color: Color(0xFF8075FF), size: 24),
                suffixIcon: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8075FF).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.tune, color: Color(0xFF8075FF), size: 20),
                ),
                hintStyle: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontSize: 15,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 17),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchHistoryOverlay() {
    return Positioned(
      top: 130,
      left: 20,
      right: 20,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Searches',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _showSearchHistory = false;
                      });
                    },
                  ),
                ],
              ),
            ),
            ..._searchHistory.map((search) => ListTile(
              leading: const Icon(Icons.history, color: Colors.grey),
              title: Text(search),
              onTap: () {
                _updateSearchQuery(search);
                setState(() {
                  _showSearchHistory = false;
                });
              },
              trailing: IconButton(
                icon: const Icon(Icons.clear, size: 16),
                onPressed: () async {
                  _searchHistory.remove(search);
                  await _prefsService.setSearchHistory(_searchHistory);
                  setState(() {});
                },
              ),
            )).toList(),
            if (_searchHistory.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _clearSearchHistory,
                      child: Text(
                        'Clear All',
                        style: GoogleFonts.poppins(
                          color: Colors.red,
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

  Widget _buildStatsCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Pending Orders',
              '$_pendingOrders',
              Icons.pending_actions,
              Colors.orange,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Completed',
              '$_completedOrders',
              Icons.check_circle,
              Colors.green,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Earnings',
              '₹${_totalEarnings.toStringAsFixed(0)}',
              Icons.attach_money,
              Colors.purple,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[600],
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
          CircularProgressIndicator(
            color: const Color(0xFF8075FF),
          ),
          const SizedBox(height: 20),
          Text(
            'Loading Your Tailor Dashboard...',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.white,
            size: 64,
          ),
          const SizedBox(height: 20),
          Text(
            _errorMessage,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _refreshData,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8075FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text(
              'Try Again',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingNavBar() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_rounded, 'Home', 0),
        //  _buildNavItem(Icons.work_rounded, 'Services', 1),
          _buildNavItem(Icons.shopping_cart_rounded, 'Orders', 2),
          _buildNavItem(Icons.chat_bubble_rounded, 'Messages', 3),
          _buildNavItem(Icons.person_rounded, 'Profile', 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => _navigateToScreen(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF8075FF).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive ? const Color(0xFF8075FF) : Colors.grey.shade600,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                color: isActive ? const Color(0xFF8075FF) : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _controller.pageController,
            itemCount: _carouselItems.length * 10000,
            onPageChanged: _controller.updateCurrentPage,
            itemBuilder: (context, index) {
              final actualIndex = index % _carouselItems.length;
              final item = _carouselItems[actualIndex];
              
              return AnimatedBuilder(
                animation: _controller.pageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_controller.pageController.position.haveDimensions) {
                    value = _controller.pageController.page! - index;
                    value = (1 - (value.abs() * 0.3)).clamp(0.7, 1.0);
                  }
                  return Center(
                    child: SizedBox(
                      height: Curves.easeInOut.transform(value) * 200,
                      child: _buildCarouselCard(item),
                    ),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _carouselItems.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 6,
              width: _controller.currentPage == index ? 24 : 6,
              decoration: BoxDecoration(
                color: _controller.currentPage == index ? const Color(0xFF8075FF) : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCarouselCard(CarouselItem item) {
    return AnimatedBuilder(
      animation: _controller.rotationController,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(math.sin(_controller.rotationController.value * 2 * math.pi) * 0.03),
          alignment: Alignment.center,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8075FF).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                      Color.fromARGB(255, 255, 255, 255),
                      BlendMode.darken,
                    ),
                    child: Image.network(
                      item.image,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [const Color(0xFF8075FF), const Color(0xFF8075FF).withOpacity(0.7)],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                
                Positioned(
                  right: 20,
                  top: 20,
                  child: AnimatedBuilder(
                    animation: _controller.rotationController,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _controller.rotationController.value * 2 * math.pi,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _controller.scaleController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, math.sin(_controller.scaleController.value * 2 * math.pi) * 2),
                            child: Text(
                              item.title,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  const Shadow(
                                    color: Colors.black,
                                    blurRadius: 10,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.subtitle,
                        style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 15),
                      AnimatedBuilder(
                        animation: _controller.scaleController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: 1 + _controller.scaleController.value * 0.1,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Text(
                                'Explore Now',
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFF8075FF),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildServiceCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Service Categories',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _serviceCategories.map((cat) => _buildCategoryCard(cat)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(ServiceCategory category) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        height: 110,
        child: AnimatedBuilder(
          animation: _controller.rotationController,
          builder: (context, child) {
            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(math.sin(_controller.rotationController.value * 2 * math.pi + _serviceCategories.indexOf(category) * 0.5) * 0.05),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () => _navigateToCategory(category.name),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            gradient: _getCategoryGradient(category.name),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: _getCategoryShadowColor(category.name),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              category.icon,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category.name,
                          style: GoogleFonts.poppins(
                            color: _getCategoryTextColor(category.name),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  LinearGradient _getCategoryGradient(String categoryName) {
    switch (categoryName) {
      case 'Alteration':
        return const LinearGradient(
          colors: [
            Color(0xFF667eea),
            Color(0xFF764ba2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'Custom':
        return const LinearGradient(
          colors: [
            Color(0xFFf093fb),
            Color(0xFFf5576c),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'Repairs':
        return const LinearGradient(
          colors: [
            Color(0xFF4facfe),
            Color(0xFF00f2fe),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'Design':
        return const LinearGradient(
          colors: [
            Color(0xFF43e97b),
            Color(0xFF38f9d7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return const LinearGradient(
          colors: [
            Color(0xFF8075FF),
            Color(0xFF8075FF),
          ],
        );
    }
  }

  Color _getCategoryShadowColor(String categoryName) {
    switch (categoryName) {
      case 'Alteration':
        return const Color(0xFF667eea).withOpacity(0.3);
      case 'Custom':
        return const Color(0xFFf5576c).withOpacity(0.3);
      case 'Repairs':
        return const Color(0xFF4facfe).withOpacity(0.3);
      case 'Design':
        return const Color(0xFF43e97b).withOpacity(0.3);
      default:
        return const Color(0xFF8075FF).withOpacity(0.3);
    }
  }

  Color _getCategoryTextColor(String categoryName) {
    switch (categoryName) {
      case 'Alteration':
        return const Color(0xFF667eea);
      case 'Custom':
        return const Color(0xFFf5576c);
      case 'Repairs':
        return const Color(0xFF4facfe);
      case 'Design':
        return const Color(0xFF43e97b);
      default:
        return const Color(0xFF8075FF);
    }
  }

Widget _buildPopularServices() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Popular Services',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PopularServicesScreen(),
                  ),
                );
              },
              child: Text(
                'View All',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color(0xFF8075FF),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 15),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: List.generate(
            _popularServices.length,
            (index) => _buildServiceCard(_popularServices[index], index),
          ),
        ),
      ),
    ],
  );
}

  Widget _buildServiceCard(TailorService service, int index) {
    return AnimatedBuilder(
      animation: _controller.floatingController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, math.sin(_controller.floatingController.value * 2 * math.pi + index * 0.5) * 2),
          child: GestureDetector(
            onTap: () {
              // Navigate to service details
            },
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
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
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF8075FF).withOpacity(0.2),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF8075FF).withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              service.image,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                        : null,
                                    color: const Color(0xFF8075FF),
                                    strokeWidth: 2,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        const Color(0xFF8075FF).withOpacity(0.1),
                                        const Color(0xFF8075FF).withOpacity(0.05),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.work_outline,
                                    color: const Color(0xFF8075FF).withOpacity(0.5),
                                    size: 30,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      service.name,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.amber.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.amber.withOpacity(0.2)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.star, color: Colors.amber, size: 14),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${service.rating}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.amber.shade800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                service.description,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                  height: 1.4,
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
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF8075FF).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      service.category,
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        color: const Color(0xFF8075FF),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecentCustomers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Recent Customers',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: List.generate(
              _recentCustomers.length,
              (index) => _buildCustomerCard(_recentCustomers[index], index),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerCard(RecentCustomer customer, int index) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
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
            // Navigate to customer details
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF8075FF).withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.network(
                      customer.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF8075FF),
                          ),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 24,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customer.name,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        customer.service,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(customer.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: _getStatusColor(customer.status).withOpacity(0.2)),
                      ),
                      child: Text(
                        customer.status,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: _getStatusColor(customer.status),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(customer.date),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in progress':
        return Colors.orange;
      case 'pending':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}