

class ProfileModel {
  int? Id;
  String name;
  String location;
  String email;
  String phoneNo;
  String targetRole;
  String experience;
  String skill;
  String education;
  String? imgpath;

  ProfileModel({
    this.Id,
    required this.education,
    required this.email,
    required this.experience,
    required this.location,
    this.imgpath,
    required this.name,
    required this.phoneNo,
    required this.skill,
    required this.targetRole,
  });
}
