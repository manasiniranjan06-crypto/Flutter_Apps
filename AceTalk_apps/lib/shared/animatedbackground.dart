// lib/shared/widgets/animated_bg.dart
import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedBgPainter extends CustomPainter {
  final double t;
  const AnimatedBgPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF040C18), Color(0xFF071526), Color(0xFF040C18)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    _drawOrb(canvas,
        center: Offset(
          size.width * (0.15 + 0.08 * sin(t * pi * 2)),
          size.height * (0.15 + 0.06 * cos(t * pi * 2)),
        ),
        radius: size.width * 0.55,
        color: const Color(0xFF2979FF).withOpacity(0.09));

    _drawOrb(canvas,
        center: Offset(
          size.width * (0.85 + 0.05 * cos(t * pi * 2)),
          size.height * (0.75 + 0.06 * sin(t * pi * 2)),
        ),
        radius: size.width * 0.5,
        color: const Color(0xFF00E5FF).withOpacity(0.06));

    _drawOrb(canvas,
        center: Offset(
          size.width * 0.5,
          size.height * (0.5 + 0.04 * sin(t * pi * 2 + 1)),
        ),
        radius: size.width * 0.3,
        color: const Color(0xFF1565C0).withOpacity(0.05));

    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.022)
      ..strokeWidth = 0.5;
    const step = 38.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  void _drawOrb(Canvas canvas,
      {required Offset center, required double radius, required Color color}) {
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(colors: [color, Colors.transparent])
            .createShader(Rect.fromCircle(center: center, radius: radius)),
    );
  }

  @override
  bool shouldRepaint(AnimatedBgPainter old) => old.t != t;
}

/// Drop this into any Scaffold body as the first Stack child.
class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0, end: 1).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => CustomPaint(
        painter: AnimatedBgPainter(_anim.value),
        size: MediaQuery.of(context).size,
      ),
    );
  }
}