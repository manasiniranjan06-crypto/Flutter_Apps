
import 'package:ai_interview_app/Screens/fieldscreen/feildbloc.dart';
import 'package:ai_interview_app/Screens/fieldscreen/welcom.dart';
import 'package:ai_interview_app/Screens/langugae/lqngugaecard.dart';
import 'package:ai_interview_app/Screens/mainScreen/view/sub_sheet.dart';
import 'package:ai_interview_app/payment/rezarpay_payment.dart';
import 'package:ai_interview_app/payment/subscription_plan.dart';
import 'package:ai_interview_app/shared/animatedbackground.dart';
import 'package:ai_interview_app/shared/app_theme.dart';
import 'package:ai_interview_app/shared/glasscard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';


// ─── FIELDS SCREEN ────────────────────────────────────────────────────────────
class FieldsScreen extends StatelessWidget {
  final LanguageEntity language;
  const FieldsScreen({super.key, required this.language});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FieldsBloc(),
      child: _FieldsView(language: language),
    );
  }
}

class _FieldsView extends StatefulWidget {
  final LanguageEntity language;
  const _FieldsView({required this.language});

  @override
  State<_FieldsView> createState() => _FieldsViewState();
}

class _FieldsViewState extends State<_FieldsView>
    with SingleTickerProviderStateMixin {
  late AnimationController _btnCtrl;
  late Animation<double> _btnScale;
  late RazorpayService _razorpayService;

  SubscriptionPlan _currentPlan = SubscriptionPlan.free;
  bool _loadingPlan = true;
  SubscriptionPlan? _pendingUpgrade; // which plan is being purchased

  static const _levels = [
    {
      'label': 'Beginner',
      'icon': Icons.spa_rounded,
      'color': AppColors.accentGreen,
      'free': true,
    },
    {
      'label': 'Easy',
      'icon': Icons.eco_rounded,
      'color': Color(0xFF69F0AE),
      'free': true,
    },
    {
      'label': 'Medium',
      'icon': Icons.bolt_rounded,
      'color': AppColors.accentGold,
      'free': false,
    },
    {
      'label': 'Hard',
      'icon': Icons.local_fire_department_rounded,
      'color': AppColors.accentRed,
      'free': false,
    },
  ];

  static const _rounds = [
    {'label': 'Entry Level', 'icon': Icons.door_front_door_rounded},
    {'label': 'Virtual', 'icon': Icons.videocam_rounded},
    {'label': 'HR', 'icon': Icons.people_rounded},
    {'label': 'Technical', 'icon': Icons.code_rounded},
    {'label': 'Managerial', 'icon': Icons.business_center_rounded},
  ];

  static const _instructions = [
    {'text': 'Answer each question via text input.', 'icon': Icons.edit_rounded},
    {'text': 'You have 60 seconds per question.', 'icon': Icons.timer_rounded},
    {'text': 'Focus on logic and clarity.', 'icon': Icons.psychology_rounded},
    {'text': 'Think before submitting your answer.', 'icon': Icons.lightbulb_rounded},
    {'text': 'Final score will be shown at the end.', 'icon': Icons.star_rounded},
  ];

  @override
  void initState() {
    super.initState();
    _btnCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _btnScale = Tween<double>(begin: 1.0, end: 0.95)
        .animate(CurvedAnimation(parent: _btnCtrl, curve: Curves.easeInOut));

    _loadSubscription();
    _initRazorpay();
  }

  Future<void> _loadSubscription() async {
    final plan = await SubscriptionManager.getCurrentPlan();
    if (mounted) setState(() {
      _currentPlan = plan;
      _loadingPlan = false;
    });
  }

  void _initRazorpay() {
    _razorpayService = RazorpayService();
    _razorpayService.initializeRazorpay(
      onSuccess: _onPaymentSuccess,
      onFailure: _onPaymentFailure,
    );
  }

  void _onPaymentSuccess(PaymentSuccessResponse response) async {
    if (_pendingUpgrade == null) return;
    final plan = _pendingUpgrade!;
    final amount = plan == SubscriptionPlan.pro ? 499.0 : 999.0;
    await SubscriptionManager.upgradePlan(plan, response.paymentId ?? '', amount);
    if (mounted) {
      setState(() {
        _currentPlan = plan;
        _pendingUpgrade = null;
      });
      _showSuccessSnack(plan);
    }
  }

  void _onPaymentFailure(PaymentFailureResponse response) {
    if (mounted) {
      setState(() => _pendingUpgrade = null);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: _snackContent(
            'Payment failed. Please try again.',
            AppColors.accentRed,
            Icons.error_rounded),
      ));
    }
  }

  void _showSuccessSnack(SubscriptionPlan plan) {
    final name = plan == SubscriptionPlan.pro ? 'Pro' : 'Elite';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: const Duration(seconds: 3),
      content: _snackContent(
          '🎉 $name Plan activated! Enjoy full access.',
          AppColors.accentGreen,
          Icons.check_circle_rounded),
    ));
  }

  Widget _snackContent(String msg, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF081525),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.5), width: 1.5),
        boxShadow: [BoxShadow(color: color.withOpacity(0.2), blurRadius: 20)],
      ),
      child: Row(children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 10),
        Expanded(
            child: Text(msg,
                style: GoogleFonts.dmSans(
                    color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500))),
      ]),
    );
  }

  void _openSubscriptionSheet({required bool forQuestions}) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SubscriptionSheet(
        currentPlan: _currentPlan,
        reason: forQuestions
            ? 'Unlock more questions per session'
            : 'Unlock Medium & Hard difficulty levels',
        onSelectPlan: (plan) {
          Navigator.pop(context);
          _startPayment(plan);
        },
      ),
    );
  }

  void _startPayment(SubscriptionPlan plan) {
    _pendingUpgrade = plan;
    final isPro = plan == SubscriptionPlan.pro;
    _razorpayService.openCheckout(
      amount: isPro ? '49900' : '99900', // paise
      name: 'AceTalk Interview App',
      description: isPro ? 'Pro Plan – Monthly' : 'Elite Plan – Monthly',
      notes: {'plan': plan.name},
    );
  }

  @override
  void dispose() {
    _btnCtrl.dispose();
    _razorpayService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingPlan) {
      return const Scaffold(
        backgroundColor: AppColors.bgDark,
        body: Center(child: CircularProgressIndicator(color: AppColors.accentCyan)),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: Stack(
        children: [
          const AnimatedBackground(),
          SafeArea(
            child: Column(children: [
              _buildAppBar(context),
              _buildBanner(),
              _buildPlanBadge(),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
                  children: [
                    _sectionLabel('Difficulty Level'),
                    const SizedBox(height: 10),
                    _buildLevelSelector(),
                    const SizedBox(height: 18),
                    _sectionLabel('Interview Round'),
                    const SizedBox(height: 10),
                    _buildRoundSelector(),
                    const SizedBox(height: 18),
                    _sectionLabel('Number of Questions'),
                    const SizedBox(height: 10),
                    _buildQuestionCounter(),
                    const SizedBox(height: 18),
                    _buildDurationCard(),
                    const SizedBox(height: 18),
                    _sectionLabel('Instructions'),
                    const SizedBox(height: 10),
                    _buildInstructions(),
                    const SizedBox(height: 30),
                    _buildStartButton(context),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanBadge() {
    Color badgeColor;
    String badgeText;
    IconData badgeIcon;

    switch (_currentPlan) {
      case SubscriptionPlan.pro:
        badgeColor = AppColors.accentGold;
        badgeText = 'PRO PLAN';
        badgeIcon = Icons.workspace_premium_rounded;
        break;
      case SubscriptionPlan.elite:
        badgeColor = AppColors.accentCyan;
        badgeText = 'ELITE PLAN';
        badgeIcon = Icons.diamond_rounded;
        break;
      case SubscriptionPlan.free:
        badgeColor = AppColors.textSecondary;
        badgeText = 'FREE PLAN · Upgrade for more';
        badgeIcon = Icons.lock_outline_rounded;
        break;
    }

    return GestureDetector(
      onTap: _currentPlan == SubscriptionPlan.free
          ? () => _openSubscriptionSheet(forQuestions: false)
          : null,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: badgeColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: badgeColor.withOpacity(0.25)),
        ),
        child: Row(children: [
          Icon(badgeIcon, color: badgeColor, size: 15),
          const SizedBox(width: 8),
          Text(badgeText,
              style: GoogleFonts.spaceMono(
                  color: badgeColor,
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2)),
          const Spacer(),
          if (_currentPlan == SubscriptionPlan.free)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.accentGold.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.accentGold.withOpacity(0.4)),
              ),
              child: Text('UPGRADE',
                  style: GoogleFonts.spaceMono(
                      color: AppColors.accentGold, fontSize: 9, fontWeight: FontWeight.bold)),
            ),
        ]),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.07),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white12),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.textSecondary, size: 18),
          ),
        ),
        const SizedBox(width: 14),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Interview Setup',
              style: GoogleFonts.dmSans(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800)),
          Text('Configure your session',
              style: GoogleFonts.dmSans(
                  color: AppColors.textSecondary, fontSize: 12)),
        ]),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.accentBlue.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.accentBlue.withOpacity(0.3)),
          ),
          child: Text('AI Mock',
              style: GoogleFonts.spaceMono(
                  color: AppColors.accentCyan,
                  fontSize: 11,
                  fontWeight: FontWeight.bold)),
        ),
      ]),
    );
  }

  Widget _buildBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      child: GlassCard(
        child: Row(children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: widget.language.accentColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: widget.language.accentColor.withOpacity(0.3)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(widget.language.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(
                      widget.language.icon,
                      color: widget.language.accentColor,
                      size: 24)),
            ),
          ),
          const SizedBox(width: 14),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Selected Language',
                style: GoogleFonts.dmSans(
                    color: AppColors.textSecondary,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 2),
            Text(widget.language.name,
                style: GoogleFonts.spaceMono(
                    color: widget.language.accentColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w800)),
          ]),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.accentGold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.accentGold.withOpacity(0.3)),
            ),
            child: Text('Ready',
                style: GoogleFonts.dmSans(
                    color: AppColors.accentGold,
                    fontSize: 11,
                    fontWeight: FontWeight.bold)),
          ),
        ]),
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Row(children: [
      Container(
        width: 3, height: 16,
        decoration: BoxDecoration(
            color: AppColors.accentCyan,
            borderRadius: BorderRadius.circular(2)),
      ),
      const SizedBox(width: 8),
      Text(label,
          style: GoogleFonts.dmSans(
              color: AppColors.textSecondary,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8)),
    ]);
  }

  Widget _buildLevelSelector() {
    return BlocBuilder<FieldsBloc, FieldsState>(
      builder: (context, state) => GlassCard(
        child: Column(
          children: _levels.map((lvl) {
            final label = lvl['label'] as String;
            final isSelected = state.level == label;
            final color = lvl['color'] as Color;
            final isFree = lvl['free'] as bool;
            final isLocked = !isFree && !SubscriptionManager.canAccessLevel(_currentPlan, label);

            return GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                if (isLocked) {
                  _openSubscriptionSheet(forQuestions: false);
                } else {
                  context.read<FieldsBloc>().add(FieldsLevelChanged(label));
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: isLocked
                      ? Colors.white.withOpacity(0.02)
                      : isSelected
                          ? color.withOpacity(0.1)
                          : Colors.white.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isLocked
                        ? Colors.white.withOpacity(0.06)
                        : isSelected
                            ? color.withOpacity(0.5)
                            : Colors.white10,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: isLocked
                          ? Colors.white.withOpacity(0.04)
                          : isSelected
                              ? color.withOpacity(0.15)
                              : Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      isLocked ? Icons.lock_rounded : lvl['icon'] as IconData,
                      color: isLocked
                          ? Colors.white24
                          : isSelected
                              ? color
                              : AppColors.textSecondary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Row(children: [
                      Text(label,
                          style: GoogleFonts.dmSans(
                              color: isLocked
                                  ? Colors.white24
                                  : isSelected
                                      ? AppColors.textPrimary
                                      : AppColors.textSecondary,
                              fontSize: 14.5,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w400)),
                      if (isFree) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.accentGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: AppColors.accentGreen.withOpacity(0.3)),
                          ),
                          child: Text('FREE',
                              style: GoogleFonts.spaceMono(
                                  color: AppColors.accentGreen,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                      if (isLocked) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.accentGold.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: AppColors.accentGold.withOpacity(0.3)),
                          ),
                          child: Text('PRO',
                              style: GoogleFonts.spaceMono(
                                  color: AppColors.accentGold,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ]),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 20, height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isLocked
                          ? Colors.transparent
                          : isSelected
                              ? color
                              : Colors.transparent,
                      border: Border.all(
                          color: isLocked
                              ? Colors.white12
                              : isSelected
                                  ? color
                                  : Colors.white24,
                          width: 1.5),
                    ),
                    child: isSelected && !isLocked
                        ? const Icon(Icons.check, color: Colors.white, size: 12)
                        : null,
                  ),
                ]),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildRoundSelector() {
    return BlocBuilder<FieldsBloc, FieldsState>(
      builder: (context, state) => GlassCard(
        child: Column(
          children: _rounds.map((round) {
            final isSelected = state.round == round['label'];
            return GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                context
                    .read<FieldsBloc>()
                    .add(FieldsRoundChanged(round['label'] as String));
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.accentBlue.withOpacity(0.1)
                      : Colors.white.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.accentBlue.withOpacity(0.5)
                        : Colors.white10,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.accentBlue.withOpacity(0.15)
                          : Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(round['icon'] as IconData,
                        color: isSelected
                            ? AppColors.accentBlue
                            : AppColors.textSecondary,
                        size: 18),
                  ),
                  const SizedBox(width: 12),
                  Text(round['label'] as String,
                      style: GoogleFonts.dmSans(
                          color: isSelected
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                          fontSize: 14.5,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w400)),
                  const Spacer(),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 20, height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? AppColors.accentBlue
                          : Colors.transparent,
                      border: Border.all(
                          color: isSelected
                              ? AppColors.accentBlue
                              : Colors.white24,
                          width: 1.5),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 12)
                        : null,
                  ),
                ]),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildQuestionCounter() {
    final maxQ = SubscriptionManager.maxQuestions(_currentPlan);
    return BlocBuilder<FieldsBloc, FieldsState>(
      builder: (context, state) {
        final atMax = state.questionCount >= maxQ;
        final atMin = state.questionCount <= FieldsState.minQuestions;
        return GlassCard(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _CounterBtn(
                    icon: Icons.remove_rounded,
                    enabled: !atMin,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      context.read<FieldsBloc>().add(
                          FieldsQuestionCountChanged(state.questionCount - 1));
                    },
                  ),
                  const SizedBox(width: 24),
                  Column(children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, anim) => ScaleTransition(
                          scale: anim,
                          child: FadeTransition(opacity: anim, child: child)),
                      child: Text(
                        '${state.questionCount}',
                        key: ValueKey(state.questionCount),
                        style: GoogleFonts.spaceMono(
                            color: AppColors.accentCyan,
                            fontSize: 40,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                    Text('questions',
                        style: GoogleFonts.dmSans(
                            color: AppColors.textSecondary, fontSize: 12)),
                  ]),
                  const SizedBox(width: 24),
                  _CounterBtn(
                    icon: Icons.add_rounded,
                    enabled: !atMax,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      if (state.questionCount >= maxQ) {
                        _openSubscriptionSheet(forQuestions: true);
                      } else {
                        context.read<FieldsBloc>().add(
                            FieldsQuestionCountChanged(state.questionCount + 1));
                      }
                    },
                  ),
                ],
              ),
              // Plan limit indicator
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ...List.generate(SubscriptionManager.eliteMaxQuestions, (i) {
                  final filled = i < state.questionCount;
                  final isLimit = i == maxQ - 1 &&
                      _currentPlan != SubscriptionPlan.elite;
                  return Container(
                    width: filled ? 8 : 6,
                    height: filled ? 8 : 6,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: filled
                          ? AppColors.accentCyan
                          : isLimit
                              ? AppColors.accentGold.withOpacity(0.4)
                              : Colors.white12,
                    ),
                  );
                }),
              ]),
              if (_currentPlan != SubscriptionPlan.elite) ...[
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _openSubscriptionSheet(forQuestions: true),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.lock_outline_rounded,
                        color: AppColors.accentGold, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      'Max $maxQ questions on ${_currentPlan.name} plan · Upgrade',
                      style: GoogleFonts.dmSans(
                          color: AppColors.accentGold,
                          fontSize: 11,
                          fontWeight: FontWeight.w600),
                    ),
                  ]),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildDurationCard() {
    return BlocBuilder<FieldsBloc, FieldsState>(
      builder: (context, state) {
        final minutes = state.durationSeconds ~/ 60;
        return GlassCard(
          accentColor: AppColors.accentGold.withOpacity(0.08),
          borderColor: AppColors.accentGold.withOpacity(0.2),
          child: Row(children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: AppColors.accentGold.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.hourglass_top_rounded,
                  color: AppColors.accentGold, size: 22),
            ),
            const SizedBox(width: 14),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Estimated Duration',
                  style: GoogleFonts.dmSans(
                      color: AppColors.textSecondary, fontSize: 12)),
              const SizedBox(height: 4),
              Text(
                '$minutes ${minutes == 1 ? 'minute' : 'minutes'}',
                style: GoogleFonts.spaceMono(
                    color: AppColors.accentGold,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ]),
            const Spacer(),
            Text('${state.questionCount}Q × 60s',
                style: GoogleFonts.spaceMono(
                    color: AppColors.accentGold.withOpacity(0.5),
                    fontSize: 11)),
          ]),
        );
      },
    );
  }

  Widget _buildInstructions() {
    return GlassCard(
      child: Column(
        children: _instructions.asMap().entries.map((entry) {
          final i = entry.key;
          final instr = entry.value;
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds: 400 + i * 80),
            curve: Curves.easeOutCubic,
            builder: (_, val, child) => Opacity(
              opacity: val,
              child: Transform.translate(
                  offset: Offset(20 * (1 - val), 0), child: child),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 30, height: 30,
                    decoration: BoxDecoration(
                      color: AppColors.accentBlue.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: AppColors.accentBlue.withOpacity(0.2)),
                    ),
                    child: Icon(instr['icon'] as IconData,
                        color: AppColors.accentBlue, size: 15),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(instr['text'] as String,
                          style: GoogleFonts.dmSans(
                              color: AppColors.textSecondary,
                              fontSize: 13.5,
                              height: 1.5)),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return BlocBuilder<FieldsBloc, FieldsState>(
      builder: (context, state) => GestureDetector(
        onTapDown: (_) => _btnCtrl.forward(),
        onTapUp: (_) async {
          await _btnCtrl.reverse();
          HapticFeedback.mediumImpact();
          if (context.mounted) {
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 500),
                pageBuilder: (_, anim, __) => FadeTransition(
                  opacity: anim,
                  child: WelcomeScreen(
                    language: widget.language,
                    totalQuestions: state.questionCount,
                    level: state.level,
                    round: state.round,
                  ),
                ),
              ),
            );
          }
        },
        onTapCancel: () => _btnCtrl.reverse(),
        child: ScaleTransition(
          scale: _btnScale,
          child: Container(
            width: double.infinity, height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: AppColors.mainGradient,
              boxShadow: [
                BoxShadow(
                    color: AppColors.accentBlue.withOpacity(0.4),
                    blurRadius: 24,
                    spreadRadius: 2,
                    offset: const Offset(0, 8)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.play_arrow_rounded,
                    color: Colors.white, size: 26),
                const SizedBox(width: 10),
                Text('Start Interview',
                    style: GoogleFonts.dmSans(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── COUNTER BUTTON ───────────────────────────────────────────────────────────
class _CounterBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;
  const _CounterBtn(
      {required this.icon, required this.onTap, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48, height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: enabled
              ? const LinearGradient(
                  colors: [Color(0xFF112844), Color(0xFF0F2340)])
              : null,
          color: enabled ? null : Colors.white.withOpacity(0.04),
          border: Border.all(
              color: enabled
                  ? AppColors.accentBlue.withOpacity(0.4)
                  : Colors.white10),
          boxShadow: enabled
              ? [
                  BoxShadow(
                      color: AppColors.accentBlue.withOpacity(0.2),
                      blurRadius: 12,
                      spreadRadius: 1)
                ]
              : [],
        ),
        child: Icon(icon,
            color: enabled ? Colors.white : Colors.white24, size: 22),
      ),
    );
  }
}