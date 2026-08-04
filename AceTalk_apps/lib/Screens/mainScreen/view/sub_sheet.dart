
// ─── SUBSCRIPTION BOTTOM SHEET ────────────────────────────────────────────────
import 'package:ai_interview_app/payment/subscription_plan.dart';
import 'package:ai_interview_app/shared/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubscriptionSheet extends StatelessWidget {
  final SubscriptionPlan currentPlan;
  final String reason;
  final Function(SubscriptionPlan) onSelectPlan;

  const SubscriptionSheet({
    required this.currentPlan,
    required this.reason,
    required this.onSelectPlan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF081525),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(top: BorderSide(color: Color(0xFF00E5FF), width: 1)),
      ),
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                  color: Colors.white24, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 20),
          // Header
          Row(children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.accentGold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.accentGold.withOpacity(0.3)),
              ),
              child: const Icon(Icons.workspace_premium_rounded,
                  color: AppColors.accentGold, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Upgrade Your Plan',
                    style: GoogleFonts.dmSans(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800)),
                Text(reason,
                    style: GoogleFonts.dmSans(
                        color: AppColors.textSecondary, fontSize: 12)),
              ]),
            ),
          ]),
          const SizedBox(height: 22),
          // Plan cards
          _planCard(
            context,
            plan: SubscriptionPlan.pro,
            title: 'Pro Plan',
            price: '₹499/mo',
            color: AppColors.accentGold,
            icon: Icons.workspace_premium_rounded,
            features: [
              'All difficulty levels (Medium & Hard)',
              'Up to 15 questions per session',
              'Priority AI feedback',
              'Session history & analytics',
            ],
            isCurrent: currentPlan == SubscriptionPlan.pro,
          ),
          const SizedBox(height: 12),
          _planCard(
            context,
            plan: SubscriptionPlan.elite,
            title: 'Elite Plan',
            price: '₹999/mo',
            color: AppColors.accentCyan,
            icon: Icons.diamond_rounded,
            features: [
              'Everything in Pro',
              'Up to 20 questions per session',
              'Company-specific question banks',
              'Resume-based interviews',
              'Unlimited sessions',
            ],
            isCurrent: currentPlan == SubscriptionPlan.elite,
          ),
          const SizedBox(height: 16),
          Text(
            'Secure payment via Razorpay · Cancel anytime',
            style: GoogleFonts.dmSans(
                color: AppColors.textSecondary, fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _planCard(
    BuildContext context, {
    required SubscriptionPlan plan,
    required String title,
    required String price,
    required Color color,
    required IconData icon,
    required List<String> features,
    required bool isCurrent,
  }) {
    return GestureDetector(
      onTap: isCurrent ? null : () => onSelectPlan(plan),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: color.withOpacity(isCurrent ? 0.15 : 0.07),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color: color.withOpacity(isCurrent ? 0.6 : 0.3),
              width: isCurrent ? 1.5 : 1),
          boxShadow: isCurrent
              ? [BoxShadow(color: color.withOpacity(0.15), blurRadius: 20)]
              : [],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 10),
            Text(title,
                style: GoogleFonts.dmSans(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800)),
            const Spacer(),
            Text(price,
                style: GoogleFonts.spaceMono(
                    color: color, fontSize: 15, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 12),
          ...features.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(children: [
                  Icon(Icons.check_circle_rounded, color: color, size: 14),
                  const SizedBox(width: 8),
                  Text(f,
                      style: GoogleFonts.dmSans(
                          color: Colors.white70, fontSize: 12.5)),
                ]),
              )),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: isCurrent
                ? Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Center(
                      child: Text('Current Plan',
                          style: GoogleFonts.dmSans(
                              color: color,
                              fontWeight: FontWeight.w700,
                              fontSize: 13)),
                    ),
                  )
                : ElevatedButton(
                    onPressed: () => onSelectPlan(plan),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: Text('Subscribe · $price',
                        style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w800, fontSize: 13)),
                  ),
          ),
        ]),
      ),
    );
  }
}