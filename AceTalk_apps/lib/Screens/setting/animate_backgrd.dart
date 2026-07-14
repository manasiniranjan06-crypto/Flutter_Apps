import 'dart:math';
import 'package:ai_interview_app/Screens/setting/color_palet.dart';
import 'package:flutter/material.dart';

class BgPainter extends CustomPainter {
  final double t;
  final Color orbA;
  final Color orbB;

  const BgPainter(
    this.t, {
    this.orbA = AppColors2.blue,
    this.orbB = AppColors2.cyan,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Base gradient
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF030A14), Color(0xFF05101E), Color(0xFF030A14)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    // Animated orbs
    for (var i = 0; i < 2; i++) {
      final cx = size.width  * (i == 0 ? 0.15 : 0.85) + cos(t + i * pi) * size.width  * 0.1;
      final cy = size.height * (i == 0 ? 0.18 : 0.78) + sin(t * 0.7 + i * pi) * size.height * 0.04;
      final col = i == 0 ? orbA : orbB;
      canvas.drawCircle(
        Offset(cx, cy),
        size.width * 0.48,
        Paint()
          ..shader = RadialGradient(
            colors: [col.withOpacity(0.13), Colors.transparent],
          ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: size.width * 0.48)),
      );
    }

    // Grid
    final grid = Paint()
      ..color = Colors.white.withOpacity(0.016)
      ..strokeWidth = 0.5;
    for (double x = 0; x < size.width;  x += 44) canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    for (double y = 0; y < size.height; y += 44) canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
  }

  @override
  bool shouldRepaint(BgPainter old) => old.t != t;
}