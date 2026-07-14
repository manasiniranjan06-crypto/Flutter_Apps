class UserModel {
  String? email;
  String? password;
  String? confirmPassword;
  String? phone;

  UserModel({this.email, this.password, this.confirmPassword, this.phone});

  set name(String name) {}

  bool validateEmail() {
    if (email == null || email!.isEmpty) return false;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email!);
  }

  bool validatePassword() {
    return password != null && password!.length >= 6;
  }

  bool validateConfirmPassword() {
    return confirmPassword == password;
  }

  bool validatePhone() {
    if (phone == null || phone!.isEmpty) return false;
    return phone!.length >= 10;
  }
}