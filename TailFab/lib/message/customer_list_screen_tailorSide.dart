
// tailor_chat_list_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'chat_screen.dart';

class TailorChatListScreen extends StatefulWidget {
  const TailorChatListScreen({Key? key}) : super(key: key);

  @override
  State<TailorChatListScreen> createState() => _TailorChatListScreenState();
}

class _TailorChatListScreenState extends State<TailorChatListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  List<Customer> _customers = [];
  List<TailorChat> _chats = [];
  bool _isLoading = true;
  String _errorMessage = '';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
      
      await Future.wait([
        _loadCustomers(),
        _loadExistingChats(),
      ]);
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        _errorMessage = 'Failed to load data. Please check your connection.';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadCustomers() async {
    try {
      print('🔄 Starting to load customers from Firestore...');
      
      final querySnapshot = await _firestore
          .collection('customers')
          .get();

      print('✅ Found ${querySnapshot.docs.length} customer documents');

      List<Customer> customers = [];
      
      for (var doc in querySnapshot.docs) {
        try {
          final data = doc.data();
          print('📄 Processing customer document: ${doc.id}');
          
          // Extract customer data from Firestore
          customers.add(Customer(
            id: doc.id,
            name: _getStringField(data, 'name', 'Customer'),
            email: _getStringField(data, 'email', 'No email'),
            phone: _getStringField(data, 'phone', 'No phone'),
            address: _getStringField(data, 'address', 'Address not available'),
            city: _getStringField(data, 'city', 'City'),
            image: _getStringField(data, 'profileImage', _getRandomCustomerImage()),
            joinDate: _getDateTimeField(data, 'createdAt', DateTime.now()),
            lastActive: _getDateTimeField(data, 'lastActive', DateTime.now()),
            orderCount: _getIntField(data, 'orderCount', 0),
            totalSpent: _getDoubleField(data, 'totalSpent', 0.0),
            averageOrderValue: _getDoubleField(data, 'averageOrderValue', 0.0),
            isActive: _getBoolField(data, 'isActive', true),
            isVerified: _getBoolField(data, 'isVerified', false),
            customerType: _getStringField(data, 'customerType', 'Regular'),
            preferredContactMethod: _getStringField(data, 'preferredContactMethod', 'WhatsApp'),
            specialRequirements: _getStringField(data, 'specialRequirements', ''),
            allergies: _getStringField(data, 'allergies', ''),
            preferredStyles: _getStringField(data, 'preferredStyles', ''),
            measurements: _getMapField(data, 'measurements'),
            notes: _getStringField(data, 'notes', ''),
          ));
          
          print('✅ Added customer: ${_getStringField(data, 'name', 'Customer')}');
          
        } catch (e) {
          print('❌ Error processing customer ${doc.id}: $e');
        }
      }

      // Sort customers by most recent activity
      customers.sort((a, b) => b.lastActive.compareTo(a.lastActive));
      
      print('🎉 Successfully processed ${customers.length} customers');

      setState(() {
        _customers = customers;
      });

    } catch (e) {
      print('❌ Error loading customers from Firestore: $e');
      // Use default customers as fallback
      _customers = _getDefaultCustomers();
    }
  }

  // Method to get random customer profile images
  String _getRandomCustomerImage() {
    final List<String> customerImages = [
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&w=400',
      'https://images.unsplash.com/photo-1494790108755-2616b612b786?ixlib=rb-4.0.3&w=400',
      'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&w=400',
      'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&w=400',
      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-4.0.3&w=400',
      'https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-4.0.3&w=400',
    ];
    return customerImages[DateTime.now().millisecondsSinceEpoch % customerImages.length];
  }

  Future<void> _loadExistingChats() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('⚠️ No tailor logged in');
        return;
      }

      print('🔄 Loading existing chats for tailor: ${user.uid}');

      final querySnapshot = await _firestore
          .collection('chats')
          .where('participants', arrayContains: user.uid)
          .orderBy('lastMessageTime', descending: true)
          .get();

      print('✅ Found ${querySnapshot.docs.length} chat documents');

      List<TailorChat> chats = [];
      
      for (var doc in querySnapshot.docs) {
        try {
          final data = doc.data();
          final participants = List<String>.from(data['participants'] ?? []);
          final customerId = participants.firstWhere(
            (id) => id != user.uid,
            orElse: () => '',
          );

          if (customerId.isNotEmpty) {
            // Find customer from already loaded customers
            final existingCustomer = _customers.firstWhere(
              (customer) => customer.id == customerId,
              orElse: () => Customer(
                id: customerId,
                name: _getStringField(data, 'customerName', 'Customer'),
                email: 'No email',
                phone: 'No phone',
                address: 'Address not available',
                city: 'City',
                image: _getStringField(data, 'customerImage', _getRandomCustomerImage()),
                joinDate: DateTime.now(),
                lastActive: DateTime.now(),
                orderCount: 0,
                totalSpent: 0.0,
                averageOrderValue: 0.0,
                isActive: true,
                isVerified: false,
                customerType: 'Regular',
                preferredContactMethod: 'WhatsApp',
                specialRequirements: '',
                allergies: '',
                preferredStyles: '',
                measurements: {},
                notes: '',
              ),
            );

            chats.add(TailorChat(
              id: doc.id,
              customer: existingCustomer,
              lastMessage: data['lastMessage'] ?? '',
              lastMessageTime: data['lastMessageTime'] != null 
                  ? (data['lastMessageTime'] as Timestamp).toDate()
                  : DateTime.now(),
              unreadCount: data['unreadCount'] ?? 0,
              orderStatus: _getStringField(data, 'lastOrderStatus', 'No orders'),
            ));
            print('✅ Added chat with customer: ${existingCustomer.name}');
          }
        } catch (e) {
          print('❌ Error processing chat ${doc.id}: $e');
        }
      }

      setState(() {
        _chats = chats;
      });
      
      print('🎉 Successfully loaded ${chats.length} chats');

    } catch (e) {
      print('❌ Error loading chats: $e');
    }
  }

  // Helper methods for data extraction
  String _getStringField(Map<String, dynamic>? data, String field, String defaultValue) {
    try {
      if (data == null) return defaultValue;
      final value = data[field];
      if (value == null) return defaultValue;
      if (value is String) return value.trim().isEmpty ? defaultValue : value;
      return value.toString().trim().isEmpty ? defaultValue : value.toString();
    } catch (e) {
      return defaultValue;
    }
  }

  double _getDoubleField(Map<String, dynamic>? data, String field, double defaultValue) {
    try {
      if (data == null) return defaultValue;
      final value = data[field];
      if (value == null) return defaultValue;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) {
        if (value.trim().isEmpty) return defaultValue;
        return double.tryParse(value) ?? defaultValue;
      }
      return defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  int _getIntField(Map<String, dynamic>? data, String field, int defaultValue) {
    try {
      if (data == null) return defaultValue;
      final value = data[field];
      if (value == null) return defaultValue;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) {
        if (value.trim().isEmpty) return defaultValue;
        return int.tryParse(value) ?? defaultValue;
      }
      return defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  bool _getBoolField(Map<String, dynamic>? data, String field, bool defaultValue) {
    try {
      if (data == null) return defaultValue;
      final value = data[field];
      if (value == null) return defaultValue;
      if (value is bool) return value;
      if (value is String) return value.toLowerCase() == 'true';
      if (value is int) return value == 1;
      return defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  Map<String, dynamic> _getMapField(Map<String, dynamic>? data, String field) {
    try {
      if (data == null) return {};
      final value = data[field];
      if (value == null) return {};
      if (value is Map) return Map<String, dynamic>.from(value);
      return {};
    } catch (e) {
      return {};
    }
  }

  DateTime _getDateTimeField(Map<String, dynamic>? data, String field, DateTime defaultValue) {
    try {
      if (data == null) return defaultValue;
      final value = data[field];
      if (value == null) return defaultValue;
      if (value is Timestamp) return value.toDate();
      return defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  List<Customer> _getDefaultCustomers() {
    print('🔄 Loading default customers as fallback');
    return [
      Customer(
        id: '1',
        name: 'Raj Sharma',
        email: 'raj.sharma@email.com',
        phone: '+91 9876543210',
        address: '123 MG Road, Pune',
        city: 'Pune',
        image: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&w=400',
        joinDate: DateTime.now().subtract(const Duration(days: 30)),
        lastActive: DateTime.now(),
        orderCount: 5,
        totalSpent: 12500.0,
        averageOrderValue: 2500.0,
        isActive: true,
        isVerified: true,
        customerType: 'Regular',
        preferredContactMethod: 'WhatsApp',
        specialRequirements: 'Prefers cotton fabrics',
        allergies: 'None',
        preferredStyles: 'Traditional',
        measurements: {
          'chest': '42',
          'waist': '38',
          'hips': '44',
          'shoulder': '18'
        },
        notes: 'Regular customer, prefers timely delivery',
      ),
      Customer(
        id: '2',
        name: 'Priya Patel',
        email: 'priya.patel@email.com',
        phone: '+91 9876543211',
        address: '456 Fashion Street, Mumbai',
        city: 'Mumbai',
        image: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?ixlib=rb-4.0.3&w=400',
        joinDate: DateTime.now().subtract(const Duration(days: 15)),
        lastActive: DateTime.now(),
        orderCount: 3,
        totalSpent: 8500.0,
        averageOrderValue: 2833.33,
        isActive: true,
        isVerified: true,
        customerType: 'Premium',
        preferredContactMethod: 'Phone',
        specialRequirements: 'Requires extra fittings',
        allergies: 'Wool allergy',
        preferredStyles: 'Western',
        measurements: {
          'chest': '36',
          'waist': '32',
          'hips': '38',
          'shoulder': '16'
        },
        notes: 'VIP customer, handle with care',
      ),
      Customer(
        id: '3',
        name: 'Amit Kumar',
        email: 'amit.kumar@email.com',
        phone: '+91 9876543212',
        address: '789 Design Avenue, Delhi',
        city: 'Delhi',
        image: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&w=400',
        joinDate: DateTime.now().subtract(const Duration(days: 60)),
        lastActive: DateTime.now().subtract(const Duration(days: 5)),
        orderCount: 8,
        totalSpent: 21000.0,
        averageOrderValue: 2625.0,
        isActive: true,
        isVerified: true,
        customerType: 'Regular',
        preferredContactMethod: 'WhatsApp',
        specialRequirements: '',
        allergies: '',
        preferredStyles: 'Business Formal',
        measurements: {
          'chest': '44',
          'waist': '40',
          'hips': '42',
          'shoulder': '19'
        },
        notes: 'Corporate client, bulk orders possible',
      ),
    ];
  }

  List<Customer> get _filteredCustomers {
    if (_searchQuery.isEmpty) return _customers;
    final query = _searchQuery.toLowerCase();
    return _customers.where((customer) {
      return customer.name.toLowerCase().contains(query) ||
             customer.email.toLowerCase().contains(query) ||
             customer.phone.contains(_searchQuery) ||
             customer.city.toLowerCase().contains(query) ||
             customer.customerType.toLowerCase().contains(query) ||
             customer.preferredStyles.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> _startNewChat(Customer customer) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        _showSnackBar('Please sign in to start a chat');
        return;
      }

      print('🔄 Starting new chat with customer: ${customer.name}');

      // Check if chat already exists
      final existingChat = _chats.firstWhere(
        (chat) => chat.customer.id == customer.id,
        orElse: () => TailorChat(
          id: '', 
          customer: customer, 
          lastMessage: '', 
          lastMessageTime: DateTime.now(), 
          unreadCount: 0,
          orderStatus: 'No orders',
        ),
      );

      if (existingChat.id.isNotEmpty) {
        print('✅ Chat already exists, navigating to existing chat');
        _navigateToChat(existingChat);
        return;
      }

      // Create new chat
      final chatData = {
        'participants': [user.uid, customer.id],
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': '',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'unreadCount': 0,
        'customerName': customer.name,
        'tailorName': user.displayName ?? 'Tailor Shop',
        'lastOrderStatus': 'No orders',
        'customerData': {
          'name': customer.name,
          'email': customer.email,
          'phone': customer.phone,
          'image': customer.image,
        },
      };

      final chatDoc = await _firestore.collection('chats').add(chatData);
      print('✅ Created new chat with ID: ${chatDoc.id}');

      final newChat = TailorChat(
        id: chatDoc.id,
        customer: customer,
        lastMessage: '',
        lastMessageTime: DateTime.now(),
        unreadCount: 0,
        orderStatus: 'No orders',
      );

      setState(() {
        _chats.insert(0, newChat);
      });

      _navigateToChat(newChat);
    } catch (e) {
      print('❌ Error starting new chat: $e');
      _showSnackBar('Failed to start chat: ${e.toString()}');
    }
  }

  void _navigateToChat(TailorChat chat) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          currentUser: _auth.currentUser!.uid,
          receiverName: chat.customer.name,
          receiverImage: chat.customer.image,
          receiverId: chat.customer.id,
          chatId: chat.id,
        ),
      ),
    ).then((_) {
      _loadExistingChats();
    });
  }

  void _viewCustomerProfile(Customer customer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Customer Profile',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF8075FF),
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(customer.image),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(
                      color: const Color(0xFF8075FF),
                      width: 3,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildProfileItem('Name', customer.name),
              _buildProfileItem('Email', customer.email),
              _buildProfileItem('Phone', customer.phone),
              _buildProfileItem('Address', customer.address),
              _buildProfileItem('City', customer.city),
              _buildProfileItem('Customer Type', customer.customerType),
              _buildProfileItem('Preferred Contact', customer.preferredContactMethod),
              _buildProfileItem('Total Orders', '${customer.orderCount} orders'),
              _buildProfileItem('Total Spent', '₹${customer.totalSpent.toStringAsFixed(2)}'),
              _buildProfileItem('Average Order', '₹${customer.averageOrderValue.toStringAsFixed(2)}'),
              _buildProfileItem('Member Since', DateFormat('MMM dd, yyyy').format(customer.joinDate)),
              _buildProfileItem('Last Active', DateFormat('MMM dd, yyyy').format(customer.lastActive)),
              
              if (customer.specialRequirements.isNotEmpty) 
                _buildProfileItem('Special Requirements', customer.specialRequirements),
              if (customer.allergies.isNotEmpty) 
                _buildProfileItem('Allergies', customer.allergies),
              if (customer.preferredStyles.isNotEmpty) 
                _buildProfileItem('Preferred Styles', customer.preferredStyles),
              
              if (customer.measurements.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Measurements:',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF8075FF),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                ...customer.measurements.entries.map((entry) => 
                  _buildProfileItem(entry.key, '${entry.value} inches')
                ).toList(),
              ],
              
              if (customer.notes.isNotEmpty) 
                _buildProfileItem('Notes', customer.notes),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startNewChat(customer);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8075FF),
            ),
            child: Text(
              'Start Chat',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF8075FF),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Customer Messages',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF8075FF),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _errorMessage.isNotEmpty
              ? _buildErrorState()
              : _buildContent(),
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
          const SizedBox(height: 16),
          Text(
            'Loading customers and messages...',
            style: GoogleFonts.poppins(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Found ${_customers.length} customers & ${_chats.length} chats',
            style: GoogleFonts.poppins(
              color: Colors.grey[500],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadData,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8075FF),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'Try Again',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search customers by name, email, phone...',
                hintStyle: GoogleFonts.poppins(
                  color: Colors.grey[500],
                ),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF8075FF)),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
            ),
          ),
        ),

        // Stats Cards
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _buildStatCard('Customers', _customers.length, Icons.people),
              const SizedBox(width: 12),
              _buildStatCard('Chats', _chats.length, Icons.chat),
              const SizedBox(width: 12),
              _buildStatCard('Active', _getActiveCustomers(), Icons.online_prediction),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Tabs
        Expanded(
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: TabBar(
                    labelColor: const Color(0xFF8075FF),
                    unselectedLabelColor: Colors.grey[600],
                    indicatorColor: const Color(0xFF8075FF),
                    labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    tabs: [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.chat, size: 18),
                            const SizedBox(width: 6),
                            Text('Active Chats'),
                            if (_chats.isNotEmpty)
                              Container(
                                margin: const EdgeInsets.only(left: 6),
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF8075FF),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${_chats.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.people_alt, size: 18),
                            const SizedBox(width: 6),
                            Text('All Customers'),
                            if (_customers.isNotEmpty)
                              Container(
                                margin: const EdgeInsets.only(left: 6),
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF8075FF),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${_customers.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      // Active Chats Tab
                      _chats.isEmpty
                          ? _buildEmptyChatsState()
                          : RefreshIndicator(
                              onRefresh: _loadExistingChats,
                              child: ListView.builder(
                                itemCount: _chats.length,
                                itemBuilder: (context, index) {
                                  return _buildChatItem(_chats[index]);
                                },
                              ),
                            ),

                      // All Customers Tab
                      _filteredCustomers.isEmpty
                          ? _buildEmptyCustomersState()
                          : RefreshIndicator(
                              onRefresh: _loadCustomers,
                              child: ListView.builder(
                                itemCount: _filteredCustomers.length,
                                itemBuilder: (context, index) {
                                  return _buildCustomerItem(_filteredCustomers[index]);
                                },
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  int _getActiveCustomers() {
    return _chats.where((chat) => chat.unreadCount > 0).length;
  }

  Widget _buildStatCard(String title, int count, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF8075FF), size: 20),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '$count',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF8075FF),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyChatsState() {
    return RefreshIndicator(
      onRefresh: _loadExistingChats,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No active conversations',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Customer messages will appear here when they start conversations with you',
                  style: GoogleFonts.poppins(
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    DefaultTabController.of(context)?.animateTo(1);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8075FF),
                  ),
                  child: Text(
                    'View All Customers',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCustomersState() {
    return RefreshIndicator(
      onRefresh: _loadCustomers,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No customers found',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _searchQuery.isEmpty
                      ? 'No customers are currently registered.'
                      : 'No customers found for "$_searchQuery".',
                  style: GoogleFonts.poppins(
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                if (_searchQuery.isNotEmpty)
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                    child: Text(
                      'Clear Search',
                      style: GoogleFonts.poppins(color: const Color(0xFF8075FF)),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatItem(TailorChat chat) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 1,
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(chat.customer.image),
              fit: BoxFit.cover,
            ),
            border: Border.all(
              color: const Color(0xFF8075FF).withOpacity(0.3),
              width: 2,
            ),
          ),
        ),
        title: Text(
          chat.customer.name,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              chat.lastMessage.isNotEmpty 
                  ? chat.lastMessage 
                  : 'No messages yet',
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getStatusColor(chat.orderStatus).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    chat.orderStatus,
                    style: GoogleFonts.poppins(
                      color: _getStatusColor(chat.orderStatus),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${chat.customer.orderCount} orders',
                  style: GoogleFonts.poppins(
                    color: Colors.grey[500],
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _formatTime(chat.lastMessageTime),
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.grey[500],
              ),
            ),
            if (chat.unreadCount > 0) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF8075FF),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  chat.unreadCount > 9 ? '9+' : '${chat.unreadCount}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        onTap: () => _navigateToChat(chat),
        onLongPress: () => _viewCustomerProfile(chat.customer),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return DateFormat('MMM dd').format(dateTime);
    } else {
      return DateFormat('HH:mm').format(dateTime);
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in progress':
        return Colors.orange;
      case 'pending':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildCustomerItem(Customer customer) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 1,
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(customer.image),
              fit: BoxFit.cover,
            ),
            border: Border.all(
              color: const Color(0xFF8075FF).withOpacity(0.3),
              width: 2,
            ),
          ),
        ),
        title: Text(
          customer.name,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              customer.email,
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.shopping_bag, color: Colors.amber, size: 14),
                const SizedBox(width: 4),
                Text(
                  '${customer.orderCount} orders',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.attach_money, color: Colors.green, size: 14),
                const SizedBox(width: 4),
                Text(
                  '₹${customer.totalSpent.toStringAsFixed(0)}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.person, color: Colors.grey[600]),
              onPressed: () => _viewCustomerProfile(customer),
              tooltip: 'View Profile',
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF8075FF),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                'Chat',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        onTap: () => _startNewChat(customer),
      ),
    );
  }
}

// Customer Model
class Customer {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String city;
  final String image;
  final DateTime joinDate;
  final DateTime lastActive;
  final int orderCount;
  final double totalSpent;
  final double averageOrderValue;
  final bool isActive;
  final bool isVerified;
  final String customerType;
  final String preferredContactMethod;
  final String specialRequirements;
  final String allergies;
  final String preferredStyles;
  final Map<String, dynamic> measurements;
  final String notes;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.city,
    required this.image,
    required this.joinDate,
    required this.lastActive,
    required this.orderCount,
    required this.totalSpent,
    required this.averageOrderValue,
    required this.isActive,
    required this.isVerified,
    required this.customerType,
    required this.preferredContactMethod,
    required this.specialRequirements,
    required this.allergies,
    required this.preferredStyles,
    required this.measurements,
    required this.notes,
  });
}

class TailorChat {
  final String id;
  final Customer customer;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final String orderStatus;

  TailorChat({
    required this.id,
    required this.customer,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.orderStatus,
  });
}