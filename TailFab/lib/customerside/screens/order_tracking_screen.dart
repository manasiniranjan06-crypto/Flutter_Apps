
import 'package:firebaseauth/customerside/components/gradient_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class CustomerOrderTracking extends StatefulWidget {
  final Map<String, dynamic> order;
  final Color? accentColor;
  final Color? primaryColor;
  final String? orderId;
  final Color? textPrimary;
  final Color? textSecondary;
  final Color? cardColor;

  const CustomerOrderTracking({
    Key? key,
    required this.order,
    this.accentColor,
    this.primaryColor,
    this.orderId,
    this.textPrimary,
    this.textSecondary,
    this.cardColor,
  }) : super(key: key);

  @override
  State<CustomerOrderTracking> createState() => _CustomerOrderTrackingState();
}

class _CustomerOrderTrackingState extends State<CustomerOrderTracking>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _progressController;
  late AnimationController _shimmerController;
  late Animation<double> _progressAnimation;

  List<Map<String, dynamic>> trackingSteps = [];
  int currentStep = 0;
  double overallProgress = 0.0;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _initializeTrackingSteps();
    
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: overallProgress,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    _progressController.forward();
  }

  void _initializeTrackingSteps() {
    double progress = widget.order['progress'] ?? 0.0;
    overallProgress = progress;

    trackingSteps = [
      {
        'title': 'Order Accepted',
        'subtitle': 'Your order has been accepted by the tailor',
        'icon': Icons.check_circle_outline,
        'activeIcon': Icons.check_circle,
        'time': '10 Oct, 10:30 AM',
        'completed': true,
        'active': progress < 0.25,
        'description': 'Tailor has reviewed and accepted your order requirements.',
        'color': const Color(0xFF4CAF50),
        'emoji': '✅',
      },
      {
        'title': 'Fabric Cut & Prepared',
        'subtitle': 'Fabric cutting and preparation in progress',
        'icon': Icons.content_cut_outlined,
        'activeIcon': Icons.content_cut,
        'time': progress >= 0.25 ? '10 Oct, 02:00 PM' : '',
        'completed': progress >= 0.25,
        'active': progress >= 0.25 && progress < 0.5,
        'description': 'Fabric is being cut according to your measurements.',
        'color': const Color(0xFFFF9800),
        'emoji': '✂️',
      },
      {
        'title': 'Stitching Started',
        'subtitle': 'Tailor has started stitching your garment',
        'icon': Icons.carpenter_outlined,
        'activeIcon': Icons.carpenter,
        'time': progress >= 0.5 ? '11 Oct, 11:00 AM' : '',
        'completed': progress >= 0.5,
        'active': progress >= 0.5 && progress < 0.7,
        'description': 'Main stitching work is in progress with attention to detail.',
        'color': const Color(0xFF2196F3),
        'emoji': '🧵',
      },
      {
        'title': 'Final Finishing',
        'subtitle': 'Quality check and finishing touches',
        'icon': Icons.auto_fix_high_outlined,
        'activeIcon': Icons.auto_fix_high,
        'time': progress >= 0.7 ? '12 Oct, 03:00 PM' : '',
        'completed': progress >= 0.7,
        'active': progress >= 0.7 && progress < 0.9,
        'description': 'Final touches, button work, and quality inspection.',
        'color': const Color(0xFF9C27B0),
        'emoji': '✨',
      },
      {
        'title': 'Ready for Delivery',
        'subtitle': 'Your order is ready for pickup/delivery',
        'icon': Icons.inventory_2_outlined,
        'activeIcon': Icons.inventory_2,
        'time': progress >= 0.9 ? '13 Oct, 10:00 AM' : '',
        'completed': progress >= 0.9,
        'active': progress >= 0.9 && progress < 1.0,
        'description': 'Your garment is ready! You can pick it up or we will deliver.',
        'color': const Color(0xFFFF5722),
        'emoji': '📦',
      },
      {
        'title': 'Delivered',
        'subtitle': 'Order successfully delivered',
        'icon': Icons.home_outlined,
        'activeIcon': Icons.home,
        'time': progress >= 1.0 ? '13 Oct, 05:30 PM' : '',
        'completed': progress >= 1.0,
        'active': false,
        'description': 'Order has been delivered successfully. Thank you!',
        'color': const Color(0xFF4CAF50),
        'emoji': '🎉',
      },
    ];

    currentStep = trackingSteps.indexWhere((step) => step['active'] == true);
    if (currentStep == -1) {
      currentStep = trackingSteps.where((step) => step['completed'] == true).length - 1;
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _progressController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        title: Text(
          'Track Order',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _refreshOrder,
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () => _showSnackBar('Sharing order details...'),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildProgressRing(),
            const SizedBox(height: 20),
            _buildOrderInfoCard(),
            const SizedBox(height: 24),
            _buildCurrentStatusBanner(),
            const SizedBox(height: 24),
            _buildTrackingTimeline(),
            const SizedBox(height: 24),
            _buildActionButtons(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressRing() {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              SizedBox(
                width: 160,
                height: 160,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(160, 160),
                      painter: ProgressRingPainter(
                        progress: _progressAnimation.value,
                        backgroundColor: Colors.grey[200]!,
                        progressColor: const Color(0xFF8075FF),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${(_progressAnimation.value * 100).toInt()}%',
                          style: GoogleFonts.poppins(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF8075FF),
                          ),
                        ),
                        Text(
                          'Complete',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _getProgressMessage(),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  String _getProgressMessage() {
    if (overallProgress < 0.25) {
      return 'Your order is being prepared';
    } else if (overallProgress < 0.5) {
      return 'Fabric preparation in progress';
    } else if (overallProgress < 0.7) {
      return 'Stitching work underway';
    } else if (overallProgress < 0.9) {
      return 'Final touches being added';
    } else if (overallProgress < 1.0) {
      return 'Almost ready for delivery!';
    } else {
      return 'Successfully delivered!';
    }
  }

  Widget _buildOrderInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            const Color(0xFF8075FF).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order ID',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    widget.order['orderId'],
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getStatusColor(widget.order['status']),
                      _getStatusColor(widget.order['status']).withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: _getStatusColor(widget.order['status']).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  widget.order['status'],
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 20),
          Row(
            children: [
              Hero(
                tag: 'order_image_${widget.order['orderId']}',
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF8075FF).withOpacity(0.2),
                        const Color(0xFF8075FF).withOpacity(0.1),
                      ],
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      widget.order['itemImage'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.image, color: Colors.grey, size: 32),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.order['itemName'],
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF8075FF).withOpacity(0.2),
                                const Color(0xFF8075FF).withOpacity(0.1),
                              ],
                            ),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              widget.order['tailorImage'],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stack) => Icon(
                                Icons.store,
                                size: 16,
                                color: Colors.grey[400],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.order['tailorName'],
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8075FF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: const Color(0xFF8075FF),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Expected: ${widget.order['deliveryDate']}',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: const Color(0xFF8075FF),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStatusBanner() {
    if (currentStep < 0 || currentStep >= trackingSteps.length) {
      return const SizedBox.shrink();
    }

    var step = trackingSteps[currentStep];

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                step['color'],
                (step['color'] as Color).withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: (step['color'] as Color).withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  step['emoji'],
                  style: const TextStyle(fontSize: 36),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Current Status',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(
                                  0.5 + (_pulseController.value * 0.5),
                                ),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      step['title'],
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      step['subtitle'],
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTrackingTimeline() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Order Timeline',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.timeline,
                color: const Color(0xFF8075FF),
                size: 24,
              ),
            ],
          ),
          const SizedBox(height: 28),
          ...List.generate(trackingSteps.length, (index) {
            return _buildTimelineStep(trackingSteps[index], index);
          }),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(Map<String, dynamic> step, int index) {
    bool isCompleted = step['completed'];
    bool isActive = step['active'];
    bool isLast = index == trackingSteps.length - 1;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: isCompleted || isActive
                          ? LinearGradient(
                              colors: [
                                step['color'],
                                (step['color'] as Color).withOpacity(0.7),
                              ],
                            )
                          : null,
                      color: !isCompleted && !isActive ? Colors.grey[200] : null,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isActive
                            ? Colors.white
                            : Colors.transparent,
                        width: 3,
                      ),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: (step['color'] as Color).withOpacity(
                                  0.3 + (_pulseController.value * 0.2),
                                ),
                                blurRadius: 12,
                                spreadRadius: 4,
                              ),
                            ]
                          : isCompleted
                              ? [
                                  BoxShadow(
                                    color: (step['color'] as Color).withOpacity(0.2),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : [],
                    ),
                    child: Center(
                      child: Icon(
                        isCompleted ? step['activeIcon'] : step['icon'],
                        color: isCompleted || isActive
                            ? Colors.white
                            : Colors.grey[400],
                        size: 24,
                      ),
                    ),
                  );
                },
              ),
              if (!isLast)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: 3,
                  height: 70,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: isCompleted
                          ? [
                              step['color'],
                              trackingSteps[index + 1]['completed']
                                  ? trackingSteps[index + 1]['color']
                                  : Colors.grey[300]!,
                            ]
                          : [Colors.grey[300]!, Colors.grey[300]!],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: () => _showStepDetails(step),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: isLast ? EdgeInsets.zero : const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: isActive
                      ? LinearGradient(
                          colors: [
                            (step['color'] as Color).withOpacity(0.08),
                            (step['color'] as Color).withOpacity(0.04),
                          ],
                        )
                      : null,
                  color: !isActive ? Colors.grey[50] : null,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isActive
                        ? (step['color'] as Color).withOpacity(0.3)
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            step['title'],
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: isActive || isCompleted
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                              color: isCompleted || isActive
                                  ? Colors.black87
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                        if (isActive)
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      step['color'],
                                      (step['color'] as Color).withOpacity(0.8),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: (step['color'] as Color).withOpacity(
                                        0.3 + (_pulseController.value * 0.2),
                                      ),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Active',
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        if (isCompleted && !isActive)
                          Icon(
                            Icons.check_circle,
                            size: 20,
                            color: step['color'],
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      step['subtitle'],
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (step['time'].isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? (step['color'] as Color).withOpacity(0.1)
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: isActive ? step['color'] : Colors.grey[600],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              step['time'],
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: isActive ? step['color'] : Colors.grey[600],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8075FF), Color(0xFF9D8CFF)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8075FF).withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () => _contactTailor(),
              icon: const Icon(Icons.phone, size: 22),
              label: Text(
                'Contact Tailor',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 58),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  icon: Icons.straighten,
                  label: 'Measurements',
                  color: const Color(0xFF2196F3),
                  onTap: _viewMeasurements,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionCard(
                  icon: Icons.directions,
                  label: 'Directions',
                  color: const Color(0xFFFF9800),
                  onTap: _getDirections,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  icon: Icons.rate_review,
                  label: 'Rate Order',
                  color: const Color(0xFFE91E63),
                  onTap: _rateOrder,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionCard(
                  icon: Icons.help_outline,
                  label: 'Help',
                  color: const Color(0xFF9C27B0),
                  onTap: _needHelp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _refreshOrder() {
    setState(() {
      _progressController.reset();
      _progressController.forward();
    });
    _showSnackBar('Order status refreshed');
  }

  void _showStepDetails(Map<String, dynamic> step) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      (step['color'] as Color).withOpacity(0.2),
                      (step['color'] as Color).withOpacity(0.1),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  step['emoji'],
                  style: const TextStyle(fontSize: 48),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                step['title'],
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                step['description'],
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.grey[600],
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              if (step['time'].isNotEmpty) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        (step['color'] as Color).withOpacity(0.15),
                        (step['color'] as Color).withOpacity(0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.access_time, size: 20, color: step['color']),
                      const SizedBox(width: 10),
                      Text(
                        step['time'],
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: step['color'],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: step['color'],
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Got it',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _contactTailor() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Contact Tailor',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 28),
              _buildContactOption(
                icon: Icons.phone,
                title: 'Call Tailor',
                subtitle: '+91 98765 43210',
                color: Colors.green,
                onTap: () {
                  Navigator.pop(context);
                  _showSnackBar('Calling tailor...');
                },
              ),
              const SizedBox(height: 12),
              _buildContactOption(
                icon: Icons.message,
                title: 'Send Message',
                subtitle: 'Chat with tailor',
                color: const Color(0xFF8075FF),
                onTap: () {
                  Navigator.pop(context);
                  _showSnackBar('Opening chat...');
                },
              ),
              const SizedBox(height: 12),
              _buildContactOption(
                icon: Icons.email,
                title: 'Send Email',
                subtitle: 'tailor@example.com',
                color: const Color(0xFF2196F3),
                onTap: () {
                  Navigator.pop(context);
                  _showSnackBar('Opening email...');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: color),
          ],
        ),
      ),
    );
  }

  void _viewMeasurements() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        'Your Measurements',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildMeasurementItem('Chest', '40 inches', Icons.straighten, const Color(0xFF2196F3)),
                  _buildMeasurementItem('Waist', '34 inches', Icons.straighten, const Color(0xFF4CAF50)),
                  _buildMeasurementItem('Shoulder', '18 inches', Icons.straighten, const Color(0xFFFF9800)),
                  _buildMeasurementItem('Sleeve Length', '24 inches', Icons.straighten, const Color(0xFF9C27B0)),
                  _buildMeasurementItem('Shirt Length', '30 inches', Icons.straighten, const Color(0xFFE91E63)),
                  _buildMeasurementItem('Neck', '15.5 inches', Icons.straighten, const Color(0xFF00BCD4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeasurementItem(String label, String value, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.08),
            color.withOpacity(0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 24, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _getDirections() {
    _showSnackBar('Opening maps for directions...');
  }

  void _rateOrder() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Rate Your Experience',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(
                      Icons.star,
                      size: 40,
                      color: Colors.amber,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showSnackBar('Thank you for your rating!');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8075FF),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Submit Rating',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _needHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF8075FF).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.help_outline,
                color: Color(0xFF8075FF),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Need Help?',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          'Our customer support team is here to help you 24/7. How would you like to reach us?',
          style: GoogleFonts.poppins(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Connecting to support...');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8075FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Contact Support',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFFF9800);
      case 'in progress':
        return const Color(0xFF2196F3);
      case 'ready':
        return const Color(0xFF4CAF50);
      case 'delivered':
        return const Color(0xFF9C27B0);
      default:
        return Colors.grey;
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF8075FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(20),
      ),
    );
  }
}

// Custom Painter for Progress Ring
class ProgressRingPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;

  ProgressRingPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = 12.0;

    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - strokeWidth / 2, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          progressColor,
          progressColor.withOpacity(0.6),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}