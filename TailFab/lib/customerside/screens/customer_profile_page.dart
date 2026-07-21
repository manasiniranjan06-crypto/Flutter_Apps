import 'package:firebaseauth/customerside/components/gradient_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class customerProfilePage extends StatefulWidget {
  const customerProfilePage({Key? key}) : super(key: key);

  @override
  State<customerProfilePage> createState() => _TailorProfilePageState();
}

class _TailorProfilePageState extends State<customerProfilePage> {
  bool isFollowing = false;
  int current =0;

  final Map<String, dynamic> tailorData = {
    'name': 'Fashion Hub',
    'image': 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=500',
    'rating': 4.8,
    'reviews': 342,
    'followers': '1.2K',
    'experience': '15 Years',
    'specialization': 'Custom Suits & Wedding Wear',
    'location': '2.5 km away',
    'openTime': '10:00 AM - 8:00 PM',
    'phone': '+91 9876543210',
    'description': 'Expert tailor specializing in premium custom suits, wedding wear, and ethnic clothing. We pride ourselves on precision, quality craftsmanship, and personalized service for every customer.',
  };

  final List<Map<String, dynamic>> services = [
    {'name': 'Custom Suit', 'price': 2999, 'duration': '7-10 days', 'icon': Icons.checkroom},
    {'name': 'Shirt Stitching', 'price': 499, 'duration': '3-5 days', 'icon': Icons.style},
    {'name': 'Pant Alterations', 'price': 299, 'duration': '2-3 days', 'icon': Icons.content_cut},
    {'name': 'Wedding Sherwani', 'price': 4999, 'duration': '15-20 days', 'icon': Icons.celebration},
    {'name': 'Kurta Pajama', 'price': 1299, 'duration': '5-7 days', 'icon': Icons.dashboard_customize},
    {'name': 'Dress Alteration', 'price': 399, 'duration': '2-4 days', 'icon': Icons.edit},
  ];

  final List<Map<String, dynamic>> portfolio = [
    {'image': 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=400', 'title': 'Wedding Suit'},
    {'image': 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=400', 'title': 'Formal Wear'},
    {'image': 'https://images.unsplash.com/photo-1617127365659-c47fa864d8bc?w=400', 'title': 'Ethnic Design'},
    {'image': 'https://images.unsplash.com/photo-1598808503491-f1504b4b3448?w=400', 'title': 'Custom Blazer'},
    {'image': 'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?w=400', 'title': 'Party Wear'},
    {'image': 'https://images.unsplash.com/photo-1594938291221-94f18cbb5660?w=400', 'title': 'Traditional'},
  ];

  final List<Map<String, dynamic>> reviews = [
    {
      'name': 'Rahul Sharma',
      'rating': 5.0,
      'date': '2 days ago',
      'comment': 'Excellent work! Perfect fit and amazing quality. Highly recommended for custom suits.',
      'avatar': 'R'
    },
    {
      'name': 'Priya Patel',
      'rating': 4.5,
      'date': '1 week ago',
      'comment': 'Great experience. The tailor understood exactly what I wanted and delivered on time.',
      'avatar': 'P'
    },
    {
      'name': 'Amit Kumar',
      'rating': 5.0,
      'date': '2 weeks ago',
      'comment': 'Best tailor in the area. The attention to detail is remarkable. Will definitely come again.',
      'avatar': 'A'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        title: Text(
          'Tailor Profile',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () => _showSnackBar('Share profile'),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () => _showSnackBar('More options'),
          ),
        ],
      ),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // Profile Header with Image
            _buildProfileHeaderWithImage(),
            const SizedBox(height: 10),
            
            // Action Buttons
            _buildActionButtons(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
GestureDetector(
  onTap: () {
    
current= 0;
setState(() {
  
});
  },
  child: Text('1')),
  GestureDetector(
  onTap: () {
    
current= 1;
setState(() {
  
});
  },
  child: Text('1')),GestureDetector(
  onTap: () {
    
current= 2;
setState(() {
  
});
  },
  child: Text('1')),

              ],
            ),
            
            // Services Section
            if(current == 0)
            _buildServicesSection(),
            
            // Portfolio Section
               if(current == 1)
            _buildPortfolioSection(),
            
            // Reviews Section
               if(current == 2)
            _buildReviewsSection(),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeaderWithImage() {
    return Container(
      height: 320,
      child: Stack(
        children: [
          // Background Image
          Container(
            height: 180,
            width: double.infinity,
            child: Image.network(
              tailorData['image'],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) => Container(
                color: const Color(0xFF8075FF),
                child: const Icon(Icons.store, size: 60, color: Colors.white),
              ),
            ),
          ),
          
          // Profile Info Card
          Positioned(
            bottom: 0,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tailorData['name'],
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              tailorData['specialization'],
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.green.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.circle, size: 8, color: Colors.green),
                            const SizedBox(width: 6),
                            Text(
                              'Open',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        tailorData['location'],
                        style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        tailorData['openTime'],
                        style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    tailorData['description'],
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildStatItem(Icons.star, '${tailorData['rating']}', 'Rating'),
                      _buildStatItem(Icons.rate_review, '${tailorData['reviews']}', 'Reviews'),
                      _buildStatItem(Icons.people, '${tailorData['followers']}', 'Followers'),
                      _buildStatItem(Icons.work, tailorData['experience'], 'Experience'),
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

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 20, color: const Color.fromARGB(255, 122, 122, 121)),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: () => _showSnackBar('Booking feature coming soon'),
              icon: const Icon(Icons.calendar_today, size: 18),
              label: const Text('Book Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8075FF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                setState(() => isFollowing = !isFollowing);
                _showSnackBar(isFollowing ? 'Following' : 'Unfollowed');
              },
              icon: Icon(
                isFollowing ? Icons.check : Icons.person_add,
                size: 18,
              ),
              label: Text(isFollowing ? 'Following' : 'Follow'),
              style: OutlinedButton.styleFrom(
                foregroundColor: isFollowing ? Colors.green : const Color(0xFF8075FF),
                side: BorderSide(
                  color: isFollowing ? Colors.green : const Color(0xFF8075FF),
                  width: 1.5,
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () => _showContactDialog(),
              icon: Icon(Icons.phone, color: Colors.green.shade700, size: 24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.construction, color: const Color(0xFF8075FF), size: 24),
              const SizedBox(width: 8),
              Text(
                'Services',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: services.length,
            itemBuilder: (context, index) => _buildServiceCard(services[index]),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF8075FF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(service['icon'], color: const Color(0xFF8075FF), size: 24),
        ),
        title: Text(
          service['name'],
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                service['duration'],
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '₹${service['price']}',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF8075FF),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Available',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        onTap: () => _showBookingDialog(service),
      ),
    );
  }

  Widget _buildPortfolioSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.photo_library, color: const Color(0xFF8075FF), size: 24),
              const SizedBox(width: 8),
              Text(
                'Portfolio',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Browse our recent work and designs',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: portfolio.length,
            itemBuilder: (context, index) => _buildPortfolioCard(portfolio[index]),
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioCard(Map<String, dynamic> item) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Image.network(
              item['image'],
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stack) => Container(
                color: Colors.grey[300],
                child: const Icon(Icons.image, size: 40, color: Colors.grey),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
                child: Text(
                  item['title'],
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star, color: const Color(0xFF8075FF), size: 24),
              const SizedBox(width: 8),
              Text(
                'Customer Reviews',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: 4),
              Text(
                '${tailorData['rating']}',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '• ${tailorData['reviews']} reviews',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reviews.length,
            itemBuilder: (context, index) => _buildReviewCard(reviews[index]),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFF8075FF),
                child: Text(
                  review['avatar'],
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['name'],
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      review['date'],
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${review['rating']}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber.shade800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review['comment'],
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  void _showBookingDialog(Map<String, dynamic> service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Book ${service['name']}',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price: ₹${service['price']}', style: GoogleFonts.poppins(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Duration: ${service['duration']}', style: GoogleFonts.poppins(fontSize: 14)),
            const SizedBox(height: 16),
            Text(
              'Would you like to proceed with booking?',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Booking confirmed! We will contact you soon.');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 148, 100, 250),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showContactDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Contact Tailor',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.green),
              title: Text('Call', style: GoogleFonts.poppins()),
              subtitle: Text(tailorData['phone'], style: GoogleFonts.poppins(color: Colors.grey[600])),
              onTap: () {
                Navigator.pop(context);
                _showSnackBar('Calling ${tailorData['phone']}');
              },
            ),
            ListTile(
              leading: const Icon(Icons.message, color: Color(0xFF8075FF)),
              title: Text('Message', style: GoogleFonts.poppins()),
              subtitle: Text('Send a message', style: GoogleFonts.poppins(color: Colors.grey[600])),
              onTap: () {
                Navigator.pop(context);
                _showSnackBar('Opening chat...');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF8075FF),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}