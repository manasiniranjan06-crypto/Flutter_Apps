// lib/features/language_select/presentation/widgets/language_card.dart
import 'dart:ui';
import 'package:ai_interview_app/Screens/langugae/lqngugaecard.dart';
import 'package:ai_interview_app/Screens/mainScreen/view/feilds_acreen.dart';
import 'package:ai_interview_app/shared/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class LanguageCard extends StatefulWidget {
  final LanguageEntity language;
  const LanguageCard({super.key, required this.language});

  @override
  State<LanguageCard> createState() => _LanguageCardState();
}

class _LanguageCardState extends State<LanguageCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressCtrl;
  late Animation<double> _pressAnim;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 120));
    _pressAnim = Tween<double>(begin: 1.0, end: 0.97).animate(
        CurvedAnimation(parent: _pressCtrl, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  Color get accent => widget.language.accentColor;

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _pressAnim,
      child: GestureDetector(
        onTapDown: (_) => _pressCtrl.forward(),
        onTapUp: (_) => _pressCtrl.reverse(),
        onTapCancel: () => _pressCtrl.reverse(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: accent.withOpacity(0.18), width: 1.5),
              ),
              child: Column(
                children: [
                  _buildTop(),
                  Container(height: 1, color: Colors.white.withOpacity(0.06)),
                  _buildBottom(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTop() {
    final tag = widget.language.tag;
    final tagColor = tag == 'Popular'
        ? AppColors.accentCyan
        : tag == 'Beginner'
            ? AppColors.accentGreen
            : AppColors.accentRed;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accent.withOpacity(0.1),
              border: Border.all(color: accent.withOpacity(0.3), width: 1.5),
              boxShadow: [
                BoxShadow(
                    color: accent.withOpacity(0.15),
                    blurRadius: 14,
                    spreadRadius: 1),
              ],
            ),
            child: ClipOval(
              child: Image.asset(widget.language.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Icon(widget.language.icon, color: accent, size: 26)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(
                    child: Text(widget.language.name,
                        style: GoogleFonts.dmSans(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w800)),
                  ),
                  // Tag badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: tagColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: tagColor.withOpacity(0.3)),
                    ),
                    child: Text(tag,
                        style: GoogleFonts.dmSans(
                            color: tagColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w700)),
                  ),
                ]),
                const SizedBox(height: 5),
                Text(widget.language.detail,
                    style: GoogleFonts.dmSans(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        height: 1.4)),
                const SizedBox(height: 10),
                _buildChips(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChips() {
    final diff = widget.language.difficulty;
    final diffColor = diff == 'Easy'
        ? AppColors.accentGreen
        : diff == 'Hard'
            ? AppColors.accentRed
            : AppColors.accentGold;
    return Row(children: [
      _chip(Icons.quiz_rounded, '${widget.language.totalQuestions} Qs', accent),
      const SizedBox(width: 8),
      _chip(Icons.timer_rounded, '60s/Q', AppColors.textSecondary),
      const SizedBox(width: 8),
      _chip(Icons.signal_cellular_alt_rounded, diff, diffColor),
    ]);
  }

  Widget _chip(IconData icon, String label, Color color) {
    return Row(children: [
      Icon(icon, size: 12, color: color.withOpacity(0.7)),
      const SizedBox(width: 4),
      Text(label,
          style: GoogleFonts.dmSans(
              color: color.withOpacity(0.9),
              fontSize: 11.5,
              fontWeight: FontWeight.w600)),
    ]);
  }

  Widget _buildBottom(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
      child: Row(children: [
        // Details button
        Expanded(
          child: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              _showDetailsSheet(context);
            },
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.info_outline_rounded,
                      color: AppColors.textSecondary, size: 15),
                  const SizedBox(width: 6),
                  Text('Details',
                      style: GoogleFonts.dmSans(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Start Interview button
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FieldsScreen(language: widget.language),
                ),
              );
            },
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                    colors: [accent.withOpacity(0.8), accent]),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.play_arrow_rounded,
                      color: Colors.white, size: 18),
                  const SizedBox(width: 6),
                  Text('Start Interview',
                      style: GoogleFonts.dmSans(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  void _showDetailsSheet(BuildContext context) {
    final topics = widget.language.detail.split(' • ');
    final diff = widget.language.difficulty;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface1.withOpacity(0.97),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              border: Border.all(color: accent.withOpacity(0.2), width: 1.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36, height: 4,
                    decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 20),
                Row(children: [
                  Container(
                    width: 46, height: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accent.withOpacity(0.12),
                      border: Border.all(color: accent.withOpacity(0.3)),
                    ),
                    child: ClipOval(
                      child: Image.asset(widget.language.imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Icon(widget.language.icon, color: accent, size: 22)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(widget.language.name,
                        style: GoogleFonts.dmSans(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w800)),
                    Text('$diff  •  ${widget.language.totalQuestions} questions',
                        style: GoogleFonts.dmSans(
                            color: AppColors.textSecondary, fontSize: 12.5)),
                  ]),
                ]),
                const SizedBox(height: 20),
                Text('TOPICS COVERED',
                    style: GoogleFonts.dmSans(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8, runSpacing: 8,
                  children: topics.map((t) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: accent.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: accent.withOpacity(0.2)),
                    ),
                    child: Text(t.trim(),
                        style: GoogleFonts.dmSans(
                            color: accent, fontSize: 13, fontWeight: FontWeight.w600)),
                  )).toList(),
                ),
                const SizedBox(height: 20),
                Row(children: [
                  _sheetStat(Icons.quiz_rounded, '${widget.language.totalQuestions}', 'Questions'),
                  const SizedBox(width: 12),
                  _sheetStat(Icons.timer_rounded, '60s', 'Per Question'),
                  const SizedBox(width: 12),
                  _sheetStat(Icons.signal_cellular_alt_rounded, diff, 'Level'),
                ]),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FieldsScreen(language: widget.language),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity, height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                          colors: [accent.withOpacity(0.8), accent]),
                      boxShadow: [
                        BoxShadow(
                            color: accent.withOpacity(0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 6)),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.play_arrow_rounded,
                            color: Colors.white, size: 22),
                        const SizedBox(width: 8),
                        Text('Start Interview',
                            style: GoogleFonts.dmSans(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sheetStat(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(children: [
          Icon(icon, color: accent, size: 18),
          const SizedBox(height: 6),
          Text(value,
              style: GoogleFonts.spaceMono(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          Text(label,
              style: GoogleFonts.dmSans(
                  color: AppColors.textSecondary, fontSize: 10.5)),
        ]),
      ),
    );
  }
}