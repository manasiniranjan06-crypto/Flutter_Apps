
import 'dart:async';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseauth/TailorSide/view/tailor_ProfileScreen.dart';
import 'package:firebaseauth/customerside/components/gradient_scaffold.dart';
import 'package:firebaseauth/customerside/models/category_model.dart';
import 'package:firebaseauth/customerside/models/homescreen_model.dart';
import 'package:firebaseauth/customerside/models/shop_model.dart';
import 'package:firebaseauth/customerside/screens/kids_screen.dart';
import 'package:firebaseauth/customerside/screens/mens_screen.dart';
import 'package:firebaseauth/customerside/screens/notifications_screen.dart';
import 'package:firebaseauth/customerside/screens/order_screen.dart';
import 'package:firebaseauth/customerside/screens/profile_screen.dart';
import 'package:firebaseauth/customerside/screens/requestdailogscreen.dart';
import 'package:firebaseauth/customerside/screens/womens_page.dart';
import 'package:firebaseauth/customerside/sharedpreferences/hooms_preferences.dart';
import 'package:firebaseauth/message/Tailor_List_screen_custSide.dart';
import 'package:firebaseauth/message/senderscreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Models
class CarouselItem {
  final String title;
  final String subtitle;
  final String image;
  final String action;

  CarouselItem({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.action,
  });
}

class Category {
  final String name;
  final String image;
  final String id;

  Category({
    required this.name,
    required this.image,
    required this.id,
  });
}

class Shop {
  final String name;
  final String image;
  final double rating;
  final int reviews;
  final double distance;
  final bool isOpen;
  final String category;
  final String id;
  final String description;
  final String address;
  final String shopName;

  Shop({
    required this.name,
    required this.image,
    required this.rating,
    required this.reviews,
    required this.distance,
    required this.isOpen,
    required this.category,
    required this.id,
    required this.description,
    required this.address,
    required this.shopName,
  });
}

// Home Controller
class HomeController extends ChangeNotifier {
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

  HomeController(this.vsync) {
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

// Main Home Screen
class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({Key? key}) : super(key: key);

  @override
  State<CustomerHomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<CustomerHomeScreen> with TickerProviderStateMixin {
  late HomeController _controller;
  int _currentIndex = 0;
  
  // Services
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late SharedPreferencesService _prefsService;
  
  // Data
  List<CarouselItem> _carouselItems = [];
  List<Category> _categories = [];
  List<Shop> _topShops = [];
  List<String> _searchHistory = [];
  String _userName = 'User';
  String _userLocation = 'Pune';
  
  // State
  bool _isLoading = true;
  String _errorMessage = '';
  bool _showSearchHistory = false;

  @override
  void initState() {
    super.initState();
    _controller = HomeController(this);
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      _prefsService = await SharedPreferencesService.getInstance();
      await _loadCachedData();
      _controller.startAutoSlide();
      await _loadUserData();
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
      _userName = _prefsService.getUserName();
      _userLocation = _prefsService.getUserLocation();
      _searchHistory = _prefsService.getSearchHistory();
    });
  }

  Future<void> _loadUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          final data = userDoc.data()!;
          final String userName = data['name'] ?? 'User';
          final String userLocation = data['location'] ?? 'Pune';
          final String userEmail = data['email'] ?? '';
          
          await _prefsService.setUserName(userName);
          await _prefsService.setUserLocation(userLocation);
          await _prefsService.setUserEmail(userEmail);
          
          setState(() {
            _userName = userName;
            _userLocation = userLocation;
          });
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
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
        _loadCategories(),
        _loadTopShops(),
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
          .collection('carousel')
          .where('isActive', isEqualTo: true)
          .orderBy('order')
          .get();

      _carouselItems = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return CarouselItem(
          title: data['title'] ?? 'Summer Collection',
          subtitle: data['subtitle'] ?? 'Discover latest trends',
          image: data['image'] ?? 'https://via.placeholder.com/300',
          action: data['action'] ?? 'shop_now',
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
        title: 'Summer Collection',
        subtitle: 'Discover the latest fashion trends',
        image: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8',
        action: 'shop_now',
      ),
      CarouselItem(
        title: 'Winter Special',
        subtitle: 'Stay warm with our winter collection',
        image: 'https://images.unsplash.com/photo-1441984904996-e0b6ba687e04',
        action: 'shop_now',
      ),
    ];
  }

  Future<void> _loadCategories() async {
    try {
      final querySnapshot = await _firestore
          .collection('categories')
          .where('isActive', isEqualTo: true)
          .orderBy('order')
          .get();

      _categories = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Category(
          name: data['name'] ?? 'Category',
          image: data['icon'] ?? '👕',
          id: doc.id,
        );
      }).toList();

      if (_categories.isEmpty) {
        _categories = _getDefaultCategories();
      }
    } catch (e) {
      print('Error loading categories: $e');
      _categories = _getDefaultCategories();
    }
  }

  List<Category> _getDefaultCategories() {
    return [
      Category(name: 'Men', image: '👔', id: 'men'),
      Category(name: 'Women', image: '👗', id: 'women'),
      Category(name: 'Kids', image: '👶', id: 'kids'),
    ];
  }

  Future<void> _loadTopShops() async {
    try {
      print("🔄 Starting to load shops from Firestore...");
      
      final querySnapshot = await _firestore
          .collection('tailors')
          .limit(10)
          .get();

      print("✅ Found ${querySnapshot.docs.length} tailor documents");

      List<Shop> shops = [];
      
      for (var doc in querySnapshot.docs) {
        try {
          final data = doc.data();
          print("📄 Processing document: ${doc.id}");
          print("📊 Document data: $data");
          
          // Extract data with proper null checks and type conversion
          final String shopName = _getStringField(data, 'shopName', 'Tailor Shop');
          final String ownerName = _getStringField(data, 'name', 'Tailor');
          final String address = _getStringField(data, 'address', 'Address not available');
          final String category = _getStringField(data, 'category', 'General Tailoring');
          final String city = _getStringField(data, 'city', 'City');
          
          // Generate random but consistent values based on document ID
          final random = math.Random(doc.id.hashCode);
          final rating = 4.0 + random.nextDouble() * 0.9; // 4.0 to 4.9
          final reviews = 10 + random.nextInt(100); // 10 to 110
          final distance = 1.0 + random.nextDouble() * 4.0; // 1.0 to 5.0 km
          
          shops.add(Shop(
            id: doc.id,
            name: ownerName,
            shopName: shopName,
            address: address,
            image: 'https://images.unsplash.com/photo-1560493676-04071c5f467b?w=400',
            rating: double.parse(rating.toStringAsFixed(1)),
            reviews: reviews,
            distance: double.parse(distance.toStringAsFixed(1)),
            isOpen: true,
            category: category,
            description: '$shopName in $city - Specializing in $category services',
          ));
          
          print("✅ Added shop: $shopName by $ownerName");
          
        } catch (e) {
          print("❌ Error processing document ${doc.id}: $e");
        }
      }

      print("🎉 Successfully processed ${shops.length} shops");

      setState(() {
        _topShops = shops;
      });

    } catch (e) {
      print("❌ Error loading shops from Firestore: $e");
      // Use default shops as fallback
      _topShops = _getDefaultShops();
    }
  }

  String _getStringField(Map<String, dynamic> data, String field, String defaultValue) {
    try {
      final value = data[field];
      if (value == null) return defaultValue;
      return value.toString().trim().isEmpty ? defaultValue : value.toString();
    } catch (e) {
      return defaultValue;
    }
  }

  List<Shop> _getDefaultShops() {
    return [
      Shop(
        id: '1',
        name: 'John Tailor',
        shopName: 'Fashion Hub',
        address: '123 Main Street, Downtown',
        image: 'https://images.unsplash.com/photo-1560493676-04071c5f467b?w=400',
        rating: 4.5,
        reviews: 120,
        distance: 2.5,
        isOpen: true,
        category: 'Traditional Wear',
        description: 'Premium fashion destination with latest trends',
      ),
      Shop(
        id: '2',
        name: 'Sarah Designer',
        shopName: 'Style Studio',
        address: '456 Fashion Avenue, City Center',
        image: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400',
        rating: 4.3,
        reviews: 89,
        distance: 1.8,
        isOpen: true,
        category: 'Western Wear',
        description: 'Contemporary fashion studio',
      ),
      Shop(
        id: '3',
        name: 'Mike Fashion',
        shopName: 'Trend Setters',
        address: '789 Design Road, Fashion District',
        image: 'https://images.unsplash.com/photo-1469334031218-e382a71b716b?w=400',
        rating: 4.7,
        reviews: 125,
        distance: 1.8,
        isOpen: true,
        category: 'Designer Wear',
        description: 'A premium boutique known for modern tailoring and seasonal trends.',
      ),
      Shop(
        id: '4',
        name: 'Emma Couture',
        shopName: 'Elite Boutique',
        address: '321 Luxury Lane, Premium Plaza',
        image: 'https://images.unsplash.com/photo-1558769132-cb1f96b8d050?w=400',
        rating: 4.9,
        reviews: 210,
        distance: 2.3,
        isOpen: true,
        category: 'Bridal & Wedding',
        description: 'Exclusive collection of handcrafted ethnic and western outfits.',
      ),
    ];
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

  void _navigateToScreen(int index) {
    setState(() {
      _currentIndex = index;
    });
    
    switch (index) {
      case 0:
        break;
      case 1:
        // Navigator.push(context, MaterialPageRoute(builder: (context) => const ShopPage()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const OrdersPage()));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const SenderScreen()));
        break;
      case 4:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
        break;
    }
  }

  void _navigateToCategory(String categoryName) {
    switch (categoryName) {
      case 'Men':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const MensPage()));
        break;
      case 'Women':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const WomensPage()));
        break;
      case 'Kids':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const KidsPage()));
        break;
    }
  }

  // Show request options when shop card is tapped
  void _showRequestOptions(BuildContext context, Shop shop) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Choose Action',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const Divider(height: 1),
              _buildRequestOption(
                icon: Icons.send,
                title: 'Send Request',
                subtitle: 'Send tailoring request to this shop',
                onTap: () => _sendTailorRequest(context, shop),
              ),
              _buildRequestOption(
                icon: Icons.person,
                title: 'View Profile',
                subtitle: 'View shop profile and services',
                onTap: () => _navigateToTailorProfile(shop),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[600],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequestOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF8075FF).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xFF8075FF), size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  // Method to send tailor request
  void _sendTailorRequest(BuildContext context, Shop shop) {
    Navigator.pop(context); // Close the bottom sheet
    
    showDialog(
      context: context,
      builder: (context) => TailorOrderRequestDialog(tailorId: "",tailorName: _userName,),
    );
  }

  // Navigate to tailor profile with the selected shop data
  void _navigateToTailorProfile(Shop shop) {
    Navigator.pop(context); // Close the bottom sheet
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => TailorProfileScreen()
      )
    );
  }

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
                  'Welcome Back, $_userName',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                Text(
                  _userLocation,
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
                                  _buildCategories(),
                                  const SizedBox(height: 30),
                                  _buildTopShops(),
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsPage()));
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
              .collection('notifications')
              .where('userId', isEqualTo: _auth.currentUser?.uid)
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
                hintText: "Search products, brands...",
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
            'Loading Fashion Trends...',
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
                                'Shop Now',
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

  Widget _buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Shop by Category',
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
            children: _categories.map((cat) => _buildCategoryCard(cat)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(Category category) {
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
                ..rotateY(math.sin(_controller.rotationController.value * 2 * math.pi + _categories.indexOf(category) * 0.5) * 0.05),
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
                              category.image,
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
      case 'Men':
        return const LinearGradient(
          colors: [
            Color.fromARGB(255, 37, 115, 179),
            Color(0xFF21CBF3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'Women':
        return const LinearGradient(
          colors: [
            Color.fromARGB(255, 203, 48, 100),
            Color(0xFFFFCDD2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'Kids':
        return const LinearGradient(
          colors: [
            Color.fromARGB(255, 230, 130, 42),
            Color(0xFFFFECB3),
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
      case 'Men':
        return const Color(0xFF2196F3).withOpacity(0.3);
      case 'Women':
        return const Color(0xFFEC407A).withOpacity(0.3);
      case 'Kids':
        return const Color(0xFFFFA000).withOpacity(0.3);
      default:
        return const Color(0xFF8075FF).withOpacity(0.3);
    }
  }

  Color _getCategoryTextColor(String categoryName) {
    switch (categoryName) {
      case 'Men':
        return const Color(0xFF1976D2);
      case 'Women':
        return const Color(0xFFC2185B);
      case 'Kids':
        return const Color(0xFFF57C00);
      default:
        return const Color(0xFF8075FF);
    }
  }

  Widget _buildTopShops() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Top Rated Shops',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                'View All',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color(0xFF8075FF),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: _topShops.isEmpty
                ? [_buildNoShopsFound()]
                : List.generate(
                    _topShops.length,
                    (index) => _buildShopCard(_topShops[index], index),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoShopsFound() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        children: [
          Icon(
            Icons.store_mall_directory_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 10),
          Text(
            'No Shops Found',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Check back later for available tailor shops',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildShopCard(Shop shop, int index) {
    return AnimatedBuilder(
      animation: _controller.floatingController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, math.sin(_controller.floatingController.value * 2 * math.pi + index * 0.5) * 2),
          child: GestureDetector(
            onTap: () {
              // Show request options instead of directly navigating
              _showRequestOptions(context, shop);
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
                              shop.image,
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
                                    Icons.store,
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
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          shop.shopName,
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          'by ${shop.name}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
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
                                          '${shop.rating}',
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
                                shop.description,
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
                                  Icon(Icons.location_on_outlined, size: 14, color: Colors.grey[600]),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      shop.address,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.grey[600],
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
                                  Icon(Icons.people_outline, size: 14, color: Colors.grey[600]),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${shop.reviews} reviews',
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
                                      shop.category,
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        color: const Color(0xFF8075FF),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: shop.isOpen ? Colors.green : Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    shop.isOpen ? 'Open now' : 'Closed',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: shop.isOpen ? Colors.green.shade600 : Colors.red.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${shop.distance} km away',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: Colors.grey[600],
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
}