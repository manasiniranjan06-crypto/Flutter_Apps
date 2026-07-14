
import 'package:firebaseauth/fabricSide/practice/checkoutpage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class FabricProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> product;
  final Color primaryColor;
  final Color accentColor;
  final Color cardColor;
  final Color textPrimary;
  final Color textSecondary;

  const FabricProductDetailPage({
    super.key,
    required this.product,
    required this.primaryColor,
    required this.accentColor,
    required this.cardColor,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  State<FabricProductDetailPage> createState() => _FabricProductDetailPageState();
}

class _FabricProductDetailPageState extends State<FabricProductDetailPage>
    with TickerProviderStateMixin {
  late AnimationController _fabController;
  late AnimationController _imageController;
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  late PageController _pageController;

  int currentImageIndex = 0;
  double selectedMeters = 1.0;
  String selectedColor = 'Indigo Blue';
  String selectedFinish = 'Matte';
  bool isFavorite = false;
  bool isExpanded = false;
  bool isComparing = false;
  int viewCount = 0;
  double fabricWidth = 44.0; // inches
  double fabricWeight = 250.0; // GSM

  // AR View Feature
  bool showARButton = true;

  // Recently Viewed Timer
  DateTime viewStartTime = DateTime.now();

  // Price Alert Feature
  bool priceAlertEnabled = false;
  double targetPrice = 0;

  // Fabric Care Guide
  bool showCareGuide = false;

  // Fabric Calculator
  bool showCalculator = false;

  // Meter options with price multipliers
  final List<Map<String, dynamic>> meterOptions = [
    {'meters': 0.5, 'label': '½ Meter', 'popular': false},
    {'meters': 1.0, 'label': '1 Meter', 'popular': true},
    {'meters': 1.5, 'label': '1.5 Meters', 'popular': false},
    {'meters': 2.0, 'label': '2 Meters', 'popular': true},
    {'meters': 2.5, 'label': '2.5 Meters', 'popular': false},
    {'meters': 3.0, 'label': '3 Meters', 'popular': false},
    {'meters': 5.0, 'label': '5 Meters', 'popular': true},
  ];

  final List<Map<String, dynamic>> colors = [
    {'name': 'Indigo Blue', 'color': Color(0xFF3F51B5), 'hex': '#3F51B5', 'inStock': true},
    {'name': 'Ruby Red', 'color': Color(0xFFDC143C), 'hex': '#DC143C', 'inStock': true},
    {'name': 'Emerald Green', 'color': Color(0xFF50C878), 'hex': '#50C878', 'inStock': true},
    {'name': 'Golden Yellow', 'color': Color(0xFFFFD700), 'hex': '#FFD700', 'inStock': false},
    {'name': 'Royal Purple', 'color': Color(0xFF7851A9), 'hex': '#7851A9', 'inStock': true},
    {'name': 'Coral Pink', 'color': Color(0xFFFF6F61), 'hex': '#FF6F61', 'inStock': true},
  ];

  final List<String> finishes = ['Matte', 'Glossy', 'Silk Finish', 'Textured'];

  final List<String> productImages = [
    'https://i.pinimg.com/736x/81/bc/aa/81bcaa9ad8ca635fd69a5786f8de8466.jpg',
    'https://i.pinimg.com/1200x/39/e9/4e/39e94e72f1afa31cd91595ba6ee426d5.jpg',
    'https://i.pinimg.com/1200x/4a/9b/83/4a9b8377d56530489133a05d1fcbc03d.jpg',
    'https://i.pinimg.com/1200x/20/45/35/204535b6503c434300d7fedcff66b544.jpg',
  ];

  // Enhanced Reviews
  final List<Map<String, dynamic>> reviews = [
    {
      'name': 'Priya Sharma',
      'rating': 5.0,
      'date': '2 days ago',
      'comment': 'Excellent quality fabric! The texture is amazing and the colors are vibrant. Perfect for my saree project. Ordered 3 meters and it was exactly as shown.',
      'avatar': 'PS',
      'helpful': 24,
      'verified': true,
      'images': ['https://i.pinimg.com/236x/20/45/35/204535b6503c434300d7fedcff66b544.jpg'],
      'meters': '3.0',
      'color': 'Indigo Blue',
    },
    {
      'name': 'Rahul Mehta',
      'rating': 4.5,
      'date': '1 week ago',
      'comment': 'Good product. Delivery was fast and packaging was excellent. The 2-meter piece was perfect for my kurta. Worth the price.',
      'avatar': 'RM',
      'helpful': 15,
      'verified': true,
      'meters': '2.0',
      'color': 'Ruby Red',
    },
    {
      'name': 'Anita Desai',
      'rating': 5.0,
      'date': '2 weeks ago',
      'comment': 'Best fabric for traditional wear. Highly recommended! Bought 5 meters for a full saree and blouse. The quality exceeded my expectations.',
      'avatar': 'AD',
      'helpful': 32,
      'verified': true,
      'images': ['https://i.pinimg.com/236x/4a/9b/83/4a9b8377d56530489133a05d1fcbc03d.jpg'],
      'meters': '5.0',
      'color': 'Royal Purple',
    },
  ];

  final List<Map<String, dynamic>> relatedProducts = List.generate(
    6,
    (index) => {
      'name': 'Premium Fabric ${index + 1}',
      'price': 300 + (index * 75),
      'rating': 4.0 + (index % 5) * 0.2,
      'image': 'https://picsum.photos/seed/${200 + index}/400/500',
      'pricePerMeter': true,
    },
  );

  // FAQ Data
  final List<Map<String, dynamic>> faqs = [
    {
      'question': 'What is the fabric composition?',
      'answer': 'This premium fabric is made from 70% finest cotton and 30% pure silk blend, ensuring both supreme comfort and long-lasting durability. Perfect for traditional and contemporary wear.',
      'expanded': false,
    },
    {
      'question': 'How do I calculate the right amount of fabric?',
      'answer': 'For a saree: 5.5-6 meters, Salwar suit: 2.5 meters, Kurta: 2-2.5 meters, Blouse: 0.75-1 meter. Our fabric calculator can help you determine the exact amount based on your measurements.',
      'expanded': false,
    },
    {
      'question': 'What is your return policy?',
      'answer': '30-day hassle-free returns. If you\'re not satisfied with the fabric quality, return unused fabric in original condition for a full refund. Cut pieces cannot be returned.',
      'expanded': false,
    },
    {
      'question': 'Do you offer bulk discounts?',
      'answer': 'Yes! Orders of 10+ meters get 10% off, 20+ meters get 15% off, and 50+ meters get 20% off. Perfect for boutiques and tailoring businesses.',
      'expanded': false,
    },
    {
      'question': 'Is the fabric pre-washed?',
      'answer': 'No, the fabric comes unwashed. We recommend dry cleaning or gentle hand wash before first use to prevent any shrinkage.',
      'expanded': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _imageController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _shimmerController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
    _pageController = PageController();
    _imageController.forward();

    _incrementViewCount();
  }

  void _incrementViewCount() {
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          viewCount = 127 + math.Random().nextInt(20);
        });
      }
    });
  }

  @override
  void dispose() {
    _fabController.dispose();
    _imageController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    _pageController.dispose();

    final viewDuration = DateTime.now().difference(viewStartTime);
    debugPrint('User viewed product for ${viewDuration.inSeconds} seconds');

    super.dispose();
  }

  double _calculatePrice() {
    return widget.product['price'] * selectedMeters;
  }

  double _calculateOriginalPrice() {
    if (widget.product['discount'] != null) {
      final basePrice = widget.product['price'] / (1 - widget.product['discount']! / 100);
      return basePrice * selectedMeters;
    }
    return _calculatePrice();
  }

  double _calculateSavings() {
    return _calculateOriginalPrice() - _calculatePrice();
  }

  void _addToCart() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAddToCartSheet(),
    );
  }

  void _buyNow() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => CheckoutPagefabric(
    //       product: {
    //         ...widget.product,
    //         'selectedMeters': selectedMeters,
    //         'totalPrice': _calculatePrice(),
    //       },
    //       quantity: 1,
    //       size: '${selectedMeters} Meters',
    //       color: selectedColor,
    //       primaryColor: widget.primaryColor,
    //       accentColor: widget.accentColor,
    //       cardColor: widget.cardColor,
    //       textPrimary: widget.textPrimary,
    //       textSecondary: widget.textSecondary, cartItems: [], total: null, discount: null, deliveryFee: null, tax: null, subtotal: null,
    //     ),
    //   ),
    // );
  }

  void _shareProduct() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildShareSheet(),
    );
  }

  void _setPriceAlert() {
    showDialog(
      context: context,
      builder: (context) => _buildPriceAlertDialog(),
    );
  }

  void _showFabricCalculator() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildFabricCalculatorSheet(),
    );
  }

  void _launchARView() {
    showDialog(
      context: context,
      builder: (context) => _buildARViewDialog(),
    );
  }

  void _askQuestion() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildAskQuestionSheet(),
    );
  }

  void _showOffersDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Available Offers', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildOfferItem('10% off on orders above 10 meters', Icons.local_offer),
            _buildOfferItem('Free delivery on orders above ₹1500', Icons.local_shipping),
            _buildOfferItem('Buy 5 meters Get 0.5 meter Free', Icons.card_giftcard),
            _buildOfferItem('Special discount on bulk orders', Icons.shopping_basket),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferItem(String text, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.green),
          SizedBox(width: 12),
          Expanded(
            child: Text(text, style: GoogleFonts.poppins(fontSize: 13)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.cardColor,
      body: Stack(
        children: [
          CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              _buildSliverAppBar(),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProductInfo(),
                    _buildImageIndicators(),
                    SizedBox(height: 20),
                    _buildQuickActions(),
                    SizedBox(height: 20),
                    _buildMeterSelector(),
                    SizedBox(height: 20),
                    _buildPriceBreakdown(),
                    SizedBox(height: 20),
                    _buildColorSelector(),
                    SizedBox(height: 20),
                    _buildFinishSelector(),
                    SizedBox(height: 20),
                    _buildFabricSpecs(),
                    SizedBox(height: 20),
                    _buildSpecifications(),
                    SizedBox(height: 20),
                    _buildDescriptionSection(),
                    SizedBox(height: 20),
                    _buildFabricCareGuide(),
                    SizedBox(height: 20),
                    _buildDeliveryInfo(),
                    SizedBox(height: 20),
                    _buildRatingsSection(),
                    SizedBox(height: 20),
                    _buildReviewsFilter(),
                    SizedBox(height: 12),
                    _buildReviewsList(),
                    SizedBox(height: 20),
                    _buildFAQSection(),
                    SizedBox(height: 20),
                    _buildRelatedProducts(),
                    SizedBox(height: 20),
                    _buildRecentlyViewed(),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
          _buildBottomBar(),
        ],
      ),
      floatingActionButton: _buildFloatingActions(),
    );
  }

  Widget _buildFloatingActions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Fabric Calculator Button
        FloatingActionButton.extended(
          onPressed: _showFabricCalculator,
          heroTag: 'calculator',
          backgroundColor: Colors.teal,
          icon: Icon(Icons.calculate, color: Colors.white),
          label: Text(
            'Calculator',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 12),
        // AR View Button
        if (showARButton)
          FloatingActionButton.extended(
            onPressed: _launchARView,
            heroTag: 'ar_view',
            backgroundColor: Colors.deepPurple,
            icon: Icon(Icons.view_in_ar, color: Colors.white),
            label: Text(
              'AR View',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        SizedBox(height: 12),
        // Ask Question Button
        FloatingActionButton(
          onPressed: _askQuestion,
          heroTag: 'ask_question',
          backgroundColor: widget.accentColor,
          child: Icon(Icons.question_answer, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      backgroundColor: widget.primaryColor,
      leading: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(Icons.arrow_back, color: widget.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(Icons.share, color: widget.primaryColor),
            onPressed: _shareProduct,
          ),
        ),
        Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : widget.primaryColor,
            ),
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        isFavorite ? 'Added to Wishlist' : 'Removed from Wishlist',
                        style: GoogleFonts.poppins(),
                      ),
                    ],
                  ),
                  backgroundColor: widget.primaryColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  currentImageIndex = index;
                });
              },
              itemCount: productImages.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _showFullScreenImage(index),
                  child: Hero(
                    tag: 'product_${widget.product['id']}_$index',
                    child: Image.network(
                      productImages[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                    Colors.transparent,
                    widget.cardColor.withOpacity(0.8),
                  ],
                ),
              ),
            ),
            // Premium Badge
            Positioned(
              top: 60,
              left: 20,
              child: AnimatedBuilder(
                animation: _shimmerController,
                builder: (context, child) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.amber[700]!,
                          Colors.amber[400]!,
                          Colors.amber[700]!,
                        ],
                        stops: [
                          0.0,
                          _shimmerController.value,
                          1.0,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.6),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.workspace_premium, color: Colors.white, size: 18),
                        SizedBox(width: 4),
                        Text(
                          'PREMIUM',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Discount Badge
            if (widget.product['discount'] != null)
              Positioned(
                bottom: 20,
                left: 20,
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1.0 + (_pulseController.value * 0.1),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.red[700]!, Colors.red[500]!],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.6),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.local_fire_department, color: Colors.white, size: 18),
                            SizedBox(width: 4),
                            Text(
                              '${widget.product['discount']}% OFF',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            // Live View Count
            if (viewCount > 0)
              Positioned(
                bottom: 20,
                right: 20,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.visibility, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text(
                        '$viewCount viewing',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
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

  void _showFullScreenImage(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: PageView.builder(
            controller: PageController(initialPage: index),
            itemCount: productImages.length,
            itemBuilder: (context, i) {
              return InteractiveViewer(
                child: Center(
                  child: Hero(
                    tag: 'product_${widget.product['id']}_$i',
                    child: Image.network(
                      productImages[i],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfo() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: widget.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified, size: 14, color: widget.accentColor),
                    SizedBox(width: 4),
                    Text(
                      'Certified Quality',
                      style: GoogleFonts.poppins(
                        color: widget.accentColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, size: 14, color: Colors.green),
                    SizedBox(width: 4),
                    Text(
                      'In Stock',
                      style: GoogleFonts.poppins(
                        color: Colors.green,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.local_shipping, size: 14, color: Colors.orange),
                    SizedBox(width: 4),
                    Text(
                      'Express Delivery',
                      style: GoogleFonts.poppins(
                        color: Colors.orange,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            widget.product['name'],
            style: GoogleFonts.playfairDisplay(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: widget.textPrimary,
              height: 1.2,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Premium Cotton-Silk Blend • Handcrafted',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: widget.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 18),
                    SizedBox(width: 4),
                    Text(
                      '${widget.product['rating']}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: widget.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              Text(
                '(${widget.product['reviews']} reviews)',
                style: GoogleFonts.poppins(
                  color: widget.textSecondary,
                  fontSize: 14,
                ),
              ),
              Spacer(),
              TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.rate_review_outlined, size: 18),
                label: Text('Write Review'),
                style: TextButton.styleFrom(
                  foregroundColor: widget.primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '₹${widget.product['price'].toStringAsFixed(0)}/meter',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: widget.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '₹${_calculatePrice().toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: widget.primaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 12),
              if (widget.product['discount'] != null) ...[
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '₹${_calculateOriginalPrice().toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          decoration: TextDecoration.lineThrough,
                          color: widget.textSecondary,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Save ₹${_calculateSavings().toStringAsFixed(2)}',
                          style: GoogleFonts.poppins(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 12),
          Text(
            'Inclusive of all taxes • Minimum order: 0.5 meters',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: widget.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageIndicators() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          productImages.length,
          (index) => AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(horizontal: 4),
            width: currentImageIndex == index ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: currentImageIndex == index
                  ? widget.primaryColor
                  : widget.primaryColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              icon: Icons.calculate,
              label: 'Calculator',
              onTap: _showFabricCalculator,
              color: Colors.teal,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              icon: Icons.notifications_active,
              label: 'Price Alert',
              onTap: _setPriceAlert,
              color: Colors.orange,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              icon: Icons.local_offer,
              label: 'Offers',
              onTap: () => _showOffersDialog(),
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeterSelector() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.straighten, color: widget.primaryColor, size: 20),
              SizedBox(width: 8),
              Text(
                'Select Meters',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: widget.textPrimary,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Width: ${fabricWidth.toStringAsFixed(0)}"',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: meterOptions.map((option) {
              final meters = option['meters'];
              final label = option['label'];
              final isPopular = option['popular'] ?? false;
              final isSelected = selectedMeters == meters;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedMeters = meters;
                  });
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(
                                colors: [widget.primaryColor, widget.accentColor],
                              )
                            : null,
                        color: isSelected ? null : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? widget.primaryColor
                              : widget.textSecondary.withOpacity(0.3),
                          width: 2,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: widget.primaryColor.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: Column(
                        children: [
                          Text(
                            label,
                            style: GoogleFonts.poppins(
                              color: isSelected ? Colors.white : widget.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '₹${(widget.product['price'] * meters).toStringAsFixed(0)}',
                            style: GoogleFonts.poppins(
                              color: isSelected
                                  ? Colors.white.withOpacity(0.9)
                                  : widget.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isPopular && !isSelected)
                      Positioned(
                        top: -8,
                        right: -8,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Popular',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 16),
          // Custom meter input
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  widget.primaryColor.withOpacity(0.05),
                  widget.accentColor.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: widget.primaryColor.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.edit, color: widget.primaryColor, size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Need a custom length?',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      color: widget.textPrimary,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _showCustomMeterDialog();
                  },
                  child: Text('Enter'),
                  style: TextButton.styleFrom(
                    foregroundColor: widget.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCustomMeterDialog() {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enter Custom Meters', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Meters',
                suffixText: 'm',
                border: OutlineInputBorder(),
                helperText: 'Minimum: 0.5m, Maximum: 100m',
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final meters = double.tryParse(controller.text);
              if (meters != null && meters >= 0.5 && meters <= 100) {
                setState(() {
                  selectedMeters = meters;
                });
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please enter a valid amount between 0.5 and 100')),
                );
              }
            },
            child: Text('Apply'),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceBreakdown() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green.withOpacity(0.1),
              Colors.blue.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.green.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Price Breakdown',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: widget.textPrimary,
                  ),
                ),
                Icon(Icons.receipt_long, color: widget.primaryColor),
              ],
            ),
            SizedBox(height: 12),
            _buildPriceRow('Base Price', '₹${widget.product['price']}/meter'),
            _buildPriceRow('Selected Quantity', '${selectedMeters} meters'),
            Divider(),
            _buildPriceRow(
              'Subtotal',
              '₹${_calculatePrice().toStringAsFixed(2)}',
              isTotal: true,
            ),
            if (selectedMeters >= 10) ...[
              _buildPriceRow(
                'Bulk Discount (10%)',
                '- ₹${(_calculatePrice() * 0.1).toStringAsFixed(2)}',
                isDiscount: true,
              ),
              Divider(),
              _buildPriceRow(
                'Final Total',
                '₹${(_calculatePrice() * 0.9).toStringAsFixed(2)}',
                isTotal: true,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false, bool isDiscount = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isDiscount ? Colors.green : widget.textPrimary,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isDiscount ? Colors.green : (isTotal ? widget.primaryColor : widget.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorSelector() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.palette, color: widget.primaryColor, size: 20),
              SizedBox(width: 8),
              Text(
                'Select Color',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: widget.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: colors.map((colorData) {
              final isSelected = selectedColor == colorData['name'];
              final inStock = colorData['inStock'] ?? true;
              return GestureDetector(
                onTap: inStock
                    ? () {
                        setState(() {
                          selectedColor = colorData['name'];
                        });
                      }
                    : null,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? widget.primaryColor : Colors.transparent,
                              width: 3,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: widget.primaryColor.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: colorData['color'],
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: (colorData['color'] as Color).withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: isSelected
                                ? Icon(Icons.check, color: Colors.white, size: 24)
                                : null,
                          ),
                        ),
                        if (!inStock)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Transform.rotate(
                                  angle: -0.5,
                                  child: Container(
                                    width: 50,
                                    height: 2,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      colorData['name'],
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: inStock ? widget.textPrimary : widget.textSecondary,
                      ),
                    ),
                    if (!inStock)
                      Text(
                        'Out of Stock',
                        style: GoogleFonts.poppins(
                          fontSize: 9,
                          color: Colors.red,
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: widget.primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: widget.primaryColor.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: colors.firstWhere((c) => c['name'] == selectedColor)['color'],
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Selected: $selectedColor',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: widget.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinishSelector() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.texture, color: widget.primaryColor, size: 20),
              SizedBox(width: 8),
              Text(
                'Select Finish',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: widget.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: finishes.map((finish) {
              final isSelected = selectedFinish == finish;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedFinish = finish;
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? widget.primaryColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? widget.primaryColor
                          : widget.textSecondary.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Text(
                    finish,
                    style: GoogleFonts.poppins(
                      color: isSelected ? Colors.white : widget.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFabricSpecs() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.purple.withOpacity(0.05),
              Colors.pink.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.purple.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fabric Specifications',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: widget.textPrimary,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSpecCard(
                    Icons.width_full,
                    'Width',
                    '${fabricWidth.toStringAsFixed(0)}"',
                    Colors.blue,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildSpecCard(
                    Icons.line_weight,
                    'Weight',
                    '${fabricWeight.toStringAsFixed(0)} GSM',
                    Colors.orange,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildSpecCard(
                    Icons.category,
                    'Type',
                    'Blend',
                    Colors.green,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildSpecCard(
                    Icons.trending_up,
                    'Thread Count',
                    '400 TC',
                    Colors.purple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecCard(IconData icon, String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: widget.textPrimary,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: widget.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecifications() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              widget.primaryColor.withOpacity(0.05),
              widget.accentColor.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.primaryColor.withOpacity(0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detailed Specifications',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: widget.textPrimary,
              ),
            ),
            SizedBox(height: 16),
            _buildSpecRow('Material', '70% Cotton, 30% Silk'),
            _buildSpecRow('Pattern', 'Traditional Handwoven'),
            _buildSpecRow('Care', 'Dry Clean or Hand Wash'),
            _buildSpecRow('Width', '44 inches (112 cm)'),
            _buildSpecRow('Weight', '250 GSM'),
            _buildSpecRow('Origin', 'Handcrafted in India'),
            _buildSpecRow('Thread Count', '400 TC'),
            _buildSpecRow('Color Fastness', 'Grade 4-5'),
            _buildSpecRow('Occasion', 'Formal & Traditional'),
            _buildSpecRow('Season', 'All Season'),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            size: 16,
            color: widget.primaryColor,
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                color: widget.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: GoogleFonts.poppins(
                color: widget.textPrimary,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About This Fabric',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: widget.textPrimary,
            ),
          ),
          SizedBox(height: 12),
          AnimatedCrossFade(
            firstChild: Text(
              'Experience luxury with our premium cotton-silk blend fabric. This exquisite piece combines traditional craftsmanship with modern aesthetics, perfect for creating stunning outfits for any occasion...',
              style: GoogleFonts.poppins(
                color: widget.textPrimary,
                fontSize: 14,
                height: 1.6,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            secondChild: Text(
              'Experience luxury with our premium cotton-silk blend fabric. This exquisite piece combines traditional craftsmanship with modern aesthetics, perfect for creating stunning outfits for any occasion.\n\nHandcrafted by skilled artisans, this fabric features an exceptional 400 thread count and superior 250 GSM weight, ensuring both comfort and durability. The 70% cotton and 30% silk composition offers a perfect balance of breathability and elegance.\n\nIdeal for sarees, salwar suits, kurtas, and other traditional wear, this versatile fabric drapes beautifully and maintains its quality wash after wash. The vibrant colors are achieved through traditional dyeing techniques, ensuring excellent color fastness (Grade 4-5).\n\nWhether you\'re a professional tailor, boutique owner, or passionate home sewer, this fabric will exceed your expectations and bring your creative vision to life.',
              style: GoogleFonts.poppins(
                color: widget.textPrimary,
                fontSize: 14,
                height: 1.6,
              ),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 300),
          ),
          SizedBox(height: 8),
          TextButton.icon(
            onPressed: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
            label: Text(isExpanded ? 'Show Less' : 'Read More'),
            style: TextButton.styleFrom(
              foregroundColor: widget.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFabricCareGuide() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                showCareGuide = !showCareGuide;
              });
            },
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.withOpacity(0.1),
                    Colors.purple.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.cleaning_services, color: Colors.blue, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Fabric Care Guide',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: widget.textPrimary,
                      ),
                    ),
                  ),
                  Icon(
                    showCareGuide ? Icons.expand_less : Icons.expand_more,
                    color: widget.primaryColor,
                  ),
                ],
              ),
            ),
          ),
          if (showCareGuide) ...[
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  _buildCareItem(Icons.wash, 'Washing', 'Hand wash or machine wash on gentle cycle with cold water. Use mild detergent only.'),
                  _buildCareItem(Icons.cleaning_services, 'Bleaching', 'Do not bleach. Avoid harsh chemicals and stain removers.'),
                  _buildCareItem(Icons.dry_cleaning, 'Drying', 'Air dry in shade. Avoid direct sunlight. Do not wring or twist.'),
                  _buildCareItem(Icons.iron, 'Ironing', 'Iron on low to medium heat. Use steam for best results. Iron on reverse side.'),
                  _buildCareItem(Icons.storage, 'Storage', 'Store in cool, dry place. Keep away from moisture and insects.'),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCareItem(IconData icon, String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: widget.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: widget.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.green.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Delivery & Returns',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: widget.textPrimary,
              ),
            ),
            SizedBox(height: 12),
            _buildDeliveryRow(Icons.local_shipping, 'Free Delivery', 'On orders above ₹1500'),
            _buildDeliveryRow(Icons.av_timer, 'Express Delivery', '2-3 business days'),
            _buildDeliveryRow(Icons.assignment_return, 'Easy Returns', '30-day return policy'),
            _buildDeliveryRow(Icons.security, 'Secure Payment', '100% secure transactions'),
            _buildDeliveryRow(Icons.verified_user, 'Quality Assured', 'Certified authentic fabric'),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryRow(IconData icon, String title, String subtitle) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: widget.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: widget.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ratings & Reviews',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: widget.textPrimary,
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      '4.8',
                      style: GoogleFonts.poppins(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: widget.primaryColor,
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(Icons.star, color: Colors.amber, size: 20),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${widget.product['reviews']} reviews',
                      style: GoogleFonts.poppins(
                        color: widget.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    children: [
                      _buildRatingBar(5, 85),
                      _buildRatingBar(4, 12),
                      _buildRatingBar(3, 2),
                      _buildRatingBar(2, 1),
                      _buildRatingBar(1, 0),
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

  Widget _buildRatingBar(int stars, int percentage) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(
            '$stars',
            style: GoogleFonts.poppins(fontSize: 12),
          ),
          Icon(Icons.star, color: Colors.amber, size: 16),
          SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(3),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percentage / 100,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          Text(
            '$percentage%',
            style: GoogleFonts.poppins(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsFilter() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('All Reviews'),
            _buildFilterChip('5 Stars'),
            _buildFilterChip('4 Stars'),
            _buildFilterChip('With Images'),
            _buildFilterChip('Verified Purchase'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: widget.textPrimary,
        ),
      ),
    );
  }

  Widget _buildReviewsList() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: reviews.map((review) => _buildReviewItem(review)).toList(),
      ),
    );
  }

  Widget _buildReviewItem(Map<String, dynamic> review) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: widget.primaryColor,
                child: Text(
                  review['avatar'],
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          review['name'],
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: widget.textPrimary,
                          ),
                        ),
                        if (review['verified'] ?? false) ...[
                          SizedBox(width: 6),
                          Icon(Icons.verified, color: Colors.blue, size: 14),
                        ],
                      ],
                    ),
                    Row(
                      children: [
                        ...List.generate(
                          5,
                          (index) => Icon(
                            Icons.star,
                            color: index < (review['rating'] as double).floor()
                                ? Colors.amber
                                : Colors.grey,
                            size: 16,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          review['date'],
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: widget.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            review['comment'],
            style: GoogleFonts.poppins(
              color: widget.textPrimary,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          if (review['images'] != null) ...[
            SizedBox(height: 12),
            Container(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: review['images'].length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(right: 8),
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(review['images'][index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Quantity: ${review['meters']}m',
                  style: GoogleFonts.poppins(fontSize: 11),
                ),
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Color: ${review['color']}',
                  style: GoogleFonts.poppins(fontSize: 11),
                ),
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.thumb_up, size: 16),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
              Text(
                '${review['helpful']}',
                style: GoogleFonts.poppins(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFAQSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Frequently Asked Questions',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: widget.textPrimary,
            ),
          ),
          SizedBox(height: 16),
          ...faqs.map((faq) => _buildFAQItem(faq)),
        ],
      ),
    );
  }

  Widget _buildFAQItem(Map<String, dynamic> faq) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: widget.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(
          faq['question'],
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color: widget.textPrimary,
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              faq['answer'],
              style: GoogleFonts.poppins(
                color: widget.textSecondary,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedProducts() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Similar Fabrics',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: widget.textPrimary,
            ),
          ),
          SizedBox(height: 16),
          Container(
            height: 240,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: relatedProducts.length,
              itemBuilder: (context, index) {
                final product = relatedProducts[index];
                return Container(
                  width: 160,
                  margin: EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: widget.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.network(
                          product['image'],
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['name'],
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: widget.textPrimary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                ...List.generate(
                                  5,
                                  (starIndex) => Icon(
                                    Icons.star,
                                    size: 12,
                                    color: starIndex < (product['rating'] as double).floor()
                                        ? Colors.amber
                                        : Colors.grey,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '${product['rating']}',
                                  style: GoogleFonts.poppins(fontSize: 10),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(
                              '₹${product['price']}/meter',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: widget.primaryColor,
                                fontSize: 14,
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
          ),
        ],
      ),
    );
  }

  Widget _buildRecentlyViewed() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recently Viewed',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: widget.textPrimary,
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Icon(Icons.history, color: widget.primaryColor),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Based on your browsing history',
                    style: GoogleFonts.poppins(
                      color: widget.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text('View All'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount:',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: widget.textPrimary,
                      ),
                    ),
                    Text(
                      '₹${_calculatePrice().toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: widget.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _addToCart,
                      icon: Icon(Icons.shopping_cart),
                      label: Text('Add to Cart'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _buyNow,
                      icon: Icon(Icons.flash_on),
                      label: Text('Buy Now'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.accentColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
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

  Widget _buildAddToCartSheet() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 20),
          Icon(Icons.check_circle, color: Colors.green, size: 64),
          SizedBox(height: 16),
          Text(
            'Added to Cart!',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: widget.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '${selectedMeters} meters of ${widget.product['name']}',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: widget.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Product successfully added to your shopping cart',
                    style: GoogleFonts.poppins(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Continue Shopping'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _buyNow,
                  child: Text('Checkout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShareSheet() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Share Product',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: widget.textPrimary,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildShareOption(Icons.message, 'Message'),
              _buildShareOption(Icons.email, 'Email'),
              _buildShareOption(Icons.link, 'Copy Link'),
              _buildShareOption(Icons.wechat_sharp, 'WhatsApp'),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildShareOption(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: widget.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: widget.primaryColor, size: 30),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: widget.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceAlertDialog() {
    return AlertDialog(
      title: Text('Set Price Alert', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Get notified when the price drops below your target amount per meter',
            style: GoogleFonts.poppins(fontSize: 14, color: widget.textSecondary),
          ),
          SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              labelText: 'Target Price per Meter',
              prefixText: '₹',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              targetPrice = double.tryParse(value) ?? 0;
            },
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.info, color: Colors.blue, size: 16),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Current price: ₹${widget.product['price']}/meter',
                  style: GoogleFonts.poppins(fontSize: 12, color: widget.textSecondary),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (targetPrice > 0 && targetPrice < widget.product['price']) {
              setState(() {
                priceAlertEnabled = true;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Price alert set for ₹$targetPrice/meter'),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please enter a valid target price below current price'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Text('Set Alert'),
        ),
      ],
    );
  }

  Widget _buildFabricCalculatorSheet() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Fabric Calculator',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: widget.textPrimary,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Calculate the right amount of fabric for your project',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: widget.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildCalculatorOption('Saree', '5.5-6 meters'),
                _buildCalculatorOption('Salwar Suit', '2.5 meters'),
                _buildCalculatorOption('Kurta', '2-2.5 meters'),
                _buildCalculatorOption('Blouse', '0.75-1 meter'),
                _buildCalculatorOption('Lehenga', '3-4 meters'),
              ],
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got it'),
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculatorOption(String item, String meters) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              color: widget.textPrimary,
            ),
          ),
          Text(
            meters,
            style: GoogleFonts.poppins(
              color: widget.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildARViewDialog() {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: widget.cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.view_in_ar, size: 64, color: widget.primaryColor),
            SizedBox(height: 16),
            Text(
              'AR View',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: widget.textPrimary,
              ),
            ),
            SizedBox(height: 12),
           // alignment:Alignment.center,
            Text(
              'Experience this fabric in your space using Augmented Reality',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: widget.textSecondary,
               // textAlign: TextAlign.center,
              ),
            ),
            
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Maybe Later'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Opening AR View...'),
                          backgroundColor: widget.primaryColor,
                        ),
                      );
                    },
                    child: Text('Launch AR'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAskQuestionSheet() {
    final TextEditingController questionController = TextEditingController();
    
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Ask a Question',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: widget.textPrimary,
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: questionController,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Your question about this fabric',
              border: OutlineInputBorder(),
              hintText: 'E.g., Is this fabric suitable for summer wear?',
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (questionController.text.trim().isNotEmpty) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Question submitted successfully!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}