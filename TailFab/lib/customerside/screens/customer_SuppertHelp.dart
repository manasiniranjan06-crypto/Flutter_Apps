 import 'package:flutter/material.dart';

// CUSTOMER HELP & SUPPORT PAGE
class CustomerHelpSupportPage extends StatefulWidget {
  const CustomerHelpSupportPage({Key? key}) : super(key: key);

  @override
  State<CustomerHelpSupportPage> createState() =>
      _CustomerHelpSupportPageState();
}

class _CustomerHelpSupportPageState extends State<CustomerHelpSupportPage> {
  String? expandedSection;
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF8075FF), Colors.white],
            stops: [0.0, 0.6],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildWelcomeSection(),
                        const SizedBox(height: 30),
                        _buildQuickActions(),
                        const SizedBox(height: 30),
                        _buildFAQSection(),
                        const SizedBox(height: 30),
                        _buildContactSupport(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            'Help & Support',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF8075FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.help_outline,
                  color: Color(0xFF8075FF),
                  size: 30,
                ),
              ),
              const SizedBox(width: 15),
              const Expanded(
                child: Text(
                  'How Can We Help?',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Text(
            'Find answers to common questions about placing orders, tracking deliveries, and getting the perfect fit.',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3142),
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.local_shipping,
                title: 'Track Order',
                color: const Color(0xFF8075FF),
                onTap: () => _trackOrder(),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildActionCard(
                icon: Icons.phone,
                title: 'Call Us',
                color: const Color(0xFF10B981),
                onTap: () => _callSupport(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.chat_bubble,
                title: 'Live Chat',
                color: const Color(0xFF3B82F6),
                onTap: () => _openLiveChat(),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildActionCard(
                icon: Icons.help_center,
                title: 'Guide',
                color: const Color(0xFFF59E0B),
                onTap: () => _showGuide(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3142),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQSection() {
    final faqs = [
      {
        'question': 'How do I place an order?',
        'answer':
            'Browse tailors in your area, select one, choose the service you need, provide measurements (or schedule an in-person visit), add any special instructions, and confirm your order with payment.',
      },
      {
        'question': 'How do I provide my measurements?',
        'answer':
            'You can either enter measurements manually using our measurement guide, upload a photo for reference, or choose to visit the tailor\'s shop for professional measurement. We recommend visiting for the best accuracy.',
      },
      {
        'question': 'Can I cancel or modify my order?',
        'answer':
            'You can cancel orders before the tailor accepts them for a full refund. After acceptance, cancellations are subject to the tailor\'s policy. To modify, contact the tailor directly through the in-app chat.',
      },
      {
        'question': 'How does payment work?',
        'answer':
            'Payment is processed securely through the app when you place an order. The amount is held until you confirm delivery and satisfaction. We accept credit cards, debit cards, and digital wallets.',
      },
      {
        'question': 'What if I\'m not satisfied with the work?',
        'answer':
            'Contact the tailor first to resolve any issues. If unresolved, open a dispute through the order page within 7 days of delivery. Our support team will review and mediate to ensure fair resolution.',
      },
      {
        'question': 'How long does delivery take?',
        'answer':
            'Delivery time varies by garment type and tailor. You\'ll see estimated completion time when placing your order. Track your order status in real-time through the Orders tab.',
      },
      {
        'question': 'Can I save my measurements for future orders?',
        'answer':
            'Yes! Go to Profile > My Measurements to save your measurements. You can create multiple measurement profiles for different garment types and family members.',
      },
      {
        'question': 'How do I track my order?',
        'answer':
            'Go to Orders tab and tap on your active order. You\'ll see real-time status updates including: Order Placed, Accepted, In Progress, Ready for Delivery, and Completed.',
      },
      {
        'question': 'What if the tailor rejects my order?',
        'answer':
            'If a tailor can\'t accept your order, you\'ll receive a full refund immediately. You can then place a new order with another tailor. Rejection reasons might include unavailability or specialized work requirements.',
      },
      {
        'question': 'How do reviews work?',
        'answer':
            'After order completion, you can rate the tailor (1-5 stars) and leave a detailed review. Your honest feedback helps other customers and improves service quality.',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Frequently Asked Questions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3142),
          ),
        ),
        const SizedBox(height: 15),
        ...faqs.map((faq) => _buildFAQItem(
              question: faq['question']!,
              answer: faq['answer']!,
            )),
      ],
    );
  }

  Widget _buildFAQItem({required String question, required String answer}) {
    final isExpanded = expandedSection == question;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ExpansionTile(
          title: Text(
            question,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3142),
            ),
          ),
          trailing: Icon(
            isExpanded ? Icons.remove_circle_outline : Icons.add_circle_outline,
            color: const Color(0xFF8075FF),
          ),
          onExpansionChanged: (expanded) {
            setState(() {
              expandedSection = expanded ? question : null;
            });
          },
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                answer,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSupport() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Still Need Help?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3142),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'We\'re here to assist you. Send us a message!',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Your Email',
              prefixIcon: const Icon(Icons.email, color: Color(0xFF8075FF)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF8075FF), width: 2),
              ),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _messageController,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: 'Describe Your Issue',
              prefixIcon: const Icon(Icons.message, color: Color(0xFF8075FF)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF8075FF), width: 2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitSupportRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8075FF),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Send Message',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 15),
          Row(
            children: [
              const Icon(Icons.phone, color: Color(0xFF8075FF), size: 20),
              const SizedBox(width: 10),
              const Text(
                '+1 (800) 123-4567',
                style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.email, color: Color(0xFF8075FF), size: 20),
              const SizedBox(width: 10),
              const Text(
                'customer.support@app.com',
                style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.access_time, color: Color(0xFF8075FF), size: 20),
              const SizedBox(width: 10),
              const Text(
                'Available 24/7',
                style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _trackOrder() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening order tracking...')),
    );
  }

  void _callSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Calling support: +1 (800) 123-4567')),
    );
  }

  void _openLiveChat() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening live chat...')),
    );
  }

  void _showGuide() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: ListView(
            controller: scrollController,
            children: [
              const Text(
                'Getting Started Guide',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildGuideStep(
                '1',
                'Create Your Account',
                'Sign up with your email and complete your profile with contact details.',
              ),
              _buildGuideStep(
                '2',
                'Browse Tailors',
                'Find tailors near you, check ratings, view portfolios, and read reviews.',
              ),
              _buildGuideStep(
                '3',
                'Place Your Order',
                'Select services, provide measurements, add special requests, and confirm.',
              ),
              _buildGuideStep(
                '4',
                'Track Progress',
                'Monitor your order status in real-time and communicate with your tailor.',
              ),
              _buildGuideStep(
                '5',
                'Receive & Review',
                'Get your perfectly tailored garment and share your experience.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuideStep(String number, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF8075FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _submitSupportRequest() {
    if (_emailController.text.isEmpty || _messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Support request submitted! We\'ll respond within 24 hours.'),
        backgroundColor: Color(0xFF10B981),
      ),
    );

    _emailController.clear();
    _messageController.clear();
  }
}

// Example usage in main.dart:
// void main() {
//   runApp(MaterialApp(
//     home: TailorHelpSupportPage(), // For Tailor
//     // OR
//     home: CustomerHelpSupportPage(), // For Customer
//   ));
// }