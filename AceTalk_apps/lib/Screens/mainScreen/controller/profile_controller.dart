import 'package:ai_interview_app/Screens/mainScreen/model/profile_model.dart';
import 'package:flutter/widgets.dart';

class ProfileController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNoController = TextEditingController();
  final skillController = TextEditingController();
  final locationController = TextEditingController();

  String? selectedRole;
  // ignore: non_constant_identifier_names
  String? SelectedExp;
  // ignore: non_constant_identifier_names
  String? SelectedEdu;

  //profile model class
  ProfileModel buildProfile() {
    return ProfileModel(
      phoneNo:phoneNoController.text.trim(),
      education: SelectedEdu ?? "",
      email: emailController.text.trim(),
      experience: SelectedExp ?? "",
      location: locationController.text.trim(),
      name: nameController.text.trim(),
      skill: skillController.text.trim(),
      targetRole: selectedRole ?? "",
    );
  }

  //validation check

  bool isValid() {
    return nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        phoneNoController.text.isNotEmpty &&
        selectedRole != null &&
        SelectedExp != null;
  }

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    locationController.dispose();
    skillController.dispose();
    phoneNoController.dispose();
  }
}
