import 'package:firebaseauth/customerside/screens/order_tracking_screen.dart';
import 'package:firebaseauth/fabricSide/practice/ordertracking.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderHistoryPage extends StatefulWidget {
  final Color primaryColor;
  final Color accentColor;
  final Color cardColor;
  final Color textPrimary;
  final Color textSecondary;

  const OrderHistoryPage({
    required this.primaryColor,
    required this.accentColor,
    required this.cardColor,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedFilter = 'All';
  
  final List<String> filters = ['All', 'Delivered', 'Processing', 'Cancelled'];
  
  final List<Map<String, dynamic>> orders = [
    {
      'orderId': 'ORD123456789',
      'date': 'Oct 11, 2025',
      'status': 'Processing',
      'statusColor': Colors.orange,
      'items': 2,
      'total': 1250,
      'image': 'https://picsum.photos/seed/order1/400/500',
      'deliveryDate': 'Oct 14, 2025',
      'canCancel': true,
      'canReorder': false,
    },
    {
      'orderId': 'ORD123456788',
      'date': 'Oct 8, 2025',
      'status': 'Delivered',
      'statusColor': Colors.green,
      'items': 3,
      'total': 2100,
      'image': 'https://picsum.photos/seed/order2/400/500',
      'deliveryDate': 'Oct 10, 2025',
      'canCancel': false,
      'canReorder': true,
    },
    {
      'orderId': 'ORD123456787',
      'date': 'Oct 5, 2025',
      'status': 'Delivered',
      'statusColor': Colors.green,
      'items': 1,
      'total': 850,
      'image': 'https://picsum.photos/seed/order3/400/500',
      'deliveryDate': 'Oct 7, 2025',
      'canCancel': false,
      'canReorder': true,
    },
    {
      'orderId': 'ORD123456786',
      'date': 'Oct 1, 2025',
      'status': 'Cancelled',
      'statusColor': Colors.red,
      'items': 2,
      'total': 1500,
      'image': 'https://picsum.photos/seed/order4/400/500',
      'deliveryDate': 'N/A',
      'canCancel': false,
      'canReorder': true,
    },
    {
      'orderId': 'ORD123456785',
      'date': 'Sep 28, 2025',
      'status': 'Delivered',
      'statusColor': Colors.green,
      'items': 4,
      'total': 3200,
      'image': 'https://picsum.photos/seed/order5/400/500',
      'deliveryDate': 'Sep 30, 2025',
      'canCancel': false,
      'canReorder': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredOrders {
    if (selectedFilter == 'All') return orders;
    return orders.where((order) => order['status'] == selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.cardColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildStatsSection(),
          _buildFilterSection(),
          Expanded(
            child: filteredOrders.isEmpty
              ? _buildEmptyState()
              : _buildOrdersList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: widget.primaryColor,
        icon: Icon(Icons.shopping_bag),
        label: Text(
          'Shop Now',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: widget.primaryColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'My Orders',
        style: GoogleFonts.playfairDisplay(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: Colors.white),
          onPressed: () => _showSearchDialog(),
        ),
        IconButton(
          icon: Icon(Icons.filter_list, color: Colors.white),
          onPressed: () => _showFilterSheet(),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.primaryColor,
            widget.primaryColor.withOpacity(0.8),
          ],
        ),
      ),
      child: Row(
        children: [
          _buildStatCard('Total Orders', '${orders.length}', Icons.shopping_bag),
          SizedBox(width: 12),
          _buildStatCard('Delivered', '${orders.where((o) => o['status'] == 'Delivered').length}', Icons.check_circle),
          SizedBox(width: 12),
          _buildStatCard('Processing', '${orders.where((o) => o['status'] == 'Processing').length}', Icons.hourglass_empty),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.9),
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedFilter = filter;
              });
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              margin: EdgeInsets.only(right: 12),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected 
                  ? widget.primaryColor 
                  : widget.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected 
                    ? widget.primaryColor 
                    : widget.primaryColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  filter,
                  style: GoogleFonts.poppins(
                    color: isSelected ? Colors.white : widget.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrdersList() {
    return ListView.builder(
      padding: EdgeInsets.all(20),
      physics: BouncingScrollPhysics(),
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        return _buildOrderCard(order, index);
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order, int index) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: Container(
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: widget.cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: widget.primaryColor.withOpacity(0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                order['image'],
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          order['orderId'],
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: widget.textPrimary,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: order['statusColor'].withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          order['status'],
                                          style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: order['statusColor'],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        size: 12,
                                        color: widget.textSecondary,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        order['date'],
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: widget.textSecondary,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Icon(
                                        Icons.shopping_basket,
                                        size: 12,
                                        color: widget.textSecondary,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        '${order['items']} items',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: widget.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '₹${order['total']}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: widget.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => tractorderpage(
                                        orderId: order['orderId'],
                                        primaryColor: widget.primaryColor,
                                        accentColor: widget.accentColor,
                                        cardColor: widget.cardColor,
                                        textPrimary: widget.textPrimary,
                                        textSecondary: widget.textSecondary, order: {},
                                      ),
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: widget.primaryColor,
                                  side: BorderSide(
                                    color: widget.primaryColor,
                                    width: 2,
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'View Details',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            if (order['canReorder']) ...[
                              SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    _showReorderDialog(order);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: widget.primaryColor,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    'Reorder',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            if (order['canCancel']) ...[
                              SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _showCancelDialog(order),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: widget.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              size: 80,
              color: widget.primaryColor,
            ),
          ),
          SizedBox(height: 24),
          Text(
            'No Orders Found',
            style: GoogleFonts.playfairDisplay(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: widget.textPrimary,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'You haven\'t placed any orders yet.\nStart shopping to see your orders here!',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: widget.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Start Shopping',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Search Orders',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: TextField(
          decoration: InputDecoration(
            hintText: 'Enter order ID or product name',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: widget.cardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filter Orders',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: widget.textPrimary,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Order Status',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: widget.textPrimary,
                    ),
                  ),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: filters.map((filter) {
                      return FilterChip(
                        label: Text(filter),
                        selected: selectedFilter == filter,
                        onSelected: (selected) {
                          setState(() {
                            selectedFilter = filter;
                          });
                          Navigator.pop(context);
                        },
                        backgroundColor: widget.primaryColor.withOpacity(0.1),
                        selectedColor: widget.primaryColor,
                        labelStyle: GoogleFonts.poppins(
                          color: selectedFilter == filter 
                            ? Colors.white 
                            : widget.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Cancel Order?',
                style: GoogleFonts.poppins(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to cancel order ${order['orderId']}? This action cannot be undone.',
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No, Keep It'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                order['status'] = 'Cancelled';
                order['statusColor'] = Colors.red;
                order['canCancel'] = false;
                order['canReorder'] = true;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Order cancelled successfully'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  void _showReorderDialog(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.refresh, color: widget.primaryColor),
            SizedBox(width: 12),
            Text(
              'Reorder Items?',
              style: GoogleFonts.poppins(fontSize: 18),
            ),
          ],
        ),
        content: Text(
          'Do you want to add all items from order ${order['orderId']} to your cart?',
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${order['items']} items added to cart'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  action: SnackBarAction(
                    label: 'VIEW CART',
                    textColor: Colors.white,
                    onPressed: () {},
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Add to Cart'),
          ),
        ],
      ),
    );
  }
}