
// TailorSide/view/tailorCustomOrders.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebaseauth/customerside/components/gradient_scaffold.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';

class TailorCustomOrdersScreen extends StatefulWidget {
  const TailorCustomOrdersScreen({Key? key}) : super(key: key);

  @override
  State<TailorCustomOrdersScreen> createState() => _TailorCustomOrdersScreenState();
}

class _TailorCustomOrdersScreenState extends State<TailorCustomOrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  OrderStatus _selectedStatus = OrderStatus.all;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<CustomOrder> _orders = [
    CustomOrder(
      id: 'ORD-2024-1001',
      customerName: 'Rajesh Kumar',
      customerPhone: '+91 98765 43210',
      serviceName: 'Custom Suit',
      serviceType: 'Bespoke Tailoring',
      fabric: 'Italian Wool',
      status: OrderStatus.pending,
      orderDate: DateTime.now().subtract(Duration(hours: 2)),
      deadline: DateTime.now().add(Duration(days: 7)),
      totalAmount: 12000,
      advancePaid: 6000,
      measurements: {
        'Chest': '42"',
        'Waist': '36"',
        'Shoulder': '18"',
        'Sleeve': '25"',
        'Length': '30"',
      },
      specialInstructions: 'Extra padding on shoulders, slim fit preferred',
      priority: OrderPriority.high,
    ),
    CustomOrder(
      id: 'ORD-2024-1002',
      customerName: 'Priya Sharma',
      customerPhone: '+91 87654 32109',
      serviceName: 'Custom Dress',
      serviceType: 'Evening Gown',
      fabric: 'French Chiffon',
      status: OrderStatus.inProgress,
      orderDate: DateTime.now().subtract(Duration(days: 3)),
      deadline: DateTime.now().add(Duration(days: 9)),
      totalAmount: 8500,
      advancePaid: 4000,
      measurements: {
        'Bust': '36"',
        'Waist': '28"',
        'Hip': '38"',
        'Length': '42"',
      },
      specialInstructions: 'V-neck design, floor length',
      priority: OrderPriority.medium,
      progress: 45,
    ),
    CustomOrder(
      id: 'ORD-2024-1003',
      customerName: 'Amit Patel',
      customerPhone: '+91 76543 21098',
      serviceName: 'Custom Shirt',
      serviceType: 'Formal Shirt',
      fabric: 'Supima Cotton',
      status: OrderStatus.readyForFitting,
      orderDate: DateTime.now().subtract(Duration(days: 5)),
      deadline: DateTime.now().add(Duration(days: 2)),
      totalAmount: 4500,
      advancePaid: 2250,
      measurements: {
        'Neck': '15.5"',
        'Chest': '40"',
        'Waist': '34"',
        'Sleeve': '34"',
      },
      specialInstructions: 'French cuffs, spread collar',
      priority: OrderPriority.low,
      progress: 85,
    ),
    CustomOrder(
      id: 'ORD-2024-1004',
      customerName: 'Sneha Reddy',
      customerPhone: '+91 65432 10987',
      serviceName: 'Custom Trousers',
      serviceType: 'Formal Pants',
      fabric: 'Wool Blend',
      status: OrderStatus.completed,
      orderDate: DateTime.now().subtract(Duration(days: 10)),
      deadline: DateTime.now().subtract(Duration(days: 2)),
      totalAmount: 3500,
      advancePaid: 3500,
      measurements: {
        'Waist': '32"',
        'Hip': '40"',
        'Length': '38"',
        'Thigh': '24"',
      },
      specialInstructions: 'Pleated front, cuffed bottom',
      priority: OrderPriority.medium,
      progress: 100,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<CustomOrder> get _filteredOrders {
    return _orders.where((order) {
      final matchesSearch = order.customerName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          order.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          order.serviceName.toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesStatus = _selectedStatus == OrderStatus.all || order.status == _selectedStatus;
      
      return matchesSearch && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Custom Orders',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.white, size: 26),
            onPressed: _showFilterOptions,
          ),
          IconButton(
            icon: Icon(Icons.calendar_today, color: Colors.white, size: 24),
            onPressed: ()=>showCalendarView(context),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSearchAndStats(),
          _buildStatusTabs(),
          Expanded(
            child: _filteredOrders.isEmpty
                ? _buildEmptyState()
                : _buildOrdersList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndStats() {
    final pendingCount = _orders.where((o) => o.status == OrderStatus.pending).length;
    final inProgressCount = _orders.where((o) => o.status == OrderStatus.inProgress).length;
    final urgentCount = _orders.where((o) => o.priority == OrderPriority.high).length;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
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
                hintText: 'Search by customer, order ID...',
                hintStyle: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 14),
                prefixIcon: Icon(Icons.search, color: Color(0xFF8075FF)),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey),
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
          
          SizedBox(height: 16),
          
          // Stats Cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Pending',
                  pendingCount.toString(),
                  Icons.pending_actions,
                  Colors.orange,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'In Progress',
                  inProgressCount.toString(),
                  Icons.build,
                  Colors.blue,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Urgent',
                  urgentCount.toString(),
                  Icons.priority_high,
                  Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTabs() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: OrderStatus.values.map((status) {
          final isSelected = _selectedStatus == status;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                _getStatusLabel(status),
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedStatus = status;
                });
              },
              backgroundColor: Colors.white.withOpacity(0.8),
              selectedColor: Color(0xFF8075FF),
              checkmarkColor: Colors.white,
              elevation: 2,
              shadowColor: Colors.black.withOpacity(0.1),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOrdersList() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _filteredOrders.length,
      itemBuilder: (context, index) {
        return _buildOrderCard(_filteredOrders[index]);
      },
    );
  }

  Widget _buildOrderCard(CustomOrder order) {
    final daysUntilDeadline = order.deadline.difference(DateTime.now()).inDays;
    final isUrgent = daysUntilDeadline <= 3;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: isUrgent ? Border.all(color: Colors.red.withOpacity(0.3), width: 2) : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showOrderDetails(order),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    // Priority Indicator
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(order.priority).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.flag,
                            size: 12,
                            color: _getPriorityColor(order.priority),
                          ),
                          SizedBox(width: 4),
                          Text(
                            order.priority.name.toUpperCase(),
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: _getPriorityColor(order.priority),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    Spacer(),
                    
                    // Order ID
                    Text(
                      order.id,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 12),
                
                // Customer Info
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0xFF8075FF).withOpacity(0.1),
                      radius: 25,
                      child: Text(
                        order.customerName.substring(0, 1).toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8075FF),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.customerName,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(Icons.phone, size: 12, color: Colors.grey[600]),
                              SizedBox(width: 4),
                              Text(
                                order.customerPhone,
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
                    
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(order.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getStatusLabel(order.status),
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(order.status),
                        ),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 12),
                
                Divider(height: 1, color: Colors.grey[300]),
                
                SizedBox(height: 12),
                
                // Service Details
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.serviceName,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Fabric: ${order.fabric}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹${order.totalAmount.toStringAsFixed(0)}',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8075FF),
                          ),
                        ),
                        if (order.advancePaid < order.totalAmount)
                          Text(
                            '₹${(order.totalAmount - order.advancePaid).toStringAsFixed(0)} due',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.red[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                
                SizedBox(height: 12),
                
                // Progress Bar (for in-progress orders)
                if (order.status == OrderStatus.inProgress && order.progress != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Progress',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${order.progress}%',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Color(0xFF8075FF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: order.progress! / 100,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8075FF)),
                          minHeight: 8,
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                
                // Timeline Info
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                    SizedBox(width: 4),
                    Text(
                      'Ordered: ${_formatDate(order.orderDate)}',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.event,
                      size: 14,
                      color: isUrgent ? Colors.red : Colors.grey[600],
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Due: ${_formatDate(order.deadline)}',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: isUrgent ? Colors.red : Colors.grey[600],
                        fontWeight: isUrgent ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 12),
                
                // Quick Actions
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _callCustomer(order),
                        icon: Icon(Icons.phone, size: 16),
                        label: Text(
                          'Call',
                          style: GoogleFonts.poppins(fontSize: 12),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Color(0xFF8075FF),
                          side: BorderSide(color: Color(0xFF8075FF)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _updateOrderStatus(order),
                        icon: Icon(Icons.update, size: 16),
                        label: Text(
                          'Update',
                          style: GoogleFonts.poppins(fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF8075FF),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 8),
                        ),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 80, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'No orders found',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Orders will appear here',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.all:
        return 'All';
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.inProgress:
        return 'In Progress';
      case OrderStatus.readyForFitting:
        return 'Ready for Fitting';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.delivered:
        return 'Delivered';
    }
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.inProgress:
        return Colors.blue;
      case OrderStatus.readyForFitting:
        return Colors.purple;
      case OrderStatus.completed:
        return Colors.green;
      case OrderStatus.delivered:
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  Color _getPriorityColor(OrderPriority priority) {
    switch (priority) {
      case OrderPriority.low:
        return Colors.green;
      case OrderPriority.medium:
        return Colors.orange;
      case OrderPriority.high:
        return Colors.red;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Tomorrow';
    if (difference == -1) return 'Yesterday';
    if (difference > 0) return 'In $difference days';
    return '${difference.abs()} days ago';
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Orders',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ...OrderStatus.values.map((status) => RadioListTile<OrderStatus>(
              title: Text(_getStatusLabel(status)),
              value: status,
              groupValue: _selectedStatus,
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value!;
                });
                Navigator.pop(context);
              },
              activeColor: Color(0xFF8075FF),
            )),
          ],
        ),
      ),
    );
  }

  void showCalendarView(BuildContext context) {
  DateTime today = DateTime.now();

  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Color(0xFF8075FF), Color(0xFF5F4BDB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '📅 Select Delivery Date',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TableCalendar(
                    focusedDay: today,
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    calendarStyle: const CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Color(0xFF8075FF),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Colors.deepPurple,
                        shape: BoxShape.circle,
                      ),
                    ),
                    selectedDayPredicate: (day) => isSameDay(day, today),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        today = selectedDay;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF8075FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Selected Date: ${today.day}-${today.month}-${today.year}',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: const Text('Confirm Date'),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}

  void _callCustomer(CustomOrder order) {
    Future<void> _makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  if (!await launchUrl(launchUri)) {
    throw Exception('Could not launch $phoneNumber');
  }
}
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Call Customer', style: GoogleFonts.poppins()),
        content: Text('Call ${order.customerName} at ${order.customerPhone}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
  Navigator.pop(context);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Calling ${order.customerName}...'),
      backgroundColor: Colors.green,
    ),
  );
  await _makePhoneCall(order.customerPhone);
},
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text('Call'),
          ),
        ],
      ),
    );
  }

  void _updateOrderStatus(CustomOrder order) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Update Order Status',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ...OrderStatus.values.where((s) => s != OrderStatus.all).map((status) => 
              ListTile(
                leading: Icon(
                  _getStatusIcon(status),
                  color: _getStatusColor(status),
                ),
                title: Text(_getStatusLabel(status)),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    order.status = status;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Order status updated to ${_getStatusLabel(status)}'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Icons.pending_actions;
      case OrderStatus.inProgress:
        return Icons.build;
      case OrderStatus.readyForFitting:
        return Icons.checkroom;
      case OrderStatus.completed:
        return Icons.check_circle;
      case OrderStatus.delivered:
        return Icons.local_shipping;
      default:
        return Icons.list;
    }
  }

  void _showOrderDetails(CustomOrder order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OrderDetailsSheet(order: order),
    );
  }
}

class OrderDetailsSheet extends StatelessWidget {
  final CustomOrder order;

  const OrderDetailsSheet({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          // Handle
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
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.serviceName,
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
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: _getStatusColor(order.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          _getStatusLabel(order.status),
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
                  
                  // Customer Information
                  _buildSectionTitle('Customer Information'),
                  SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(Icons.person, 'Name', order.customerName),
                        Divider(height: 20),
                        _buildInfoRow(Icons.phone, 'Phone', order.customerPhone),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Order Details
                  _buildSectionTitle('Order Details'),
                  SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(Icons.checkroom, 'Service', order.serviceName),
                        Divider(height: 20),
                        _buildInfoRow(Icons.category, 'Type', order.serviceType),
                        Divider(height: 20),
                        _buildInfoRow(Icons.texture, 'Fabric', order.fabric),
                        Divider(height: 20),
                        _buildInfoRow(Icons.calendar_today, 'Order Date', _formatFullDate(order.orderDate)),
                        Divider(height: 20),
                        _buildInfoRow(Icons.event, 'Deadline', _formatFullDate(order.deadline)),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Measurements
                  _buildSectionTitle('Measurements'),
                  SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF8075FF).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Color(0xFF8075FF).withOpacity(0.2)),
                    ),
                    child: Column(
                      children: order.measurements.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                entry.key,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Text(
                                entry.value,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF8075FF),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Special Instructions
                  if (order.specialInstructions.isNotEmpty) ...[
                    _buildSectionTitle('Special Instructions'),
                    SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.amber.withOpacity(0.3)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline, color: Colors.amber[700], size: 20),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              order.specialInstructions,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[800],
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                  
                  // Payment Information
                  _buildSectionTitle('Payment Information'),
                  SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Amount',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                            Text(
                              '₹${order.totalAmount.toStringAsFixed(0)}',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Advance Paid',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                            Text(
                              '₹${order.advancePaid.toStringAsFixed(0)}',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.green[700],
                              ),
                            ),
                          ],
                        ),
                        Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Balance Due',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                            Text(
                              '₹${(order.totalAmount - order.advancePaid).toStringAsFixed(0)}',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.red[700],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 30),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
  child: OutlinedButton.icon(
    onPressed: () async {
      Navigator.pop(context); // Close bottom sheet or dialog first

      const String phoneNumber = "9876543210"; 
      final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);

      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not make the call'),
            backgroundColor: Colors.red,
          ),
        );
      }
    },
    icon: const Icon(Icons.phone, size: 18),
    label: const Text('Call Customer'),
    style: OutlinedButton.styleFrom(
      foregroundColor: const Color(0xFF8075FF),
      side: const BorderSide(color: Color(0xFF8075FF), width: 2),
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    ),
  ),
),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            // Update status
                          },
                          icon: Icon(Icons.edit, size: 18),
                          label: Text('Update Status'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF8075FF),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
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
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
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
              SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatFullDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.inProgress:
        return Colors.blue;
      case OrderStatus.readyForFitting:
        return Colors.purple;
      case OrderStatus.completed:
        return Colors.green;
      case OrderStatus.delivered:
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.all:
        return 'All';
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.inProgress:
        return 'In Progress';
      case OrderStatus.readyForFitting:
        return 'Ready for Fitting';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.delivered:
        return 'Delivered';
    }
  }
}

// Models
class CustomOrder {
  String id;
  String customerName;
  String customerPhone;
  String serviceName;
  String serviceType;
  String fabric;
  OrderStatus status;
  DateTime orderDate;
  DateTime deadline;
  double totalAmount;
  double advancePaid;
  Map<String, String> measurements;
  String specialInstructions;
  OrderPriority priority;
  int? progress;

  CustomOrder({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.serviceName,
    required this.serviceType,
    required this.fabric,
    required this.status,
    required this.orderDate,
    required this.deadline,
    required this.totalAmount,
    required this.advancePaid,
    required this.measurements,
    required this.specialInstructions,
    required this.priority,
    this.progress,
  });
}

enum OrderStatus {
  all,
  pending,
  inProgress,
  readyForFitting,
  completed,
  delivered,
}

enum OrderPriority {
  low,
  medium,
  high,
}

extension OrderPriorityExtension on OrderPriority {
  String get name {
    switch (this) {
      case OrderPriority.low:
        return 'Low';
      case OrderPriority.medium:
        return 'Medium';
      case OrderPriority.high:
        return 'High';
    }
  }
}