
import 'dart:ui';

import 'package:flutter/material.dart';

class ProfileItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  ProfileItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });


}