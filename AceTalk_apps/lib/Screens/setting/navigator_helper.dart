import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// App-wide navigation utilities
class AppNav {
  AppNav._();

  /// Slide-in from right
  static Future<T?> push<T>(BuildContext context, Widget page) {
    HapticFeedback.selectionClick();
    return Navigator.push<T>(
      context,
      PageRouteBuilder(
        pageBuilder: (_, a, b) => page,
        transitionsBuilder: (_, a, b, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  /// Replace entire stack (used after logout)
  static Future<T?> pushAndRemoveUntil<T>(BuildContext context, Widget page) {
    return Navigator.pushAndRemoveUntil<T>(
      context,
      MaterialPageRoute(builder: (_) => page),
      (r) => false,
    );
  }
}