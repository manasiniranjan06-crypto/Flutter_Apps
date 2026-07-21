// chat_list_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  List<Shop> _shops = [];
  List<Chat> _chats = [];
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
        _loadShops(),
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

  Future<void> _loadShops() async {
    try {
      print('🔄 Starting to load shops from Firestore...');
      
      final querySnapshot = await _firestore
          .collection('tailors')
          .get(); // Remove the where clause to get all tailors

      print('✅ Found ${querySnapshot.docs.length} tailor documents');

      List<Shop> shops = [];
      
      for (var doc in querySnapshot.docs) {
        try {
          final data = doc.data();
          print('📄 Processing document: ${doc.id}');
          print('📊 Document data: $data');
          
          // Extract data with proper null checks and type conversion
          final String shopName = _getStringField(data, 'shopName', 'Tailor Shop');
          final String ownerName = _getStringField(data, 'name', 'Tailor');
          final String address = _getStringField(data, 'address', 'Address not available');
          final String category = _getStringField(data, 'category', 'General Tailoring');
          final String city = _getStringField(data, 'city', 'City');
          final String image = _getStringField(data, 'profileImage', 'https://images.unsplash.com/photo-1560493676-04071c5f467b?w=400');
          final String description = _getStringField(data, 'description', 'Professional tailoring services');
          
          // Get rating and reviews with proper fallbacks
          final double rating = _getDoubleField(data, 'rating', 4.0);
          final int reviews = _getIntField(data, 'reviews', 0);
          
          shops.add(Shop(
            id: doc.id,
            name: ownerName,
            shopName: shopName,
            address: address,
            image: image,
            rating: rating,
            reviews: reviews,
            distance: 0.0, // You can calculate this based on user location
            isOpen: _getBoolField(data, 'isOpen', true),
            category: category,
            description: description,
          ));
          
          print('✅ Added shop: $shopName by $ownerName');
          
        } catch (e) {
          print('❌ Error processing document ${doc.id}: $e');
        }
      }

      print('🎉 Successfully processed ${shops.length} shops');

      setState(() {
        _shops = shops;
      });

    } catch (e) {
      print('❌ Error loading shops from Firestore: $e');
      // Use default shops as fallback
      _shops = _getDefaultShops();
      rethrow;
    }
  }

  Future<void> _loadExistingChats() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('⚠️ No user logged in');
        return;
      }

      print('🔄 Loading existing chats for user: ${user.uid}');

      final querySnapshot = await _firestore
          .collection('chats')
          .where('participants', arrayContains: user.uid)
          .orderBy('lastMessageTime', descending: true)
          .get();

      print('✅ Found ${querySnapshot.docs.length} chat documents');

      List<Chat> chats = [];
      
      for (var doc in querySnapshot.docs) {
        try {
          final data = doc.data();
          final participants = List<String>.from(data['participants'] ?? []);
          final otherUserId = participants.firstWhere(
            (id) => id != user.uid,
            orElse: () => '',
          );

          if (otherUserId.isNotEmpty) {
            print('🔍 Loading shop details for: $otherUserId');
            
            // Get shop details for this chat
            final shopDoc = await _firestore.collection('tailors').doc(otherUserId).get();
            if (shopDoc.exists) {
              final shopData = shopDoc.data()!;
              chats.add(Chat(
                id: doc.id,
                shop: Shop(
                  id: otherUserId,
                  name: _getStringField(shopData, 'name', 'Tailor'),
                  shopName: _getStringField(shopData, 'shopName', 'Tailor Shop'),
                  address: _getStringField(shopData, 'address', 'Address not available'),
                  image: _getStringField(shopData, 'profileImage', 'https://images.unsplash.com/photo-1560493676-04071c5f467b?w=400'),
                  rating: _getDoubleField(shopData, 'rating', 4.0),
                  reviews: _getIntField(shopData, 'reviews', 0),
                  distance: 0.0,
                  isOpen: _getBoolField(shopData, 'isOpen', true),
                  category: _getStringField(shopData, 'category', 'General Tailoring'),
                  description: _getStringField(shopData, 'description', 'Professional tailoring services'),
                ),
                lastMessage: data['lastMessage'] ?? '',
                lastMessageTime: data['lastMessageTime'] != null 
                    ? (data['lastMessageTime'] as Timestamp).toDate()
                    : DateTime.now(),
                unreadCount: data['unreadCount'] ?? 0,
              ));
              print('✅ Added chat with shop: ${_getStringField(shopData, 'shopName', 'Unknown Shop')}');
            } else {
              print('⚠️ Shop document not found for: $otherUserId');
            }
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
      // Don't throw here, just continue without chats
    }
  }

  String _getStringField(Map<String, dynamic> data, String field, String defaultValue) {
    try {
      final value = data[field];
      if (value == null) return defaultValue;
      if (value is String) return value.trim().isEmpty ? defaultValue : value;
      return value.toString().trim().isEmpty ? defaultValue : value.toString();
    } catch (e) {
      return defaultValue;
    }
  }

  double _getDoubleField(Map<String, dynamic> data, String field, double defaultValue) {
    try {
      final value = data[field];
      if (value == null) return defaultValue;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? defaultValue;
      return defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  int _getIntField(Map<String, dynamic> data, String field, int defaultValue) {
    try {
      final value = data[field];
      if (value == null) return defaultValue;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.tryParse(value) ?? defaultValue;
      return defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  bool _getBoolField(Map<String, dynamic> data, String field, bool defaultValue) {
    try {
      final value = data[field];
      if (value == null) return defaultValue;
      if (value is bool) return value;
      if (value is String) return value.toLowerCase() == 'true';
      return defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  List<Shop> _getDefaultShops() {
    print('🔄 Loading default shops as fallback');
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
    ];
  }

  List<Shop> get _filteredShops {
    if (_searchQuery.isEmpty) return _shops;
    return _shops.where((shop) {
      return shop.shopName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             shop.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             shop.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             shop.description.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  Future<void> _startNewChat(Shop shop) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        _showSnackBar('Please sign in to start a chat');
        return;
      }

      print('🔄 Starting new chat with shop: ${shop.shopName}');

      // Check if chat already exists
      final existingChat = _chats.firstWhere(
        (chat) => chat.shop.id == shop.id,
        orElse: () => Chat(id: '', shop: shop, lastMessage: '', lastMessageTime: DateTime.now(), unreadCount: 0),
      );

      if (existingChat.id.isNotEmpty) {
        print('✅ Chat already exists, navigating to existing chat');
        _navigateToChat(existingChat);
        return;
      }

      // Create new chat
      final chatData = {
        'participants': [user.uid, shop.id],
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': '',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'unreadCount': 0,
        'customerName': user.displayName ?? 'Customer',
        'tailorName': shop.shopName,
      };

      final chatDoc = await _firestore.collection('chats').add(chatData);
      print('✅ Created new chat with ID: ${chatDoc.id}');

      final newChat = Chat(
        id: chatDoc.id,
        shop: shop,
        lastMessage: '',
        lastMessageTime: DateTime.now(),
        unreadCount: 0,
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

  void _navigateToChat(Chat chat) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          currentUser: _auth.currentUser!.uid,
          receiverName: chat.shop.shopName,
          receiverImage: chat.shop.image,
          receiverId: chat.shop.id,
          chatId: chat.id,
        ),
      ),
    ).then((_) {
      // Refresh chats when returning from chat screen
      _loadExistingChats();
    });
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
          'Messages',
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
            'Loading shops and messages...',
            style: GoogleFonts.poppins(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Found ${_shops.length} shops & ${_chats.length} chats',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _shops = _getDefaultShops();
                      _errorMessage = '';
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    'Use Demo Data',
                    style: GoogleFonts.poppins(color: const Color(0xFF8075FF)),
                  ),
                ),
              ],
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
                hintText: 'Search shops by name, category...',
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

        // Stats Info
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _buildStatCard('Shops', _shops.length, Icons.store),
              const SizedBox(width: 12),
              _buildStatCard('Chats', _chats.length, Icons.chat),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Tabs for Existing Chats and New Shops
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
                    unselectedLabelStyle: GoogleFonts.poppins(),
                    tabs: [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.chat, size: 18),
                            const SizedBox(width: 6),
                            Text('Chats'),
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
                            const Icon(Icons.store, size: 18),
                            const SizedBox(width: 6),
                            Text('Shops'),
                            if (_shops.isNotEmpty)
                              Container(
                                margin: const EdgeInsets.only(left: 6),
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF8075FF),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${_shops.length}',
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
                      // Existing Chats Tab
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

                      // New Shops Tab
                      _filteredShops.isEmpty
                          ? _buildEmptyShopsState()
                          : RefreshIndicator(
                              onRefresh: _loadShops,
                              child: ListView.builder(
                                itemCount: _filteredShops.length,
                                itemBuilder: (context, index) {
                                  return _buildShopItem(_filteredShops[index]);
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
                  'No conversations yet',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Start a conversation with any shop to discuss your tailoring needs',
                    style: GoogleFonts.poppins(
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Switch to shops tab
                    DefaultTabController.of(context)?.animateTo(1);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8075FF),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    'Browse Shops',
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

  Widget _buildEmptyShopsState() {
    return RefreshIndicator(
      onRefresh: _loadShops,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.store_mall_directory_outlined,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No shops found',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    _searchQuery.isEmpty
                        ? 'No tailor shops are currently available. Please check back later.'
                        : 'No shops found for "$_searchQuery". Try a different search term.',
                    style: GoogleFonts.poppins(
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
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

  Widget _buildChatItem(Chat chat) {
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
              image: NetworkImage(chat.shop.image),
              fit: BoxFit.cover,
            ),
            border: Border.all(
              color: const Color(0xFF8075FF).withOpacity(0.3),
              width: 2,
            ),
          ),
        ),
        title: Text(
          chat.shop.shopName,
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
            Text(
              'by ${chat.shop.name} • ${chat.shop.category}',
              style: GoogleFonts.poppins(
                color: const Color(0xFF8075FF),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              DateFormat('HH:mm').format(chat.lastMessageTime),
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
      ),
    );
  }

  Widget _buildShopItem(Shop shop) {
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
              image: NetworkImage(shop.image),
              fit: BoxFit.cover,
            ),
            border: Border.all(
              color: const Color(0xFF8075FF).withOpacity(0.3),
              width: 2,
            ),
          ),
        ),
        title: Text(
          shop.shopName,
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
              'by ${shop.name}',
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 14),
                const SizedBox(width: 4),
                Text(
                  '${shop.rating}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8075FF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    shop.category,
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF8075FF),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Container(
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
        onTap: () => _startNewChat(shop),
      ),
    );
  }
}

// Models
class Shop {
  final String id;
  final String name;
  final String shopName;
  final String image;
  final double rating;
  final int reviews;
  final double distance;
  final bool isOpen;
  final String category;
  final String description;
  final String address;

  Shop({
    required this.id,
    required this.name,
    required this.shopName,
    required this.image,
    required this.rating,
    required this.reviews,
    required this.distance,
    required this.isOpen,
    required this.category,
    required this.description,
    required this.address,
  });
}

class Chat {
  final String id;
  final Shop shop;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  Chat({
    required this.id,
    required this.shop,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
  });
}