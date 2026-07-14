// models/profile_model.dart
import 'package:flutter/material.dart';

class ProfileModel {
  String fullName;
  String birthday;
  String phoneNumber;
  String instagram;
  String email;
  String? profileImagePath;

  ProfileModel({
    required this.fullName,
    required this.birthday,
    required this.phoneNumber,
    required this.instagram,
    required this.email,
    this.profileImagePath,
  });

  // Create a copy with updated fields
  ProfileModel copyWith({
    String? fullName,
    String? birthday,
    String? phoneNumber,
    String? instagram,
    String? email,
    String? profileImagePath,
  }) {
    return ProfileModel(
      fullName: fullName ?? this.fullName,
      birthday: birthday ?? this.birthday,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      instagram: instagram ?? this.instagram,
      email: email ?? this.email,
      profileImagePath: profileImagePath ?? this.profileImagePath,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'birthday': birthday,
      'phoneNumber': phoneNumber,
      'instagram': instagram,
      'email': email,
      'profileImagePath': profileImagePath,
    };
  }

  // Create from JSON
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      fullName: json['fullName'] ?? '',
      birthday: json['birthday'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      instagram: json['instagram'] ?? '',
      email: json['email'] ?? '',
      profileImagePath: json['profileImagePath'],
    );
  }
}

// Menu item model for navigation buttons
class ProfileMenuItem {
  final String title;
  final IconData icon;
  final String route;
  final Color? color;

  ProfileMenuItem({
    required this.title,
    required this.icon,
    required this.route,
    this.color,
  });
}