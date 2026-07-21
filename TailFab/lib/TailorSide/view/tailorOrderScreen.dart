// lib/TailorSide/view/tailorOrderScreen.dart
import 'package:cloud_firestore/cloud_firestore.dart'hide Order;
import 'package:firebaseauth/TailorSide/model/tailor_order_model.dart';
import 'package:firebaseauth/TailorSide/view/tailor_orderCard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderScreen extends StatefulWidget {
  final String tailorId;

  const OrderScreen({Key? key, required this.tailorId}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<Order> orders = [];
  bool isLoading = true;
  String? errorMessage;
  bool hasIndexError = false;

  // Firestore reference
  final CollectionReference ordersCollection = 
      FirebaseFirestore.instance.collection('tailor_orders');

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  // Load orders from Firestore with error handling
  void _loadOrders() async {
    try {
      // First try the optimized query with ordering
      final query = ordersCollection
          .where('tailorId', isEqualTo: widget.tailorId)
          .orderBy('createdAt', descending: true);

      query.snapshots().listen((snapshot) {
        if (mounted) {
          setState(() {
            orders = snapshot.docs.map((doc) => Order.fromFirestore(doc)).toList();
            isLoading = false;
            errorMessage = null;
            hasIndexError = false;
          });
        }
      }, onError: (error) {
        // If there's an index error, try without ordering
        if (error.toString().contains('index') || error.toString().contains('FAILED_PRECONDITION')) {
          _loadOrdersWithoutOrdering();
        } else {
          if (mounted) {
            setState(() {
              isLoading = false;
              errorMessage = 'Error loading orders: $error';
            });
          }
          _showSnackBar('Error loading orders');
        }
      });
    } catch (error) {
      // Fallback to simple query
      _loadOrdersWithoutOrdering();
    }
  }

  // Fallback method without ordering
  void _loadOrdersWithoutOrdering() {
    ordersCollection
        .where('tailorId', isEqualTo: widget.tailorId)
        .snapshots()
        .listen((snapshot) {
      if (mounted) {
        setState(() {
          orders = snapshot.docs.map((doc) => Order.fromFirestore(doc)).toList();
          // Sort manually by createdAt in descending order
          orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
          isLoading = false;
          hasIndexError = true;
          errorMessage = null;
        });
      }
    }, onError: (error) {
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Error loading orders: $error';
        });
      }
      _showSnackBar('Error loading orders');
    });
  }

  // Accept order
  Future<void> _acceptOrder(int index) async {
    try {
      final order = orders[index];
      await ordersCollection.doc(order.id).update({
        'status': 'accepted',
        'updatedAt': FieldValue.serverTimestamp(),
        'rejectionReason': FieldValue.delete(),
      });
      _showSnackBar('Order ${order.id} accepted successfully!');
    } catch (error) {
      _showSnackBar('Error accepting order: $error');
    }
  }

  // Reject order
  void _rejectOrder(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String rejectionReason = '';
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Reject Order',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Please provide reason for rejection:',
                style: GoogleFonts.poppins(),
              ),
              SizedBox(height: 10),
              TextField(
                onChanged: (value) => rejectionReason = value,
                decoration: InputDecoration(
                  hintText: 'Enter rejection reason...',
                  hintStyle: GoogleFonts.poppins(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF8075FF), width: 2),
                  ),
                ),
                style: GoogleFonts.poppins(),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(color: Colors.grey[700]),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (rejectionReason.isNotEmpty) {
                  try {
                    final order = orders[index];
                    await ordersCollection.doc(order.id).update({
                      'status': 'rejected',
                      'rejectionReason': rejectionReason,
                      'updatedAt': FieldValue.serverTimestamp(),
                    });
                    Navigator.of(context).pop();
                    _showSnackBar('Order ${order.id} rejected.');
                  } catch (error) {
                    _showSnackBar('Error rejecting order: $error');
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please provide rejection reason',
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Reject Order',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(),
        ),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: Color(0xFF8075FF),
      ),
    );
  }

  void _showOrderDetails(Order order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OrderDetailsBottomSheet(order: order),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF8075FF), Colors.white],
            stops: [0.0, 0.6],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Tailor Orders',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              if (hasIndexError)
                IconButton(
                  icon: Icon(Icons.warning, color: Colors.orange, size: 26),
                  onPressed: _showIndexWarning,
                  tooltip: 'Index Warning',
                ),
              IconButton(
                icon: Icon(Icons.refresh, color: Colors.white, size: 26),
                onPressed: _loadOrders,
              ),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelColor: Color(0xFF8075FF),
                  unselectedLabelColor: Colors.white,
                  labelStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  unselectedLabelStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Pending'),
                          SizedBox(width: 4),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${orders.where((o) => o.status == OrderStatus.pending).length}',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
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
                          Text('Accepted'),
                          SizedBox(width: 4),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${orders.where((o) => o.status == OrderStatus.accepted).length}',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
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
                          Text('Rejected'),
                          SizedBox(width: 4),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${orders.where((o) => o.status == OrderStatus.rejected).length}',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
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
            ),
          ),
          body: isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Color(0xFF8075FF),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Loading orders...',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              : errorMessage != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 64, color: Colors.red),
                          SizedBox(height: 16),
                          Text(
                            'Error Loading Orders',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              errorMessage!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadOrders,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF8075FF),
                            ),
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : TabBarView(
                      children: [
                        _buildOrderList(OrderStatus.pending),
                        _buildOrderList(OrderStatus.accepted),
                        _buildOrderList(OrderStatus.rejected),
                      ],
                    ),
        ),
      ),
    );
  }

  void _showIndexWarning() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Database Optimization Required'),
        content: Text(
          'For better performance, please create a Firestore index. '
          'This app will work without it, but some features may be slower.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList(OrderStatus status) {
    final filteredOrders = orders.where((order) => order.status == status).toList();
    
    if (filteredOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                size: 80,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'No ${status.name} orders',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Orders will appear here once available',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredOrders.length,
      padding: EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        final originalIndex = orders.indexOf(order);
        
        return OrderCard(
          order: order,
          onTap: () => _showOrderDetails(order),
          onAccept: status == OrderStatus.pending ? () => _acceptOrder(originalIndex) : null,
          onReject: status == OrderStatus.pending ? () => _rejectOrder(originalIndex) : null,
        );
      },
    );
  }
}

// Keep the OrderDetailsBottomSheet class the same as before...
// Order Details Bottom Sheet
class OrderDetailsBottomSheet extends StatelessWidget {
  final Order order;

  const OrderDetailsBottomSheet({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // Draggable Handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order Details',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            order.id,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: _getStatusColor(order.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          order.status.name.toUpperCase(),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _getStatusColor(order.status),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Customer Info
                  _buildSectionTitle('Customer Information'),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(Icons.person, 'Name', order.customerName),
                        Divider(height: 20),
                        _buildInfoRow(Icons.phone, 'Phone', order.customerPhone),
                        if (order.customerEmail.isNotEmpty) ...[
                          Divider(height: 20),
                          _buildInfoRow(Icons.email, 'Email', order.customerEmail),
                        ],
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Order Items
                  _buildSectionTitle('Order Items'),
                  SizedBox(height: 12),
                  ...order.items.map((item) => _buildOrderItem(item)),
                  
                  SizedBox(height: 24),
                  
                  // Payment Info
                  _buildSectionTitle('Payment Information'),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF8075FF).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Color(0xFF8075FF).withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Amount',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '₹${order.totalAmount.toStringAsFixed(2)}',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8075FF),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  if (order.rejectionReason != null) ...[
                    SizedBox(height: 24),
                    _buildSectionTitle('Rejection Reason'),
                    SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.red.withOpacity(0.2)),
                      ),
                      child: Text(
                        order.rejectionReason!,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.red[700],
                        ),
                      ),
                    ),
                  ],
                  
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Color(0xFF8075FF)),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItem(OrderItem item) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.garmentType,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '₹${item.price.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8075FF),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              _buildDetailChip('Fabric', item.fabric),
              SizedBox(width: 8),
              _buildDetailChip('Color', item.color),
              SizedBox(width: 8),
              _buildDetailChip('Qty', item.quantity.toString()),
            ],
          ),
          if (item.specialInstructions.isNotEmpty) ...[
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.amber.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.amber[700]),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.specialInstructions,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: 12),
          Text(
            'Measurements:',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: item.measurements.entries.map((entry) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFF8075FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${entry.key}: ${entry.value}',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Color(0xFF8075FF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailChip(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label: $value',
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.accepted:
        return Colors.green;
      case OrderStatus.rejected:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}