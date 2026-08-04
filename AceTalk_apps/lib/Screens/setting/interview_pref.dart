import 'dart:math';

import 'package:ai_interview_app/Screens/setting/animate_backgrd.dart';
import 'package:ai_interview_app/Screens/setting/color_palet.dart';
import 'package:ai_interview_app/Screens/setting/resuable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InterviewPrefScreen extends StatefulWidget {
  const InterviewPrefScreen({super.key});
  @override
  State<InterviewPrefScreen> createState() => _InterviewPrefScreenState();
}

class _InterviewPrefScreenState extends State<InterviewPrefScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _bgCtrl;
  late Animation<double> _bgAnim;
  bool _saving = false;

  // ── Pref keys ───────────────────────────────────────────────────────────────
  static const _kType = 'pref_int_type';
  static const _kDifficulty = 'pref_int_diff';
  static const _kFormat = 'pref_int_format';
  static const _kDuration = 'pref_int_duration';
  static const _kQTime = 'pref_int_qtime';
  static const _kRealFeedback = 'pref_int_realfb';
  static const _kMockMode = 'pref_int_mock';
  static const _kCompanyMode = 'pref_int_company';
  static const _kCompanies = 'pref_int_companies';

  // ── State ───────────────────────────────────────────────────────────────────
  String _type = 'Technical';
  String _difficulty = 'Intermediate';
  String _format = 'Descriptive';
  String _duration = '30 min';
  int _questionTime = 60;
  bool _realFeedback = true;
  bool _mockMode = false;
  bool _companyMode = false;
  final _selectedCompanies = <String>[];

  static const _companies = [
    'Google',
    'Amazon',
    'Microsoft',
    'Flipkart',
    'Infosys',
    'TCS',
    'Wipro',
    'Meta',
    'Apple',
    'Uber',
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
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _type = prefs.getString(_kType) ?? _type;
      _difficulty = prefs.getString(_kDifficulty) ?? _difficulty;
      _format = prefs.getString(_kFormat) ?? _format;
      _duration = prefs.getString(_kDuration) ?? _duration;
      _questionTime = prefs.getInt(_kQTime) ?? _questionTime;
      _realFeedback = prefs.getBool(_kRealFeedback) ?? _realFeedback;
      _mockMode = prefs.getBool(_kMockMode) ?? _mockMode;
      _companyMode = prefs.getBool(_kCompanyMode) ?? _companyMode;
      _selectedCompanies.addAll(prefs.getStringList(_kCompanies) ?? []);
    });
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kType, _type);
    await prefs.setString(_kDifficulty, _difficulty);
    await prefs.setString(_kFormat, _format);
    await prefs.setString(_kDuration, _duration);
    await prefs.setInt(_kQTime, _questionTime);
    await prefs.setBool(_kRealFeedback, _realFeedback);
    await prefs.setBool(_kMockMode, _mockMode);
    await prefs.setBool(_kCompanyMode, _companyMode);
    await prefs.setStringList(_kCompanies, _selectedCompanies);
    if (!mounted) return;
    setState(() => _saving = false);
    showAppSnack(
      context,
      'Interview preferences saved!',
      AppColors2.green,
      Icons.check_circle_rounded,
    );
  }

  // ── Widgets ─────────────────────────────────────────────────────────────────
  Widget _summaryCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors2.blue.withOpacity(0.2),
            AppColors2.purple.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors2.blue.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(child: _chip('Type', _type, AppColors2.cyan)),
          Expanded(child: _chip('Level', _difficulty, AppColors2.gold)),
          Expanded(child: _chip('Duration', _duration, AppColors2.green)),
        ],
      ),
    );
  }

  Widget _chip(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.dmSans(
            color: AppColors2.ts,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.spaceMono(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _prefRow(String label, IconData icon, Color color, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.dmSans(
                color: AppColors2.ts,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }

  Widget _toggleRow(
    String title,
    String sub,
    IconData icon,
    Color color,
    bool val,
    VoidCallback onTap,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: color.withOpacity(0.25)),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.dmSans(
                  color: AppColors2.tp,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                sub,
                style: GoogleFonts.dmSans(color: AppColors2.ts, fontSize: 11.5),
              ),
            ],
          ),
        ),
        AnimToggle(value: val, onTap: onTap),
      ],
    );
  }

  // ── Build ───────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors2.bg,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _bgAnim,
            builder: (_, __) => CustomPaint(
              painter: BgPainter(
                _bgAnim.value,
                orbA: AppColors2.blue,
                orbB: AppColors2.purple,
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
                        'Interview Preferences',
                        style: GoogleFonts.spaceMono(
                          fontSize: 16,
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
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _summaryCard(),
                        const SizedBox(height: 22),
                        const SectionLabel('Interview Type'),
                        const SizedBox(height: 12),
                        GlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _prefRow(
                                'Type',
                                Icons.category_rounded,
                                AppColors2.blue,
                                ChipSelector(
                                  options: const [
                                    'HR',
                                    'Technical',
                                    'Behavioral',
                                    'Mixed',
                                  ],
                                  selected: _type,
                                  color: AppColors2.blue,
                                  onSelect: (v) => setState(() => _type = v),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Divider(color: Colors.white.withOpacity(0.06)),
                              const SizedBox(height: 16),
                              _prefRow(
                                'Format',
                                Icons.question_answer_rounded,
                                AppColors2.cyan,
                                ChipSelector(
                                  options: const [
                                    'MCQ',
                                    'Descriptive',
                                    'Voice',
                                    'Mixed',
                                  ],
                                  selected: _format,
                                  color: AppColors2.cyan,
                                  onSelect: (v) => setState(() => _format = v),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        const SectionLabel('Difficulty & Duration'),
                        const SizedBox(height: 12),
                        GlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _prefRow(
                                'Difficulty Level',
                                Icons.bar_chart_rounded,
                                AppColors2.gold,
                                ChipSelector(
                                  options: const [
                                    'Beginner',
                                    'Intermediate',
                                    'Advanced',
                                    'Expert',
                                  ],
                                  selected: _difficulty,
                                  color: AppColors2.gold,
                                  onSelect: (v) =>
                                      setState(() => _difficulty = v),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Divider(color: Colors.white.withOpacity(0.06)),
                              const SizedBox(height: 16),
                              _prefRow(
                                'Session Duration',
                                Icons.schedule_rounded,
                                AppColors2.green,
                                ChipSelector(
                                  options: const [
                                    '15 min',
                                    '30 min',
                                    '45 min',
                                    '60 min',
                                  ],
                                  selected: _duration,
                                  color: AppColors2.green,
                                  onSelect: (v) =>
                                      setState(() => _duration = v),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Divider(color: Colors.white.withOpacity(0.06)),
                              const SizedBox(height: 16),
                              _prefRow(
                                'Time / Question: ${_questionTime}s',
                                Icons.timer_rounded,
                                AppColors2.cyan,
                                SliderTheme(
                                  data: SliderThemeData(
                                    activeTrackColor: AppColors2.cyan,
                                    inactiveTrackColor: AppColors2.s2,
                                    thumbColor: AppColors2.cyan,
                                    overlayColor: AppColors2.cyan.withOpacity(
                                      0.15,
                                    ),
                                    thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 9,
                                    ),
                                    trackHeight: 5,
                                  ),
                                  child: Slider(
                                    min: 30,
                                    max: 180,
                                    divisions: 10,
                                    value: _questionTime.toDouble(),
                                    onChanged: (v) => setState(
                                      () => _questionTime = v.toInt(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        const SectionLabel('Options'),
                        const SizedBox(height: 12),
                        GlassCard(
                          child: Column(
                            children: [
                              _toggleRow(
                                'Real-time Feedback',
                                'Instant AI hints after each answer',
                                Icons.bolt_rounded,
                                AppColors2.cyan,
                                _realFeedback,
                                () => setState(
                                  () => _realFeedback = !_realFeedback,
                                ),
                              ),
                              Divider(
                                color: Colors.white.withOpacity(0.06),
                                height: 24,
                              ),
                              _toggleRow(
                                'Mock Interview Mode',
                                'Simulates a real interview experience',
                                Icons.videocam_rounded,
                                AppColors2.blue,
                                _mockMode,
                                () => setState(() => _mockMode = !_mockMode),
                              ),
                              Divider(
                                color: Colors.white.withOpacity(0.06),
                                height: 24,
                              ),
                              _toggleRow(
                                'Company-Specific Mode',
                                'Questions from top companies',
                                Icons.business_rounded,
                                AppColors2.gold,
                                _companyMode,
                                () => setState(
                                  () => _companyMode = !_companyMode,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_companyMode) ...[
                          const SizedBox(height: 12),
                          GlassCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Select Companies',
                                  style: GoogleFonts.dmSans(
                                    color: AppColors2.ts,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: _companies.map((c) {
                                    final sel = _selectedCompanies.contains(c);
                                    return GestureDetector(
                                      onTap: () {
                                        HapticFeedback.selectionClick();
                                        setState(() {
                                          if (sel)
                                            _selectedCompanies.remove(c);
                                          else
                                            _selectedCompanies.add(c);
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 7,
                                        ),
                                        decoration: BoxDecoration(
                                          color: sel
                                              ? AppColors2.gold.withOpacity(
                                                  0.15,
                                                )
                                              : AppColors2.s2,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          border: Border.all(
                                            color: sel
                                                ? AppColors2.gold.withOpacity(
                                                    0.5,
                                                  )
                                                : Colors.white12,
                                          ),
                                        ),
                                        child: Text(
                                          c,
                                          style: GoogleFonts.dmSans(
                                            color: sel
                                                ? AppColors2.gold
                                                : AppColors2.ts,
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 28),
                        SaveButton(onSave: _save, saving: _saving),
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
