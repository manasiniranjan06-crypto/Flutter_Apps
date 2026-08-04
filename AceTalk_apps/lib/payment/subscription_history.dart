import 'dart:math';

import 'package:ai_interview_app/Screens/setting/animate_backgrd.dart';
import 'package:ai_interview_app/Screens/setting/color_palet.dart';
import 'package:ai_interview_app/Screens/setting/resuable_widget.dart';
import 'package:ai_interview_app/payment/subscription_plan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SubscriptionHistoryScreen extends StatefulWidget {
  final SubscriptionPlan plan;
  const SubscriptionHistoryScreen({super.key, required this.plan});
  @override
  State<SubscriptionHistoryScreen> createState() =>
      _SubscriptionHistoryScreenState();
}

class _SubscriptionHistoryScreenState extends State<SubscriptionHistoryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _bgCtrl;
  late Animation<double> _bgAnim;
  List<Map<String, String>> _history = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
    _bgAnim = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(CurvedAnimation(parent: _bgCtrl, curve: Curves.linear));
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final hist = await SubscriptionManager.getHistory();
    if (mounted)
      setState(() {
        _history = hist;
        _loading = false;
      });
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    super.dispose();
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────
  Color _planColor(SubscriptionPlan p) {
    switch (p) {
      case SubscriptionPlan.pro:
        return AppColors2.gold;
      case SubscriptionPlan.elite:
        return AppColors2.cyan;
      case SubscriptionPlan.free:
        return AppColors2.ts;
    }
  }

  Color _histColor(String plan) {
    switch (plan) {
      case 'pro':
        return AppColors2.gold;
      case 'elite':
        return AppColors2.cyan;
      default:
        return AppColors2.ts;
    }
  }

  IconData _histIcon(String plan) {
    switch (plan) {
      case 'pro':
        return Icons.workspace_premium_rounded;
      case 'elite':
        return Icons.diamond_rounded;
      default:
        return Icons.free_breakfast_rounded;
    }
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso);
      const m = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${m[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (_) {
      return iso;
    }
  }

  // ── Plan card ────────────────────────────────────────────────────────────────
  Widget _currentPlanCard(Color planColor) {
    final planName =
        widget.plan.name[0].toUpperCase() + widget.plan.name.substring(1);
    final features = {
      SubscriptionPlan.free: [
        'Beginner & Easy levels only',
        'Up to 5 questions/session',
        'Basic AI feedback',
      ],
      SubscriptionPlan.pro: [
        'All difficulty levels',
        'Up to 15 questions/session',
        'Priority AI feedback',
        'Session analytics',
      ],
      SubscriptionPlan.elite: [
        'All difficulty levels',
        'Up to 20 questions/session',
        'Company-specific banks',
        'Resume-based interviews',
        'Unlimited sessions',
      ],
    };

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [planColor.withOpacity(0.25), planColor.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: planColor.withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: planColor.withOpacity(0.15),
            blurRadius: 24,
            spreadRadius: 2,
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
                  color: planColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: planColor.withOpacity(0.4)),
                ),
                child: Icon(
                  widget.plan == SubscriptionPlan.elite
                      ? Icons.diamond_rounded
                      : widget.plan == SubscriptionPlan.pro
                      ? Icons.workspace_premium_rounded
                      : Icons.free_breakfast_rounded,
                  color: planColor,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Plan',
                    style: GoogleFonts.dmSans(
                      color: AppColors2.ts,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '$planName Plan',
                    style: GoogleFonts.spaceMono(
                      color: planColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              if (widget.plan != SubscriptionPlan.free)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors2.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors2.green.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors2.green,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Active',
                        style: GoogleFonts.dmSans(
                          color: AppColors2.green,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),
          Divider(color: planColor.withOpacity(0.2)),
          const SizedBox(height: 14),
          ...(features[widget.plan] ?? []).map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(Icons.check_circle_rounded, color: planColor, size: 15),
                  const SizedBox(width: 10),
                  Text(
                    f,
                    style: GoogleFonts.dmSans(
                      color: AppColors2.tp,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Plan comparison ──────────────────────────────────────────────────────────
  Widget _planComparison() {
    final plans = [
      {
        'plan': SubscriptionPlan.free,
        'title': 'Free',
        'price': '₹0',
        'questions': '5',
        'levels': 'Basic',
        'color': AppColors2.ts,
      },
      {
        'plan': SubscriptionPlan.pro,
        'title': 'Pro',
        'price': '₹499/mo',
        'questions': '15',
        'levels': 'All',
        'color': AppColors2.gold,
      },
      {
        'plan': SubscriptionPlan.elite,
        'title': 'Elite',
        'price': '₹999/mo',
        'questions': '20',
        'levels': 'All + Co.',
        'color': AppColors2.cyan,
      },
    ];

    return GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Feature',
                    style: GoogleFonts.dmSans(
                      color: AppColors2.ts,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                ...plans.map(
                  (p) => Expanded(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: (p['color'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: (p['color'] as Color).withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            p['title'] as String,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.spaceMono(
                              color: p['color'] as Color,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (p['plan'] == widget.plan)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: p['color'] as Color,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(color: Colors.white.withOpacity(0.07), height: 1),
          _compRow(
            'Price',
            plans.map((p) => p['price'] as String).toList(),
            plans.map((p) => p['color'] as Color).toList(),
            plans.map((p) => p['plan'] == widget.plan).toList(),
          ),
          Divider(color: Colors.white.withOpacity(0.05), height: 1),
          _compRow(
            'Max Q',
            plans.map((p) => p['questions'] as String).toList(),
            plans.map((p) => p['color'] as Color).toList(),
            plans.map((p) => p['plan'] == widget.plan).toList(),
          ),
          Divider(color: Colors.white.withOpacity(0.05), height: 1),
          _compRow(
            'Levels',
            plans.map((p) => p['levels'] as String).toList(),
            plans.map((p) => p['color'] as Color).toList(),
            plans.map((p) => p['plan'] == widget.plan).toList(),
          ),
        ],
      ),
    );
  }

  Widget _compRow(
    String label,
    List<String> vals,
    List<Color> colors,
    List<bool> isCurrent,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.dmSans(color: AppColors2.ts, fontSize: 12.5),
            ),
          ),
          ...List.generate(
            vals.length,
            (i) => Expanded(
              child: Container(
                padding: isCurrent[i]
                    ? const EdgeInsets.symmetric(vertical: 4)
                    : EdgeInsets.zero,
                decoration: isCurrent[i]
                    ? BoxDecoration(
                        color: colors[i].withOpacity(0.08),
                        borderRadius: BorderRadius.circular(6),
                      )
                    : null,
                child: Text(
                  vals[i],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.spaceMono(
                    color: isCurrent[i] ? colors[i] : AppColors2.ts,
                    fontSize: 11,
                    fontWeight: isCurrent[i]
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Payment history ──────────────────────────────────────────────────────────
  Widget _paymentHistory() {
    if (_loading)
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors2.gold,
          strokeWidth: 2,
        ),
      );

    if (_history.isEmpty) {
      return GlassCard(
        child: Column(
          children: [
            Icon(
              Icons.receipt_long_rounded,
              color: AppColors2.ts.withOpacity(0.4),
              size: 40,
            ),
            const SizedBox(height: 12),
            Text(
              'No payment history yet',
              style: GoogleFonts.dmSans(
                color: AppColors2.ts,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Your purchases will appear here',
              style: GoogleFonts.dmSans(
                color: AppColors2.ts.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    return GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: List.generate(_history.length, (i) {
          final item = _history[i];
          final isLast = i == _history.length - 1;
          final planStr = item['plan'] ?? 'free';
          final planColor = _histColor(planStr);
          final planIcon = _histIcon(planStr);
          final dateStr = _formatDate(item['date'] ?? '');
          final amount = item['amount'] ?? '0';
          final payId = item['paymentId'] ?? '';

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: planColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: planColor.withOpacity(0.25)),
                      ),
                      child: Icon(planIcon, color: planColor, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${planStr[0].toUpperCase()}${planStr.substring(1)} Plan',
                            style: GoogleFonts.dmSans(
                              color: AppColors2.tp,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            dateStr,
                            style: GoogleFonts.dmSans(
                              color: AppColors2.ts,
                              fontSize: 11.5,
                            ),
                          ),
                          if (payId.isNotEmpty)
                            Text(
                              'ID: ${payId.length > 16 ? '${payId.substring(0, 16)}…' : payId}',
                              style: GoogleFonts.spaceMono(
                                color: AppColors2.ts.withOpacity(0.6),
                                fontSize: 9.5,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹$amount',
                          style: GoogleFonts.spaceMono(
                            color: planColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors2.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: AppColors2.green.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            'Paid',
                            style: GoogleFonts.dmSans(
                              color: AppColors2.green,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Divider(
                  color: Colors.white.withOpacity(0.05),
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _cancelInfo() {
    return GlassCard(
      borderColor: AppColors2.red.withOpacity(0.2),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors2.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors2.red.withOpacity(0.25)),
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              color: AppColors2.red,
              size: 18,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cancel Subscription',
                  style: GoogleFonts.dmSans(
                    color: AppColors2.tp,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'To cancel, contact support@acetalk.com. Your access continues until end of billing period.',
                  style: GoogleFonts.dmSans(
                    color: AppColors2.ts,
                    fontSize: 11.5,
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

  // ── Build ───────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final planColor = _planColor(widget.plan);
    return Scaffold(
      backgroundColor: AppColors2.bg,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _bgAnim,
            builder: (_, __) => CustomPaint(
              painter: BgPainter(
                _bgAnim.value,
                orbA: AppColors2.gold,
                orbB: AppColors2.blue,
              ),
              child: const SizedBox.expand(),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppColors2.ts,
                          size: 20,
                        ),
                      ),
                      Text(
                        'Subscription',
                        style: GoogleFonts.spaceMono(
                          fontSize: 18,
                          color: AppColors2.tp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _currentPlanCard(planColor),
                        const SizedBox(height: 24),
                        const SectionLabel('Compare Plans'),
                        const SizedBox(height: 12),
                        _planComparison(),
                        const SizedBox(height: 24),
                        const SectionLabel('Payment History'),
                        const SizedBox(height: 12),
                        _paymentHistory(),
                        if (widget.plan != SubscriptionPlan.free) ...[
                          const SizedBox(height: 24),
                          _cancelInfo(),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
