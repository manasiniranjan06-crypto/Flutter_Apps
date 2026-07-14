
// TailorSide/view/tailorRepairs.dart
import 'package:firebaseauth/TailorSide/model/tailor_repari_model.dart';
import 'package:firebaseauth/TailorSide/view/tailor_serviceorderdialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebaseauth/customerside/components/gradient_scaffold.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class RepairsScreen extends StatefulWidget {
  const RepairsScreen({Key? key}) : super(key: key);

  @override
  State<RepairsScreen> createState() => _RepairsScreenState();
}

class _RepairsScreenState extends State<RepairsScreen> {
  final List<RepairService> _services = [
    RepairService(
      name: 'Zipper Replacement',
      price: 15.0,
      duration: '1 day',
      description: 'Professional zipper replacement for all types of garments',
      image: 'https://images.unsplash.com/photo-1594736797933-d0c1382d7c2e',
      urgency: 'Express',
      category: RepairCategory.zippers,
      popularity: 4.8,
      features: ['Metal/Plastic Zippers', 'Hidden/Exposed Style', 'Color Matching'],
      materials: ['Replacement Zipper', 'Matching Thread'],
      skillLevel: 'Intermediate',
      toolsRequired: ['Seam Ripper', 'Zipper Foot'],
    ),
    RepairService(
      name: 'Tear Repair',
      price: 20.0,
      duration: '1-2 days',
      description: 'Expert tear and hole repair with invisible mending techniques',
      image: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
      urgency: 'Standard',
      category: RepairCategory.fabric,
      popularity: 4.6,
      features: ['Invisible Mending', 'Patch Reinforcement', 'Color Matching'],
      materials: ['Matching Fabric', 'Reinforcement Patches'],
      skillLevel: 'Advanced',
      toolsRequired: ['Embroidery Hoop', 'Fine Needles'],
    ),
    RepairService(
      name: 'Button Replacement',
      price: 10.0,
      duration: 'Same day',
      description: 'Quick button replacement with extensive button selection',
      image: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8',
      urgency: 'Express',
      category: RepairCategory.accessories,
      popularity: 4.9,
      features: ['Button Selection', 'Secure Stitching', 'Position Matching'],
      materials: ['Replacement Buttons', 'Strong Thread'],
      skillLevel: 'Beginner',
      toolsRequired: ['Button Gauge', 'Thimble'],
    ),
    RepairService(
      name: 'Seam Repair',
      price: 18.0,
      duration: '1 day',
      description: 'Professional seam reinforcement and repair',
      image: 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea',
      urgency: 'Standard',
      category: RepairCategory.structural,
      popularity: 4.7,
      features: ['Seam Reinforcement', 'Original Stitch Pattern'],
      materials: ['Heavy-duty Thread', 'Seam Tape'],
      skillLevel: 'Intermediate',
      toolsRequired: ['Seam Ripper', 'Sewing Machine'],
    ),
  ];


  final TextEditingController _searchController = TextEditingController();
  
  String _searchQuery = '';
  RepairCategory _selectedCategory = RepairCategory.all;
  List<RepairOrder> _activeOrders = [];
  double _totalEarnings = 1250.0;
  int _completedOrders = 45;
  int _pendingOrders = 3;

  @override
  void initState() {
    super.initState();
  
    _loadTailorData();
  }

  void _loadTailorData() {
    setState(() {
      _activeOrders = [
        RepairOrder(
          id: '001',
          serviceName: 'Zipper Replacement',
          customerName: 'John Doe',
          price: 15.0,
          status: RepairStatus.inProgress,
          deadline: DateTime.now().add(Duration(days: 1)),
          customerPhone: '+1234567890',
          orderDate: DateTime.now().subtract(Duration(hours: 2)),
          customerAddress: '123 Main St, City',
          garmentType: 'Jacket',
          specialInstructions: 'Use metal zipper',
        ),
        RepairOrder(
          id: '002',
          serviceName: 'Button Replacement',
          customerName: 'Jane Smith',
          price: 10.0,
          status: RepairStatus.pending,
          deadline: DateTime.now().add(Duration(hours: 4)),
          customerPhone: '+0987654321',
          orderDate: DateTime.now().subtract(Duration(hours: 1)),
          customerAddress: '456 Oak Ave, Town',
          garmentType: 'Shirt',
          specialInstructions: 'Match existing buttons',
        ),
      ];
    });
  }

  @override
  void dispose() {
 
    _searchController.dispose();
    super.dispose();
  }

  List<RepairService> get _filteredServices {
    return _services.where((service) {
      final matchesSearch = service.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          service.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == RepairCategory.all ||
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
              'Repair Workshop',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Manage Repair Services',
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
            icon: Icon(Icons.bar_chart, color: Colors.white, size: 28),
            onPressed: _showAnalytics,
          ),
        ],
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                // Tailor Dashboard Header
                _buildTailorDashboard(),
                
                // Quick Stats
                _buildStatsSection(),
                
                // Active Orders Section
                _buildActiveOrdersSection(),
                
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

  Widget _buildTailorDashboard() {
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
                  child: Icon(Icons.person, color: Colors.white, size: 30),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, Master Tailor!',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Total Earnings: ₹$_totalEarnings',
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
                  icon: Icon(Icons.add_circle, color: Color(0xFF8075FF), size: 32),
                  onPressed: _addNewService,
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
          onPressed: _showNotifications,
        ),
        if (_pendingOrders > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                _pendingOrders.toString(),
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
    final completionRate = _completedOrders > 0 ? ((_completedOrders / (_completedOrders + _activeOrders.length)) * 100).round() : 0;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildStatCard('Active Orders', _activeOrders.length.toString(), Icons.assignment, Colors.blue)),
              SizedBox(width: 12),
              Expanded(child: _buildStatCard('Today\'s Earnings', '₹$todayEarnings', Icons.attach_money, Colors.green)),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildStatCard('Completion Rate', '$completionRate%', Icons.trending_up, Colors.orange)),
              SizedBox(width: 12),
              Expanded(child: _buildStatCard('Services', _services.length.toString(), Icons.build, Colors.purple)),
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

  Widget _buildActiveOrdersSection() {
    final activeOrders = _activeOrders.where((order) => order.status != RepairStatus.completed && order.status != RepairStatus.delivered).toList();
    
    if (activeOrders.isEmpty) return SizedBox();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Active Orders',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: _viewAllOrders,
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
          ...activeOrders.map((order) => _buildOrderCard(order)).toList(),
        ],
      ),
    );
  }

  Widget _buildOrderCard(RepairOrder order) {
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
                    order.serviceName,
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
                    color: _getStatusColor(order.status),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    order.status.name.toUpperCase(),
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
              'Customer: ${order.customerName}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            Text(
              'Garment: ${order.garmentType}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            Text(
              'Deadline: ${_formatDeadline(order.deadline)}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            if (order.specialInstructions.isNotEmpty) ...[
              SizedBox(height: 4),
              Text(
                'Instructions: ${order.specialInstructions}',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.orange[700],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹${order.price}',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8075FF),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.phone, size: 20, color: Colors.green),
                      onPressed: () => _contactCustomer(order),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, size: 20, color: Colors.blue),
                      onPressed: () => _updateOrderStatus(order),
                    ),
                    IconButton(
                      icon: Icon(Icons.visibility, size: 20, color: Colors.purple),
                      onPressed: () => _viewOrderDetails(order),
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

  Widget _buildSearchFilterSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Repair Services',
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
                hintText: 'Search repair services...',
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
                    selected: _selectedCategory == RepairCategory.all,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = RepairCategory.all;
                      });
                    },
                    backgroundColor: Colors.white.withOpacity(0.8),
                    selectedColor: Color(0xFF8075FF),
                    checkmarkColor: Colors.white,
                  ),
                ),
                // Category Filters
                ...RepairCategory.values.where((c) => c != RepairCategory.all).map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(category.name),
                      selected: _selectedCategory == category,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = selected ? category : RepairCategory.all;
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
                'Available Services',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: Icon(Icons.filter_list, color: Colors.white, size: 24),
                onPressed: _showAdvancedFilter,
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

  Widget _buildServiceCard(RepairService service) {
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
                                  color: _getSkillColor(service.skillLevel),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  service.skillLevel,
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
                                  color: _getUrgencyColor(service.urgency),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  service.urgency,
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
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
                    Text(
                      '₹${service.price}',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8075FF),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, size: 20, color: Colors.blue),
                          onPressed: () => _editService(service),
                        ),
                        IconButton(
                          icon: Icon(Icons.analytics, size: 20, color: Colors.orange),
                          onPressed: () => _showServiceAnalytics(service),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, size: 20, color: Colors.red),
                          onPressed: () => _deleteService(service),
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
          Icon(Icons.build_circle, size: 80, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'No repair services found',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
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
                _selectedCategory = RepairCategory.all;
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
            onPressed: _addNewService,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'Add New Service',
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

  // Service Management Methods
  void _showServiceManagement(RepairService service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ServiceManagementSheet(
          service: service,
          onEdit: () => _editService(service),
          onViewOrders: () => _viewServiceOrders(service),
          onUpdatePrice: () => _updateServicePrice(service),
          onDelete: () => _deleteService(service),
        );
      },
    );
  }

  void _showAnalytics() {
    showDialog(
      context: context,
      builder: (context) => AnalyticsDialog(
        totalEarnings: _totalEarnings,
        activeOrders: _activeOrders.length,
        completedOrders: _completedOrders,
        services: _services,
      ),
    );
  }

  void _addNewService() {
    showDialog(
      context: context,
      builder: (context) => AddServiceDialog(
        onAdd: (newService) {
          setState(() {
            _services.add(newService);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('New service added successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  void _editService(RepairService service) {
    showDialog(
      context: context,
      builder: (context) => EditServiceDialog(
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
              content: Text('Service updated successfully!'),
              backgroundColor: Colors.blue,
            ),
          );
        },
      ),
    );
  }

  void _deleteService(RepairService service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Service'),
        content: Text('Are you sure you want to delete ${service.name}?'),
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
                  content: Text('Service deleted successfully!'),
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

  void _updateServicePrice(RepairService service) {
    final priceController = TextEditingController(text: service.price.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Price'),
        content: TextField(
          controller: priceController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'New Price (₹)',
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
                    _services[index] = service.copyWith(price: newPrice);
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

  void _viewAllOrders() {
    showDialog(
      context: context,
      builder: (context) => AllOrdersDialog(orders: _activeOrders),
    );
  }

  void _viewServiceOrders(RepairService service) {
    final serviceOrders = _activeOrders.where((order) => order.serviceName == service.name).toList();
    showDialog(
      context: context,
      builder: (context) => ServiceOrdersDialog(
        service: service,
        orders: serviceOrders,
      ),
    );
  }

  void _contactCustomer(RepairOrder order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Contact Customer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer: ${order.customerName}'),
            Text('Phone: ${order.customerPhone}'),
            Text('Service: ${order.serviceName}'),
            Text('Address: ${order.customerAddress}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              // Implement call functionality
              Navigator.pop(context);
            },
            child: Text('Call Customer'),
          ),
        ],
      ),
    );
  }

  void _updateOrderStatus(RepairOrder order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Order Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: RepairStatus.values.map((status) {
            return ListTile(
              title: Text(status.name),
              trailing: order.status == status ? Icon(Icons.check, color: Colors.green) : null,
              onTap: () {
                setState(() {
                  final index = _activeOrders.indexWhere((o) => o.id == order.id);
                  if (index != -1) {
                    _activeOrders[index] = order.copyWith(status: status);
                    if (status == RepairStatus.completed) {
                      _completedOrders++;
                      _pendingOrders--;
                    }
                  }
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Order status updated to ${status.name}'),
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

  void _viewOrderDetails(RepairOrder order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Order ID', order.id),
              _buildDetailRow('Service', order.serviceName),
              _buildDetailRow('Customer', order.customerName),
              _buildDetailRow('Phone', order.customerPhone),
              _buildDetailRow('Address', order.customerAddress),
              _buildDetailRow('Garment', order.garmentType),
              _buildDetailRow('Price', '₹${order.price}'),
              _buildDetailRow('Status', order.status.name),
              _buildDetailRow('Order Date', '${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year}'),
              _buildDetailRow('Deadline', '${order.deadline.day}/${order.deadline.month}/${order.deadline.year}'),
              if (order.specialInstructions.isNotEmpty)
                _buildDetailRow('Special Instructions', order.specialInstructions),
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

  void _showServiceAnalytics(RepairService service) {
    final serviceOrders = _activeOrders.where((order) => order.serviceName == service.name).length;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${service.name} Analytics'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Total Orders', serviceOrders.toString()),
            _buildDetailRow('Price', '₹${service.price}'),
            _buildDetailRow('Duration', service.duration),
            _buildDetailRow('Skill Level', service.skillLevel),
            _buildDetailRow('Urgency', service.urgency),
            _buildDetailRow('Category', service.category.name),
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

  void _showNotifications() {
    final pendingOrders = _activeOrders.where((order) => order.status == RepairStatus.pending).toList();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pending Orders (${pendingOrders.length})'),
        content: pendingOrders.isEmpty
            ? Text('No pending orders')
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: pendingOrders.map((order) => ListTile(
                  title: Text(order.serviceName),
                  subtitle: Text(order.customerName),
                  trailing: Text('₹${order.price}'),
                )).toList(),
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

  void _showAdvancedFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Advanced Filters',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text('Price Range:', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            // Add price range slider here
            SizedBox(height: 20),
            Text('Skill Level:', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            Wrap(
              spacing: 8,
              children: ['Beginner', 'Intermediate', 'Advanced'].map((level) {
                return FilterChip(
                  label: Text(level),
                  selected: false,
                  onSelected: (selected) {
                    // Implement skill level filtering
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF8075FF),
                    ),
                    child: Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Utility Methods
  Color _getStatusColor(RepairStatus status) {
    switch (status) {
      case RepairStatus.pending:
        return Colors.orange;
      case RepairStatus.inProgress:
        return Colors.blue;
      case RepairStatus.completed:
        return Colors.green;
      case RepairStatus.delivered:
        return Colors.purple;
    }
  }

  Color _getSkillColor(String skillLevel) {
    switch (skillLevel) {
      case 'Beginner':
        return Colors.green;
      case 'Intermediate':
        return Colors.orange;
      case 'Advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getUrgencyColor(String urgency) {
    switch (urgency) {
      case 'Express':
        return Colors.green;
      case 'Standard':
        return Colors.orange;
      case 'Urgent':
        return Colors.red;
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
    final todayOrders = _activeOrders.where((order) => 
        order.orderDate.year == today.year &&
        order.orderDate.month == today.month &&
        order.orderDate.day == today.day
    ).toList();
    
    return todayOrders.fold(0, (sum, order) => sum + order.price.toInt());
  }
}


// Extensions for Enum names
extension RepairCategoryExtension on RepairCategory {
  String get name {
    switch (this) {
      case RepairCategory.all:
        return 'All';
      case RepairCategory.zippers:
        return 'Zippers';
      case RepairCategory.fabric:
        return 'Fabric';
      case RepairCategory.accessories:
        return 'Accessories';
      case RepairCategory.structural:
        return 'Structural';
      case RepairCategory.alterations:
        return 'Alterations';
      case RepairCategory.creative:
        return 'Creative';
    }
  }
}

extension RepairStatusExtension on RepairStatus {
  String get name {
    switch (this) {
      case RepairStatus.pending:
        return 'Pending';
      case RepairStatus.inProgress:
        return 'In Progress';
      case RepairStatus.completed:
        return 'Completed';
      case RepairStatus.delivered:
        return 'Delivered';
    }
  }
}

// Supporting Dialog Widgets
class ServiceManagementSheet extends StatelessWidget {
  final RepairService service;
  final VoidCallback onEdit;
  final VoidCallback onViewOrders;
  final VoidCallback onUpdatePrice;
  final VoidCallback onDelete;

  const ServiceManagementSheet({
    Key? key,
    required this.service,
    required this.onEdit,
    required this.onViewOrders,
    required this.onUpdatePrice,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Manage Service',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                ListTile(
                  leading: Icon(Icons.edit, color: Color(0xFF8075FF)),
                  title: Text('Edit Service Details'),
                  onTap: () {
                    Navigator.pop(context);
                    onEdit();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.assignment, color: Colors.blue),
                  title: Text('View Service Orders'),
                  onTap: () {
                    Navigator.pop(context);
                    onViewOrders();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.attach_money, color: Colors.green),
                  title: Text('Update Pricing'),
                  onTap: () {
                    Navigator.pop(context);
                    onUpdatePrice();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.analytics, color: Colors.orange),
                  title: Text('Service Analytics'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text('Delete Service', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    onDelete();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AnalyticsDialog extends StatelessWidget {
  final double totalEarnings;
  final int activeOrders;
  final int completedOrders;
  final List<RepairService> services;

  const AnalyticsDialog({
    Key? key,
    required this.totalEarnings,
    required this.activeOrders,
    required this.completedOrders,
    required this.services,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalOrders = activeOrders + completedOrders;
    final completionRate = totalOrders > 0 ? ((completedOrders / totalOrders) * 100).round() : 0;
    final averagePrice = _calculateAveragePrice();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Business Analytics',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildAnalyticsItem('Total Earnings', '₹$totalEarnings', Icons.attach_money),
            _buildAnalyticsItem('Active Orders', '$activeOrders', Icons.assignment),
            _buildAnalyticsItem('Completed Orders', '$completedOrders', Icons.check_circle),
            _buildAnalyticsItem('Completion Rate', '$completionRate%', Icons.trending_up),
            _buildAnalyticsItem('Services Offered', '${services.length}', Icons.build),
            _buildAnalyticsItem('Avg. Service Price', '₹${averagePrice.toStringAsFixed(2)}', Icons.trending_up),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF8075FF),
              ),
              child: Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsItem(String title, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF8075FF)),
      title: Text(title),
      trailing: Text(
        value,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          color: Color(0xFF8075FF),
        ),
      ),
    );
  }

  double _calculateAveragePrice() {
    if (services.isEmpty) return 0.0;
    final total = services.map((s) => s.price).reduce((a, b) => a + b);
    return total / services.length;
  }
}

class AddServiceDialog extends StatefulWidget {
  final Function(RepairService) onAdd;

  const AddServiceDialog({Key? key, required this.onAdd}) : super(key: key);

  @override
  State<AddServiceDialog> createState() => _AddServiceDialogState();
}

class _AddServiceDialogState extends State<AddServiceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _durationController = TextEditingController();
  final _descriptionController = TextEditingController();
  RepairCategory _selectedCategory = RepairCategory.zippers;
  String _selectedUrgency = 'Standard';
  String _selectedSkillLevel = 'Beginner';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add New Service',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Service Name',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter service name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'Price (₹)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter valid price';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _durationController,
                  decoration: InputDecoration(
                    labelText: 'Duration (e.g., 1-2 days)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter duration';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<RepairCategory>(
                  value: _selectedCategory,
                  items: RepairCategory.values.where((c) => c != RepairCategory.all).map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedUrgency,
                        items: ['Standard', 'Express', 'Urgent'].map((urgency) {
                          return DropdownMenuItem(
                            value: urgency,
                            child: Text(urgency),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedUrgency = value!;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Urgency',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedSkillLevel,
                        items: ['Beginner', 'Intermediate', 'Advanced'].map((level) {
                          return DropdownMenuItem(
                            value: level,
                            child: Text(level),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedSkillLevel = value!;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Skill Level',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final newService = RepairService(
                              name: _nameController.text,
                              price: double.parse(_priceController.text),
                              duration: _durationController.text,
                              description: _descriptionController.text,
                              image: 'https://images.unsplash.com/photo-1594736797933-d0c1382d7c2e',
                              urgency: _selectedUrgency,
                              category: _selectedCategory,
                              popularity: 4.5,
                              features: ['Quality Work', 'Professional Finish'],
                              materials: ['Basic Materials'],
                              skillLevel: _selectedSkillLevel,
                              toolsRequired: ['Basic Tools'],
                            );
                            widget.onAdd(newService);
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF8075FF),
                        ),
                        child: Text('Add Service'),
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
}

class EditServiceDialog extends StatefulWidget {
  final RepairService service;
  final Function(RepairService) onUpdate;

  const EditServiceDialog({Key? key, required this.service, required this.onUpdate}) : super(key: key);

  @override
  State<EditServiceDialog> createState() => _EditServiceDialogState();
}

class _EditServiceDialogState extends State<EditServiceDialog> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _durationController;
  late TextEditingController _descriptionController;
  late RepairCategory _selectedCategory;
  late String _selectedUrgency;
  late String _selectedSkillLevel;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.service.name);
    _priceController = TextEditingController(text: widget.service.price.toString());
    _durationController = TextEditingController(text: widget.service.duration);
    _descriptionController = TextEditingController(text: widget.service.description);
    _selectedCategory = widget.service.category;
    _selectedUrgency = widget.service.urgency;
    _selectedSkillLevel = widget.service.skillLevel;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Service',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Service Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price (₹)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _durationController,
                decoration: InputDecoration(
                  labelText: 'Duration',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<RepairCategory>(
                value: _selectedCategory,
                items: RepairCategory.values.where((c) => c != RepairCategory.all).map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedUrgency,
                      items: ['Standard', 'Express', 'Urgent'].map((urgency) {
                        return DropdownMenuItem(
                          value: urgency,
                          child: Text(urgency),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedUrgency = value!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Urgency',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedSkillLevel,
                      items: ['Beginner', 'Intermediate', 'Advanced'].map((level) {
                        return DropdownMenuItem(
                          value: level,
                          child: Text(level),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedSkillLevel = value!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Skill Level',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final updatedService = widget.service.copyWith(
                          name: _nameController.text,
                          price: double.tryParse(_priceController.text) ?? widget.service.price,
                          duration: _durationController.text,
                          description: _descriptionController.text,
                          category: _selectedCategory,
                          urgency: _selectedUrgency,
                          skillLevel: _selectedSkillLevel,
                        );
                        widget.onUpdate(updatedService);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF8075FF),
                      ),
                      child: Text('Update Service'),
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
}

class AllOrdersDialog extends StatelessWidget {
  final List<RepairOrder> orders;

  const AllOrdersDialog({Key? key, required this.orders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'All Orders (${orders.length})',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            orders.isEmpty
                ? Text('No orders found')
                : SizedBox(
                    height: 400,
                    child: ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return Card(
                          child: ListTile(
                            title: Text(order.serviceName),
                            subtitle: Text('${order.customerName} - ${order.status.name}'),
                            trailing: Text('₹${order.price}'),
                          ),
                        );
                      },
                    ),
                  ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF8075FF),
              ),
              child: Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
