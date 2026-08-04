import 'dart:ui';
import 'package:ai_interview_app/Screens/setting/color_palet.dart';
import 'package:ai_interview_app/shared/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Glass Card ──────────────────────────────────────────────────────────────

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? borderColor;
  final Color? bgColor;
  final double radius;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderColor,
    this.bgColor,
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: padding ?? const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: bgColor ?? AppColors2.s1.withOpacity(0.9),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: borderColor ?? Colors.white10,
              width: 1.2,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

// ─── Section Label ────────────────────────────────────────────────────────────

class SectionLabel extends StatelessWidget {
  final String label;
  const SectionLabel(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: AppColors2.cyan,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(color: AppColors2.cyan.withOpacity(0.5), blurRadius: 8),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label.toUpperCase(),
          style: GoogleFonts.spaceMono(
            fontSize: 10,
            color: AppColors2.ts,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.5,
          ),
        ),
      ],
    );
  }
}

// ─── Tag ─────────────────────────────────────────────────────────────────────

class AppTag extends StatelessWidget {
  final String text;
  final Color color;
  const AppTag(this.text, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Text(
        text,
        style: GoogleFonts.spaceMono(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ─── Chip Selector ────────────────────────────────────────────────────────────

class ChipSelector extends StatelessWidget {
  final List<String> options;
  final String selected;
  final Color color;
  final ValueChanged<String> onSelect;

  const ChipSelector({
    super.key,
    required this.options,
    required this.selected,
    required this.color,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((o) {
        final active = o == selected;
        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            onSelect(o);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: active ? color.withOpacity(0.18) : AppColors2.s2,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: active ? color.withOpacity(0.65) : Colors.white12,
              ),
              boxShadow: active
                  ? [BoxShadow(color: color.withOpacity(0.22), blurRadius: 12)]
                  : [],
            ),
            child: Text(
              o,
              style: GoogleFonts.dmSans(
                color: active ? color : AppColors2.ts,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─── Animated Toggle ─────────────────────────────────────────────────────────

class AnimToggle extends StatelessWidget {
  final bool value;
  final VoidCallback onTap;
  const AnimToggle({super.key, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 52,
        height: 28,
        decoration: BoxDecoration(
          color: value ? AppColors2.cyan.withOpacity(0.22) : AppColors2.s2,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: value ? AppColors2.cyan.withOpacity(0.6) : Colors.white12,
          ),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 250),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.all(3),
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: value ? AppColors2.cyan : AppColors2.ts,
              boxShadow: value
                  ? [
                      BoxShadow(
                        color: AppColors2.cyan.withOpacity(0.55),
                        blurRadius: 10,
                      ),
                    ]
                  : [],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Nav Tile ─────────────────────────────────────────────────────────────────

class NavTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Widget? trailing;

  const NavTile({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Icon(icon, color: color, size: 20),
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
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.dmSans(
                      color: AppColors2.ts,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: 8), trailing!],
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors2.ts,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Save Button ─────────────────────────────────────────────────────────────

class SaveButton extends StatelessWidget {
  final Future<void> Function() onSave;
  final bool saving;

  const SaveButton({super.key, required this.onSave, required this.saving});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: saving ? null : onSave,
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: saving
              ? LinearGradient(
                  colors: [
                    AppColors2.green.withOpacity(0.6),
                    AppColors2.green.withOpacity(0.8),
                  ],
                )
              : const LinearGradient(
                  colors: [
                    Color(0xFF1565C0),
                    Color(0xFF2979FF),
                    Color(0xFF00B0FF),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          boxShadow: [
            BoxShadow(
              color: AppColors2.blue.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 1,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: saving
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.save_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Save Changes',
                      style: GoogleFonts.dmSans(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// ─── Snackbar Helper ─────────────────────────────────────────────────────────

void showAppSnack(
  BuildContext context,
  String msg,
  Color color,
  IconData icon,
) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: const Duration(seconds: 3),
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors2.s1,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.4), width: 1.5),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.15), blurRadius: 20),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                msg,
                style: GoogleFonts.dmSans(
                  color: AppColors2.tp,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// ─── Animated Background Scaffold ────────────────────────────────────────────

class AnimatedBgScaffold extends StatefulWidget {
  final Widget Function(BuildContext context, AnimationController controller)
  builder;
  final Color orbA;
  final Color orbB;

  const AnimatedBgScaffold({
    super.key,
    required this.builder,
    this.orbA = AppColors2.blue,
    this.orbB = AppColors2.cyan,
  });

  @override
  State<AnimatedBgScaffold> createState() => _AnimatedBgScaffoldState();
}

class _AnimatedBgScaffoldState extends State<AnimatedBgScaffold>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
    _anim = Tween<double>(
      begin: 0,
      end: 6.2832,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.linear));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _ctrl);
  }
}
