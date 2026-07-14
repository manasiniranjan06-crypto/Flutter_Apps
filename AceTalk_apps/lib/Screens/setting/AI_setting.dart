import 'dart:math';

import 'package:ai_interview_app/Screens/setting/animate_backgrd.dart';
import 'package:ai_interview_app/Screens/setting/color_palet.dart';
import 'package:ai_interview_app/Screens/setting/resuable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';



class AiSettingsScreen extends StatefulWidget {
  const AiSettingsScreen({super.key});
  @override
  State<AiSettingsScreen> createState() => _AiSettingsScreenState();
}

class _AiSettingsScreenState extends State<AiSettingsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _bgCtrl;
  late Animation<double> _bgAnim;
  bool _saving = false;

  // ── Pref keys ───────────────────────────────────────────────────────────────
  static const _kVoice     = 'ai_voice';
  static const _kFeedback  = 'ai_feedback';
  static const _kEval      = 'ai_eval';
  static const _kLang      = 'ai_lang';
  static const _kConf      = 'ai_conf';
  static const _kSmartFU   = 'ai_smart_fu';
  static const _kEmotion   = 'ai_emotion';
  static const _kConfScore = 'ai_conf_score';
  static const _kTts       = 'ai_tts';
  static const _kKeyword   = 'ai_keyword';
  static const _kPause     = 'ai_pause';
  static const _kFacial    = 'ai_facial';

  // ── State ───────────────────────────────────────────────────────────────────
  String _voice            = 'Female';
  String _feedbackStyle    = 'Detailed';
  String _evalLevel        = 'Standard';
  String _language         = 'English';
  double _confidenceThreshold = 70;
  bool   _smartFollowups   = true;
  bool   _emotionAnalysis  = true;
  bool   _confidenceScore  = true;
  bool   _ttsCoach         = false;
  bool   _keywordTracking  = true;
  bool   _pauseDetection   = false;
  bool   _facialAnalysis   = false;

  @override
  void initState() {
    super.initState();
    _bgCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 12))..repeat();
    _bgAnim = Tween<double>(begin: 0, end: 2 * pi)
        .animate(CurvedAnimation(parent: _bgCtrl, curve: Curves.linear));
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _voice               = prefs.getString(_kVoice)    ?? _voice;
      _feedbackStyle       = prefs.getString(_kFeedback) ?? _feedbackStyle;
      _evalLevel           = prefs.getString(_kEval)     ?? _evalLevel;
      _language            = prefs.getString(_kLang)     ?? _language;
      _confidenceThreshold = prefs.getDouble(_kConf)     ?? _confidenceThreshold;
      _smartFollowups  = prefs.getBool(_kSmartFU)   ?? _smartFollowups;
      _emotionAnalysis = prefs.getBool(_kEmotion)   ?? _emotionAnalysis;
      _confidenceScore = prefs.getBool(_kConfScore) ?? _confidenceScore;
      _ttsCoach        = prefs.getBool(_kTts)       ?? _ttsCoach;
      _keywordTracking = prefs.getBool(_kKeyword)   ?? _keywordTracking;
      _pauseDetection  = prefs.getBool(_kPause)     ?? _pauseDetection;
      _facialAnalysis  = prefs.getBool(_kFacial)    ?? _facialAnalysis;
    });
  }

  @override
  void dispose() { _bgCtrl.dispose(); super.dispose(); }

  Future<void> _save() async {
    setState(() => _saving = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kVoice,    _voice);
    await prefs.setString(_kFeedback, _feedbackStyle);
    await prefs.setString(_kEval,     _evalLevel);
    await prefs.setString(_kLang,     _language);
    await prefs.setDouble(_kConf,     _confidenceThreshold);
    await prefs.setBool(_kSmartFU,   _smartFollowups);
    await prefs.setBool(_kEmotion,   _emotionAnalysis);
    await prefs.setBool(_kConfScore, _confidenceScore);
    await prefs.setBool(_kTts,       _ttsCoach);
    await prefs.setBool(_kKeyword,   _keywordTracking);
    await prefs.setBool(_kPause,     _pauseDetection);
    await prefs.setBool(_kFacial,    _facialAnalysis);
    if (!mounted) return;
    setState(() => _saving = false);
    showAppSnack(context, 'AI settings saved!', AppColors2.green, Icons.check_circle_rounded);
  }

  void _resetDefaults() {
    HapticFeedback.mediumImpact();
    setState(() {
      _voice = 'Female'; _feedbackStyle = 'Detailed'; _evalLevel = 'Standard'; _language = 'English';
      _confidenceThreshold = 70;
      _smartFollowups = true; _emotionAnalysis = true; _confidenceScore = true;
      _ttsCoach = false; _keywordTracking = true; _pauseDetection = false; _facialAnalysis = false;
    });
    showAppSnack(context, 'Settings reset to defaults.', AppColors2.ts, Icons.refresh_rounded);
  }

  // ── Status card ─────────────────────────────────────────────────────────────
  Widget _statusCard() {
    final active = [_smartFollowups, _emotionAnalysis, _confidenceScore,
        _keywordTracking, _pauseDetection, _facialAnalysis, _ttsCoach].where((b) => b).length;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors2.purple.withOpacity(0.2), AppColors2.blue.withOpacity(0.1)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors2.purple.withOpacity(0.3)),
      ),
      child: Row(children: [
        Container(
          width: 50, height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(colors: [AppColors2.purple, AppColors2.blue]),
            boxShadow: [BoxShadow(color: AppColors2.purple.withOpacity(0.4), blurRadius: 16)],
          ),
          child: const Icon(Icons.psychology_rounded, color: Colors.white, size: 26),
        ),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('AI Engine Active', style: GoogleFonts.dmSans(color: AppColors2.tp, fontSize: 15, fontWeight: FontWeight.w800)),
          const SizedBox(height: 3),
          Text('$active of 7 features enabled', style: GoogleFonts.dmSans(color: AppColors2.ts, fontSize: 12)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: active / 7,
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation<Color>(
                active >= 5 ? AppColors2.green : active >= 3 ? AppColors2.gold : AppColors2.red,
              ),
              minHeight: 6,
            ),
          ),
        ])),
        const SizedBox(width: 12),
        Column(children: [
          Text(_voice, style: GoogleFonts.spaceMono(color: AppColors2.purple, fontSize: 11, fontWeight: FontWeight.bold)),
          Text('voice', style: GoogleFonts.dmSans(color: AppColors2.ts, fontSize: 10)),
        ]),
      ]),
    );
  }

  Widget _prefRow(String label, IconData icon, Color color, Widget child) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 6),
        Text(label, style: GoogleFonts.dmSans(color: AppColors2.ts, fontSize: 12, fontWeight: FontWeight.w700)),
      ]),
      const SizedBox(height: 10),
      child,
    ]);
  }

  Widget _toggleRow(String title, String sub, IconData icon, Color color, bool val, VoidCallback onTap) {
    return Row(children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(9),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Icon(icon, color: color, size: 16),
      ),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: GoogleFonts.dmSans(color: AppColors2.tp, fontSize: 13.5, fontWeight: FontWeight.w700)),
        Text(sub,   style: GoogleFonts.dmSans(color: AppColors2.ts, fontSize: 11.5)),
      ])),
      AnimToggle(value: val, onTap: onTap),
    ]);
  }

  // ── Build ───────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors2.bg,
      body: Stack(children: [
        AnimatedBuilder(
          animation: _bgAnim,
          builder: (_, __) => CustomPaint(
            painter: BgPainter(_bgAnim.value, orbA: AppColors2.purple, orbB: AppColors2.blue),
            child: const SizedBox.expand(),
          ),
        ),
        SafeArea(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
              child: Row(children: [
                IconButton(
                  onPressed: () { HapticFeedback.lightImpact(); Navigator.pop(context); },
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors2.ts, size: 20),
                ),
                Text('AI Settings',
                    style: GoogleFonts.spaceMono(fontSize: 18, color: AppColors2.tp, fontWeight: FontWeight.w700)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors2.purple.withOpacity(0.1), borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors2.purple.withOpacity(0.35)),
                  ),
                  child: Text('AI Engine v2',
                      style: GoogleFonts.spaceMono(color: AppColors2.purple, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ]),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 40),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _statusCard(),
                  const SizedBox(height: 22),
                  const SectionLabel('Voice & Language'),
                  const SizedBox(height: 12),
                  GlassCard(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      _prefRow('AI Voice', Icons.record_voice_over_rounded, AppColors2.purple,
                          ChipSelector(options: const ['Male','Female','Neutral'], selected: _voice, color: AppColors2.purple, onSelect: (v) => setState(() => _voice = v))),
                      const SizedBox(height: 16),
                      Divider(color: Colors.white.withOpacity(0.06)),
                      const SizedBox(height: 16),
                      _prefRow('Language', Icons.language_rounded, AppColors2.blue,
                          ChipSelector(options: const ['English','Hindi','Mixed'], selected: _language, color: AppColors2.blue, onSelect: (v) => setState(() => _language = v))),
                    ]),
                  ),
                  const SizedBox(height: 16),
                  const SectionLabel('Feedback & Evaluation'),
                  const SizedBox(height: 12),
                  GlassCard(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      _prefRow('Feedback Style', Icons.rate_review_rounded, AppColors2.cyan,
                          ChipSelector(options: const ['Brief','Detailed','Coach Mode'], selected: _feedbackStyle, color: AppColors2.cyan, onSelect: (v) => setState(() => _feedbackStyle = v))),
                      const SizedBox(height: 16),
                      Divider(color: Colors.white.withOpacity(0.06)),
                      const SizedBox(height: 16),
                      _prefRow('Evaluation Level', Icons.assessment_rounded, AppColors2.gold,
                          ChipSelector(options: const ['Lenient','Standard','Strict'], selected: _evalLevel, color: AppColors2.gold, onSelect: (v) => setState(() => _evalLevel = v))),
                      const SizedBox(height: 16),
                      Divider(color: Colors.white.withOpacity(0.06)),
                      const SizedBox(height: 16),
                      _prefRow('Confidence Threshold: ${_confidenceThreshold.toInt()}%', Icons.speed_rounded, AppColors2.green,
                          SliderTheme(
                            data: SliderThemeData(
                              activeTrackColor: AppColors2.green, inactiveTrackColor: AppColors2.s2,
                              thumbColor: AppColors2.green, overlayColor: AppColors2.green.withOpacity(0.15),
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9), trackHeight: 5,
                            ),
                            child: Slider(min: 30, max: 100, divisions: 14, value: _confidenceThreshold,
                                onChanged: (v) => setState(() => _confidenceThreshold = v)),
                          )),
                    ]),
                  ),
                  const SizedBox(height: 16),
                  const SectionLabel('Advanced AI Features'),
                  const SizedBox(height: 12),
                  GlassCard(
                    child: Column(children: [
                      _toggleRow('Smart Follow-up Questions', 'AI digs deeper on weak answers',       Icons.psychology_rounded,              AppColors2.purple, _smartFollowups,  () => setState(() => _smartFollowups  = !_smartFollowups)),
                      Divider(color: Colors.white.withOpacity(0.06), height: 24),
                      _toggleRow('Emotion & Tone Analysis',   'Detects confidence in your voice',     Icons.sentiment_satisfied_alt_rounded, AppColors2.cyan,   _emotionAnalysis, () => setState(() => _emotionAnalysis = !_emotionAnalysis)),
                      Divider(color: Colors.white.withOpacity(0.06), height: 24),
                      _toggleRow('Confidence Scoring',        'Real-time body language feedback',     Icons.show_chart_rounded,              AppColors2.gold,   _confidenceScore, () => setState(() => _confidenceScore = !_confidenceScore)),
                      Divider(color: Colors.white.withOpacity(0.06), height: 24),
                      _toggleRow('Keyword Tracking',          'Highlights important answer keywords', Icons.text_fields_rounded,             AppColors2.green,  _keywordTracking, () => setState(() => _keywordTracking = !_keywordTracking)),
                      Divider(color: Colors.white.withOpacity(0.06), height: 24),
                      _toggleRow('Pause & Filler Detection',  'Tracks umm, uh, like in speech',       Icons.mic_none_rounded,                AppColors2.blue,   _pauseDetection,  () => setState(() => _pauseDetection  = !_pauseDetection)),
                      Divider(color: Colors.white.withOpacity(0.06), height: 24),
                      _toggleRow('Facial Expression Analysis','Camera-based confidence check',        Icons.face_rounded,                    AppColors2.red,    _facialAnalysis,  () => setState(() => _facialAnalysis  = !_facialAnalysis)),
                      Divider(color: Colors.white.withOpacity(0.06), height: 24),
                      _toggleRow('TTS Voice Coach',           'AI speaks questions aloud',            Icons.volume_up_rounded,               AppColors2.purple, _ttsCoach,        () => setState(() => _ttsCoach        = !_ttsCoach)),
                    ]),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: _resetDefaults,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        const Icon(Icons.refresh_rounded, color: AppColors2.ts, size: 18),
                        const SizedBox(width: 8),
                        Text('Reset to Defaults',
                            style: GoogleFonts.dmSans(color: AppColors2.ts, fontSize: 13.5, fontWeight: FontWeight.w600)),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SaveButton(onSave: _save, saving: _saving),
                ]),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}