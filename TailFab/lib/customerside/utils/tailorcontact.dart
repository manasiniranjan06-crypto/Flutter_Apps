import 'package:firebaseauth/customerside/models/messgaemodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TailorContactScreen extends StatefulWidget {
  final String tailorName;
  final String tailorImage;
  final String tailorSpecialty;
  final double rating;
  final int reviewCount;
  final String location;
  final double distance;

  const TailorContactScreen({
    Key? key,
    required this.tailorName,
    required this.tailorImage,
    this.tailorSpecialty = "Western & Traditional Wear",
    this.rating = 4.8,
    this.reviewCount = 125,
    this.location = "City Center",
    this.distance = 2.5,
  }) : super(key: key);

  @override
  State<TailorContactScreen> createState() => _TailorContactScreenState();
}

class _TailorContactScreenState extends State<TailorContactScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  late final List<ChatMessage> _messages = [
    ChatMessage(
      text: "Hello! I'm ${widget.tailorName}. Thank you for reaching out. How can I assist you with your tailoring needs today?",
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      isTailor: true,
    ),
  ];

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _selectedShopOption = 0;
  bool _showQuickQuestions = true;

  // Enhanced question database with detailed responses
  final List<QuickQuestion> _quickQuestions = [
    QuickQuestion(
      question: "What's your pricing?",
      category: "pricing",
      detailedResponse: """
💰 **Detailed Pricing Information:**

**Basic Services:**
• Shirt/Blouse: ₹800 - ₹1,500
• Trousers/Pants: ₹900 - ₹1,800
• Kurti/Top: ₹700 - ₹1,200
• Dress (Simple): ₹1,500 - ₹3,000

**Premium Services:**
• Suit (2-piece): ₹4,000 - ₹8,000
• Wedding Outfit: ₹8,000 - ₹25,000
• Designer Gown: ₹5,000 - ₹15,000
• Traditional Wear (Saree Blouse): ₹600 - ₹1,200

**Factors affecting price:**
• Fabric quality & type
• Design complexity
• Embellishments & embroidery
• Urgency of delivery

Would you like a custom quote for a specific garment?""",
    ),
    QuickQuestion(
      question: "How long for delivery?",
      category: "delivery",
      detailedResponse: """
⏰ **Delivery Timeline:**

**Standard Timeline:**
• Basic alterations: 2-3 days
• New garment (simple): 5-7 days
• New garment (complex): 7-10 days
• Traditional wear: 8-12 days
• Wedding outfits: 10-15 days

**Express Service (Additional 30% charge):**
• Basic alterations: 24 hours
• New garments: 3-5 days

**Fitting Sessions Included:**
• 1st fitting: After measurements
• 2nd fitting: Before final stitching
• Final fitting: For adjustments

What type of garment are you planning? I can give you a more accurate timeline.""",
    ),
    QuickQuestion(
      question: "Do you do measurements?",
      category: "measurements",
      detailedResponse: """
📏 **Measurement Services:**

**Professional Measurement Options:**
1. **In-Studio Measurement** (Recommended)
   • Free service with appointment
   • Digital measurements stored
   • Professional fitting advice

2. **Home Visit Service**
   • ₹500 service charge
   • Available within 5km radius
   • Evening slots available

3. **Self-Measurement Guide**
   • Video tutorial available
   • Printable measurement chart
   • WhatsApp support for guidance

**What We Measure:**
• Chest, Waist, Hip
• Shoulder, Arm length
• Back length, Front length
• Special measurements for traditional wear

Would you like to schedule a measurement session?""",
    ),
    QuickQuestion(
      question: "Available fabrics?",
      category: "fabrics",
      detailedResponse: """
🧵 **Fabric Collection Available:**

**Premium Cottons:**
• Egyptian Cotton (₹400/m)
• Organic Cotton (₹350/m)
• Cotton Silk (₹600/m)
• Cotton Linen (₹450/m)

**Silk & Satin:**
• Pure Silk (₹1,200-₹3,000/m)
• Silk Cotton (₹800/m)
• Satin Silk (₹900/m)
• Chiffon (₹700/m)

**Wool & Blends:**
• Merino Wool (₹1,500/m)
• Wool Blend (₹800/m)
• Tweed (₹1,000/m)

**Synthetic & Special:**
• Georgette (₹400/m)
• Crepe (₹350/m)
• Velvet (₹600/m)
• Brocade (₹800-₹2,000/m)

**Services:**
• Fabric sourcing assistance
• Swatch samples available
• Custom dyeing options

Would you like to see fabric samples or discuss specific fabric requirements?""",
    ),
    QuickQuestion(
      question: "Design consultation?",
      category: "design",
      detailedResponse: """
🎨 **Design Consultation Services:**

**Free Basic Consultation:**
• Style assessment
• Fabric recommendations
• Design brainstorming
• Budget planning

**Premium Design Service (₹1,500):**
• Custom design creation
• Digital mockups (2 revisions)
• Fabric sourcing assistance
• Complete style coordination

**What We Offer:**
• Trend analysis based on body type
• Color palette suggestions
• Mix & match styling ideas
• Occasion-specific recommendations

**Portfolio Includes:**
• Western formal & casual wear
• Traditional Indian wear
• Fusion outfits
• Bridal collections
• Corporate dressing

Would you like to schedule a design consultation?""",
    ),
    QuickQuestion(
      question: "Appointment booking?",
      category: "appointment",
      detailedResponse: """
📅 **Appointment Booking:**

**Available Time Slots:**
• **Monday-Friday:** 10:00 AM - 7:00 PM
• **Saturday:** 11:00 AM - 5:00 PM
• **Sunday:** Emergency appointments only

**Session Types:**
1. **Initial Consultation** (30 mins) - FREE
2. **Design Discussion** (60 mins) - FREE
3. **Measurement Session** (45 mins) - FREE
4. **Fitting Session** (30 mins) - FREE

**Home Visit Appointments:**
• Available: Tuesday & Thursday
• Timing: 2:00 PM - 5:00 PM
• Charges: ₹500 (within 5km)

**How to Book:**
1. Direct message with preferred date/time
2. Call us at [Phone Number]
3. Visit our studio

What type of appointment would you like to schedule?""",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: _messageController.text,
          isUser: true,
          timestamp: DateTime.now(),
          isTailor: false,
        ),
      );
      _showQuickQuestions = false;
    });

    _simulateTailorResponse(_messageController.text);
    _messageController.clear();
  }

  void _sendQuickQuestion(QuickQuestion question) {
    setState(() {
      // Add user question
      _messages.add(
        ChatMessage(
          text: question.question,
          isUser: true,
          timestamp: DateTime.now(),
          isTailor: false,
        ),
      );
      _showQuickQuestions = false;
    });

    // Simulate typing indicator
    _showTypingIndicator();

    // Send detailed response after delay
    Future.delayed(const Duration(seconds: 3), () {
      _removeTypingIndicator();
      setState(() {
        _messages.add(
          ChatMessage(
            text: question.detailedResponse,
            isUser: false,
            timestamp: DateTime.now(),
            isTailor: true,
          ),
        );
      });
    });
  }

  void _showTypingIndicator() {
    setState(() {
      _messages.add(
        ChatMessage(
          text: "typing...",
          isUser: false,
          timestamp: DateTime.now(),
          isTailor: true,
          isTyping: true,
        ),
      );
    });
  }

  void _removeTypingIndicator() {
    setState(() {
      _messages.removeWhere((message) => message.isTyping == true);
    });
  }

  void _simulateTailorResponse(String userMessage) {
    // Show typing indicator
    _showTypingIndicator();

    Future.delayed(const Duration(seconds: 2), () {
      _removeTypingIndicator();
      String response = _generateTailorResponse(userMessage);
      setState(() {
        _messages.add(
          ChatMessage(
            text: response,
            isUser: false,
            timestamp: DateTime.now(),
            isTailor: true,
          ),
        );
      });
    });
  }

  String _generateTailorResponse(String userMessage) {
    userMessage = userMessage.toLowerCase();
    
    // Find matching quick question for detailed response
    for (var question in _quickQuestions) {
      if (userMessage.contains(question.question.toLowerCase().replaceAll("what's", "").replaceAll("?", "").trim())) {
        return question.detailedResponse;
      }
    }
    
    // Fallback to category-based responses
    if (userMessage.contains('price') || userMessage.contains('cost') || userMessage.contains('how much')) {
      return _quickQuestions.firstWhere((q) => q.category == "pricing").detailedResponse;
    } else if (userMessage.contains('time') || userMessage.contains('delivery') || userMessage.contains('how long')) {
      return _quickQuestions.firstWhere((q) => q.category == "delivery").detailedResponse;
    } else if (userMessage.contains('measure') || userMessage.contains('size') || userMessage.contains('fitting')) {
      return _quickQuestions.firstWhere((q) => q.category == "measurements").detailedResponse;
    } else if (userMessage.contains('fabric') || userMessage.contains('material') || userMessage.contains('cloth')) {
      return _quickQuestions.firstWhere((q) => q.category == "fabrics").detailedResponse;
    } else if (userMessage.contains('design') || userMessage.contains('style') || userMessage.contains('fashion')) {
      return _quickQuestions.firstWhere((q) => q.category == "design").detailedResponse;
    } else if (userMessage.contains('appointment') || userMessage.contains('meet') || userMessage.contains('schedule')) {
      return _quickQuestions.firstWhere((q) => q.category == "appointment").detailedResponse;
    } else {
      return """
Thank you for your message! I understand you're interested in: "$userMessage". 

I'd love to help you create the perfect outfit. Here's how I can assist you:

🎯 **My Services Include:**
• Custom tailoring for all occasions
• Professional measurements & fittings
• Wide fabric selection
• Design consultation
• Alterations & repairs

Would you like specific information about:
• Pricing & packages
• Delivery timelines  
• Measurement process
• Fabric options
• Design consultation
• Booking an appointment

Just let me know what you'd like to know more about! 🪡""";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8075FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(widget.tailorImage),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.tailorName,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Online • Master Tailor',
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white),
            onPressed: _makeCall,
          ),
          IconButton(
            icon: const Icon(Icons.video_call, color: Colors.white),
            onPressed: _makeVideoCall,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              _handleMenuSelection(value);
            },
            itemBuilder: (BuildContext context) {
              return {'View Portfolio', 'Share Contact', 'Report Issue'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Tailor Info Card
            _buildTailorInfoCard(),
            
            // Shop Options
            _buildShopOptions(),
            
            // Quick Questions
            if (_showQuickQuestions) _buildQuickQuestions(),
            
            // Chat Messages
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                reverse: false,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _buildMessageBubble(_messages[index]);
                },
              ),
            ),
            
            // Message Input
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildTailorInfoCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF8075FF), Color(0xFF6A5BFF)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(widget.tailorImage),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.tailorName,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.rating} • ${widget.reviewCount} reviews',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.white, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.location} • ${widget.distance}km',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Specializes in: ${widget.tailorSpecialty}',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Available',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShopOptions() {
    List<Map<String, dynamic>> options = [
      {'icon': Icons.photo_library, 'title': 'Portfolio', 'color': Colors.purple},
      {'icon': Icons.schedule, 'title': 'Appointment', 'color': Colors.green},
      {'icon': Icons.local_offer, 'title': 'Pricing', 'color': Colors.orange},
      {'icon': Icons.room_preferences, 'title': 'Services', 'color': Colors.blue},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(options.length, (index) {
          return GestureDetector(
            onTap: () => _handleShopOptionTap(index),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _selectedShopOption == index 
                    ? options[index]['color'].withOpacity(0.1)
                    : Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: _selectedShopOption == index 
                      ? options[index]['color'] 
                      : Colors.transparent,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    options[index]['icon'],
                    color: options[index]['color'],
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    options[index]['title'],
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildQuickQuestions() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Quick Questions",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
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
                  "Tap to ask",
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: const Color(0xFF8075FF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _quickQuestions.map((question) {
              return GestureDetector(
                onTap: () => _sendQuickQuestion(question),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: _getQuestionColor(question.category),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF8075FF).withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _getQuestionIcon(question.category),
                      const SizedBox(width: 6),
                      Text(
                        question.question,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: const Color(0xFF8075FF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Color _getQuestionColor(String category) {
    switch (category) {
      case 'pricing':
        return Colors.orange.withOpacity(0.1);
      case 'delivery':
        return Colors.green.withOpacity(0.1);
      case 'measurements':
        return Colors.blue.withOpacity(0.1);
      case 'fabrics':
        return Colors.purple.withOpacity(0.1);
      case 'design':
        return Colors.pink.withOpacity(0.1);
      case 'appointment':
        return Colors.teal.withOpacity(0.1);
      default:
        return Colors.white;
    }
  }

  Widget _getQuestionIcon(String category) {
    IconData icon;
    Color color;
    
    switch (category) {
      case 'pricing':
        icon = Icons.attach_money;
        color = Colors.orange;
        break;
      case 'delivery':
        icon = Icons.access_time;
        color = Colors.green;
        break;
      case 'measurements':
        icon = Icons.straighten;
        color = Colors.blue;
        break;
      case 'fabrics':
        icon = Icons.photo_camera_back;
        color = Colors.purple;
        break;
      case 'design':
        icon = Icons.design_services;
        color = Colors.pink;
        break;
      case 'appointment':
        icon = Icons.calendar_today;
        color = Colors.teal;
        break;
      default:
        icon = Icons.help_outline;
        color = const Color(0xFF8075FF);
    }
    
    return Icon(icon, size: 14, color: color);
  }

  Widget _buildMessageBubble(ChatMessage message) {
    if (message.isTyping) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF8075FF), width: 2),
              ),
              child: CircleAvatar(
                radius: 14,
                backgroundImage: NetworkImage(widget.tailorImage),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser)
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF8075FF), width: 2),
              ),
              child: CircleAvatar(
                radius: 14,
                backgroundImage: NetworkImage(widget.tailorImage),
              ),
            ),
          if (!message.isUser) const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isUser 
                    ? const Color(0xFF8075FF)
                    : Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: GoogleFonts.poppins(
                      color: message.isUser ? Colors.white : Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        _formatTime(message.timestamp),
                        style: GoogleFonts.poppins(
                          color: message.isUser ? Colors.white70 : Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                      if (message.isUser) ...[
                        const SizedBox(width: 4),
                        Icon(
                          message.isTailor ? Icons.done_all : Icons.done,
                          color: message.isUser ? Colors.white70 : Colors.grey,
                          size: 12,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (message.isUser) const SizedBox(width: 8),
          if (message.isUser)
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF8075FF), width: 2),
              ),
              child: CircleAvatar(
                radius: 14,
                backgroundColor: Colors.grey[400],
                child: const Icon(Icons.person, color: Colors.white, size: 14),
              ),
            ),
        ],
      ),
    );
  }
  Widget _buildMessageInput() {
  return Container(
    padding: const EdgeInsets.all(16),
    color: Colors.white,
    child: Row(
      children: [
        // Attachment Button
        PopupMenuButton<String>(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: Colors.grey),
          ),
          onSelected: (value) {
            _handleAttachmentSelection(value);
          },
          itemBuilder: (BuildContext context) {
            return {
              'Photo': Icons.photo,
              'Measurements': Icons.text_rotate_up,
              'Appointment': Icons.schedule,
              'Location': Icons.location_on,
            }.entries.map((entry) {
              return PopupMenuItem<String>(
                value: entry.key,
                child: Row(
                  children: [
                    Icon(entry.value, color: const Color(0xFF8075FF)),
                    const SizedBox(width: 8),
                    Text(entry.key),
                  ],
                ),
              );
            }).toList();
          },
        ),
        const SizedBox(width: 8),
        
        // Message Input
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Message ${widget.tailorName}...",
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
                  onPressed: () {
                    // Implement emoji picker
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        
        // Send Button
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF8075FF), Color(0xFF6A5BFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.send, color: Colors.white),
            onPressed: _sendMessage,
          ),
        ),
      ],
    ),
  );
}

String _formatTime(DateTime timestamp) {
  return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
}

void _handleShopOptionTap(int index) {
  setState(() {
    _selectedShopOption = index;
  });

  switch (index) {
    case 0: // Portfolio
      _messageController.text = "Can I see your portfolio?";
      break;
    case 1: // Appointment
      _bookAppointment();
      return; // Don't send message for appointment
    case 2: // Pricing
      _messageController.text = "What are your pricing details?";
      break;
    case 3: // Services
      _messageController.text = "What services do you offer?";
      break;
  }
  
  _sendMessage();
}

void _handleAttachmentSelection(String type) {
  switch (type) {
    case 'Photo':
      _sendPhoto();
      break;
    case 'Measurements':
      _shareMeasurements();
      break;
    case 'Appointment':
      _bookAppointment();
      break;
    case 'Location':
      _shareLocation();
      break;
  }
}

void _handleMenuSelection(String value) {
  switch (value) {
    case 'View Portfolio':
      _viewPortfolio();
      break;
    case 'Share Contact':
      _shareContact();
      break;
    case 'Report Issue':
      _reportIssue();
      break;
  }
}

void _sendPhoto() {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Photo attachment selected', style: GoogleFonts.poppins()),
    ),
  );
}

void _shareMeasurements() {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share Measurements',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildMeasurementField('Chest (inches)'),
            _buildMeasurementField('Waist (inches)'),
            _buildMeasurementField('Hip (inches)'),
            _buildMeasurementField('Shoulder (inches)'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _messageController.text = "I've shared my measurements";
                _sendMessage();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8075FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text('Send Measurements', style: GoogleFonts.poppins(color: Colors.white)),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildMeasurementField(String label) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: TextField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      keyboardType: TextInputType.number,
    ),
  );
}

// UPDATED: Proper Date Picker Implementation
void _bookAppointment() {
  showDialog(
    context: context,
    builder: (context) {
      DateTime selectedDate = DateTime.now();
      TimeOfDay selectedTime = TimeOfDay.now();

      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text('Book Appointment', style: GoogleFonts.poppins()),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Schedule a consultation with ${widget.tailorName}', 
                  style: GoogleFonts.poppins()),
                const SizedBox(height: 16),
                
                // Date Picker
                GestureDetector(
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 60)),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Color(0xFF8075FF),
                              onPrimary: Colors.white,
                              onSurface: Colors.black,
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF8075FF),
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (pickedDate != null && pickedDate != selectedDate) {
                      setDialogState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Color(0xFF8075FF)),
                        const SizedBox(width: 10),
                        Text(
                          '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                          style: GoogleFonts.poppins(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Time Picker
                GestureDetector(
                  onTap: () async {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Color(0xFF8075FF),
                              onPrimary: Colors.white,
                              onSurface: Colors.black,
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF8075FF),
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (pickedTime != null && pickedTime != selectedTime) {
                      setDialogState(() {
                        selectedTime = pickedTime;
                      });
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time, color: Color(0xFF8075FF)),
                        const SizedBox(width: 10),
                        Text(
                          selectedTime.format(context),
                          style: GoogleFonts.poppins(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Service Type
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.design_services, color: Color(0xFF8075FF)),
                      const SizedBox(width: 10),
                      Text(
                        'Design Consultation',
                        style: GoogleFonts.poppins(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: GoogleFonts.poppins()),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _confirmAppointment(selectedDate, selectedTime);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8075FF),
                ),
                child: Text('Schedule', style: GoogleFonts.poppins(color: Colors.white)),
              ),
            ],
          );
        },
      );
    },
  );
}

void _confirmAppointment(DateTime date, TimeOfDay time) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Confirm Appointment', style: GoogleFonts.poppins()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('With: ${widget.tailorName}', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Date: ${date.day}/${date.month}/${date.year}', style: GoogleFonts.poppins()),
            Text('Time: ${time.format(context)}', style: GoogleFonts.poppins()),
            Text('Service: Design Consultation', style: GoogleFonts.poppins()),
            const SizedBox(height: 12),
            Text('We will send you a confirmation message shortly.', 
              style: GoogleFonts.poppins(color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Edit', style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showAppointmentSuccess(date, time);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8075FF),
            ),
            child: Text('Confirm', style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      );
    },
  );
}

void _showAppointmentSuccess(DateTime date, TimeOfDay time) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Appointment confirmed with ${widget.tailorName}!', 
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          Text('${date.day}/${date.month}/${date.year} at ${time.format(context)}',
            style: GoogleFonts.poppins(fontSize: 12)),
        ],
      ),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        label: 'View',
        textColor: Colors.white,
        onPressed: () {
          // Navigate to appointments screen
        },
      ),
    ),
  );
  
  // Send confirmation message
  setState(() {
    _messages.add(
      ChatMessage(
        text: "I've scheduled your appointment for ${date.day}/${date.month}/${date.year} at ${time.format(context)}. We'll send you a reminder before your visit!",
        isUser: false,
        timestamp: DateTime.now(),
        isTailor: true,
      ),
    );
  });
}

void _shareLocation() {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Location sharing selected', style: GoogleFonts.poppins()),
    ),
  );
}

void _viewPortfolio() {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Opening portfolio...', style: GoogleFonts.poppins()),
    ),
  );
}

void _shareContact() {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Contact shared!', style: GoogleFonts.poppins()),
    ),
  );
}

void _reportIssue() {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Report issue selected', style: GoogleFonts.poppins()),
    ),
  );
}

void _makeCall() {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Calling ${widget.tailorName}...', style: GoogleFonts.poppins()),
    ),
  );
}

void _makeVideoCall() {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Starting video call with ${widget.tailorName}...', style: GoogleFonts.poppins()),
    ),
  );
}

  // ... (Keep all other methods the same as before: _buildMessageInput, _formatTime, 
  // _handleShopOptionTap, _handleAttachmentSelection, _handleMenuSelection, 
  // _sendPhoto, _shareMeasurements, _bookAppointment, etc.)

  // Add the remaining methods from your original code here...
  // They remain exactly the same as in your provided code


}

