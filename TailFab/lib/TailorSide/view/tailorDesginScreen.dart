

// TailorSide/view/tailorDesign.dart
import 'package:firebaseauth/TailorSide/model/tailor_designService_model.dart';
import 'package:firebaseauth/TailorSide/view/tailor_desginServ_mange.dart';
import 'package:firebaseauth/TailorSide/view/tailor_desgin_alayticDialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebaseauth/customerside/components/gradient_scaffold.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DesignScreen extends StatefulWidget {
  const DesignScreen({Key? key}) : super(key: key);

  @override
  State<DesignScreen> createState() => _DesignScreenState();
}

class _DesignScreenState extends State<DesignScreen> {
  final List<DesignService> _services = [
    DesignService(
      name: 'Bridal Wear Design',
      startingPrice: 300.0,
      duration: '15-20 days',
      description: 'Custom bridal wear design with intricate embroidery and premium fabrics',
      image: 'https://images.unsplash.com/photo-1595777457583-95e059d581b8',
      complexity: 'High',
      category: DesignCategory.bridal,
      popularity: 4.9,
      features: ['Custom Embroidery', 'Premium Fabrics', 'Multiple Fittings', 'Accessory Matching'],
      materials: ['Silk', 'Zari', 'Sequins', 'Pearls'],
      skillLevel: 'Expert',
      toolsRequired: ['Embroidery Machine', 'Pattern Software', 'Sketch Tools'],
      designTime: '2-3 weeks',
      measurements: ['Full Body', 'Special Requirements'],
      revisions: 3,
    ),
    DesignService(
      name: 'Evening Gown Design',
      startingPrice: 200.0,
      duration: '10-14 days',
      description: 'Elegant evening gowns for special occasions and red carpet events',
      image: 'https://images.unsplash.com/photo-1595777457583-95e059d581b8',
      complexity: 'Medium',
      category: DesignCategory.evening,
      popularity: 4.7,
      features: ['Elegant Draping', 'Luxury Fabrics', 'Perfect Fit', 'Style Consultation'],
      materials: ['Chiffon', 'Satin', 'Lace', 'Beads'],
      skillLevel: 'Advanced',
      toolsRequired: ['Draping Mannequin', 'Sewing Machine', 'Design Software'],
      designTime: '1-2 weeks',
      measurements: ['Standard Body', 'Style Preferences'],
      revisions: 2,
    ),
    DesignService(
      name: 'Traditional Wear Design',
      startingPrice: 150.0,
      duration: '8-12 days',
      description: 'Traditional ethnic wear combining classic patterns with modern aesthetics',
      image: 'https://images.unsplash.com/photo-1585487000120-7cbe0d6bfd6a',
      complexity: 'Medium',
      category: DesignCategory.traditional,
      popularity: 4.8,
      features: ['Traditional Patterns', 'Modern Cuts', 'Comfort Focus', 'Cultural Authenticity'],
      materials: ['Cotton', 'Silk', 'Brocaade', 'Embroidered Fabric'],
      skillLevel: 'Advanced',
      toolsRequired: ['Pattern Tools', 'Traditional Stitching', 'Design Templates'],
      designTime: '1 week',
      measurements: ['Ethnic Wear Specific', 'Comfort Parameters'],
      revisions: 2,
    ),
    DesignService(
      name: 'Custom Suit Design',
      startingPrice: 250.0,
      duration: '12-15 days',
      description: 'Bespoke suit design with premium tailoring and perfect fit guarantee',
      image: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
      complexity: 'High',
      category: DesignCategory.formal,
      popularity: 4.6,
      features: ['Bespoke Tailoring', 'Premium Wool', 'Perfect Fit', 'Style Options'],
      materials: ['Wool', 'Linen', 'Silk Lining', 'Quality Buttons'],
      skillLevel: 'Expert',
      toolsRequired: ['Tailoring Tools', 'Measuring Instruments', 'Fitting Room'],
      designTime: '2 weeks',
      measurements: ['Precision Measurements', 'Posture Analysis'],
      revisions: 3,
    ),
    DesignService(
      name: 'Casual Wear Design',
      startingPrice: 80.0,
      duration: '5-7 days',
      description: 'Trendy casual wear designs for everyday fashion and comfort',
      image: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8',
      complexity: 'Low',
      category: DesignCategory.casual,
      popularity: 4.5,
      features: ['Trendy Designs', 'Comfort Focus', 'Quick Turnaround', 'Style Variety'],
      materials: ['Cotton', 'Denim', 'Knit Fabric', 'Basic Trims'],
      skillLevel: 'Intermediate',
      toolsRequired: ['Basic Sewing', 'Pattern Making', 'Design Sketches'],
      designTime: '3-5 days',
      measurements: ['Standard Sizing', 'Comfort Fit'],
      revisions: 1,
    ),
    DesignService(
      name: 'Fashion Consultation',
      startingPrice: 50.0,
      duration: '2-3 hours',
      description: 'Personal fashion styling consultation and wardrobe planning',
      image: 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea',
      complexity: 'Low',
      category: DesignCategory.consultation,
      popularity: 4.4,
      features: ['Style Analysis', 'Wardrobe Planning', 'Trend Advice', 'Personal Shopping'],
      materials: ['Style Guides', 'Color Palettes', 'Fabric Swatches'],
      skillLevel: 'Expert',
      toolsRequired: ['Style Books', 'Color Wheels', 'Fabric Samples'],
      designTime: 'Immediate',
      measurements: ['Style Preferences', 'Body Type Analysis'],
      revisions: 1,
    ),
  ];

  
  final TextEditingController _searchController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  
  String _searchQuery = '';
  DesignCategory _selectedCategory = DesignCategory.all;
  List<DesignProject> _activeProjects = [];
  double _totalEarnings = 0.0;
  int _completedProjects = 0;
  int _pendingConsultations = 0;
  List<DesignPortfolio> _portfolioItems = [];

  @override
  void initState() {
    super.initState();

    _loadDesignerData();
    _loadPortfolio();
  }

  void _loadDesignerData() {
    setState(() {
      _activeProjects = [
        DesignProject(
          id: 'D001',
          serviceName: 'Bridal Wear Design',
          clientName: 'Sarah Johnson',
          price: 450.0,
          status: DesignProjectStatus.designing,
          deadline: DateTime.now().add(Duration(days: 12)),
          clientPhone: '+1234567890',
          orderDate: DateTime.now().subtract(Duration(days: 3)),
          clientEmail: 'sarah@email.com',
          measurements: {
            'Bust': '34"',
            'Waist': '28"',
            'Hips': '36"',
            'Height': '5\'6"'
          },
          fabricChoice: 'Silk with Zari',
          designNotes: 'Traditional red lehenga with gold embroidery',
          progress: 40,
        ),
        DesignProject(
          id: 'D002',
          serviceName: 'Custom Suit Design',
          clientName: 'Michael Brown',
          price: 300.0,
          status: DesignProjectStatus.measurement,
          deadline: DateTime.now().add(Duration(days: 18)),
          clientPhone: '+0987654321',
          orderDate: DateTime.now().subtract(Duration(days: 1)),
          clientEmail: 'michael@email.com',
          measurements: {
            'Chest': '42"',
            'Waist': '36"',
            'Sleeve': '25"',
            'Height': '6\'0"'
          },
          fabricChoice: 'Premium Wool',
          designNotes: 'Navy blue business suit with peak lapel',
          progress: 20,
        ),
        DesignProject(
          id: 'D003',
          serviceName: 'Evening Gown Design',
          clientName: 'Emma Wilson',
          price: 280.0,
          status: DesignProjectStatus.completed,
          deadline: DateTime.now().add(Duration(days: 2)),
          clientPhone: '+1122334455',
          orderDate: DateTime.now().subtract(Duration(days: 10)),
          clientEmail: 'emma@email.com',
          measurements: {
            'Bust': '32"',
            'Waist': '26"',
            'Hips': '35"',
            'Height': '5\'7"'
          },
          fabricChoice: 'Black Chiffon',
          designNotes: 'Floor-length gown with sequin detailing',
          progress: 100,
        ),
      ];
      _totalEarnings = 3250.0;
      _completedProjects = 28;
      _pendingConsultations = 3;
    });
  }

  void _loadPortfolio() {
    setState(() {
      _portfolioItems = [
        DesignPortfolio(
          id: 'P001',
          title: 'Royal Bridal Collection',
          description: 'Traditional bridal wear with modern elegance',
          images: [
            'https://images.unsplash.com/photo-1595777457583-95e059d581b8',
            'https://images.unsplash.com/photo-1585487000120-7cbe0d6bfd6a',
          ],
          category: DesignCategory.bridal,
          likes: 124,
          completionDate: DateTime.now().subtract(Duration(days: 30)),
        ),
        DesignPortfolio(
          id: 'P002',
          title: 'Urban Formal Wear',
          description: 'Contemporary suits for modern professionals',
          images: [
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
          ],
          category: DesignCategory.formal,
          likes: 89,
          completionDate: DateTime.now().subtract(Duration(days: 15)),
        ),
      ];
    });
  }

  @override
  void dispose() {
   
    _searchController.dispose();
    super.dispose();
  }

  List<DesignService> get _filteredServices {
    return _services.where((service) {
      final matchesSearch = service.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          service.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == DesignCategory.all ||
          service.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Design Studio',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Creative Fashion Design Services',
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          _buildNotificationBadge(),
          IconButton(
            icon: Icon(Icons.dashboard, color: Colors.white, size: 28),
            onPressed: _showDesignDashboard,
          ),
        ],
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                // Designer Dashboard Header
                _buildDesignerDashboard(),
                
                // Quick Stats
                _buildStatsSection(),
                
                // Active Projects Section
                _buildActiveProjectsSection(),
                
                // Portfolio Preview
                _buildPortfolioSection(),
                
                // Search and Filter Section
                _buildSearchFilterSection(),
                
                // Services Grid
                _buildServicesSection(),
                
                SizedBox(height: 20),
              ],
            ),
          ),
          
     
         
        ],
      ),
    );
  }

  Widget _buildDesignerDashboard() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xFF8075FF),
                  child: Icon(Icons.palette, color: Colors.white, size: 30),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, Fashion Designer!',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Design Studio Revenue: ₹$_totalEarnings',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Color(0xFF8075FF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add_photo_alternate, color: Color(0xFF8075FF), size: 32),
                  onPressed: _addToPortfolio,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationBadge() {
    return Stack(
      children: [
        IconButton(
          icon: Icon(Icons.notifications, color: Colors.white, size: 28),
          onPressed: _showDesignNotifications,
        ),
        if (_pendingConsultations > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                _pendingConsultations.toString(),
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStatsSection() {
    final todayEarnings = _calculateTodayEarnings();
    final completionRate = _completedProjects > 0 ? ((_completedProjects / (_completedProjects + _activeProjects.length)) * 100).round() : 0;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildStatCard('Active Projects', _activeProjects.length.toString(), Icons.assignment, Colors.purple)),
              SizedBox(width: 12),
              Expanded(child: _buildStatCard('Today\'s Revenue', '₹$todayEarnings', Icons.attach_money, Colors.green)),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildStatCard('Completion Rate', '$completionRate%', Icons.trending_up, Colors.orange)),
              SizedBox(width: 12),
              Expanded(child: _buildStatCard('Designs', _services.length.toString(), Icons.palette, Colors.pink)),
            ],
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
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
          ),
        ],
      ),
    );
  }

  Widget _buildActiveProjectsSection() {
    final activeProjects = _activeProjects.where((project) => project.status != DesignProjectStatus.completed && project.status != DesignProjectStatus.delivered).toList();
    
    if (activeProjects.isEmpty) return SizedBox();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Active Design Projects',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: _viewAllProjects,
                child: Text(
                  'View All',
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          ...activeProjects.map((project) => _buildProjectCard(project)).toList(),
        ],
      ),
    );
  }

  Widget _buildProjectCard(DesignProject project) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    project.serviceName,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getProjectStatusColor(project.status),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    project.status.name.toUpperCase(),
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Client: ${project.clientName}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            Text(
              'Fabric: ${project.fabricChoice}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            Text(
              'Deadline: ${_formatDeadline(project.deadline)}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            
            // Progress Bar
            SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Progress: ${project.progress}%',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                LinearProgressIndicator(
                  value: project.progress / 100,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(_getProgressColor(project.progress)),
                  borderRadius: BorderRadius.circular(10),
                ),
              ],
            ),
            
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹${project.price}',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8075FF),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.email, size: 20, color: Colors.blue),
                      onPressed: () => _contactClient(project),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, size: 20, color: Colors.orange),
                      onPressed: () => _updateProjectStatus(project),
                    ),
                    IconButton(
                      icon: Icon(Icons.visibility, size: 20, color: Colors.purple),
                      onPressed: () => _viewProjectDetails(project),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPortfolioSection() {
    if (_portfolioItems.isEmpty) return SizedBox();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Design Portfolio',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: _viewFullPortfolio,
                child: Text(
                  'View All',
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _portfolioItems.length,
              itemBuilder: (context, index) {
                return _buildPortfolioItem(_portfolioItems[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioItem(DesignPortfolio portfolio) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Portfolio Image
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              image: DecorationImage(
                image: NetworkImage(portfolio.images.first),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // Portfolio Info
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  portfolio.title,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.favorite, size: 12, color: Colors.pink),
                    SizedBox(width: 4),
                    Text(
                      '${portfolio.likes}',
                      style: GoogleFonts.poppins(fontSize: 10),
                    ),
                    Spacer(),
                    Text(
                      portfolio.category.name,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
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
    );
  }

  Widget _buildSearchFilterSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Design Services',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12),
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search design services...',
                hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
                prefixIcon: Icon(Icons.search, color: Color(0xFF8075FF), size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey, size: 20),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                            _searchController.clear();
                          });
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
          ),
          SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // All Categories Chip
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text('All'),
                    selected: _selectedCategory == DesignCategory.all,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = DesignCategory.all;
                      });
                    },
                    backgroundColor: Colors.white.withOpacity(0.8),
                    selectedColor: Color(0xFF8075FF),
                    checkmarkColor: Colors.white,
                  ),
                ),
                // Category Filters
                ...DesignCategory.values.where((c) => c != DesignCategory.all).map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(category.name),
                      selected: _selectedCategory == category,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = selected ? category : DesignCategory.all;
                        });
                      },
                      backgroundColor: Colors.white.withOpacity(0.8),
                      selectedColor: Color(0xFF8075FF),
                      checkmarkColor: Colors.white,
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

  Widget _buildServicesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Available Design Services',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: Icon(Icons.add_circle, color: Colors.white, size: 24),
                onPressed: _addNewDesignService,
              ),
            ],
          ),
          SizedBox(height: 12),
          _filteredServices.isEmpty
              ? _buildEmptyState()
              : Column(
                  children: _filteredServices.map((service) => _buildServiceCard(service)).toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(DesignService service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            _showServiceManagement(service);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Image and Basic Info
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Service Image
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(service.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    // Service Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  service.name,
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getComplexityColor(service.complexity),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  service.complexity,
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(
                            service.description,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.purple.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  service.category.name,
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: Colors.purple,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.schedule, size: 14, color: Colors.grey[600]),
                              SizedBox(width: 4),
                              Text(
                                service.duration,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
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
                
                SizedBox(height: 12),
                
                // Features and Tools
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    ...service.features.take(2).map((feature) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        feature,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: Colors.blue[800],
                        ),
                      ),
                    )).toList(),
                    ...service.toolsRequired.take(2).map((tool) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tool,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: Colors.green[800],
                        ),
                      ),
                    )).toList(),
                  ],
                ),
                
                SizedBox(height: 12),
                
                // Footer with Price and Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Starting from',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '₹${service.startingPrice}',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8075FF),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, size: 20, color: Colors.blue),
                          onPressed: () => _editDesignService(service),
                        ),
                        IconButton(
                          icon: Icon(Icons.analytics, size: 20, color: Colors.orange),
                          onPressed: () => _showServiceAnalytics(service),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, size: 20, color: Colors.red),
                          onPressed: () => _deleteDesignService(service),
                        ),
                      ],
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

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(Icons.palette, size: 80, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'No design services found',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your search or add new services',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _selectedCategory = DesignCategory.all;
                _searchController.clear();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF8075FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'Reset Filters',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _addNewDesignService,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'Add New Design Service',
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

  // Enhanced Functionality Methods
  void _showServiceManagement(DesignService service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DesignServiceManagementSheet(
          service: service,
          onEdit: () => _editDesignService(service),
          onViewProjects: () => _viewServiceProjects(service),
          onUpdatePrice: () => _updateDesignServicePrice(service),
          onAddToPortfolio: () => _addServiceToPortfolio(service),
          onDelete: () => _deleteDesignService(service),
        );
      },
    );
  }

  void _showDesignDashboard() {
    showDialog(
      context: context,
      builder: (context) => DesignAnalyticsDialog(
        totalEarnings: _totalEarnings,
        activeProjects: _activeProjects.length,
        completedProjects: _completedProjects,
        services: _services,
        portfolioItems: _portfolioItems,
      ),
    );
  }

  void _addNewDesignService() {
    showDialog(
      context: context,
      builder: (context) => AddDesignServiceDialog(
        onAdd: (newService) {
          setState(() {
            _services.add(newService);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('New design service added successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  void _editDesignService(DesignService service) {
    showDialog(
      context: context,
      builder: (context) => EditDesignServiceDialog(
        service: service,
        onUpdate: (updatedService) {
          setState(() {
            final index = _services.indexWhere((s) => s.name == service.name);
            if (index != -1) {
              _services[index] = updatedService;
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Design service updated successfully!'),
              backgroundColor: Colors.blue,
            ),
          );
        },
      ),
    );
  }

  void _deleteDesignService(DesignService service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Design Service'),
        content: Text('Are you sure you want to delete ${service.name}? This will also remove associated projects.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _services.removeWhere((s) => s.name == service.name);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Design service deleted successfully!'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _updateDesignServicePrice(DesignService service) {
    final priceController = TextEditingController(text: service.startingPrice.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Starting Price'),
        content: TextField(
          controller: priceController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'New Starting Price (₹)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newPrice = double.tryParse(priceController.text);
              if (newPrice != null) {
                setState(() {
                  final index = _services.indexWhere((s) => s.name == service.name);
                  if (index != -1) {
                    _services[index] = service.copyWith(startingPrice: newPrice);
                  }
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Price updated successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  void _viewAllProjects() {
    showDialog(
      context: context,
      builder: (context) => AllDesignProjectsDialog(projects: _activeProjects),
    );
  }

  void _viewServiceProjects(DesignService service) {
    final serviceProjects = _activeProjects.where((project) => project.serviceName == service.name).toList();
    showDialog(
      context: context,
      builder: (context) => ServiceDesignProjectsDialog(
        service: service,
        projects: serviceProjects,
      ),
    );
  }

  void _contactClient(DesignProject project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Contact Client'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Client: ${project.clientName}'),
            Text('Email: ${project.clientEmail}'),
            Text('Phone: ${project.clientPhone}'),
            Text('Project: ${project.serviceName}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              // Implement email functionality
              Navigator.pop(context);
            },
            child: Text('Send Email'),
          ),
          ElevatedButton(
            onPressed: () {
              // Implement call functionality
              Navigator.pop(context);
            },
            child: Text('Call Client'),
          ),
        ],
      ),
    );
  }

  void _updateProjectStatus(DesignProject project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Project Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: DesignProjectStatus.values.map((status) {
            return ListTile(
              title: Text(status.name),
              trailing: project.status == status ? Icon(Icons.check, color: Colors.green) : null,
              onTap: () {
                setState(() {
                  final index = _activeProjects.indexWhere((p) => p.id == project.id);
                  if (index != -1) {
                    _activeProjects[index] = project.copyWith(status: status);
                    if (status == DesignProjectStatus.completed) {
                      _completedProjects++;
                    }
                  }
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Project status updated to ${status.name}'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _viewProjectDetails(DesignProject project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Project Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Project ID', project.id),
              _buildDetailRow('Service', project.serviceName),
              _buildDetailRow('Client', project.clientName),
              _buildDetailRow('Email', project.clientEmail),
              _buildDetailRow('Phone', project.clientPhone),
              _buildDetailRow('Price', '₹${project.price}'),
              _buildDetailRow('Status', project.status.name),
              _buildDetailRow('Progress', '${project.progress}%'),
              _buildDetailRow('Fabric Choice', project.fabricChoice),
              _buildDetailRow('Order Date', '${project.orderDate.day}/${project.orderDate.month}/${project.orderDate.year}'),
              _buildDetailRow('Deadline', '${project.deadline.day}/${project.deadline.month}/${project.deadline.year}'),
              SizedBox(height: 10),
              Text(
                'Measurements:',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              ...project.measurements.entries.map((entry) => 
                _buildDetailRow(entry.key, entry.value)
              ).toList(),
              if (project.designNotes.isNotEmpty)
                _buildDetailRow('Design Notes', project.designNotes),
            ],
          ),
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

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showServiceAnalytics(DesignService service) {
    final serviceProjects = _activeProjects.where((project) => project.serviceName == service.name).length;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${service.name} Analytics'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Active Projects', serviceProjects.toString()),
            _buildDetailRow('Starting Price', '₹${service.startingPrice}'),
            _buildDetailRow('Duration', service.duration),
            _buildDetailRow('Complexity', service.complexity),
            _buildDetailRow('Category', service.category.name),
            _buildDetailRow('Skill Level', service.skillLevel),
            _buildDetailRow('Design Time', service.designTime),
            _buildDetailRow('Revisions Included', service.revisions.toString()),
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

  void _showDesignNotifications() {
    final pendingProjects = _activeProjects.where((project) => project.status == DesignProjectStatus.consultation).toList();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Design Notifications (${pendingProjects.length + _pendingConsultations})'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_pendingConsultations > 0)
              ListTile(
                leading: Icon(Icons.people, color: Colors.pink),
                title: Text('$_pendingConsultations Pending Consultations'),
                subtitle: Text('New client consultations awaiting response'),
              ),
            ...pendingProjects.take(3).map((project) => ListTile(
              leading: Icon(Icons.assignment, color: Colors.orange),
              title: Text(project.serviceName),
              subtitle: Text('Client: ${project.clientName}'),
              trailing: Text('₹${project.price}'),
            )).toList(),
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

  void _addToPortfolio() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add to Portfolio'),
        content: Text('Feature coming soon: Upload your design work to showcase in portfolio'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _addServiceToPortfolio(DesignService service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Service to Portfolio'),
        content: Text('Add ${service.name} as a portfolio item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newPortfolio = DesignPortfolio(
                id: 'P${_portfolioItems.length + 1}',
                title: service.name,
                description: service.description,
                images: [service.image],
                category: service.category,
                likes: 0,
                completionDate: DateTime.now(),
              );
              setState(() {
                _portfolioItems.add(newPortfolio);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Service added to portfolio!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text('Add to Portfolio'),
          ),
        ],
      ),
    );
  }

  void _viewFullPortfolio() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Design Portfolio'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: _portfolioItems.isEmpty
              ? Center(child: Text('No portfolio items yet'))
              : ListView.builder(
                  itemCount: _portfolioItems.length,
                  itemBuilder: (context, index) {
                    final item = _portfolioItems[index];
                    return Card(
                      child: ListTile(
                        leading: Image.network(item.images.first, width: 50, height: 50, fit: BoxFit.cover),
                        title: Text(item.title),
                        subtitle: Text(item.category.name),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.favorite, size: 16, color: Colors.pink),
                            Text('${item.likes}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
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

  // Utility Methods
  Color _getProjectStatusColor(DesignProjectStatus status) {
    switch (status) {
      case DesignProjectStatus.consultation:
        return Colors.purple;
      case DesignProjectStatus.measurement:
        return Colors.blue;
      case DesignProjectStatus.designing:
        return Colors.orange;
      case DesignProjectStatus.production:
        return Colors.indigo;
      case DesignProjectStatus.fitting:
        return Colors.teal;
      case DesignProjectStatus.completed:
        return Colors.green;
      case DesignProjectStatus.delivered:
        return Colors.pink;
    }
  }

  Color _getProgressColor(int progress) {
    if (progress < 30) return Colors.red;
    if (progress < 70) return Colors.orange;
    return Colors.green;
  }

  Color _getComplexityColor(String complexity) {
    switch (complexity) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatDeadline(DateTime deadline) {
    final now = DateTime.now();
    final difference = deadline.difference(now);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} days';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours';
    } else {
      return '${difference.inMinutes} mins';
    }
  }

  int _calculateTodayEarnings() {
    final today = DateTime.now();
    final todayProjects = _activeProjects.where((project) => 
        project.orderDate.year == today.year &&
        project.orderDate.month == today.month &&
        project.orderDate.day == today.day
    ).toList();
    
    return todayProjects.fold(0, (sum, project) => sum + project.price.toInt());
  }
}

// Extensions for Enum names
extension DesignCategoryExtension on DesignCategory {
  String get name {
    switch (this) {
      case DesignCategory.all:
        return 'All';
      case DesignCategory.bridal:
        return 'Bridal';
      case DesignCategory.evening:
        return 'Evening Wear';
      case DesignCategory.traditional:
        return 'Traditional';
      case DesignCategory.formal:
        return 'Formal Wear';
      case DesignCategory.casual:
        return 'Casual Wear';
      case DesignCategory.consultation:
        return 'Consultation';
    }
  }
}

extension DesignProjectStatusExtension on DesignProjectStatus {
  String get name {
    switch (this) {
      case DesignProjectStatus.consultation:
        return 'Consultation';
      case DesignProjectStatus.measurement:
        return 'Measurement';
      case DesignProjectStatus.designing:
        return 'Designing';
      case DesignProjectStatus.production:
        return 'Production';
      case DesignProjectStatus.fitting:
        return 'Fitting';
      case DesignProjectStatus.completed:
        return 'Completed';
      case DesignProjectStatus.delivered:
        return 'Delivered';
    }
  }
}


// class DesignAnalyticsDialog extends StatelessWidget {
//   final double totalEarnings;
//   final int activeProjects;
//   final int completedProjects;
//   final List<DesignService> services;
//   final List<DesignPortfolio> portfolioItems;

//   const DesignAnalyticsDialog({
//     Key? key,
//     required this.totalEarnings,
//     required this.activeProjects,
//     required this.completedProjects,
//     required this.services,
//     required this.portfolioItems,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final totalProjects = activeProjects + completedProjects;
//     final completionRate = totalProjects > 0 ? ((completedProjects / totalProjects) * 100).round() : 0;
//     final averagePrice = _calculateAveragePrice();

//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'Design Studio Analytics',
//               style: GoogleFonts.poppins(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 20),
//             _buildAnalyticsItem('Total Revenue', '₹$totalEarnings', Icons.attach_money),
//             _buildAnalyticsItem('Active Projects', '$activeProjects', Icons.assignment),
//             _buildAnalyticsItem('Completed Projects', '$completedProjects', Icons.check_circle),
//             _buildAnalyticsItem('Completion Rate', '$completionRate%', Icons.trending_up),
//             _buildAnalyticsItem('Design Services', '${services.length}', Icons.palette),
//             _buildAnalyticsItem('Portfolio Items', '${portfolioItems.length}', Icons.photo_library),
//             _buildAnalyticsItem('Avg. Service Price', '₹${averagePrice.toStringAsFixed(2)}', Icons.trending_up),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => Navigator.pop(context),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFF8075FF),
//               ),
//               child: Text('Close'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAnalyticsItem(String title, String value, IconData icon) {
//     return ListTile(
//       leading: Icon(icon, color: Color(0xFF8075FF)),
//       title: Text(title),
//       trailing: Text(
//         value,
//         style: GoogleFonts.poppins(
//           fontWeight: FontWeight.bold,
//           color: Color(0xFF8075FF),
//         ),
//       ),
//     );
//   }

//   double _calculateAveragePrice() {
//     if (services.isEmpty) return 0.0;
//     final total = services.map((s) => s.startingPrice).reduce((a, b) => a + b);
//     return total / services.length;
//   }
// }

// // Add similar dialog implementations for AddDesignServiceDialog, EditDesignServiceDialog, 
// // AllDesignProjectsDialog, ServiceDesignProjectsDialog following the same pattern as repair screen

class AddDesignServiceDialog extends StatefulWidget {
  final Function(DesignService) onAdd;

  const AddDesignServiceDialog({Key? key, required this.onAdd}) : super(key: key);

  @override
  State<AddDesignServiceDialog> createState() => _AddDesignServiceDialogState();
}

class _AddDesignServiceDialogState extends State<AddDesignServiceDialog> {
  // Implementation similar to repair service dialog but for design services
  @override
  Widget build(BuildContext context) {
    return Dialog(
      // Dialog implementation for adding new design service
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Add New Design Service'),
            // Add form fields for design service
            ElevatedButton(
              onPressed: () {
                // Create new design service and call onAdd
              },
              child: Text('Add Service'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditDesignServiceDialog extends StatefulWidget {
  final DesignService service;
  final Function(DesignService) onUpdate;

  const EditDesignServiceDialog({Key? key, required this.service, required this.onUpdate}) : super(key: key);

  @override
  State<EditDesignServiceDialog> createState() => _EditDesignServiceDialogState();
}

class _EditDesignServiceDialogState extends State<EditDesignServiceDialog> {
  // Implementation for editing design service
  @override
  Widget build(BuildContext context) {
    return Dialog(
      // Dialog implementation for editing design service
      child: Container(),
    );
  }
}

class AllDesignProjectsDialog extends StatelessWidget {
  final List<DesignProject> projects;

  const AllDesignProjectsDialog({Key? key, required this.projects}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // Implementation for all design projects
      child: Container(),
    );
  }
}

class ServiceDesignProjectsDialog extends StatelessWidget {
  final DesignService service;
  final List<DesignProject> projects;

  const ServiceDesignProjectsDialog({Key? key, required this.service, required this.projects}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // Implementation for service-specific design projects
      child: Container(),
    );
  }
}