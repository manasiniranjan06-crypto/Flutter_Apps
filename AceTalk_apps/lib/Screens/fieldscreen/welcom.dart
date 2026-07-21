// lib/features/welcome/presentation/pages/welcome_screen.dart
import 'dart:async';
import 'package:ai_interview_app/Screens/fieldscreen/questionscreen.dart';
import 'package:ai_interview_app/Screens/langugae/lqngugaecard.dart';
import 'package:ai_interview_app/shared/animatedbackground.dart';
import 'package:ai_interview_app/shared/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class WelcomeScreen extends StatefulWidget {
  final LanguageEntity language;
  final int totalQuestions;
  final String level;
  final String round;

  const WelcomeScreen({
    super.key,
    required this.language,
    required this.totalQuestions,
    required this.level,
    required this.round,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  final FlutterTts _tts = FlutterTts();
  String _displayed = '';
  int _charIndex = 0;
  Timer? _typingTimer;
  bool _isTyping = true;
  bool _ttsReady = false;

  late AnimationController _fadeCtrl;
  late AnimationController _pulseCtrl;
  late Animation<double> _fadeAnim;
  late Animation<double> _pulseAnim;

  String get _welcomeText =>
      'Welcome to AceTalk Interview Coach.\n'
      'Practice real ${widget.language.name.replaceAll(' Interview', '')} questions.\n'
      'Level: ${widget.level}  •  Round: ${widget.round}\n'
      '${widget.totalQuestions} questions await you. Good luck! 🚀';

  @override
  void initState() {
    super.initState();

    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
      ..forward();
    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);

    _fadeAnim =
        CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _pulseAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _initTts();
    _startTyping();
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);
    setState(() => _ttsReady = true);
    _tts.speak(_welcomeText);
  }

  void _startTyping() {
    _typingTimer =
        Timer.periodic(const Duration(milliseconds: 40), (timer) {
      if (_charIndex < _welcomeText.length) {
        setState(() {
          _displayed += _welcomeText[_charIndex];
          _charIndex++;
        });
      } else {
        timer.cancel();
        setState(() => _isTyping = false);
      }
    });
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _tts.stop();
    _fadeCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _navigateToInterview() {
    _tts.stop();
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, anim, __) => FadeTransition(
          opacity: anim,
          child: QuestionScreen(
            language: widget.language,
            totalQuestions: widget.totalQuestions,
            level: widget.level,
            round: widget.round,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: Stack(
        children: [
          const AnimatedBackground(),
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    // Lottie animation
                    ScaleTransition(
                      scale: _pulseAnim,
                      child: SizedBox(
                        height: 180,
                        child: Lottie.asset(
                          'assets/lottie_ani/robot.json',
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.psychology_alt_rounded,
                            color: AppColors.accentCyan,
                            size: 80,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Title
                    Text(
                      'AI Interview Coach',
                      style: GoogleFonts.spaceMono(
                        color: AppColors.accentCyan,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildMetaBadges(),
                    const SizedBox(height: 32),
                    // Typing text card
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.04),
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: SingleChildScrollView(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _displayed,
                                style: GoogleFonts.dmSans(
                                  color: AppColors.textPrimary,
                                  fontSize: 15,
                                  height: 1.7,
                                ),
                              ),
                              if (_isTyping)
                                _buildCursor(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Start button
                    AnimatedOpacity(
                      opacity: _isTyping ? 0.5 : 1.0,
                      duration: const Duration(milliseconds: 400),
                      child: GestureDetector(
                        onTap: _navigateToInterview,
                        child: Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            gradient: AppColors.mainGradient,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accentBlue.withOpacity(0.4),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.play_arrow_rounded,
                                  color: Colors.white, size: 26),
                              const SizedBox(width: 10),
                              Text(
                                'Begin Interview',
                                style: GoogleFonts.dmSans(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Skip
                    GestureDetector(
                      onTap: _navigateToInterview,
                      child: Text(
                        'Skip intro →',
                        style: GoogleFonts.dmSans(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaBadges() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        _badge(widget.language.name, widget.language.accentColor),
        _badge(widget.level, AppColors.accentGold),
        _badge(widget.round, AppColors.accentCyan),
        _badge('${widget.totalQuestions} Questions', AppColors.accentGreen),
      ],
    );
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: GoogleFonts.dmSans(
            color: color, fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildCursor() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      builder: (_, val, __) => Opacity(
        opacity: val > 0.5 ? 1.0 : 0.0,
        child: Container(
          width: 2,
          height: 18,
          margin: const EdgeInsets.only(left: 1, top: 2),
          color: AppColors.accentCyan,
        ),
      ),
    );
  }
}