

// lib/features/home/presentation/pages/home_screen.dart
import 'dart:math';
import 'dart:ui';

import 'package:ai_interview_app/Screens/block/historybloc.dart';
import 'package:ai_interview_app/Screens/fieldscreen/scorescreen.dart';
import 'package:ai_interview_app/Screens/history/historymodel.dart';
import 'package:ai_interview_app/Screens/mainScreen/view/language_screen.dart';
import 'package:ai_interview_app/Screens/setting/setting_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';



// ─── COLOUR ALIASES (matches original _C palette exactly) ────────────────────
class _C {
  static const bg          = Color.fromARGB(255,   3,  10,  20);
  static const s1          = Color.fromARGB(255,   8,  21,  37);
  static const s2          = Color.fromARGB(255,  13,  32,  64);
  static const cyan        = Color.fromARGB(255,   2, 225, 250);
  static const blue        = Color.fromARGB(255,  21, 101, 192);
  static const blueBright  = Color.fromARGB(255,  41, 121, 255);
  static const gold        = Color.fromARGB(255, 255, 215,  64);
  static const green       = Color.fromARGB(255,   0, 230, 118);
  static const red         = Color.fromARGB(255, 255,  61,  87);
  static const tp          = Color.fromARGB(255, 232, 244, 253);
  static const ts          = Color.fromARGB(255,  91, 143, 168);
}

// ─── HOME SCREEN ─────────────────────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _bgCtrl;
  late AnimationController _entryCtrl;
  late AnimationController _pulseCtrl;

  late Animation<double> _bgAnim;
  late Animation<double> _fadeAnim;
  late Animation<Offset>  _slideAnim;
  late Animation<double> _pulseAnim;

  int _carouselIndex = 0;

  @override
  void initState() {
    super.initState();

    _bgCtrl = AnimationController(
      vsync: this, duration: const Duration(seconds: 12))..repeat();

    _entryCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1100))..forward();

    _pulseCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1800))
      ..repeat(reverse: true);

    _bgAnim = Tween<double>(begin: 0, end: 2 * pi)
        .animate(CurvedAnimation(parent: _bgCtrl, curve: Curves.linear));

    _fadeAnim = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.25), end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic));

    _pulseAnim = Tween<double>(begin: 0.92, end: 1.0)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    // Load history so stats are available
    context.read<HistoryBloc>().add(const HistoryLoadRequested());
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _entryCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  // ─── BUILD ───────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.bg,
      extendBodyBehindAppBar: true,
      body: Stack(children: [
        // constellation background
        AnimatedBuilder(
          animation: _bgAnim,
          builder: (_, __) => CustomPaint(
            painter: _ConstellationPainter(_bgAnim.value),
            child: const SizedBox.expand(),
          ),
        ),

        SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SlideTransition(position: _slideAnim, child: _buildTopBar()),
                  const SizedBox(height: 26),
                  SlideTransition(position: _slideAnim, child: _buildHeroCard()),
                  const SizedBox(height: 22),
                  _buildSectionLabel('Quick Start'),
                  const SizedBox(height: 12),
                  _buildCarousel(),
                  const SizedBox(height: 8),
                  _buildDots(),
                  const SizedBox(height: 26),
                  _buildSectionLabel('Your Stats'),
                  const SizedBox(height: 12),
                  _buildStatsRow(),       // ← dynamic
                  const SizedBox(height: 26),
                  _buildSectionLabel('Last Session'),
                  const SizedBox(height: 12),
                  _buildLastSession(),    // ← dynamic
                  const SizedBox(height: 26),
                  _buildSectionLabel('Practice Tracks'),
                  const SizedBox(height: 12),
                  _buildPracticeTrack(
                    icon: Icons.psychology_alt_rounded,
                    color: _C.cyan,
                    title: 'Behavioural & HR',
                    desc: 'STAR method, communication, teamwork',
                    languageKey: 'hr',
                  ),
                  const SizedBox(height: 10),
                  _buildPracticeTrack(
                    icon: Icons.terminal_rounded,
                    color: _C.blueBright,
                    title: 'Technical Deep-Dive',
                    desc: 'DSA, system design, language-specific',
                    languageKey: 'technical',
                  ),
                  const SizedBox(height: 10),
                  _buildPracticeTrack(
                    icon: Icons.trending_up_rounded,
                    color: _C.gold,
                    title: 'Case Studies',
                    desc: 'Problem-solving, frameworks, analytics',
                    languageKey: 'case',
                  ),
                  const SizedBox(height: 36),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  // ─── TOP BAR ─────────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Row(children: [
      Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: _C.s1,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _C.cyan.withOpacity(0.3)),
          boxShadow: [BoxShadow(
              color: _C.cyan.withOpacity(0.25), blurRadius: 20, spreadRadius: 2)],
        ),
        child: Image.asset('assets/images/logo.png', height: 36, width: 36,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.psychology_alt_rounded, color: _C.cyan, size: 36)),
      ),
      const SizedBox(width: 13),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('AceTalk',
            style: GoogleFonts.spaceMono(
                fontSize: 22, color: _C.tp,
                fontWeight: FontWeight.w700, letterSpacing: 1.5)),
        Text('AI INTERVIEW COACH',
            style: GoogleFonts.spaceMono(
                fontSize: 9, color: _C.cyan,
                fontWeight: FontWeight.w500, letterSpacing: 2.5)),
      ]),
      const Spacer(),
      // notification dot
      Stack(children: [
        _iconBtn(Icons.notifications_none_rounded, onTap: () {}),
        Positioned(
          right: 8, top: 8,
          child: Container(
            width: 8, height: 8,
            decoration: BoxDecoration(
              color: _C.red, shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: _C.red.withOpacity(0.6), blurRadius: 6)],
            ),
          ),
        ),
      ]),
      const SizedBox(width: 8),
      _iconBtn(Icons.settings_outlined, onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return SettingPage();
        }));
        // Navigate to settings — keep your existing SettingPage route here
      }),
    ]);
  }

  Widget _iconBtn(IconData icon, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: () { HapticFeedback.lightImpact(); onTap(); },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _C.s1,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Icon(icon, color: _C.ts, size: 21),
      ),
    );
  }

  // ─── HERO CARD ───────────────────────────────────────────────────────────
  Widget _buildHeroCard() {
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (_, child) =>
          Transform.scale(scale: _pulseAnim.value, child: child),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                _C.blueBright.withOpacity(0.22),
                _C.cyan.withOpacity(0.08),
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: _C.cyan.withOpacity(0.25), width: 1.5),
              boxShadow: [BoxShadow(
                  color: _C.blueBright.withOpacity(0.15),
                  blurRadius: 30, spreadRadius: 2)],
            ),
            child: Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // AI Ready chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _C.green.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _C.green.withOpacity(0.4)),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Container(
                          width: 6, height: 6,
                          decoration: BoxDecoration(
                            color: _C.green, shape: BoxShape.circle,
                            boxShadow: [BoxShadow(
                                color: _C.green.withOpacity(0.7), blurRadius: 6)],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text('AI Ready',
                            style: GoogleFonts.dmSans(
                                color: _C.green, fontSize: 11,
                                fontWeight: FontWeight.w600)),
                      ]),
                    ),
                    const SizedBox(height: 12),
                    Text('Ready to ace\nyour next\ninterview?',
                        style: GoogleFonts.dmSans(
                            fontSize: 22, color: _C.tp,
                            fontWeight: FontWeight.w800, height: 1.25)),
                    const SizedBox(height: 10),
                    Text(
                      'Practice with AI · Get instant feedback · Track progress',
                      style: GoogleFonts.dmSans(
                          fontSize: 12, color: _C.ts, height: 1.5),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        // Navigate to language select (tab 1 in shell)
                        // Use the bottom nav index setter via callback if available,
                        // or push directly:
                        Navigator.push(context, MaterialPageRoute(
                            builder: (_) => const LanguageScreen()));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 11),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [_C.blueBright, _C.cyan]),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [BoxShadow(
                              color: _C.blueBright.withOpacity(0.4),
                              blurRadius: 16, spreadRadius: 1)],
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Text('Start Session',
                              style: GoogleFonts.dmSans(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700, fontSize: 13)),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded,
                              color: Colors.white, size: 16),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
              Lottie.asset('assets/lottie_ani/home.json',
                  height: 145, width: 145,
                  errorBuilder: (_, __, ___) => const Icon(
                      Icons.mic_rounded, color: _C.cyan, size: 80)),
            ]),
          ),
        ),
      ),
    );
  }

  // ─── SECTION LABEL ───────────────────────────────────────────────────────
  Widget _buildSectionLabel(String text) {
    return Row(children: [
      Container(
        width: 3, height: 16,
        decoration: BoxDecoration(
          color: _C.cyan, borderRadius: BorderRadius.circular(2),
          boxShadow: [BoxShadow(color: _C.cyan.withOpacity(0.5), blurRadius: 8)],
        ),
      ),
      const SizedBox(width: 9),
      Text(text.toUpperCase(),
          style: GoogleFonts.spaceMono(
              fontSize: 11, color: _C.ts,
              fontWeight: FontWeight.w700, letterSpacing: 2)),
    ]);
  }

  // ─── CAROUSEL ────────────────────────────────────────────────────────────
  Widget _buildCarousel() {
    final cards = [
      _CarouselItem(
        title: 'HR Mock Interview',
        subtitle: 'Practice real HR questions',
        duration: '10–15 min',
        color: _C.cyan,
        lottie: 'assets/lottie_ani/interview.json',
      ),
      _CarouselItem(
        title: 'Technical Interview',
        subtitle: 'Flutter, Java, Python & more',
        duration: '15–20 min',
        color: _C.blueBright,
        lottie: 'assets/lottie_ani/Developer.json',
      ),
      _CarouselItem(
        title: 'AI Feedback Report',
        subtitle: 'Score, tips & improvement',
        duration: '5 min review',
        color: _C.gold,
        lottie: 'assets/lottie_ani/scroe.json',
      ),
    ];

    return CarouselSlider(
      options: CarouselOptions(
        height: 160,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
        enlargeCenterPage: true,
        enlargeFactor: 0.15,
        viewportFraction: 0.92,
        onPageChanged: (i, _) => setState(() => _carouselIndex = i),
      ),
      items: cards.map(_buildCarouselCard).toList(),
    );
  }

  Widget _buildCarouselCard(_CarouselItem item) {
    return GestureDetector(
      onTap: () => HapticFeedback.selectionClick(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
              colors: [_C.s1, _C.s2],
              begin: Alignment.topLeft, end: Alignment.bottomRight),
          border: Border.all(color: item.color.withOpacity(0.3), width: 1.5),
          boxShadow: [BoxShadow(
              color: item.color.withOpacity(0.15), blurRadius: 20, spreadRadius: 1)],
        ),
        child: Stack(children: [
          Positioned(
            right: 0, top: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(22),
                  bottomLeft: Radius.circular(60)),
              child: Container(
                  width: 90, height: 90,
                  color: item.color.withOpacity(0.07)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 3),
                      decoration: BoxDecoration(
                        color: item.color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: item.color.withOpacity(0.35)),
                      ),
                      child: Text(item.duration,
                          style: GoogleFonts.spaceMono(
                              color: item.color, fontSize: 9,
                              fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                    ),
                    const SizedBox(height: 8),
                    Text(item.title,
                        style: GoogleFonts.dmSans(
                            fontSize: 16, color: _C.tp,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 3),
                    Text(item.subtitle,
                        style: GoogleFonts.dmSans(
                            color: _C.ts, fontSize: 12, height: 1.4)),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: item.color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: item.color.withOpacity(0.4)),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Text('Begin',
                            style: GoogleFonts.dmSans(
                                color: item.color, fontSize: 12,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(width: 5),
                        Icon(Icons.arrow_forward_rounded,
                            color: item.color, size: 14),
                      ]),
                    ),
                  ],
                ),
              ),
              Lottie.asset(item.lottie, height: 100, width: 100,
                  errorBuilder: (_, __, ___) =>
                      Icon(Icons.mic_rounded, color: item.color, size: 60)),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final active = i == _carouselIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: active ? _C.cyan : _C.ts.withOpacity(0.4),
            borderRadius: BorderRadius.circular(3),
            boxShadow: active
                ? [BoxShadow(color: _C.cyan.withOpacity(0.5), blurRadius: 8)]
                : [],
          ),
        );
      }),
    );
  }

  // ─── DYNAMIC STATS ROW ───────────────────────────────────────────────────
  Widget _buildStatsRow() {
    return BlocBuilder<HistoryBloc, HistoryState>(
      builder: (context, state) {
        // Compute from real data
        int totalSessions = 0;
        double avgScore    = 0;
        int totalSeconds   = 0;

        if (state is HistoryLoaded) {
          final sessions = state.sessions;
          totalSessions = sessions.length;
          avgScore = sessions.isEmpty
              ? 0
              : sessions.map((s) => s.scorePercent).reduce((a, b) => a + b) /
                  sessions.length;
          totalSeconds = sessions.fold(
              0,
              (sum, s) =>
                  sum + s.results.fold(0, (rs, r) => rs + r.timeTaken));
        }

        final hours   = totalSeconds ~/ 3600;
        final minutes = (totalSeconds % 3600) ~/ 60;
        final timeLabel = hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';

        return Row(children: [
          _MiniStat(
            value: '$totalSessions',
            label: 'Sessions',
            color: _C.cyan,
          ),
          const SizedBox(width: 10),
          _MiniStat(
            value: totalSessions == 0 ? '—' : '${avgScore.toInt()}%',
            label: 'Avg Score',
            color: _C.green,
          ),
          const SizedBox(width: 10),
          _MiniStat(
            value: totalSeconds == 0 ? '0m' : timeLabel,
            label: 'Practice',
            color: _C.gold,
          ),
        ]);
      },
    );
  }

  // ─── DYNAMIC LAST SESSION ────────────────────────────────────────────────
  Widget _buildLastSession() {
    return BlocBuilder<HistoryBloc, HistoryState>(
      builder: (context, state) {
        // Empty / loading placeholder
        if (state is HistoryEmpty || state is HistoryInitial) {
          return _buildNoSession();
        }
        if (state is HistoryLoading) {
          return _buildSessionSkeleton();
        }
        if (state is HistoryLoaded) {
          final last = state.sessions.first; // already ordered DESC
          return _buildSessionCard(last);
        }
        return _buildNoSession();
      },
    );
  }

  Widget _buildNoSession() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _C.s1.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _C.ts.withOpacity(0.15)),
          ),
          child: Row(children: [
            Container(
              width: 62, height: 62,
              decoration: BoxDecoration(
                color: _C.s2,
                shape: BoxShape.circle,
                border: Border.all(color: _C.ts.withOpacity(0.2)),
              ),
              child: const Icon(Icons.history_rounded, color: _C.ts, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('No sessions yet',
                      style: GoogleFonts.dmSans(
                          color: _C.tp, fontSize: 15,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text('Complete an interview to see your results',
                      style: GoogleFonts.dmSans(color: _C.ts, fontSize: 12)),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(
                            builder: (_) => const LanguageScreen())),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Text('Start now',
                          style: GoogleFonts.dmSans(
                              color: _C.cyan, fontSize: 12,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward_rounded,
                          color: _C.cyan, size: 13),
                    ]),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildSessionSkeleton() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: _C.s1.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: SizedBox(
            width: 24, height: 24,
            child: CircularProgressIndicator(
                color: _C.cyan, strokeWidth: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildSessionCard(SessionEntity last) {
    // Compute score colour
    final scoreColor = last.scorePercent >= 80
        ? _C.green
        : last.scorePercent >= 60
            ? _C.gold
            : _C.red;

    // Human-readable language name
    final langName = last.language
        .split('-')
        .map((w) => w.isEmpty ? '' : w[0].toUpperCase() + w.substring(1))
        .join(' ');

    // Total time for this session
    final totalSecs =
        last.results.fold(0, (sum, r) => sum + r.timeTaken);
    final mins = (totalSecs ~/ 60).clamp(1, 999);

    // Date
    final dateStr =
        DateFormat('dd MMM yyyy').format(last.completedAt);

    // Skipped (no answer)
    final skipped =
        last.results.where((r) => r.userAnswer.contains('timed out') || r.userAnswer.isEmpty).length;

    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ScoreScreen(session: last))),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _C.s1.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: scoreColor.withOpacity(0.22)),
            ),
            child: Row(children: [
              // score ring
              SizedBox(
                width: 62, height: 62,
                child: Stack(alignment: Alignment.center, children: [
                  CircularProgressIndicator(
                    value: last.scorePercent / 100,
                    strokeWidth: 5,
                    backgroundColor: _C.s2,
                    valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                    strokeCap: StrokeCap.round,
                  ),
                  Text(
                    '${last.scorePercent.toInt()}',
                    style: GoogleFonts.spaceMono(
                        color: scoreColor, fontSize: 15,
                        fontWeight: FontWeight.w900),
                  ),
                ]),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Expanded(
                        child: Text(langName,
                            style: GoogleFonts.dmSans(
                                color: _C.tp, fontSize: 15,
                                fontWeight: FontWeight.w700)),
                      ),
                      Text(dateStr,
                          style: GoogleFonts.dmSans(
                              color: _C.ts, fontSize: 10.5)),
                    ]),
                    const SizedBox(height: 3),
                    Text('${last.level}  •  ${last.round}',
                        style: GoogleFonts.dmSans(
                            color: _C.ts, fontSize: 12)),
                    const SizedBox(height: 8),
                    Row(children: [
                      _tag('${last.totalQuestions} Q\'s', _C.cyan),
                      const SizedBox(width: 6),
                      _tag('$mins min', _C.gold),
                      if (skipped > 0) ...[
                        const SizedBox(width: 6),
                        _tag('$skipped skipped', _C.red),
                      ],
                    ]),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.chevron_right_rounded, color: _C.ts, size: 22),
            ]),
          ),
        ),
      ),
    );
  }

  // ─── DYNAMIC PRACTICE TRACKS ─────────────────────────────────────────────
  /// Computes progress as avg-score of sessions whose language contains
  /// [languageKey] (case-insensitive). Falls back to 0.
  Widget _buildPracticeTrack({
    required IconData icon,
    required Color color,
    required String title,
    required String desc,
    required String languageKey,
  }) {
    return BlocBuilder<HistoryBloc, HistoryState>(
      builder: (context, state) {
        double progress = 0.0;

        if (state is HistoryLoaded) {
          final relevant = state.sessions
              .where((s) =>
                  s.language.toLowerCase().contains(languageKey) ||
                  s.round.toLowerCase().contains(languageKey))
              .toList();
          if (relevant.isNotEmpty) {
            progress = relevant
                    .map((s) => s.scorePercent)
                    .reduce((a, b) => a + b) /
                relevant.length /
                100;
          }
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _C.s1,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(title,
                        style: GoogleFonts.dmSans(
                            color: _C.tp, fontSize: 13.5,
                            fontWeight: FontWeight.w700)),
                    const Spacer(),
                    Text(
                      progress == 0
                          ? 'No data'
                          : '${(progress * 100).toInt()}%',
                      style: GoogleFonts.spaceMono(
                          color: color, fontSize: 11,
                          fontWeight: FontWeight.bold),
                    ),
                  ]),
                  const SizedBox(height: 4),
                  Text(desc,
                      style: GoogleFonts.dmSans(
                          color: _C.ts, fontSize: 11.5)),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: _C.s2,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 4,
                    ),
                  ),
                ],
              ),
            ),
          ]),
        );
      },
    );
  }
}

// ─── MINI STAT CARD ──────────────────────────────────────────────────────────
class _MiniStat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _MiniStat(
      {required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: _C.s1,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.25)),
          boxShadow: [BoxShadow(
              color: color.withOpacity(0.08), blurRadius: 12, spreadRadius: 1)],
        ),
        child: Column(children: [
          Text(value,
              style: GoogleFonts.spaceMono(
                  color: color, fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(label,
              style: GoogleFonts.dmSans(
                  color: _C.ts, fontSize: 11, fontWeight: FontWeight.w500)),
        ]),
      ),
    );
  }
}

// ─── TAG HELPER ──────────────────────────────────────────────────────────────
Widget _tag(String text, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(text,
        style: GoogleFonts.dmSans(
            color: color, fontSize: 10, fontWeight: FontWeight.w600)),
  );
}

// ─── CAROUSEL ITEM MODEL ─────────────────────────────────────────────────────
class _CarouselItem {
  final String title, subtitle, duration, lottie;
  final Color color;
  const _CarouselItem({
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.color,
    required this.lottie,
  });
}

// ─── CONSTELLATION BACKGROUND PAINTER ───────────────────────────────────────
class _ConstellationPainter extends CustomPainter {
  final double t;
  _ConstellationPainter(this.t);

  static final _stars = List.generate(
      60,
      (i) => [
            (i * 137.5) % 1.0,
            (i * 97.3) % 1.0,
            (i % 3) * 0.5 + 0.5,
          ]);

  @override
  void paint(Canvas canvas, Size size) {
    // base gradient
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF030A14), Color(0xFF05101E), Color(0xFF030A14)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    // animated cyan orb
    final cx  = size.width  * 0.5 + cos(t) * size.width * 0.3;
    final cy  = size.height * 0.25 + sin(t * 0.7) * size.height * 0.1;
    canvas.drawCircle(
      Offset(cx, cy), size.width * 0.55,
      Paint()
        ..shader = RadialGradient(colors: [
          const Color(0xFF2979FF).withOpacity(0.13),
          Colors.transparent,
        ], radius: 0.6)
            .createShader(Rect.fromCircle(
                center: Offset(cx, cy), radius: size.width * 0.55)),
    );

    // second orb
    final cx2 = size.width  * 0.8 + cos(t + pi) * size.width  * 0.15;
    final cy2 = size.height * 0.75 + sin(t * 0.5 + pi) * size.height * 0.06;
    canvas.drawCircle(
      Offset(cx2, cy2), size.width * 0.4,
      Paint()
        ..shader = RadialGradient(colors: [
          const Color(0xFF00E5FF).withOpacity(0.07),
          Colors.transparent,
        ], radius: 0.7)
            .createShader(Rect.fromCircle(
                center: Offset(cx2, cy2), radius: size.width * 0.4)),
    );

    // flickering stars
    for (var s in _stars) {
      final x       = s[0] * size.width;
      final y       = s[1] * size.height;
      final flicker = 0.4 + sin(t * s[2] * 3 + s[0] * 10) * 0.4;
      canvas.drawCircle(
        Offset(x, y), s[2] * 1.2,
        Paint()..color = Colors.white.withOpacity(flicker * 0.6),
      );
    }

    // subtle grid
    final grid = Paint()
      ..color = Colors.white.withOpacity(0.018)
      ..strokeWidth = 0.5;
    for (double x = 0; x < size.width; x += 44) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y < size.height; y += 44) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
  }

  @override
  bool shouldRepaint(_ConstellationPainter old) => old.t != t;
}