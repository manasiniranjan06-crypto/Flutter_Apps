// lib/shared/widgets/glass_card.dart
import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final Color? accentColor;
  final Color? borderColor;
  final EdgeInsets? padding;
  final double borderRadius;

  const GlassCard({
    super.key,
    required this.child,
    this.accentColor,
    this.borderColor,
    this.padding,
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: padding ?? const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: accentColor ?? Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor ?? Colors.white.withOpacity(0.09),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}