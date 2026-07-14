// controllers/profile_controller.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// Profile Model
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

// Menu Item Model
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

// Profile Controller
class ProfileController extends ChangeNotifier {
  // Private profile data
  ProfileModel _profile = ProfileModel(
    fullName: 'Anna Avetisyan',
    birthday: 'January 15, 1995',
    phoneNumber: '818 123 4567',
    instagram: '@anna_avetisyan',
    email: 'info@aplusdesign.co',
  );

  // Private state variables
  File? _profileImage;
  bool _isEditing = false;
  bool _isLoading = false;
  String? _errorMessage;
  final ImagePicker _picker = ImagePicker();

  // Getters - Expose read-only data to the UI
  ProfileModel get profile => _profile;
  File? get profileImage => _profileImage;
  bool get isEditing => _isEditing;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Menu items for navigation
  List<ProfileMenuItem> get menuItems => [
    ProfileMenuItem(
      title: 'My Orders',
      icon: Icons.shopping_bag_outlined,
      route: '/orders',
    ),
    ProfileMenuItem(
      title: 'Favorites',
      icon: Icons.favorite_outline,
      route: '/favorites',
    ),
    ProfileMenuItem(
      title: 'Saved Addresses',
      icon: Icons.location_on_outlined,
      route: '/addresses',
    ),
    ProfileMenuItem(
      title: 'Settings',
      icon: Icons.settings_outlined,
      route: '/settings',
    ),
    ProfileMenuItem(
      title: 'Help & Support',
      icon: Icons.help_outline,
      route: '/help',
    ),
  ];

  // Initialize controller - can load saved data
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      await loadProfile();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load profile: $e';
      debugPrint(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Toggle edit mode
  void toggleEditMode() {
    _isEditing = !_isEditing;
    notifyListeners();
  }

  // Enable edit mode
  void enableEditMode() {
    _isEditing = true;
    notifyListeners();
  }

  // Disable edit mode
  void disableEditMode() {
    _isEditing = false;
    notifyListeners();
  }

  // Update profile data
  void updateProfile({
    String? fullName,
    String? birthday,
    String? phoneNumber,
    String? instagram,
    String? email,
  }) {
    _profile = _profile.copyWith(
      fullName: fullName,
      birthday: birthday,
      phoneNumber: phoneNumber,
      instagram: instagram,
      email: email,
    );
    _isEditing = false;
    _errorMessage = null;
    notifyListeners();
    
    // Auto-save after update
    saveProfile();
  }

  // Validate profile data
  bool validateProfile({
    required String fullName,
    required String email,
    required String phoneNumber,
  }) {
    if (fullName.trim().isEmpty) {
      _errorMessage = 'Full name is required';
      notifyListeners();
      return false;
    }

    if (email.trim().isEmpty || !_isValidEmail(email)) {
      _errorMessage = 'Valid email is required';
      notifyListeners();
      return false;
    }

    if (phoneNumber.trim().isEmpty) {
      _errorMessage = 'Phone number is required';
      notifyListeners();
      return false;
    }

    _errorMessage = null;
    notifyListeners();
    return true;
  }

  // Email validation helper
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // Pick image from gallery or camera
  Future<bool> pickImage(ImageSource source) async {
    try {
      _errorMessage = null;
      notifyListeners();

      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        _profileImage = File(pickedFile.path);
        _profile = _profile.copyWith(profileImagePath: pickedFile.path);
        notifyListeners();
        
        // Auto-save after image update
        await saveProfile();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Error picking image: $e';
      debugPrint(_errorMessage);
      notifyListeners();
      return false;
    }
  }

  // Remove profile image
  void removeProfileImage() {
    _profileImage = null;
    _profile = _profile.copyWith(profileImagePath: null);
    notifyListeners();
    
    // Auto-save after removal
    saveProfile();
  }

  // Load profile image from path
  void loadProfileImageFromPath(String? path) {
    if (path != null && path.isNotEmpty) {
      final file = File(path);
      if (file.existsSync()) {
        _profileImage = file;
        notifyListeners();
      }
    }
  }

  // Load profile from storage (implement with SharedPreferences or API)
  Future<void> loadProfile() async {
    try {
      // TODO: Implement loading from SharedPreferences or API
      // Example with SharedPreferences:
      // final prefs = await SharedPreferences.getInstance();
      // final jsonString = prefs.getString('profile_data');
      // if (jsonString != null) {
      //   final jsonData = jsonDecode(jsonString);
      //   _profile = ProfileModel.fromJson(jsonData);
      //   loadProfileImageFromPath(_profile.profileImagePath);
      // }
      
      // For now, just load the default profile
      debugPrint('Profile loaded: ${_profile.fullName}');
      
      // Load profile image if path exists
      if (_profile.profileImagePath != null) {
        loadProfileImageFromPath(_profile.profileImagePath);
      }
    } catch (e) {
      throw Exception('Failed to load profile: $e');
    }
  }

  // Save profile to storage (implement with SharedPreferences or API)
  Future<void> saveProfile() async {
    try {
      // TODO: Implement saving to SharedPreferences or API
      // Example with SharedPreferences:
      // final prefs = await SharedPreferences.getInstance();
      // final jsonString = jsonEncode(_profile.toJson());
      // await prefs.setString('profile_data', jsonString);
      
      debugPrint('Profile saved: ${_profile.fullName}');
    } catch (e) {
      _errorMessage = 'Failed to save profile: $e';
      debugPrint(_errorMessage);
      notifyListeners();
    }
  }

  // Update specific field
  void updateField(String field, String value) {
    switch (field) {
      case 'fullName':
        _profile = _profile.copyWith(fullName: value);
        break;
      case 'birthday':
        _profile = _profile.copyWith(birthday: value);
        break;
      case 'phoneNumber':
        _profile = _profile.copyWith(phoneNumber: value);
        break;
      case 'instagram':
        _profile = _profile.copyWith(instagram: value);
        break;
      case 'email':
        _profile = _profile.copyWith(email: value);
        break;
    }
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Reset profile to default
  void resetProfile() {
    _profile = ProfileModel(
      fullName: 'Anna Avetisyan',
      birthday: 'January 15, 1995',
      phoneNumber: '818 123 4567',
      instagram: '@anna_avetisyan',
      email: 'info@aplusdesign.co',
    );
    _profileImage = null;
    _isEditing = false;
    _errorMessage = null;
    notifyListeners();
  }

  // Logout - clear all user data
  Future<void> logout() async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Implement API logout call if needed
      // await AuthService.logout();

      // Clear profile data
      _profile = ProfileModel(
        fullName: '',
        birthday: '',
        phoneNumber: '',
        instagram: '',
        email: '',
      );
      _profileImage = null;
      _isEditing = false;
      _errorMessage = null;

      // TODO: Clear stored data
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.clear();

      debugPrint('User logged out successfully');
    } catch (e) {
      _errorMessage = 'Logout failed: $e';
      debugPrint(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh profile (reload from API)
  Future<void> refreshProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      await loadProfile();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to refresh profile: $e';
      debugPrint(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Dispose resources
  @override
  void dispose() {
    // Clean up any resources if needed
    debugPrint('ProfileController disposed');
    super.dispose();
  }
}