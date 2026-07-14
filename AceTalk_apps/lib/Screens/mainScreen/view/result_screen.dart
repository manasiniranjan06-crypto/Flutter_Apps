import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultScreen extends StatefulWidget {
  final List<Map<String, dynamic>> sessionData;
  const ResultScreen({super.key, required this.sessionData});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {
  // ── palette (mirrors QuestionScreen) ──────────────────────────────────────
  static const Color _bgDark = Color.fromARGB(255, 5, 13, 26);
  static const Color _surface1 = Color.fromARGB(255, 13, 31, 53);
  static const Color _surface2 = Color.fromARGB(255, 17, 40, 68);
  static const Color _accentCyan = Color.fromARGB(255, 0, 229, 255);
  static const Color _accentBlue = Color.fromARGB(255, 41, 121, 255);
  static const Color _accentGold = Color(0xFFFFD740);
  static const Color _dangerRed = Color(0xFFFF3D57);
  static const Color _successGreen = Color(0xFF00E676);
  static const Color _textPrimary = Color(0xFFE8F4FD);
  static const Color _textSecondary = Color(0xFF7BA7C4);

  // ── animations ────────────────────────────────────────────────────────────
  late AnimationController _introCtrl;
  late AnimationController _scoreCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _orbCtrl;
  late Animation<double> _scoreAnim;
  late Animation<double> _fadeAnim;
  late Animation<double> _pulseAnim;
  late Animation<double> _orbAnim;

  // ── state ─────────────────────────────────────────────────────────────────
  int _expandedIndex = -1;
  bool _showBreakdown = false;

  // ── computed ──────────────────────────────────────────────────────────────
  late final int _totalScore;
  late final int _maxScore;
  late final double _percentage;
  late final int _skipped;
  late final int _answered;
  late final double _avgTime;

  @override
  void initState() {
    super.initState();
    _compute();
    _setupAnimations();
    _startAnimations();
  }

  void _compute() {
    _totalScore = widget.sessionData.fold<int>(
      0,
      (sum, d) => sum + ((d['score'] ?? 0) as int),
    );
    _maxScore = widget.sessionData.length * 10;
    _percentage = _maxScore == 0 ? 0 : (_totalScore / _maxScore) * 100;
    _skipped = widget.sessionData.where((d) => d['skipped'] == true).length;
    _answered = widget.sessionData.length - _skipped;
    final totalTime = widget.sessionData.fold<int>(
      0,
      (sum, d) => sum + ((d['timeSpent'] ?? 0) as int),
    );
    _avgTime = _answered == 0 ? 0 : totalTime / _answered;
  }

  void _setupAnimations() {
    _introCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _scoreCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _orbCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _fadeAnim = CurvedAnimation(parent: _introCtrl, curve: Curves.easeOut);
    _scoreAnim = Tween<double>(
      begin: 0,
      end: _percentage / 100,
    ).animate(CurvedAnimation(parent: _scoreCtrl, curve: Curves.easeOutCubic));
    _pulseAnim = Tween<double>(
      begin: 1.0,
      end: 1.08,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
    _orbAnim = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(CurvedAnimation(parent: _orbCtrl, curve: Curves.linear));
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _introCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    _scoreCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) setState(() => _showBreakdown = true);
    HapticFeedback.mediumImpact();
  }

  @override
  void dispose() {
    _introCtrl.dispose();
    _scoreCtrl.dispose();
    _pulseCtrl.dispose();
    _orbCtrl.dispose();
    super.dispose();
  }

  // ── helpers ────────────────────────────────────────────────────────────────

  String get _grade {
    if (_percentage >= 90) return 'A+';
    if (_percentage >= 80) return 'A';
    if (_percentage >= 70) return 'B';
    if (_percentage >= 60) return 'C';
    if (_percentage >= 40) return 'D';
    return 'F';
  }

  String get _gradientLabel {
    if (_percentage >= 80) return 'Outstanding 🌟';
    if (_percentage >= 60) return 'Good Job 👍';
    if (_percentage >= 40) return 'Keep Practising 💪';
    return 'Needs Improvement 📚';
  }

  Color get _gradeColor {
    if (_percentage >= 80) return _successGreen;
    if (_percentage >= 60) return _accentCyan;
    if (_percentage >= 40) return _accentGold;
    return _dangerRed;
  }

  Color _scoreColor(int score) {
    if (score >= 8) return _successGreen;
    if (score >= 6) return _accentCyan;
    if (score >= 4) return _accentGold;
    return _dangerRed;
  }

  // ── build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgDark,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          FadeTransition(
            opacity: _fadeAnim,
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildResultHero(),
                    const SizedBox(height: 28),
                    _buildStatsRow(),
                    const SizedBox(height: 28),
                    _buildBreakdownSection(),
                    const SizedBox(height: 32),
                    _buildCtaButtons(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() => AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    automaticallyImplyLeading: false,
    title: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: _accentBlue.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _accentBlue.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.analytics_rounded, color: _accentCyan, size: 16),
          const SizedBox(width: 7),
          Text(
            'Interview Report',
            style: GoogleFonts.spaceMono(
              color: _textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    ),
  );

  // ── animated orb background ────────────────────────────────────────────────

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _orbAnim,
      builder: (_, __) => CustomPaint(
        painter: _BackgroundPainter(_orbAnim.value),
        child: const SizedBox.expand(),
      ),
    );
  }

  // ── hero score ring ────────────────────────────────────────────────────────

  Widget _buildResultHero() {
    return Column(
      children: [
        AnimatedBuilder(
          animation: Listenable.merge([_scoreAnim, _pulseCtrl]),
          builder: (_, __) {
            final progress = _scoreAnim.value;
            final scale = _percentage >= 60 ? _pulseAnim.value : 1.0;
            return Transform.scale(
              scale: scale,
              child: SizedBox(
                width: 190,
                height: 190,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // outer glow
                    Container(
                      width: 190,
                      height: 190,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _gradeColor.withOpacity(0.3),
                            blurRadius: 40,
                            spreadRadius: 6,
                          ),
                        ],
                      ),
                    ),
                    // track
                    SizedBox(
                      width: 170,
                      height: 170,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 10,
                        backgroundColor: _surface2,
                        valueColor: AlwaysStoppedAnimation<Color>(_gradeColor),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    // inner content
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _grade,
                          style: GoogleFonts.spaceMono(
                            color: _gradeColor,
                            fontSize: 52,
                            fontWeight: FontWeight.w900,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(progress * _percentage).toStringAsFixed(0)}%',
                          style: GoogleFonts.dmSans(
                            color: _textSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        Text(
          _gradientLabel,
          style: GoogleFonts.dmSans(
            color: _gradeColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '$_totalScore / $_maxScore points earned',
          style: GoogleFonts.spaceMono(color: _textSecondary, fontSize: 13),
        ),
      ],
    );
  }

  // ── stats row ──────────────────────────────────────────────────────────────

  Widget _buildStatsRow() {
    return Row(
      children: [
        _StatCard(
          icon: Icons.check_circle_rounded,
          color: _successGreen,
          value: '$_answered',
          label: 'Answered',
        ),
        const SizedBox(width: 10),
        _StatCard(
          icon: Icons.skip_next_rounded,
          color: _dangerRed,
          value: '$_skipped',
          label: 'Skipped',
        ),
        const SizedBox(width: 10),
        _StatCard(
          icon: Icons.timer_rounded,
          color: _accentGold,
          value: '${_avgTime.toStringAsFixed(0)}s',
          label: 'Avg Time',
        ),
      ],
    );
  }

  // ── question breakdown ─────────────────────────────────────────────────────

  Widget _buildBreakdownSection() {
    return AnimatedOpacity(
      opacity: _showBreakdown ? 1 : 0,
      duration: const Duration(milliseconds: 600),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.list_alt_rounded, color: _accentCyan, size: 18),
              const SizedBox(width: 8),
              Text(
                'Question Breakdown',
                style: GoogleFonts.dmSans(
                  color: _textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...List.generate(widget.sessionData.length, (i) {
            final d = widget.sessionData[i];
            final bool skipped = d['skipped'] == true;
            final int score = (d['score'] ?? 0) as int;
            final bool expanded = _expandedIndex == i;
            final color = skipped ? _dangerRed : _scoreColor(score);

            return GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _expandedIndex = expanded ? -1 : i);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: expanded ? color.withOpacity(0.08) : _surface1,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: expanded ? color.withOpacity(0.4) : Colors.white10,
                    width: 1.5,
                  ),
                  boxShadow: expanded
                      ? [
                          BoxShadow(
                            color: color.withOpacity(0.15),
                            blurRadius: 20,
                            spreadRadius: 1,
                          ),
                        ]
                      : [],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // number badge
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: color.withOpacity(0.4)),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${i + 1}',
                            style: GoogleFonts.spaceMono(
                              color: color,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            d['question'] ?? '',
                            maxLines: expanded ? 10 : 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.dmSans(
                              color: _textPrimary,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // score pill
                        if (!skipped)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '$score/10',
                              style: GoogleFonts.spaceMono(
                                color: color,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _dangerRed.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Skipped',
                              style: GoogleFonts.spaceMono(
                                color: _dangerRed,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        const SizedBox(width: 6),
                        Icon(
                          expanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: _textSecondary,
                          size: 20,
                        ),
                      ],
                    ),
                    if (expanded) ...[
                      const SizedBox(height: 14),
                      Divider(color: Colors.white.withOpacity(0.07)),
                      const SizedBox(height: 10),
                      if (!skipped) ...[
                        _DetailRow(
                          icon: Icons.edit_rounded,
                          label: 'Your Answer',
                          color: _accentCyan,
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _surface2,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            d['answer']?.toString().isEmpty == true
                                ? '(No answer written)'
                                : d['answer'],
                            style: GoogleFonts.dmSans(
                              color: _textPrimary,
                              fontSize: 13,
                              height: 1.6,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.timer_rounded,
                              color: _accentGold,
                              size: 14,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Time spent: ${d['timeSpent'] ?? 0}s',
                              style: GoogleFonts.dmSans(
                                color: _textSecondary,
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            _ScoreBar(score: score, color: color),
                          ],
                        ),
                      ] else ...[
                        Row(
                          children: [
                            const Icon(
                              Icons.info_outline_rounded,
                              color: _dangerRed,
                              size: 14,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Reason: ${d['skipReason'] ?? 'Not specified'}',
                              style: GoogleFonts.dmSans(
                                color: _textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── CTA buttons ────────────────────────────────────────────────────────────

  Widget _buildCtaButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              HapticFeedback.mediumImpact();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            icon: const Icon(Icons.refresh_rounded, size: 20),
            label: Text(
              'Try Again',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _accentBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.home_rounded, size: 20),
            label: Text(
              'Back to Home',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: _textSecondary,
              side: const BorderSide(color: Colors.white24),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── small widgets ──────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  static const Color _surface1 = Color(0xFF0D1F35);
  static const Color _textPrimary = Color(0xFFE8F4FD);
  static const Color _textSecondary = Color(0xFF7BA7C4);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          color: _surface1,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withOpacity(0.25)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 16,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.spaceMono(
                color: color,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.dmSans(
                color: _textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.color,
  });

  static const Color _textSecondary = Color(0xFF7BA7C4);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.dmSans(
            color: _textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _ScoreBar extends StatelessWidget {
  final int score;
  final Color color;

  const _ScoreBar({required this.score, required this.color});

  static const Color _surface2 = Color(0xFF112844);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(10, (i) {
        return Container(
          margin: const EdgeInsets.only(left: 3),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: i < score ? color : _surface2,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}

// ── animated background painter ────────────────────────────────────────────────

class _BackgroundPainter extends CustomPainter {
  final double angle;
  _BackgroundPainter(this.angle);

  @override
  void paint(Canvas canvas, Size size) {
    // base gradient
    final bg = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF050D1A), Color(0xFF071628), Color(0xFF050D1A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bg);

    // animated orb 1
    final cx1 = size.width * 0.5 + cos(angle) * size.width * 0.25;
    final cy1 = size.height * 0.3 + sin(angle) * size.height * 0.08;
    final orb1 = Paint()
      ..shader =
          RadialGradient(
            colors: [
              const Color(0xFF2979FF).withOpacity(0.18),
              Colors.transparent,
            ],
            radius: 0.6,
          ).createShader(
            Rect.fromCircle(center: Offset(cx1, cy1), radius: size.width * 0.5),
          );
    canvas.drawCircle(Offset(cx1, cy1), size.width * 0.5, orb1);

    // animated orb 2
    final cx2 = size.width * 0.5 + cos(angle + pi) * size.width * 0.25;
    final cy2 = size.height * 0.7 + sin(angle + pi) * size.height * 0.08;
    final orb2 = Paint()
      ..shader =
          RadialGradient(
            colors: [
              const Color(0xFF00E5FF).withOpacity(0.09),
              Colors.transparent,
            ],
            radius: 0.7,
          ).createShader(
            Rect.fromCircle(
              center: Offset(cx2, cy2),
              radius: size.width * 0.45,
            ),
          );
    canvas.drawCircle(Offset(cx2, cy2), size.width * 0.45, orb2);

    // subtle grid
    final grid = Paint()
      ..color = Colors.white.withOpacity(0.02)
      ..strokeWidth = 0.5;
    const step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
  }

  @override
  bool shouldRepaint(_BackgroundPainter old) => old.angle != angle;
}
