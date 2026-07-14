import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BusinessAnalyticsPage extends StatefulWidget {
  const BusinessAnalyticsPage({super.key});

  @override
  State<BusinessAnalyticsPage> createState() => _BusinessAnalyticsPageState();
}

class _BusinessAnalyticsPageState extends State<BusinessAnalyticsPage> {
  int _selectedTimeFilter = 0; // 0: Weekly, 1: Monthly, 2: Yearly
  int _selectedMetric = 0; // 0: Revenue, 1: Orders, 2: Customers

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Business Analytics'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _exportData(context),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time Filter Chips
            _buildTimeFilterChips(),
            const SizedBox(height: 16),
            
            // Key Metrics Cards
            _buildKeyMetrics(),
            const SizedBox(height: 24),
            
            // Revenue Chart
            _buildRevenueChart(),
            const SizedBox(height: 24),
            
            // Performance Metrics
            _buildPerformanceMetrics(),
            const SizedBox(height: 24),
            
            // Recent Activity
            _buildRecentActivity(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeFilterChips() {
    final filters = ['This Week', 'This Month', 'This Year'];
    return Wrap(
      spacing: 8,
      children: List.generate(filters.length, (index) {
        return ChoiceChip(
          label: Text(filters[index]),
          selected: _selectedTimeFilter == index,
          onSelected: (selected) {
            setState(() {
              _selectedTimeFilter = index;
            });
          },
        );
      }),
    );
  }

  Widget _buildKeyMetrics() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildMetricCard(
          title: 'Total Revenue',
          value: '\$12,458',
          change: '+12.5%',
          isPositive: true,
          icon: Icons.attach_money,
          color: Colors.green,
        ),
        _buildMetricCard(
          title: 'Total Orders',
          value: '1,248',
          change: '+8.2%',
          isPositive: true,
          icon: Icons.shopping_cart,
          color: Colors.blue,
        ),
        _buildMetricCard(
          title: 'Avg. Order Value',
          value: '\$99.80',
          change: '+3.1%',
          isPositive: true,
          icon: Icons.trending_up,
          color: Colors.orange,
        ),
        _buildMetricCard(
          title: 'Conversion Rate',
          value: '4.2%',
          change: '-0.5%',
          isPositive: false,
          icon: Icons.bar_chart,
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String change,
    required bool isPositive,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                Text(
                  change,
                  style: TextStyle(
                    color: isPositive ? Colors.green : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueChart() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Revenue Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: SfCartesianChart(
                primaryXAxis: const CategoryAxis(),
                // series: <ChartSeries<SalesData, String>>[
                //   LineSeries<SalesData, String>(
                //     dataSource: _getRevenueData(),
                //     xValueMapper: (SalesData sales, _) => sales.period,
                //     yValueMapper: (SalesData sales, _) => sales.amount,
                //     markerSettings: const MarkerSettings(isVisible: true),
                //     dataLabelSettings: const DataLabelSettings(isVisible: true),
                //   ),
                // ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceMetrics() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Performance Metrics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildPerformanceRow('Customer Satisfaction', '92%', Colors.green),
            _buildPerformanceRow('Order Accuracy', '98.5%', Colors.green),
            _buildPerformanceRow('Delivery Time', '34 min', Colors.orange),
            _buildPerformanceRow('Return Rate', '2.1%', Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceRow(String title, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ..._getRecentActivities().map((activity) => _buildActivityItem(activity)),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: activity['color'].withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(activity['icon'], color: activity['color'], size: 20),
      ),
      title: Text(activity['title']),
      subtitle: Text(activity['subtitle']),
      trailing: Text(
        activity['time'],
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),
    );
  }

  List<SalesData> _getRevenueData() {
    return [
      SalesData('Mon', 1200),
      SalesData('Tue', 1800),
      SalesData('Wed', 1500),
      SalesData('Thu', 2200),
      SalesData('Fri', 2800),
      SalesData('Sat', 3200),
      SalesData('Sun', 2500),
    ];
  }

  List<Map<String, dynamic>> _getRecentActivities() {
    return [
      {
        'icon': Icons.shopping_cart,
        'color': Colors.blue,
        'title': 'New Order #1234',
        'subtitle': 'Customer: John Doe',
        'time': '2 min ago',
      },
      {
        'icon': Icons.payment,
        'color': Colors.green,
        'title': 'Payment Received',
        'subtitle': '\$245.00',
        'time': '1 hour ago',
      },
      {
        'icon': Icons.person_add,
        'color': Colors.purple,
        'title': 'New Customer',
        'subtitle': 'Sarah Wilson registered',
        'time': '3 hours ago',
      },
      {
        'icon': Icons.assignment_return,
        'color': Colors.orange,
        'title': 'Return Processed',
        'subtitle': 'Order #1189',
        'time': '5 hours ago',
      },
    ];
  }

  void _exportData(BuildContext context) {
    // Implement export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exporting analytics data...')),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Analytics'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterOption('Revenue', 0),
            _buildFilterOption('Orders', 1),
            _buildFilterOption('Customers', 2),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Apply filters
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOption(String title, int value) {
    return ListTile(
      title: Text(title),
      leading: Radio<int>(
        value: value,
        groupValue: _selectedMetric,
        onChanged: (int? newValue) {
          setState(() {
            _selectedMetric = newValue!;
          });
          Navigator.pop(context);
        },
      ),
    );
  }
}

class SalesData {
  final String period;
  final double amount;

  SalesData(this.period, this.amount);
}