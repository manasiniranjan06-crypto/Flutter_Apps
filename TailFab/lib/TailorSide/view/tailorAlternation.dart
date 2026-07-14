

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebaseauth/customerside/components/gradient_scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AlterationsScreen extends StatefulWidget {
  const AlterationsScreen({Key? key}) : super(key: key);

  @override
  State<AlterationsScreen> createState() => _AlterationsScreenState();
}

class _AlterationsScreenState extends State<AlterationsScreen> with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  late TabController _tabController;
  List<AlterationService> _services = [];
  List<AlterationService> _filteredServices = [];
  List<AlterationOrder> _activeOrders = [];
  List<AlterationOrder> _completedOrders = [];
  
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerPhoneController = TextEditingController();
  final TextEditingController _specialInstructionsController = TextEditingController();
  
  String _selectedCategory = 'All';
  String _selectedServiceType = 'Standard';
  DateTime _selectedDeadline = DateTime.now().add(Duration(days: 2));
  double _customPrice = 0.0;
  bool _isLoading = true;

  // Updated categories with specific alteration points
  final List<String> _categories = [
    'All',
    'Sleeve Shortening',
    'Pant Length Adjustment',
    'Waist Tightening',
    'Zip Replacement',
    'Button Re-stitching',
    'Blouse Fitting',
    'Saree Fall Stitch',
    'Patch Repair',
    'Collar Reshape',
    'Elastic Replacement',
    'Quick Fix',
    'Other'
  ];

  final List<String> _serviceTypes = [
    'Standard',
    'Express',
    'Premium'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadServices();
    _loadOrders();
    _searchController.addListener(_filterServices);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _specialInstructionsController.dispose();
    super.dispose();
  }

  Future<void> _loadServices() async {
    try {
      final snapshot = await _firestore.collection('alteration_services').get();
      if (snapshot.docs.isEmpty) {
        // Add default services if none exist
        await _addDefaultServices();
        _loadServices(); // Reload after adding defaults
        return;
      }
      
      setState(() {
        _services = snapshot.docs.map((doc) {
          final data = doc.data();
          return AlterationService(
            id: doc.id,
            name: data['name'] ?? '',
            price: (data['price'] ?? 0.0).toDouble(),
            duration: data['duration'] ?? '',
            description: data['description'] ?? '',
            image: data['image'] ?? '',
            category: data['category'] ?? 'Other',
            serviceType: data['serviceType'] ?? 'Standard',
            isActive: data['isActive'] ?? true,
          );
        }).toList();
        _filteredServices = _services;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading services: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addDefaultServices() async {
    final defaultServices = [
      {
        'name': 'Sleeve Shortening',
        'price': 30.0,
        'duration': '1-2 days',
        'description': 'Adjust sleeve length for shirts and jackets',
        'image': 'https://images.unsplash.com/photo-1594736797933-d0c1382d7c2e',
        'category': 'Sleeve Shortening',
        'serviceType': 'Standard',
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Pant Length Adjustment',
        'price': 25.0,
        'duration': '1-2 days',
        'description': 'Adjust pant length as per requirement',
        'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
        'category': 'Pant Length Adjustment',
        'serviceType': 'Standard',
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Waist Tightening',
        'price': 35.0,
        'duration': '2-3 days',
        'description': 'Reduce waist size for perfect fit',
        'image': 'https://images.unsplash.com/photo-1441986300917-64674bd600d8',
        'category': 'Waist Tightening',
        'serviceType': 'Standard',
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Zip Replacement',
        'price': 20.0,
        'duration': '1 day',
        'description': 'Replace broken or faulty zippers',
        'image': 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea',
        'category': 'Zip Replacement',
        'serviceType': 'Standard',
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Button Re-stitching',
        'price': 15.0,
        'duration': '1 day',
        'description': 'Fix loose or missing buttons',
        'image': 'https://images.unsplash.com/photo-1586367579630-42491e4c0353',
        'category': 'Button Re-stitching',
        'serviceType': 'Standard',
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Blouse Fitting',
        'price': 45.0,
        'duration': '2-3 days',
        'description': 'Custom fitting for blouses and tops',
        'image': 'https://images.unsplash.com/photo-1585487000113-7e7f781cb78d',
        'category': 'Blouse Fitting',
        'serviceType': 'Standard',
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Saree Fall Stitch',
        'price': 20.0,
        'duration': '1 day',
        'description': 'Attach fall to saree for durability',
        'image': 'https://images.unsplash.com/photo-1515377905703-c4788e51af15',
        'category': 'Saree Fall Stitch',
        'serviceType': 'Standard',
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Patch Repair',
        'price': 25.0,
        'duration': '1-2 days',
        'description': 'Repair holes and tears with patches',
        'image': 'https://images.unsplash.com/photo-1556909114-4d0d853e5e25',
        'category': 'Patch Repair',
        'serviceType': 'Standard',
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Collar Reshape',
        'price': 30.0,
        'duration': '2 days',
        'description': 'Reshape and restore collar structure',
        'image': 'https://images.unsplash.com/photo-1582142306909-195724d1a6e5',
        'category': 'Collar Reshape',
        'serviceType': 'Standard',
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Elastic Replacement',
        'price': 20.0,
        'duration': '1 day',
        'description': 'Replace worn-out elastic bands',
        'image': 'https://images.unsplash.com/photo-1554412933-514a83d2f3c8',
        'category': 'Elastic Replacement',
        'serviceType': 'Standard',
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Quick Fix',
        'price': 15.0,
        'duration': 'Same day',
        'description': 'Minor repairs and quick alterations',
        'image': 'https://images.unsplash.com/photo-1562157873-818bc0726f68',
        'category': 'Quick Fix',
        'serviceType': 'Standard',
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
    ];

    final batch = _firestore.batch();
    for (var service in defaultServices) {
      final docRef = _firestore.collection('alteration_services').doc();
      batch.set(docRef, service);
    }
    await batch.commit();
  }

  Future<void> _loadOrders() async {
    try {
      final tailorId = _auth.currentUser?.uid;
      if (tailorId == null) return;

      final snapshot = await _firestore
          .collection('alteration_orders')
          .where('tailorId', isEqualTo: tailorId)
          .orderBy('createdAt', descending: true)
          .get();

      setState(() {
        _activeOrders = snapshot.docs
            .where((doc) => doc.data()['status'] != 'Completed')
            .map((doc) => AlterationOrder.fromFirestore(doc))
            .toList();
        
        _completedOrders = snapshot.docs
            .where((doc) => doc.data()['status'] == 'Completed')
            .map((doc) => AlterationOrder.fromFirestore(doc))
            .toList();
      });
    } catch (e) {
      print('Error loading orders: $e');
    }
  }

  void _filterServices() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredServices = _services.where((service) {
        final matchesSearch = service.name.toLowerCase().contains(query) ||
            service.description.toLowerCase().contains(query) ||
            service.category.toLowerCase().contains(query);
        final matchesCategory = _selectedCategory == 'All' || 
            service.category == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _updateOrderStatus(String orderId, String status) async {
    try {
      await _firestore.collection('alteration_orders').doc(orderId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      if (status == 'Completed') {
        await _firestore.collection('alteration_orders').doc(orderId).update({
          'completedAt': FieldValue.serverTimestamp(),
        });
      }
      
      _loadOrders();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order status updated to $status')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating order: $e')),
      );
    }
  }

  Future<void> _createNewOrder(AlterationService service) async {
    final tailorId = _auth.currentUser?.uid;
    if (tailorId == null) return;

    final order = {
      'serviceId': service.id,
      'serviceName': service.name,
      'customerName': _customerNameController.text.trim(),
      'customerPhone': _customerPhoneController.text.trim(),
      'specialInstructions': _specialInstructionsController.text.trim(),
      'originalPrice': service.price,
      'finalPrice': _customPrice > 0 ? _customPrice : service.price,
      'serviceType': _selectedServiceType,
      'deadline': _selectedDeadline,
      'status': 'Pending',
      'tailorId': tailorId,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    try {
      await _firestore.collection('alteration_orders').add(order);
      
      // Reset form
      _customerNameController.clear();
      _customerPhoneController.clear();
      _specialInstructionsController.clear();
      _customPrice = 0.0;
      _selectedServiceType = 'Standard';
      _selectedDeadline = DateTime.now().add(Duration(days: 2));
      
      Navigator.pop(context); // Close bottom sheet
      _loadOrders(); // Refresh orders list
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('New order created successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating order: $e')),
      );
    }
  }

  double _calculateExpressPrice(double basePrice) {
    switch (_selectedServiceType) {
      case 'Express':
        return basePrice * 1.5;
      case 'Premium':
        return basePrice * 2.0;
      default:
        return basePrice;
    }
  }

  String _getServiceTypeDuration(String serviceType) {
    switch (serviceType) {
      case 'Express':
        return '24 hours';
      case 'Premium':
        return 'Same day';
      default:
        return '1-2 days';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Alteration Services',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          tabs: [
            Tab(text: 'Services'),
            Tab(text: 'Active Orders (${_activeOrders.length})'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildServicesTab(),
          _buildActiveOrdersTab(),
          _buildCompletedOrdersTab(),
        ],
      ),
    );
  }

  Widget _buildServicesTab() {
    return Column(
      children: [
        // Search and Filter Section
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search alteration services...',
                    prefixIcon: Icon(Icons.search, color: Color(0xFF8075FF)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              SizedBox(height: 12),
              // Category Filter
              Container(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = _selectedCategory == category;
                    
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(
                          category,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                          _filterServices();
                        },
                        backgroundColor: Colors.white.withOpacity(0.8),
                        selectedColor: Color(0xFF8075FF),
                        labelStyle: GoogleFonts.poppins(
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                        checkmarkColor: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        
        // Info Card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.construction_outlined, color: Color(0xFF8075FF), size: 24),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Professional Alteration Services',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${_services.length} specialized services available for your customers',
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Services List
        Expanded(
          child: _isLoading 
              ? Center(child: CircularProgressIndicator(color: Color(0xFF8075FF)))
              : _filteredServices.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                          SizedBox(height: 16),
                          Text(
                            'No services found',
                            style: GoogleFonts.poppins(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Try selecting a different category',
                            style: GoogleFonts.poppins(
                              color: Colors.grey[500],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredServices.length,
                      itemBuilder: (context, index) {
                        return _buildServiceCard(_filteredServices[index]);
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(AlterationService service) {
    final expressPrice = _calculateExpressPrice(service.price);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            _showServiceDetails(service);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
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
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Color(0xFF8075FF).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              service.category,
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: Color(0xFF8075FF),
                                fontWeight: FontWeight.w500,
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
                          Icon(Icons.schedule, size: 14, color: Colors.grey[600]),
                          SizedBox(width: 4),
                          Text(
                            service.duration,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '₹${service.price.toStringAsFixed(0)}',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF8075FF),
                                ),
                              ),
                              if (_selectedServiceType != 'Standard')
                                Text(
                                  '${_selectedServiceType}: ₹${expressPrice.toStringAsFixed(0)}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: Colors.grey[600],
                                  ),
                                ),
                            ],
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
    );
  }

  Widget _buildActiveOrdersTab() {
    return _activeOrders.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.assignment_outlined, size: 64, color: Colors.grey[400]),
                SizedBox(height: 16),
                Text(
                  'No active orders',
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Create new orders from the Services tab',
                  style: GoogleFonts.poppins(
                    color: Colors.grey[500],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: _activeOrders.length,
            itemBuilder: (context, index) {
              return _buildOrderCard(_activeOrders[index]);
            },
          );
  }

  Widget _buildCompletedOrdersTab() {
    return _completedOrders.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, size: 64, color: Colors.grey[400]),
                SizedBox(height: 16),
                Text(
                  'No completed orders',
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: _completedOrders.length,
            itemBuilder: (context, index) {
              return _buildOrderCard(_completedOrders[index], isCompleted: true);
            },
          );
  }

  Widget _buildOrderCard(AlterationOrder order, {bool isCompleted = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Color(0xFF8075FF).withOpacity(0.1),
          child: Icon(
            _getOrderStatusIcon(order.status),
            color: Color(0xFF8075FF),
          ),
        ),
        title: Text(
          order.customerName,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(order.serviceName),
            Text(
              '₹${order.finalPrice.toStringAsFixed(0)} • ${order.serviceType}',
              style: GoogleFonts.poppins(fontSize: 12),
            ),
            Text(
              'Deadline: ${_formatDate(order.deadline)}',
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: isCompleted
            ? Text(
                'Completed',
                style: GoogleFonts.poppins(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              )
            : PopupMenuButton<String>(
                onSelected: (status) => _updateOrderStatus(order.id, status),
                itemBuilder: (context) => [
                  PopupMenuItem(value: 'In Progress', child: Text('In Progress')),
                  PopupMenuItem(value: 'Ready for Pickup', child: Text('Ready for Pickup')),
                  PopupMenuItem(value: 'Completed', child: Text('Complete Order')),
                ],
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    order.status,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  IconData _getOrderStatusIcon(String status) {
    switch (status) {
      case 'Pending': return Icons.pending_actions;
      case 'In Progress': return Icons.build;
      case 'Ready for Pickup': return Icons.local_shipping;
      case 'Completed': return Icons.check_circle;
      default: return Icons.assignment;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending': return Colors.orange;
      case 'In Progress': return Colors.blue;
      case 'Ready for Pickup': return Colors.purple;
      case 'Completed': return Colors.green;
      default: return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showServiceDetails(AlterationService service) {
    final expressPrice = _calculateExpressPrice(service.price);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFF8075FF),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Service Details',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Service Image
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: NetworkImage(service.image),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          
                          // Service Name and Category
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  service.name,
                                  style: GoogleFonts.poppins(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Color(0xFF8075FF).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  service.category,
                                  style: GoogleFonts.poppins(
                                    color: Color(0xFF8075FF),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          SizedBox(height: 10),
                          Text(
                            service.description,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 20),
                          
                          // Service Type Selection
                          Text(
                            'Service Type',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            height: 50,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _serviceTypes.length,
                              itemBuilder: (context, index) {
                                final type = _serviceTypes[index];
                                final price = type == 'Standard' 
                                    ? service.price 
                                    : type == 'Express' 
                                        ? service.price * 1.5 
                                        : service.price * 2.0;
                                
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: ChoiceChip(
                                    label: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(type),
                                        Text(
                                          '₹${price.toStringAsFixed(0)}',
                                          style: GoogleFonts.poppins(fontSize: 10),
                                        ),
                                      ],
                                    ),
                                    selected: _selectedServiceType == type,
                                    onSelected: (selected) {
                                      setModalState(() {
                                        _selectedServiceType = type;
                                        _customPrice = price;
                                      });
                                    },
                                    selectedColor: Color(0xFF8075FF),
                                    labelStyle: GoogleFonts.poppins(
                                      color: _selectedServiceType == type 
                                          ? Colors.white 
                                          : Colors.black87,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          
                          SizedBox(height: 20),
                          
                          // Customer Information
                          Text(
                            'Customer Information',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 12),
                          TextField(
                            controller: _customerNameController,
                            decoration: InputDecoration(
                              labelText: 'Customer Name',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person),
                            ),
                          ),
                          SizedBox(height: 12),
                          TextField(
                            controller: _customerPhoneController,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.phone),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                          SizedBox(height: 12),
                          TextField(
                            controller: _specialInstructionsController,
                            decoration: InputDecoration(
                              labelText: 'Special Instructions',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.note),
                            ),
                            maxLines: 3,
                          ),
                          
                          SizedBox(height: 20),
                          
                          // Deadline Selection
                          Text(
                            'Deadline',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8),
                          InkWell(
                            onTap: () async {
                              final selectedDate = await showDatePicker(
                                context: context,
                                initialDate: _selectedDeadline,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(Duration(days: 30)),
                              );
                              if (selectedDate != null) {
                                setModalState(() {
                                  _selectedDeadline = selectedDate;
                                });
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_today, color: Color(0xFF8075FF)),
                                  SizedBox(width: 12),
                                  Text(_formatDate(_selectedDeadline)),
                                ],
                              ),
                            ),
                          ),
                          
                          SizedBox(height: 20),
                          
                          // Price Summary
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                _buildDetailRow('Base Price', '₹${service.price.toStringAsFixed(0)}'),
                                _buildDetailRow('Service Type', _selectedServiceType),
                                _buildDetailRow(
                                  'Service Type Multiplier', 
                                  _selectedServiceType == 'Standard' ? '1.0x' : 
                                  _selectedServiceType == 'Express' ? '1.5x' : '2.0x'
                                ),
                                Divider(),
                                _buildDetailRow(
                                  'Total Price', 
                                  '₹${_calculateExpressPrice(service.price).toStringAsFixed(0)}',
                                  isTotal: true,
                                ),
                                _buildDetailRow(
                                  'Estimated Completion', 
                                  _getServiceTypeDuration(_selectedServiceType),
                                ),
                              ],
                            ),
                          ),
                          
                          SizedBox(height: 30),
                          
                          // Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey[600],
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_customerNameController.text.trim().isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Please enter customer name')),
                                      );
                                      return;
                                    }
                                    _createNewOrder(service);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF8075FF),
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: Text(
                                    'Create Order',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
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
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(String title, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? Color(0xFF8075FF) : Colors.black87,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: isTotal ? 18 : 14,
              color: isTotal ? Color(0xFF8075FF) : Colors.black87,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class AlterationService {
  final String id;
  final String name;
  final double price;
  final String duration;
  final String description;
  final String image;
  final String category;
  final String serviceType;
  final bool isActive;

  AlterationService({
    required this.id,
    required this.name,
    required this.price,
    required this.duration,
    required this.description,
    required this.image,
    required this.category,
    required this.serviceType,
    required this.isActive,
  });
}

class AlterationOrder {
  final String id;
  final String serviceId;
  final String serviceName;
  final String customerName;
  final String customerPhone;
  final String specialInstructions;
  final double originalPrice;
  final double finalPrice;
  final String serviceType;
  final DateTime deadline;
  final String status;
  final String tailorId;
  final DateTime createdAt;

  AlterationOrder({
    required this.id,
    required this.serviceId,
    required this.serviceName,
    required this.customerName,
    required this.customerPhone,
    required this.specialInstructions,
    required this.originalPrice,
    required this.finalPrice,
    required this.serviceType,
    required this.deadline,
    required this.status,
    required this.tailorId,
    required this.createdAt,
  });

  factory AlterationOrder.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AlterationOrder(
      id: doc.id,
      serviceId: data['serviceId'] ?? '',
      serviceName: data['serviceName'] ?? '',
      customerName: data['customerName'] ?? '',
      customerPhone: data['customerPhone'] ?? '',
      specialInstructions: data['specialInstructions'] ?? '',
      originalPrice: (data['originalPrice'] ?? 0.0).toDouble(),
      finalPrice: (data['finalPrice'] ?? 0.0).toDouble(),
      serviceType: data['serviceType'] ?? 'Standard',
      deadline: (data['deadline'] as Timestamp).toDate(),
      status: data['status'] ?? 'Pending',
      tailorId: data['tailorId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}