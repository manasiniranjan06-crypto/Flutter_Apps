import 'package:flutter/material.dart';

// TAILOR HELP & SUPPORT PAGE
class TailorHelpSupportPage extends StatefulWidget {
  const TailorHelpSupportPage({Key? key}) : super(key: key);

  @override
  State<TailorHelpSupportPage> createState() => _TailorHelpSupportPageState();
}

class _TailorHelpSupportPageState extends State<TailorHelpSupportPage> {
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
                  Icons.support_agent,
                  color: Color(0xFF8075FF),
                  size: 30,
                ),
              ),
              const SizedBox(width: 15),
              const Expanded(
                child: Text(
                  'We\'re Here to Help!',
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
            'Get assistance with managing your tailoring business, handling orders, and growing your customer base.',
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
                icon: Icons.video_library,
                title: 'Tutorials',
                color: const Color(0xFF8075FF),
                onTap: () => _showTutorials(),
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
                icon: Icons.chat,
                title: 'Live Chat',
                color: const Color(0xFF3B82F6),
                onTap: () => _openLiveChat(),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildActionCard(
                icon: Icons.email,
                title: 'Email',
                color: const Color(0xFFF59E0B),
                onTap: () => _scrollToContactForm(),
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
        'question': 'How do I accept new orders?',
        'answer':
            'Navigate to the Orders tab and you\'ll see all pending orders. Tap on any order to view details, then click "Accept Order" to confirm. You can also set automatic acceptance in Settings.',
      },
      {
        'question': 'How do I update my shop timings?',
        'answer':
            'Go to Profile > Shop Settings > Business Hours. Here you can set your daily opening and closing times, mark holidays, and set special hours for specific dates.',
      },
      {
        'question': 'What if I need to cancel an accepted order?',
        'answer':
            'Go to the specific order details and tap "Cancel Order". You must provide a valid reason. Note: Frequent cancellations may affect your rating and visibility.',
      },
      {
        'question': 'How does the payment system work?',
        'answer':
            'Payments are processed through the app. When a customer completes payment, the amount is held securely. Once you mark the order as delivered, funds are transferred to your registered bank account within 2-3 business days.',
      },
      {
        'question': 'How can I improve my shop rating?',
        'answer':
            'Maintain high quality work, deliver on time, communicate clearly with customers, respond promptly to messages, and maintain professional behavior. Customer reviews directly impact your rating.',
      },
      {
        'question': 'Can I add custom measurement templates?',
        'answer':
            'Yes! Go to Profile > Measurement Templates. You can create custom templates for different garment types, save commonly used measurements, and apply them to orders quickly.',
      },
      {
        'question': 'How do I handle customer measurements?',
        'answer':
            'When accepting an order, you can either use customer-provided measurements or request them to visit your shop. Always verify measurements before starting work to avoid issues.',
      },
      {
        'question': 'What should I do if there\'s a dispute?',
        'answer':
            'Contact our support team immediately through the app. Provide order details and any relevant photos or communication. We\'ll mediate and help resolve the issue fairly.',
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
            'Contact Support',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3142),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Can\'t find what you\'re looking for? Send us a message!',
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
              labelText: 'Your Message',
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
          _buildContactInfo(Icons.phone, '+1 (800) 123-4567'),
          const SizedBox(height: 10),
          _buildContactInfo(Icons.email, 'tailor.support@app.com'),
          const SizedBox(height: 10),
          _buildContactInfo(Icons.access_time, 'Mon-Sat: 9 AM - 8 PM'),
        ],
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF8075FF), size: 20),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  void _showTutorials() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Video Tutorials',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildTutorialItem('Getting Started', '5:30'),
            _buildTutorialItem('Managing Orders', '8:15'),
            _buildTutorialItem('Setting Up Your Profile', '4:45'),
            _buildTutorialItem('Payment & Withdrawals', '6:20'),
          ],
        ),
      ),
    );
  }

  Widget _buildTutorialItem(String title, String duration) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Color(0xFF8075FF),
        child: Icon(Icons.play_arrow, color: Colors.white),
      ),
      title: Text(title),
      trailing: Text(duration),
      onTap: () {},
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

  void _scrollToContactForm() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Scroll down to contact form')),
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
