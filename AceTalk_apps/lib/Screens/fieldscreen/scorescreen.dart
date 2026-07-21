// lib/features/interview/presentation/pages/score_screen.dart
import 'dart:math';
import 'package:ai_interview_app/Screens/history/historymodel.dart';
import 'package:ai_interview_app/shared/animatedbackground.dart';
import 'package:ai_interview_app/shared/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ScoreScreen extends StatefulWidget {
  final SessionEntity session;
  const ScoreScreen({super.key, required this.session});

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen>
    with TickerProviderStateMixin {
  late AnimationController _entryCtrl;
  late AnimationController _scoreCtrl;
  late Animation<double> _fadeAnim;
  late Animation<double> _scoreAnim;

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..forward();
    _scoreCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..forward();

    _fadeAnim =
        CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _scoreAnim = CurvedAnimation(
        parent: _scoreCtrl, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _scoreCtrl.dispose();
    super.dispose();
  }

  Color get _gradeColor {
    final s = widget.session.scorePercent;
    if (s >= 80) return AppColors.accentGreen;
    if (s >= 60) return AppColors.accentGold;
    return AppColors.accentRed;
  }

  @override
  Widget build(BuildContext context) {
    final session = widget.session;
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: Stack(children: [
        const AnimatedBackground(),
        SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: Column(children: [
              _buildHeader(context),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                  children: [
                    _buildScoreHero(session),
                    const SizedBox(height: 20),
                    _buildStatsRow(session),
                    const SizedBox(height: 20),
                    _buildSessionMeta(session),
                    const SizedBox(height: 20),
                    _buildQuestionBreakdown(session),
                    const SizedBox(height: 28),
                    _buildActions(context),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(children: [
        GestureDetector(
          onTap: () {
            // Pop all the way to home
            Navigator.of(context)
                .popUntil((r) => r.isFirst);
          },
          child: Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.07),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white12),
            ),
            child: const Icon(Icons.home_rounded,
                color: AppColors.textSecondary, size: 20),
          ),
        ),
        const SizedBox(width: 12),
        Text('Interview Complete',
            style: GoogleFonts.spaceMono(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700)),
      ]),
    );
  }

  Widget _buildScoreHero(SessionEntity session) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
            color: _gradeColor.withOpacity(0.25), width: 1.5),
      ),
      child: Column(children: [
        // Circular score
        AnimatedBuilder(
          animation: _scoreAnim,
          builder: (_, __) {
            final value =
                _scoreAnim.value * widget.session.scorePercent / 100;
            return Stack(alignment: Alignment.center, children: [
              SizedBox(
                width: 140, height: 140,
                child: CircularProgressIndicator(
                  value: value,
                  backgroundColor: Colors.white.withOpacity(0.06),
                  valueColor:
                      AlwaysStoppedAnimation<Color>(_gradeColor),
                  strokeWidth: 8,
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(children: [
                Text(
                  '${(widget.session.scorePercent * _scoreAnim.value).toInt()}%',
                  style: GoogleFonts.spaceMono(
                      color: _gradeColor,
                      fontSize: 36,
                      fontWeight: FontWeight.w900),
                ),
                Text(
                  session.grade,
                  style: GoogleFonts.dmSans(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                ),
              ]),
            ]);
          },
        ),
        const SizedBox(height: 20),
        Text(
          _getMotivationalMessage(),
          textAlign: TextAlign.center,
          style: GoogleFonts.dmSans(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        Text(
          '${session.correctAnswers} out of ${session.totalQuestions} correct',
          style: GoogleFonts.dmSans(
              color: AppColors.textSecondary, fontSize: 13),
        ),
      ]),
    );
  }

  Widget _buildStatsRow(SessionEntity session) {
    final avgTime = session.results.isEmpty
        ? 0
        : session.results
                .map((r) => r.timeTaken)
                .fold(0, (a, b) => a + b) ~/
            session.results.length;

    return Row(children: [
      _statBox(Icons.quiz_rounded, '${session.totalQuestions}', 'Total Qs',
          AppColors.accentCyan),
      const SizedBox(width: 12),
      _statBox(Icons.check_circle_rounded, '${session.correctAnswers}',
          'Correct', AppColors.accentGreen),
      const SizedBox(width: 12),
      _statBox(Icons.timer_rounded, '${avgTime}s', 'Avg Time',
          AppColors.accentGold),
    ]);
  }

  Widget _statBox(IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(value,
              style: GoogleFonts.spaceMono(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          Text(label,
              style: GoogleFonts.dmSans(
                  color: AppColors.textSecondary, fontSize: 11)),
        ]),
      ),
    );
  }

  Widget _buildSessionMeta(SessionEntity session) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _metaItem('Language',
              session.language.replaceAll('-', ' ').toUpperCase()),
          _metaItem('Level', session.level),
          _metaItem('Round', session.round),
        ],
      ),
    );
  }

  Widget _metaItem(String label, String value) {
    return Column(children: [
      Text(label,
          style: GoogleFonts.dmSans(
              color: AppColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5)),
      const SizedBox(height: 4),
      Text(value,
          style: GoogleFonts.dmSans(
              color: AppColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w700)),
    ]);
  }

  Widget _buildQuestionBreakdown(SessionEntity session) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Container(
            width: 3, height: 16,
            decoration: BoxDecoration(
                color: AppColors.accentCyan,
                borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(width: 8),
          Text('Question Breakdown',
              style: GoogleFonts.dmSans(
                  color: AppColors.textSecondary,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8)),
        ]),
        const SizedBox(height: 12),
        ...session.results.asMap().entries.map((e) {
          final i = e.key;
          final result = e.value;
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds:300 + i * 100),
            builder: (_, val, child) => Opacity(
              opacity: val,
              child: Transform.translate(
                  offset: Offset(20 * (1 - val), 0), child: child),
            ),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: result.isCorrect
                    ? AppColors.accentGreen.withOpacity(0.06)
                    : AppColors.accentRed.withOpacity(0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: result.isCorrect
                        ? AppColors.accentGreen.withOpacity(0.2)
                        : AppColors.accentRed.withOpacity(0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    result.isCorrect
                        ? Icons.check_circle_rounded
                        : Icons.cancel_rounded,
                    color: result.isCorrect
                        ? AppColors.accentGreen
                        : AppColors.accentRed,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(result.question,
                            style: GoogleFonts.dmSans(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text(
                          result.userAnswer.isEmpty
                              ? 'No answer'
                              : result.userAnswer,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.dmSans(
                              color: AppColors.textSecondary,
                              fontSize: 11.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('${result.timeTaken}s',
                      style: GoogleFonts.spaceMono(
                          color: AppColors.textSecondary, fontSize: 10)),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(children: [
      GestureDetector(
        onTap: () {
          HapticFeedback.mediumImpact();
          Navigator.of(context).popUntil((r) => r.isFirst);
        },
        child: Container(
          width: double.infinity, height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: AppColors.mainGradient,
            boxShadow: [
              BoxShadow(
                  color: AppColors.accentBlue.withOpacity(0.4),
                  blurRadius: 24,
                  offset: const Offset(0, 8)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.replay_rounded, color: Colors.white, size: 22),
              const SizedBox(width: 10),
              Text('Practice Again',
                  style: GoogleFonts.dmSans(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      ),
    ]);
  }

  String _getMotivationalMessage() {
    final s = widget.session.scorePercent;
    if (s >= 90) return '🏆 Outstanding! You nailed it!';
    if (s >= 75) return '🌟 Great job! Keep it up!';
    if (s >= 60) return '💪 Good effort! Room to grow!';
    if (s >= 40) return '📚 Keep studying and try again!';
    return '🔄 Don\'t give up — practice makes perfect!';
  }
}