

import 'package:flutter/material.dart';

class ProfileController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNoController = TextEditingController();
  final locationController = TextEditingController();
  final skillController = TextEditingController();

  String? selectedRole;
  String? selectedExp;
  String? selectedEdu;

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneNoController.dispose();
    locationController.dispose();
    skillController.dispose();
  }
}