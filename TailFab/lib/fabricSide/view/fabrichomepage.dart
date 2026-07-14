

  import 'package:firebaseauth/fabricSide/model/fabricmodel.dart';
import 'package:firebaseauth/fabricSide/practice/category.dart';
import 'package:firebaseauth/fabricSide/view/fabricprofile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;



// Main Screen Widget
class fabrichomepage extends StatefulWidget {
  @override
  State<fabrichomepage> createState() => _FabricHomeScreenState();
}

class _FabricHomeScreenState extends State<fabrichomepage> with TickerProviderStateMixin {
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

  // Fabric Categories
  final List<FabricCategory2> categories = [
    FabricCategory2(
      name: 'Cotton',
    //  emoji: '🧵',
      description: 'Soft & breathable',
      image:
          'https://i.pinimg.com/736x/cb/82/33/cb8233606d40d5a7ed9345c888cbe94a.jpg',
      color: Color.fromARGB(255, 139, 195, 74),
    ),
    FabricCategory2(
      name: 'Linen',
     // emoji: '🌾',
      description: 'Natural elegance',
      image: 'https://i.pinimg.com/736x/7f/8d/9b/7f8d9bf7fe5a85d76eda9642d6c821fe.jpg',
      color: Color.fromARGB(255, 139, 195, 74),
    ),
    FabricCategory2(
      name: 'Silk',
     // emoji: '✨',
      description: 'Luxurious shine',
      image: 'https://i.pinimg.com/736x/95/62/6d/95626d5ee08228b7fbda3e20671aa5aa.jpg',
      color: Color.fromARGB(255, 139, 195, 74),
    ),
    FabricCategory2(
      name: 'Velvet',
      //emoji: '💎',
      description: 'Rich texture',
      image: 'https://i.pinimg.com/736x/02/35/a9/0235a90696a824d1dd3aec22a6886694.jpg',
      color: Color.fromARGB(255, 139, 195, 74),
    ),
  ];

  // Featured Collections
  final List<FeaturedCollection> featuredCollections = [
    FeaturedCollection(
      title: 'Summer Collection',
      subtitle: 'Light & Breezy Fabrics',
      image:
          'https://wildlinens.com/cdn/shop/products/tropikala13-1402102.jpg?v=1666708231',
      gradient: [Color.fromARGB(255, 3, 21, 103), Color(0xFF764BA2)],
    ),
    FeaturedCollection(
      title: 'Sustainable Fabrics',
      subtitle: 'Eco-Friendly Choices',
      image:
          'https://cdn.shopify.com/s/files/1/1136/2606/files/organic-fabrics_1024x1024.jpeg?v=1555599389',
      gradient: [Color(0xFF34E89E), Color(0xFF0F3443)],
    ),
    FeaturedCollection(
      title: 'Custom Prints',
      subtitle: 'Unique Designs',
      image:
          'https://www.fabvoguestudio.com/cdn/shop/files/pr-pco-0-ta08633p18-108-white-floral-printed-pure-cotton-fabric-material-1.jpg?v=1756980089',
      gradient: [Color(0xFFF093FB), Color(0xFFF5576C)],
    ),
  ];

  // Trending Fabrics
  final List<TrendingFabric> trendingFabrics = [
    TrendingFabric(
      name: 'Premium Cotton Voile',
      type: 'Cotton',
      price: '₹450/meter',
      rating: 4.8,
      reviews: 234,
      image:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgb4DGyFqTEQ7SdZBf5N_18cHEwcYuw6XYSQ&s',
    ),
    TrendingFabric(
      name: 'Handwoven Linen',
      type: 'Linen',
      price: '₹890/meter',
      rating: 4.9,
      reviews: 189,
      image:
          'https://goswadeshi.in/cdn/shop/files/sl_no-8_yardage.jpg?v=1744372088',
    ),
    TrendingFabric(
      name: 'Silk Satin Supreme',
      type: 'Silk',
      price: '₹1,250/meter',
      rating: 4.7,
      reviews: 156,
      image:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQr1onfJlW-opSpUgkoeE_oofM9sPcBtZGRtw&s',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _scaleController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _rotationController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _pageController = PageController(viewportFraction: 0.85);

    // Auto-slide for carousel
    Future.delayed(Duration(seconds: 3), _autoSlide);
  }

  void _autoSlide() {
    if (!mounted) return;
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

  @override
  void dispose() {
    _floatingController.dispose();
    _scaleController.dispose();
    _rotationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _showSnackBar(
    String message, {
    bool isError = false,
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? Color(0xFFE74C3C) : primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: duration,
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      drawer: _buildSidebar(),
      body: Stack(
        children: [
          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildHeader(),
                  _buildHeroSection(),
                  SizedBox(height: 25),
                  _buildSearchBar(),
                  SizedBox(height: 30),
                  _buildFabricCategories(),
                  SizedBox(height: 30),
                  _buildFeaturedCarousel(),
                  SizedBox(height: 30),
                  _buildTrendingFabrics(),
                  SizedBox(height: 100), // Space for floating nav bar
                ],
              ),
            ),
          ),

          // Floating Navigation Bar
          _buildFloatingNavBar(),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.82,
      decoration: BoxDecoration(
        color: cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 30,
            offset: Offset(5, 0),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Picker Section Only
          Container(
            height: 220,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, Color(0xFF8B6B91), Color(0xFFA78FB8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 0.6, 1.0],
              ),
            ),
            child: Stack(
              children: [
                // Background decorative elements
                Positioned(
                  top: -40,
                  right: -40,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.15),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -50,
                  left: -50,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.12),
                    ),
                  ),
                ),
                Positioned(
                  top: 30,
                  left: 20,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),

                // Profile Content
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          // Profile Picture with Edit Option
                          GestureDetector(
                            onTap: _showProfileImagePicker,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 15,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 32,
                                    backgroundColor: Colors.white.withOpacity(
                                      0.2,
                                    ),
                                    child: CircleAvatar(
                                      radius: 28,
                                      backgroundImage: NetworkImage(
                                        'https://api.dicebear.com/7.x/avataaars/png?seed=Rlexandra&backgroundColor=b6e3f4,c0aede,d1d4f9',
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Rlexandra',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'flexandra@gmail.com',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        size: 12,
                                        color: Colors.amber,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Premium Member',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
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
              ],
            ),
          ),

          // Navigation Items
          Expanded(
            child: Container(
              color: backgroundColor.withOpacity(0.3),
              child: ListView(
                padding: EdgeInsets.only(top: 15, bottom: 20),
                children: [
                  _buildSidebarItem(
                    icon: Icons.home_filled,
                    title: 'Home',
                    isSelected: true,
                    badgeCount: 0,
                    onTap: () {
                      Navigator.pop(context);
                      _showSnackBar(
                        '🏠 Welcome home! Explore our fabric collections',
                      );
                    },
                  ),
                  _buildSidebarItem(
                    icon: Icons.person_rounded,
                    title: 'My Profile',
                    badgeCount: 3,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DynamicProfileScreen(),
                        ),
                      );
                    },
                  ),
                  _buildSidebarItem(
                    icon: Icons.work_history_rounded,
                    title: 'My Vacancy',
                    badgeCount: 2,
                    onTap: () {
                      Navigator.pop(context);
                     // _showSnackBar('💼 Vacancy - Check your job applications');
                    },
                  ),
                  _buildSidebarItem(
                    icon: Icons.chat_bubble_rounded,
                    title: 'Message',
                    badgeCount: 5,
                    onTap: () {
                      Navigator.pop(context);
                      // _showSnackBar(
                      //   '💬 Messages - Connect with fabric experts',
                      // );
                    },
                  ),
                  _buildSidebarItem(
                    icon: Icons.card_membership_rounded,
                    title: 'Subscription',
                    badgeCount: 1,
                    onTap: () {
                      Navigator.pop(context);
                      // _showSnackBar(
                      //   '🎫 Subscription - Premium fabric benefits',
                      // );
                    },
                  ),
                  _buildSidebarItem(
                    icon: Icons.notifications_active_rounded,
                    title: 'Notification',
                    badgeCount: 7,
                    onTap: () {
                      Navigator.pop(context);
                      _showSnackBar(
                        '🔔 Notifications - Stay updated with fabric trends',
                      );
                    },
                  ),
                  _buildSidebarItem(
                    icon: Icons.settings_rounded,
                    title: 'Setting',
                    badgeCount: 0,
                    onTap: () {
                      Navigator.pop(context);
                      _showSnackBar(
                        '⚙️ Settings - Customize your fabric shopping experience',
                      );
                    },
                  ),

                  // Shop Management Section
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 25,
                      top: 25,
                      bottom: 10,
                    ),
                    child: Text(
                      'SHOP MANAGEMENT',
                      style: GoogleFonts.poppins(
                        color: textSecondary.withOpacity(0.7),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),

                  _buildSidebarItem(
                    icon: Icons.inventory_2_rounded,
                    title: 'My Products',
                    badgeCount: 12,
                    onTap: () {
                      Navigator.pop(context);
                      _showSnackBar(
                        '📦 Products - Manage your fabric inventory',
                      );
                    },
                  ),
                  _buildSidebarItem(
                    icon: Icons.analytics_rounded,
                    title: 'Sales Analytics',
                    badgeCount: 0,
                    onTap: () {
                      Navigator.pop(context);
                      _showSnackBar(
                        '📊 Analytics - Track your fabric sales performance',
                      );
                    },
                  ),
                  _buildSidebarItem(
                    icon: Icons.local_shipping_rounded,
                    title: 'Orders & Shipping',
                    badgeCount: 8,
                    onTap: () {
                      Navigator.pop(context);
                      _showSnackBar(
                        '🚚 Orders - Manage fabric deliveries worldwide',
                      );
                    },
                  ),
                  _buildSidebarItem(
                    icon: Icons.people_alt_rounded,
                    title: 'Customers',
                    badgeCount: 0,
                    onTap: () {
                      Navigator.pop(context);
                      _showSnackBar(
                        '👥 Customers - Connect with fabric enthusiasts',
                      );
                    },
                  ),

                  // Support Section
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 25,
                      top: 25,
                      bottom: 10,
                    ),
                    child: Text(
                      'SUPPORT',
                      style: GoogleFonts.poppins(
                        color: textSecondary.withOpacity(0.7),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),

                  _buildSidebarItem(
                    icon: Icons.help_center_rounded,
                    title: 'Help & Support',
                    badgeCount: 0,
                    onTap: () {
                      Navigator.pop(context);
                      _showSnackBar(
                        '❓ Help Center - Get assistance with fabric selection',
                      );
                    },
                  ),
                  _buildSidebarItem(
                    icon: Icons.info_rounded,
                    title: 'About Fabric Haven',
                    badgeCount: 0,
                    onTap: () {
                      Navigator.pop(context);
                      _showSnackBar(
                        'ℹ️ About Us - Learn about our fabric quality promise',
                      );
                    },
                  ),
                  _buildSidebarItem(
                    icon: Icons.contact_support_rounded,
                    title: 'Contact Us',
                    badgeCount: 0,
                    onTap: () {
                      Navigator.pop(context);
                      _showSnackBar(
                        '📞 Contact - Reach our fabric experts directly',
                      );
                    },
                  ),

                  // Quick Stats
                  Container(
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          accentColor.withOpacity(0.1),
                          primaryColor.withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: primaryColor.withOpacity(0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quick Stats',
                          style: GoogleFonts.poppins(
                            color: textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem('1.2K', 'Fabrics'),
                            _buildStatItem('4.9', 'Rating'),
                            _buildStatItem('98%', 'Quality'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Logout Button
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: _buildSidebarItem(
                      icon: Icons.logout_rounded,
                      title: 'Logout',
                      isLogout: true,
                      badgeCount: 0,
                      onTap: () {
                        Navigator.pop(context);
                        _showSnackBar(
                          '👋 Logged out successfully. Visit again for premium fabrics!',
                        );
                      },
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

  // Profile Image Picker Method
  void _showProfileImagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: textSecondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Change Profile Photo',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            _buildImagePickerOption(
              icon: Icons.photo_library_outlined,
              title: 'Choose from Gallery',
              onTap: () {
                Navigator.pop(context);
                _pickImageFromGallery();
              },
            ),
            _buildImagePickerOption(
              icon: Icons.photo_camera_outlined,
              title: 'Take Photo',
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  color: textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePickerOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: primaryColor, size: 24),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Image Picker Methods
  Future<void> _pickImageFromGallery() async {
    _showSnackBar('Opening gallery to select profile picture...');
  }

  Future<void> _takePhoto() async {
    _showSnackBar('Opening camera to take profile picture...');
  }

  Widget _buildSidebarItem({
    required IconData icon,
    required String title,
    bool isSelected = false,
    bool isLogout = false,
    required int badgeCount,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      primaryColor.withOpacity(0.15),
                      primaryColor.withOpacity(0.08),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : null,
            color: isLogout ? Colors.red.withOpacity(0.05) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: isSelected
                ? Border.all(
                    color: primaryColor.withOpacity(0.3),
                    width: 1.5,
                  )
                : (isLogout
                    ? Border.all(color: Colors.red.withOpacity(0.2))
                    : null),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [primaryColor, Color(0xFF8B6B91)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : (isLogout
                          ? LinearGradient(
                              colors: [Colors.red, Colors.redAccent],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : LinearGradient(
                              colors: [
                                textSecondary.withOpacity(0.1),
                                textSecondary.withOpacity(0.05),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )),
                  shape: BoxShape.circle,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ]
                      : (isLogout
                          ? [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                            ]
                          : null),
                ),
                child: Icon(
                  icon,
                  color: isSelected
                      ? Colors.white
                      : (isLogout ? Colors.white : textSecondary),
                  size: 20,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: isLogout
                        ? Colors.red
                        : (isSelected ? primaryColor : textPrimary),
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    letterSpacing: isSelected ? 0.3 : 0.2,
                  ),
                ),
              ),
              if (badgeCount > 0)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : primaryColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.2),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    badgeCount.toString(),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (isSelected && badgeCount == 0)
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.5),
                        blurRadius: 4,
                        offset: Offset(0, 1),
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

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            color: primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 80,
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
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Builder(
                builder: (context) => GestureDetector(
                  onTap: () => Scaffold.of(context).openDrawer(),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Icon(Icons.menu, color: primaryColor, size: 22),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Welcome to',
                    style: GoogleFonts.poppins(
                      color: textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Fabric Haven',
                    style: GoogleFonts.playfairDisplay(
                      color: primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  AnimatedBuilder(
                    animation: _floatingController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          0,
                          math.sin(_floatingController.value * 2 * math.pi) * 3,
                        ),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.favorite_border,
                            size: 22,
                            color: accentColor,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 15),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      size: 22,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      height: 380,
      width: double.infinity,
      child: Stack(
        children: [
          Container(
            height: 380,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://anuprerna-bloomscorp.s3.ap-south-1.amazonaws.com/H5OAU8H4AP6G9GCSHW3JNMA0CJ3502464.jpg',
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          Positioned(
            right: -50,
            top: 30,
            child: AnimatedBuilder(
              animation: _rotationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationController.value * 2 * math.pi,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accentColor.withOpacity(0.2),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _scaleController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(
                        0,
                        math.sin(_scaleController.value * 2 * math.pi) * 3,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Discover Premium',
                            style: GoogleFonts.playfairDisplay(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 15,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Fabrics for Every',
                            style: GoogleFonts.playfairDisplay(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 15,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Creation',
                            style: GoogleFonts.playfairDisplay(
                              color: accentColor,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 15,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 15),
                Text(
                  'From everyday cottons to luxurious silks\nQuality you can feel',
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.95),
                    fontSize: 15,
                    height: 1.6,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AnimatedBuilder(
        animation: _floatingController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              0,
              math.sin(_floatingController.value * 2 * math.pi) * 1.5,
            ),
            child: Container(
              height: 55,
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
              child: TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: "Search fabrics, materials...",
                  prefixIcon: Icon(Icons.search, color: accentColor, size: 24),
                  suffixIcon: Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.tune, color: primaryColor, size: 20),
                  ),
                  hintStyle: GoogleFonts.poppins(
                    color: textSecondary,
                    fontSize: 15,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 17),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFabricCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Fabric Categories',
            style: GoogleFonts.playfairDisplay(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
        ),
        SizedBox(height: 18),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 0.85,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) => _buildCategoryCard(categories[index], index),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(FabricCategory2 category, int index) {
  return AnimatedBuilder(
    animation: _rotationController,
    builder: (context, child) {
      return Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(
            math.sin(_rotationController.value * 2 * math.pi + index * 0.5) * 0.05,
          ),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FabricCategoryScreen(),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: category.color.withOpacity(0.15),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FabricCategoryScreen(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Replaced gradient circle with image
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: category.color.withOpacity(0.3),
                              blurRadius: 15,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.network(
                            category.image,
                            fit: BoxFit.cover,
                            width: 80,
                            height: 80,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      category.color,
                                      category.color.withOpacity(0.6),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      category.color,
                                      category.color.withOpacity(0.6),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.image,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category.name,
                        style: GoogleFonts.poppins(
                          color: textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        category.description,
                        style: GoogleFonts.poppins(
                          color: textSecondary,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                     // const SizedBox(height: 0),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: category.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'View Collection',
                          style: GoogleFonts.poppins(
                            color: category.color,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
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

  Widget _buildFeaturedCarousel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Featured Collections',
            style: GoogleFonts.playfairDisplay(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
        ),
        SizedBox(height: 18),
        Container(
          height: 220,
          child: PageView.builder(
            controller: _pageController,
            itemCount: featuredCollections.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_pageController.position.haveDimensions) {
                    value = _pageController.page! - index;
                    value = (1 - (value.abs() * 0.3)).clamp(0.7, 1.0);
                  }
                  return Center(
                    child: SizedBox(
                      height: Curves.easeInOut.transform(value) * 220,
                      child: child,
                    ),
                  );
                },
                child: _buildFeaturedCard(featuredCollections[index]),
              );
            },
          ),
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            featuredCollections.length,
            (index) => AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 4),
              height: 6,
              width: _currentPage == index ? 24 : 6,
              decoration: BoxDecoration(
                color: _currentPage == index ? primaryColor : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedCard(FeaturedCollection collection) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: collection.gradient.last.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3),
                BlendMode.darken,
              ),
              child: Image.network(
                collection.image,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  collection.title,
                  style: GoogleFonts.playfairDisplay(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  collection.subtitle,
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Explore Now',
                    style: GoogleFonts.poppins(
                      color: collection.gradient.first,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
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

  Widget _buildTrendingFabrics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Trending Now',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              Text(
                'View All',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: accentColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: List.generate(
              trendingFabrics.length,
              (index) => _buildTrendingCard(trendingFabrics[index], index),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingCard(TrendingFabric fabric, int index) {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            0,
            math.sin(_floatingController.value * 2 * math.pi + index * 0.5) * 2,
          ),
          child: Container(
            margin: EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          fabric.image,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fabric.name,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textPrimary,
                              ),
                            ),
                            SizedBox(height: 6),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                fabric.type,
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  '${fabric.rating}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: textPrimary,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '(${fabric.reviews})',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              fabric.price,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: accentColor,
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
          ),
        );
      },
    );
  }

  Widget _buildFloatingNavBar() {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: AnimatedBuilder(
        animation: _floatingController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              0,
              math.sin(_floatingController.value * 2 * math.pi) * 3,
            ),
            child: Container(
              height: 65,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 25,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.home_rounded, 0, () {
                    setState(() => _selectedNavIndex = 0);
                  }),
                  _buildNavItem(Icons.grid_view_rounded, 1, () {
                    setState(() => _selectedNavIndex = 1);
                    _showSnackBar('📁 Exploring fabric categories...');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FabricCategoryScreen(),
                      ),
                    );
                  }),
                  _buildNavItem(Icons.shopping_bag_rounded, 2, () {
                    setState(() => _selectedNavIndex = 2);
                    _showSnackBar('🛍️ Opening shopping bag...');
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, VoidCallback onTap) {
    bool isSelected = _selectedNavIndex == index;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 20 : 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(
          icon,
          color: isSelected ? primaryColor : textSecondary,
          size: 24,
        ),
      ),
    );
  }
}