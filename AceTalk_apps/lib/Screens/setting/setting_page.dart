import 'dart:math';
import 'dart:ui';

import 'package:ai_interview_app/Screens/setting/AI_setting.dart';
import 'package:ai_interview_app/Screens/setting/account_screen.dart';
import 'package:ai_interview_app/Screens/setting/animate_backgrd.dart';
import 'package:ai_interview_app/Screens/setting/color_palet.dart';
import 'package:ai_interview_app/Screens/setting/inforItem.dart';
import 'package:ai_interview_app/Screens/setting/interview_pref.dart';
import 'package:ai_interview_app/Screens/setting/navigator_helper.dart';
import 'package:ai_interview_app/Screens/setting/resuable_widget.dart';
import 'package:ai_interview_app/Screens/setting/toggle_pref.dart';
import 'package:ai_interview_app/Screens/startScreens/service/Authgate.dart';
import 'package:ai_interview_app/payment/subscription_history.dart';
import 'package:ai_interview_app/payment/subscription_plan.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage>
    with SingleTickerProviderStateMixin {
  User? get _user => FirebaseAuth.instance.currentUser;
  late AnimationController _bgCtrl;
  late Animation<double> _bgAnim;

  SubscriptionPlan _plan = SubscriptionPlan.free;
  bool _loadingPlan = true;

  final _toggles = [
    TogglePref(
      'Push Notifications',
      'pref_push_notif',
      'Interview reminders & updates',
      true,
    ),
    TogglePref(
      'Email Digest',
      'pref_email_digest',
      'Weekly progress summary',
      false,
    ),
    TogglePref('Sound Effects', 'pref_sound_fx', 'UI audio feedback', true),
    TogglePref(
      'Haptic Feedback',
      'pref_haptic',
      'Vibration on interactions',
      true,
    ),
  ];

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
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final plan = await SubscriptionManager.getCurrentPlan();
    if (!mounted) return;
    setState(() {
      _plan = plan;
      _loadingPlan = false;
      for (final t in _toggles) t.value = prefs.getBool(t.prefKey) ?? t.value;
    });
  }

  Future<void> _saveToggle(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    super.dispose();
  }

  // ── Plan badge ─────────────────────────────────────────────────────────────
  Widget _planBadge() {
    Color c;
    String label;
    switch (_plan) {
      case SubscriptionPlan.pro:
        c = AppColors2.gold;
        label = 'PRO';
        break;
      case SubscriptionPlan.elite:
        c = AppColors2.cyan;
        label = 'ELITE';
        break;
      case SubscriptionPlan.free:
        c = AppColors2.ts;
        label = 'FREE';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: c.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: c.withOpacity(0.35)),
      ),
      child: Text(
        label,
        style: GoogleFonts.spaceMono(
          color: c,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ── Profile card ────────────────────────────────────────────────────────────
  Widget _profileCard(String name, String email, String initials) {
    Color planColor;
    String planLabel;
    switch (_plan) {
      case SubscriptionPlan.pro:
        planColor = AppColors2.gold;
        planLabel = 'Pro Plan';
        break;
      case SubscriptionPlan.elite:
        planColor = AppColors2.cyan;
        planLabel = 'Elite Plan';
        break;
      case SubscriptionPlan.free:
        planColor = AppColors2.ts;
        planLabel = 'Free Plan';
        break;
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors2.blue.withOpacity(0.2),
                AppColors2.cyan.withOpacity(0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors2.cyan.withOpacity(0.25),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors2.blue.withOpacity(0.14),
                blurRadius: 30,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppColors2.blue, AppColors2.cyan],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors2.cyan.withOpacity(0.4),
                      blurRadius: 18,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    initials.isEmpty ? 'AC' : initials,
                    style: GoogleFonts.spaceMono(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
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
                      name,
                      style: GoogleFonts.dmSans(
                        color: AppColors2.tp,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      email,
                      style: GoogleFonts.dmSans(
                        color: AppColors2.ts,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Row(
                      children: [
                        AppTag(planLabel, planColor),
                        const SizedBox(width: 6),
                        const AppTag('14 Sessions', AppColors2.cyan),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => AppNav.push(context, const AccountScreen()),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors2.s2,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: const Icon(
                    Icons.edit_rounded,
                    color: AppColors2.ts,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Subscription banner ─────────────────────────────────────────────────────
  Widget _subscriptionBanner() {
    if (_loadingPlan || _plan == SubscriptionPlan.elite)
      return const SizedBox.shrink();
    final color = _plan == SubscriptionPlan.pro
        ? AppColors2.gold
        : AppColors2.cyan;
    final title = _plan == SubscriptionPlan.pro
        ? 'Upgrade to Elite'
        : 'Upgrade to Pro';
    final sub = _plan == SubscriptionPlan.pro
        ? 'Get 20 questions & company-specific banks'
        : 'Unlock all difficulty levels & more questions';

    return GestureDetector(
      onTap: () => AppNav.push(context, SubscriptionHistoryScreen(plan: _plan)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withOpacity(0.35)),
        ),
        child: Row(
          children: [
            Icon(
              _plan == SubscriptionPlan.pro
                  ? Icons.diamond_rounded
                  : Icons.workspace_premium_rounded,
              color: color,
              size: 24,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.dmSans(
                      color: AppColors2.tp,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    sub,
                    style: GoogleFonts.dmSans(
                      color: AppColors2.ts,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded, color: color, size: 22),
          ],
        ),
      ),
    );
  }

  // ── Toggles card ────────────────────────────────────────────────────────────
  Widget _togglesCard() {
    return GlassCard(
      child: Column(
        children: List.generate(_toggles.length, (i) {
          final t = _toggles[i];
          final isLast = i == _toggles.length - 1;
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.label,
                          style: GoogleFonts.dmSans(
                            color: AppColors2.tp,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          t.subtitle,
                          style: GoogleFonts.dmSans(
                            color: AppColors2.ts,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  AnimToggle(
                    value: t.value,
                    onTap: () {
                      setState(() => t.value = !t.value);
                      _saveToggle(t.prefKey, t.value);
                    },
                  ),
                ],
              ),
              if (!isLast) ...[
                const SizedBox(height: 14),
                Divider(color: Colors.white.withOpacity(0.06), height: 1),
                const SizedBox(height: 14),
              ],
            ],
          );
        }),
      ),
    );
  }

  // ── Logout ──────────────────────────────────────────────────────────────────
  Widget _logoutButton() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        _showLogoutConfirm();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors2.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors2.red.withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: AppColors2.red.withOpacity(0.1),
              blurRadius: 18,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded, color: AppColors2.red, size: 20),
            const SizedBox(width: 10),
            Text(
              'Log Out',
              style: GoogleFonts.dmSans(
                color: AppColors2.red,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _deleteAccount() {
    return Center(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.heavyImpact();
          _showInfoDialog(
            'Delete Account',
            'This will permanently delete all your data, sessions, and progress. This action cannot be undone. '
                'Contact support@acetalk.com to proceed with account deletion.',
            AppColors2.red,
            isDanger: true,
          );
        },
        child: Text(
          'Delete Account',
          style: GoogleFonts.dmSans(
            color: AppColors2.red.withOpacity(0.5),
            fontSize: 12,
            decoration: TextDecoration.underline,
            decorationColor: AppColors2.red.withOpacity(0.4),
          ),
        ),
      ),
    );
  }

  // ── Dialogs ─────────────────────────────────────────────────────────────────
  void _showLogoutConfirm() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(
                color: AppColors2.s1,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: AppColors2.red.withOpacity(0.35)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors2.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors2.red.withOpacity(0.35),
                      ),
                    ),
                    child: const Icon(
                      Icons.logout_rounded,
                      color: AppColors2.red,
                      size: 34,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Log Out?',
                    style: GoogleFonts.dmSans(
                      color: AppColors2.tp,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "You'll need to sign in again to access your sessions and progress.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSans(
                      color: AppColors2.ts,
                      fontSize: 13,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors2.ts,
                            side: const BorderSide(color: Colors.white12),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            await FirebaseAuth.instance.signOut();

                            if (!mounted) return;

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AuthGate(),
                              ),
                              (route) => false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors2.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                          child: Text(
                            'Log Out',
                            style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.bold,
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
        ),
      ),
    );
  }

  void _showInfoDialog(
    String title,
    String body,
    Color color, {
    bool isDanger = false,
  }) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors2.s1,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: color.withOpacity(0.32)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          isDanger ? Icons.warning_rounded : Icons.info_rounded,
                          color: color,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          title,
                          style: GoogleFonts.dmSans(
                            color: AppColors2.tp,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(color: Colors.white.withOpacity(0.07)),
                  const SizedBox(height: 12),
                  Text(
                    body,
                    style: GoogleFonts.dmSans(
                      color: AppColors2.ts,
                      fontSize: 13.5,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color.withOpacity(0.16),
                        foregroundColor: color,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                          side: BorderSide(color: color.withOpacity(0.4)),
                        ),
                      ),
                      child: Text(
                        'Got it',
                        style: GoogleFonts.dmSans(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet({
    required String title,
    required IconData icon,
    required Color color,
    required List<InfoItem> items,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
            decoration: const BoxDecoration(
              color: AppColors2.s1,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: color.withOpacity(0.35)),
                      ),
                      child: Icon(icon, color: color, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      title,
                      style: GoogleFonts.dmSans(
                        color: AppColors2.tp,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Divider(color: Colors.white.withOpacity(0.07)),
                const SizedBox(height: 14),
                ...items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.09),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(item.icon, color: color, size: 16),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: GoogleFonts.dmSans(
                                  color: AppColors2.tp,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              if (item.subtitle.isNotEmpty) ...[
                                const SizedBox(height: 3),
                                Text(
                                  item.subtitle,
                                  style: GoogleFonts.dmSans(
                                    color: AppColors2.ts,
                                    fontSize: 12,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Build ───────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final email = _user?.email ?? 'guest@acetalk.com';
    final name = _user?.displayName ?? 'Interview Candidate';
    final initials = name
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .take(2)
        .join()
        .toUpperCase();

    return Scaffold(
      backgroundColor: AppColors2.bg,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _bgAnim,
            builder: (_, __) => CustomPaint(
              painter: BgPainter(_bgAnim.value),
              child: const SizedBox.expand(),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // App bar
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
                        'Settings',
                        style: GoogleFonts.spaceMono(
                          fontSize: 18,
                          color: AppColors2.tp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors2.cyan.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors2.cyan.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          'v1.0',
                          style: GoogleFonts.spaceMono(
                            color: AppColors2.cyan,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _profileCard(name, email, initials),
                        const SizedBox(height: 16),
                        _subscriptionBanner(),
                        const SizedBox(height: 28),
                        const SectionLabel('General'),
                        const SizedBox(height: 12),
                        NavTile(
                          icon: Icons.person_rounded,
                          color: AppColors2.cyan,
                          title: 'Account',
                          subtitle: 'Profile, resume, password',
                          onTap: () =>
                              AppNav.push(context, const AccountScreen()),
                        ),
                        const SizedBox(height: 10),
                        NavTile(
                          icon: Icons.tune_rounded,
                          color: AppColors2.blue,
                          title: 'Interview Preferences',
                          subtitle: 'Type, difficulty, time limit',
                          onTap: () =>
                              AppNav.push(context, const InterviewPrefScreen()),
                        ),
                        const SizedBox(height: 10),
                        NavTile(
                          icon: Icons.psychology_alt_rounded,
                          color: AppColors2.purple,
                          title: 'AI Settings',
                          subtitle: 'Voice, feedback style, scoring',
                          onTap: () =>
                              AppNav.push(context, const AiSettingsScreen()),
                        ),
                        const SizedBox(height: 10),
                        NavTile(
                          icon: Icons.receipt_long_rounded,
                          color: AppColors2.gold,
                          title: 'Subscription & Billing',
                          subtitle: 'Plan, payment history, upgrade',
                          trailing: _planBadge(),
                          onTap: () => AppNav.push(
                            context,
                            SubscriptionHistoryScreen(plan: _plan),
                          ),
                        ),
                        const SizedBox(height: 28),
                        const SectionLabel('App Preferences'),
                        const SizedBox(height: 12),
                        _togglesCard(),
                        const SizedBox(height: 28),
                        const SectionLabel('Support'),
                        const SizedBox(height: 12),
                        NavTile(
                          icon: Icons.help_outline_rounded,
                          color: AppColors2.cyan,
                          title: 'Help & Support',
                          subtitle: 'FAQs, email, bug reports',
                          onTap: () => _showBottomSheet(
                            title: 'Help & Support',
                            icon: Icons.help_outline_rounded,
                            color: AppColors2.cyan,
                            items: const [
                              InfoItem(
                                Icons.quiz_rounded,
                                'FAQs & Guides',
                                'Browse common questions and tutorials',
                              ),
                              InfoItem(
                                Icons.mail_rounded,
                                'Email Support',
                                'support@acetalk.com · replies within 24h',
                              ),
                              InfoItem(
                                Icons.bug_report_rounded,
                                'Report a Bug',
                                'Help us squash issues faster',
                              ),
                              InfoItem(
                                Icons.lightbulb_rounded,
                                'Feature Requests',
                                'Suggest what to build next',
                              ),
                              InfoItem(
                                Icons.manage_accounts_rounded,
                                'Account Recovery',
                                'Lost access? We can help',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        NavTile(
                          icon: Icons.info_outline_rounded,
                          color: AppColors2.blue,
                          title: 'About AceTalk',
                          subtitle: 'Version, licenses, credits',
                          onTap: () => _showBottomSheet(
                            title: 'About AceTalk',
                            icon: Icons.info_outline_rounded,
                            color: AppColors2.blue,
                            items: const [
                              InfoItem(
                                Icons.rocket_launch_rounded,
                                'AceTalk v1.0',
                                'AI-powered interview coaching platform',
                              ),
                              InfoItem(
                                Icons.psychology_rounded,
                                'Personalized Mocks',
                                'Tailored to your experience & role',
                              ),
                              InfoItem(
                                Icons.speed_rounded,
                                'Real-time Scoring',
                                'Instant AI-based keyword analysis',
                              ),
                              InfoItem(
                                Icons.description_rounded,
                                'Resume Intelligence',
                                'Questions from your own resume',
                              ),
                              InfoItem(
                                Icons.copyright_rounded,
                                '© 2026 AceTalk',
                                'All rights reserved',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        NavTile(
                          icon: Icons.privacy_tip_outlined,
                          color: AppColors2.gold,
                          title: 'Privacy Policy',
                          subtitle: 'How we handle your data',
                          onTap: () => _showInfoDialog(
                            'Privacy Policy',
                            'We do not sell your data. Your interview sessions are encrypted and stored securely. '
                                'They are used only to personalise your results. You can request full data deletion at any time by contacting support.',
                            AppColors2.gold,
                          ),
                        ),
                        const SizedBox(height: 28),
                        _logoutButton(),
                        const SizedBox(height: 14),
                        _deleteAccount(),
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

// ── Login placeholder (post-logout destination) ──────────────────────────────
class _LoginPlaceholder extends StatelessWidget {
  const _LoginPlaceholder();
  @override
  Widget build(BuildContext context) => const Scaffold(
    backgroundColor: AppColors2.bg,
    body: Center(
      child: Text('Login Screen', style: TextStyle(color: AppColors2.tp)),
    ),
  );
}
