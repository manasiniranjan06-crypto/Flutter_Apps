import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SQFLITE — single-row profile store
// ─────────────────────────────────────────────────────────────────────────────

class ProfileSqflite {
  ProfileSqflite._();
  static final ProfileSqflite instance = ProfileSqflite._();
  static Database? _db;

  Future<Database> _getDb() async {
    if (_db != null) return _db!;
    _db = await openDatabase(
      p.join(await getDatabasesPath(), 'Profile.db'),
      version: 1,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE PROFILEDATA (
            id         INTEGER PRIMARY KEY,
            name       TEXT,
            email      TEXT,
            phoneNo    TEXT,
            location   TEXT,
            skill      TEXT,
            targetRole TEXT,
            experience TEXT,
            education  TEXT,
            imagepath  TEXT
          )
        ''');
      },
    );
    return _db!;
  }

  Future<Map<String, dynamic>?> getProfile() async {
    final db = await _getDb();
    final rows = await db.query('PROFILEDATA', where: 'id = ?', whereArgs: [1]);
    return rows.isNotEmpty ? Map<String, dynamic>.from(rows.first) : null;
  }

  Future<void> saveProfile(Map<String, dynamic> data) async {
    final db = await _getDb();
    await db.insert('PROFILEDATA', {
      ...data,
      'id': 1,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteProfile() async {
    final db = await _getDb();
    await db.delete('PROFILEDATA', where: 'id = ?', whereArgs: [1]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PROFILE CONTROLLER
// ─────────────────────────────────────────────────────────────────────────────

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

// ─────────────────────────────────────────────────────────────────────────────
// PROFILE SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  final _ctrl = ProfileController();
  final _picker = ImagePicker();

  File? profileImage;
  bool isSaving = false;
  bool saved = false;
  bool _loading = true;

  final Map<String, String?> _errors = {};
  int _activeSection = 0;
  final List<String> _sections = ['Personal', 'Professional', 'Preferences'];

  // ── Animations ──
  late AnimationController _bgController;
  late AnimationController _avatarController;
  late AnimationController _contentController;
  late AnimationController _saveController;

  late Animation<double> _bgAnim;
  late Animation<double> _avatarScale;
  late Animation<double> _avatarGlow;
  late Animation<double> _contentFade;
  late Animation<Offset> _contentSlide;
  late Animation<double> _saveScale;

  // ── Colors ──
  static const Color _bgDark = Color(0xFF040C18);
  static const Color _surface1 = Color(0xFF0B1A2E);
  static const Color _accentCyan = Color(0xFF00E5FF);
  static const Color _accentBlue = Color(0xFF2979FF);
  static const Color _accentGold = Color(0xFFFFD740);
  static const Color _successGreen = Color(0xFF00E676);
  static const Color _dangerRed = Color(0xFFFF3D57);
  static const Color _textPrimary = Color(0xFFE8F4FD);
  static const Color _textSecondary = Color(0xFF6B9AB8);

  // ─────────────────────────────────────────────────────────────────────────
  // LIFECYCLE
  // ─────────────────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadProfile();
  }

  void _setupAnimations() {
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);

    _avatarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    _saveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _bgAnim = Tween<double>(begin: 0, end: 1).animate(_bgController);

    _avatarScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _avatarController, curve: Curves.elasticOut),
    );

    _avatarGlow = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _bgController, curve: Curves.easeInOut));

    _contentFade = CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeOut,
    );

    _contentSlide =
        Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _contentController,
            curve: Curves.easeOutCubic,
          ),
        );

    _saveScale = Tween<double>(
      begin: 1.0,
      end: 0.94,
    ).animate(CurvedAnimation(parent: _saveController, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _bgController.dispose();
    _avatarController.dispose();
    _contentController.dispose();
    _saveController.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // LOAD FROM SQFLITE
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> _loadProfile() async {
    final data = await ProfileSqflite.instance.getProfile();
    if (!mounted) return;
    if (data != null) {
      setState(() {
        _ctrl.nameController.text = data['name'] ?? '';
        _ctrl.emailController.text = data['email'] ?? '';
        _ctrl.phoneNoController.text = data['phoneNo'] ?? '';
        _ctrl.locationController.text = data['location'] ?? '';
        _ctrl.skillController.text = data['skill'] ?? '';
        _ctrl.selectedRole = data['targetRole'] as String?;
        _ctrl.selectedExp = data['experience'] as String?;
        _ctrl.selectedEdu = data['education'] as String?;
        final path = data['imagepath'] as String?;
        if (path != null && File(path).existsSync()) {
          profileImage = File(path);
        }
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // IMAGE PICKER
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> pickImage() async {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _buildImageSourceSheet(),
    );
  }

  Widget _buildImageSourceSheet() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: _surface1.withOpacity(0.95),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Change Profile Photo",
                style: GoogleFonts.dmSans(
                  color: _textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              _sourceOption(
                icon: Icons.photo_library_rounded,
                label: "Choose from Gallery",
                color: _accentCyan,
                onTap: () async {
                  Navigator.pop(context);
                  final img = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (img != null) {
                    setState(() => profileImage = File(img.path));
                    _showSnackbar(
                      "Photo updated!",
                      _successGreen,
                      Icons.check_circle_rounded,
                    );
                  }
                },
              ),
              const SizedBox(height: 10),
              _sourceOption(
                icon: Icons.camera_alt_rounded,
                label: "Take a Photo",
                color: _accentBlue,
                onTap: () async {
                  Navigator.pop(context);
                  final img = await _picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (img != null) {
                    setState(() => profileImage = File(img.path));
                    _showSnackbar(
                      "Photo updated!",
                      _successGreen,
                      Icons.check_circle_rounded,
                    );
                  }
                },
              ),
              if (profileImage != null) ...[
                const SizedBox(height: 10),
                _sourceOption(
                  icon: Icons.delete_outline_rounded,
                  label: "Remove Photo",
                  color: _dangerRed,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => profileImage = null);
                    _showSnackbar(
                      "Photo removed.",
                      _dangerRed,
                      Icons.delete_rounded,
                    );
                  },
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sourceOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 14),
            Text(
              label,
              style: GoogleFonts.dmSans(
                color: _textPrimary,
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: _textSecondary,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // VALIDATE & SAVE
  // ─────────────────────────────────────────────────────────────────────────

  bool _validate() {
    final errs = <String, String?>{};
    final name = _ctrl.nameController.text.trim();
    final email = _ctrl.emailController.text.trim();
    final phone = _ctrl.phoneNoController.text.trim();

    if (name.isEmpty) errs['name'] = "Name is required";
    if (email.isEmpty) {
      errs['email'] = "Email is required";
    } else if (!RegExp(r'^[\w.-]+@[\w.-]+\.\w+$').hasMatch(email)) {
      errs['email'] = "Enter a valid email";
    }
    if (phone.isNotEmpty && !RegExp(r'^\+?[0-9]{10,13}$').hasMatch(phone)) {
      errs['phone'] = "Enter a valid phone number";
    }

    setState(() => _errors.addAll(errs));
    return errs.isEmpty;
  }

  Future<void> _saveProfile() async {
    if (!_validate()) {
      HapticFeedback.mediumImpact();
      _showSnackbar(
        "Please fix the errors before saving.",
        _dangerRed,
        Icons.error_rounded,
      );
      return;
    }

    setState(() => isSaving = true);

    final data = {
      'name': _ctrl.nameController.text.trim(),
      'email': _ctrl.emailController.text.trim(),
      'phoneNo': _ctrl.phoneNoController.text.trim(),
      'location': _ctrl.locationController.text.trim(),
      'skill': _ctrl.skillController.text.trim(),
      'targetRole': _ctrl.selectedRole,
      'experience': _ctrl.selectedExp,
      'education': _ctrl.selectedEdu,
      'imagepath': profileImage?.path,
    };

    await ProfileSqflite.instance.saveProfile(data);

    if (!mounted) return;
    setState(() {
      isSaving = false;
      saved = true;
    });

    _showSnackbar("Profile saved!", _successGreen, Icons.check_circle_rounded);

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => saved = false);
    });
  }

  void _showSnackbar(String msg, Color color, IconData icon) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: const Duration(seconds: 3),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: _surface1,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.4), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.15),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  msg,
                  style: GoogleFonts.dmSans(
                    color: _textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: _bgDark,
        body: const Center(
          child: CircularProgressIndicator(color: _accentCyan, strokeWidth: 2),
        ),
      );
    }

    return Scaffold(
      backgroundColor: _bgDark,
      extendBodyBehindAppBar: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,
              Color(0xFF0A1929),
              Color.fromARGB(255, 3, 58, 107),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Animated background
            AnimatedBuilder(
              animation: _bgAnim,
              builder: (_, __) => CustomPaint(
                painter: _ProfileBgPainter(_bgAnim.value),
                size: MediaQuery.of(context).size,
              ),
            ),

            // Content
            FadeTransition(
              opacity: _contentFade,
              child: SlideTransition(
                position: _contentSlide,
                child: SafeArea(
                  child: Column(
                    children: [
                      _buildAppBar(),
                      _buildAvatarSection(),
                      const SizedBox(height: 16),
                      _buildSectionTabs(),
                      const SizedBox(height: 14),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(18, 0, 18, 30),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 350),
                            switchInCurve: Curves.easeOutCubic,
                            switchOutCurve: Curves.easeInCubic,
                            transitionBuilder: (child, anim) => FadeTransition(
                              opacity: anim,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0.05, 0),
                                  end: Offset.zero,
                                ).animate(anim),
                                child: child,
                              ),
                            ),
                            child: _buildActiveSection(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── APP BAR ─────────────────────────────────────────────────────────────

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Edit Profile",
                style: GoogleFonts.dmSans(
                  color: _textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                "Update your information",
                style: GoogleFonts.dmSans(color: _textSecondary, fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          AnimatedBuilder(
            animation: _bgAnim,
            builder: (_, __) => Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _accentCyan.withOpacity(0.5 + 0.5 * _bgAnim.value),
                boxShadow: [
                  BoxShadow(
                    color: _accentCyan.withOpacity(0.4 * _bgAnim.value),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── AVATAR ──────────────────────────────────────────────────────────────

  Widget _buildAvatarSection() {
    return ScaleTransition(
      scale: _avatarScale,
      child: Column(
        children: [
          GestureDetector(
            onTap: pickImage,
            child: AnimatedBuilder(
              animation: _avatarGlow,
              builder: (_, __) => Stack(
                alignment: Alignment.center,
                children: [
                  // Glow ring
                  Container(
                    width: 108,
                    height: 108,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _accentCyan.withOpacity(
                            0.2 * _avatarGlow.value,
                          ),
                          blurRadius: 24,
                          spreadRadius: 4,
                        ),
                      ],
                      gradient: SweepGradient(
                        colors: [
                          _accentCyan.withOpacity(0.6),
                          _accentBlue.withOpacity(0.6),
                          _accentCyan.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                  // Avatar
                  Container(
                    width: 102,
                    height: 102,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: _bgDark, width: 3),
                    ),
                    child: ClipOval(
                      child: profileImage != null
                          ? Image.file(profileImage!, fit: BoxFit.cover)
                          : Image.asset(
                              "assets/images/profile.jpg",
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: _surface1,
                                child: const Icon(
                                  Icons.person_rounded,
                                  color: _textSecondary,
                                  size: 48,
                                ),
                              ),
                            ),
                    ),
                  ),
                  // Camera badge
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _accentBlue,
                        border: Border.all(color: _bgDark, width: 2),
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _ctrl.nameController.text.isEmpty
                ? "Your Name"
                : _ctrl.nameController.text,
            style: GoogleFonts.dmSans(
              color: _textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            _ctrl.selectedRole ?? "Role not selected",
            style: GoogleFonts.dmSans(color: _textSecondary, fontSize: 12.5),
          ),
        ],
      ),
    );
  }

  // ─── SECTION TABS ────────────────────────────────────────────────────────

  Widget _buildSectionTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: _sections.asMap().entries.map((e) {
                final active = _activeSection == e.key;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _activeSection = e.key);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: active ? _accentBlue : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: active
                            ? [
                                BoxShadow(
                                  color: _accentBlue.withOpacity(0.3),
                                  blurRadius: 10,
                                ),
                              ]
                            : [],
                      ),
                      child: Text(
                        e.value,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                          color: active ? Colors.white : _textSecondary,
                          fontSize: 13,
                          fontWeight: active
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  // ─── SECTIONS ────────────────────────────────────────────────────────────

  Widget _buildActiveSection() {
    switch (_activeSection) {
      case 0:
        return _buildPersonalSection();
      case 1:
        return _buildProfessionalSection();
      case 2:
        return _buildPreferencesSection();
      default:
        return _buildPersonalSection();
    }
  }

  Widget _buildPersonalSection() {
    return Column(
      key: const ValueKey('personal'),
      children: [
        _GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionHeader(
                "Personal Info",
                Icons.person_rounded,
                _accentCyan,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Full Name",
                hint: "e.g. Arjun Sharma",
                controller: _ctrl.nameController,
                icon: Icons.badge_rounded,
                error: _errors['name'],
                onChanged: (_) => setState(() => _errors.remove('name')),
              ),
              _buildTextField(
                label: "Email Address",
                hint: "e.g. arjun@email.com",
                controller: _ctrl.emailController,
                icon: Icons.email_rounded,
                keyboardType: TextInputType.emailAddress,
                error: _errors['email'],
                onChanged: (_) => setState(() => _errors.remove('email')),
              ),
              _buildTextField(
                label: "Mobile Number",
                hint: "e.g. +91 9876543210",
                controller: _ctrl.phoneNoController,
                icon: Icons.phone_rounded,
                keyboardType: TextInputType.phone,
                error: _errors['phone'],
                onChanged: (_) => setState(() => _errors.remove('phone')),
              ),
              _buildTextField(
                label: "Location",
                hint: "e.g. Mumbai, India",
                controller: _ctrl.locationController,
                icon: Icons.location_on_rounded,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildSaveButton(),
      ],
    );
  }

  Widget _buildProfessionalSection() {
    return Column(
      key: const ValueKey('professional'),
      children: [
        _GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionHeader(
                "Professional Info",
                Icons.work_rounded,
                _accentBlue,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Skills",
                hint: "e.g. Flutter, Dart, Firebase",
                controller: _ctrl.skillController,
                icon: Icons.star_rounded,
                maxLines: 3,
              ),
              _buildDropdown(
                label: "Target Role",
                hint: "Select your target role",
                icon: Icons.business_center_rounded,
                items: const [
                  "Flutter Developer",
                  "Web Developer",
                  "Data Analyst",
                  "UI/UX Designer",
                  "Backend Developer",
                  "Full Stack Developer",
                ],
                value: _ctrl.selectedRole,
                onChanged: (v) => setState(() => _ctrl.selectedRole = v),
              ),
              _buildDropdown(
                label: "Years of Experience",
                hint: "Select experience level",
                icon: Icons.timeline_rounded,
                items: const ["Fresher", "1-3 Years", "3-5 Years", "5+ Years"],
                value: _ctrl.selectedExp,
                onChanged: (v) => setState(() => _ctrl.selectedExp = v),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildSaveButton(),
      ],
    );
  }

  Widget _buildPreferencesSection() {
    return Column(
      key: const ValueKey('preferences'),
      children: [
        _GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionHeader(
                "Education & Preferences",
                Icons.school_rounded,
                _accentGold,
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: "Highest Education",
                hint: "Select your education",
                icon: Icons.school_rounded,
                items: const [
                  "B.Tech",
                  "M.Tech",
                  "BCA",
                  "MCA",
                  "MBA",
                  "B.Sc",
                  "M.Sc",
                ],
                value: _ctrl.selectedEdu,
                onChanged: (v) => setState(() => _ctrl.selectedEdu = v),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _buildCompletionCard(),
        const SizedBox(height: 20),
        _buildSaveButton(),
      ],
    );
  }

  // ─── COMPLETION METER ────────────────────────────────────────────────────

  Widget _buildCompletionCard() {
    int filled = 0;
    if (_ctrl.nameController.text.isNotEmpty) filled++;
    if (_ctrl.emailController.text.isNotEmpty) filled++;
    if (_ctrl.phoneNoController.text.isNotEmpty) filled++;
    if (_ctrl.locationController.text.isNotEmpty) filled++;
    if (_ctrl.skillController.text.isNotEmpty) filled++;
    if (_ctrl.selectedRole != null) filled++;
    if (_ctrl.selectedExp != null) filled++;
    if (_ctrl.selectedEdu != null) filled++;
    if (profileImage != null) filled++;

    const total = 9;
    final pct = filled / total;

    return _GlassCard(
      accentColor: _accentGold.withOpacity(0.06),
      borderColor: _accentGold.withOpacity(0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.pie_chart_rounded, color: _accentGold, size: 18),
              const SizedBox(width: 8),
              Text(
                "Profile Completion",
                style: GoogleFonts.dmSans(
                  color: _textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                "${(pct * 100).toInt()}%",
                style: GoogleFonts.spaceMono(
                  color: _accentGold,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation<Color>(
                pct >= 0.8 ? _successGreen : _accentGold,
              ),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            pct >= 1.0
                ? "Your profile is complete! 🎉"
                : "$filled of $total fields filled. Complete your profile for better results.",
            style: GoogleFonts.dmSans(color: _textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // ─── SAVE BUTTON ─────────────────────────────────────────────────────────

  Widget _buildSaveButton() {
    return ScaleTransition(
      scale: _saveScale,
      child: GestureDetector(
        onTapDown: (_) => _saveController.forward(),
        onTapCancel: () => _saveController.reverse(),
        onTapUp: (_) async {
          await _saveController.reverse();
          _saveProfile();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: saved
                ? LinearGradient(
                    colors: [_successGreen.withOpacity(0.8), _successGreen],
                  )
                : const LinearGradient(
                    colors: [
                      Color(0xFF1565C0),
                      Color(0xFF2979FF),
                      Color(0xFF00B0FF),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
            boxShadow: [
              BoxShadow(
                color: (saved ? _successGreen : _accentBlue).withOpacity(0.35),
                blurRadius: 20,
                spreadRadius: 1,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: isSaving
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        saved ? Icons.check_circle_rounded : Icons.save_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        saved ? "Saved!" : "Save Changes",
                        style: GoogleFonts.dmSans(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  // ─── HELPERS ─────────────────────────────────────────────────────────────

  Widget _sectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 17),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.dmSans(
            color: _textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    String? error,
    TextInputType? keyboardType,
    int maxLines = 1,
    Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.dmSans(
              color: _textSecondary,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            style: GoogleFonts.dmSans(
              color: _textPrimary,
              fontSize: 14.5,
              height: 1.5,
            ),
            keyboardType: keyboardType,
            maxLines: maxLines,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.dmSans(
                color: Colors.white24,
                fontSize: 13.5,
              ),
              prefixIcon: Icon(
                icon,
                color: error != null ? _dangerRed : _textSecondary,
                size: 18,
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.04),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: error != null
                      ? _dangerRed.withOpacity(0.5)
                      : Colors.white10,
                  width: 1.2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: error != null
                      ? _dangerRed
                      : _accentCyan.withOpacity(0.5),
                  width: 1.5,
                ),
              ),
              errorText: error,
              errorStyle: GoogleFonts.dmSans(color: _dangerRed, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String hint,
    required IconData icon,
    required List<String> items,
    required String? value,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.dmSans(
              color: _textSecondary,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: value,
            dropdownColor: const Color(0xFF0D1F35),
            borderRadius: BorderRadius.circular(16),
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: _textSecondary,
              size: 20,
            ),
            hint: Text(
              hint,
              style: GoogleFonts.dmSans(color: Colors.white24, fontSize: 13.5),
            ),
            items: items
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      e,
                      style: GoogleFonts.dmSans(
                        color: _textPrimary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: _textSecondary, size: 18),
              filled: true,
              fillColor: Colors.white.withOpacity(0.04),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Colors.white10, width: 1.2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: _accentCyan.withOpacity(0.4),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GLASS CARD
// ─────────────────────────────────────────────────────────────────────────────

class _GlassCard extends StatelessWidget {
  final Widget child;
  final Color? accentColor;
  final Color? borderColor;

  const _GlassCard({required this.child, this.accentColor, this.borderColor});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: accentColor ?? Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(22),
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

// ─────────────────────────────────────────────────────────────────────────────
// BACKGROUND PAINTER
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileBgPainter extends CustomPainter {
  final double t;
  _ProfileBgPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()
      ..shader = const LinearGradient(
        colors: [
          Colors.black,
          Color(0xFF0A1929),
          Color.fromARGB(255, 3, 58, 107),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bg);

    _orb(
      canvas,
      Offset(
        size.width * (0.2 + 0.06 * sin(t * pi * 2)),
        size.height * (0.15 + 0.05 * cos(t * pi * 2)),
      ),
      size.width * 0.5,
      const Color(0xFF2979FF).withOpacity(0.1),
    );

    _orb(
      canvas,
      Offset(
        size.width * (0.8 + 0.04 * cos(t * pi * 2)),
        size.height * (0.8 + 0.05 * sin(t * pi * 2 + 1)),
      ),
      size.width * 0.45,
      const Color(0xFF00E5FF).withOpacity(0.06),
    );

    _orb(
      canvas,
      Offset(size.width * 0.5, size.height * 0.12),
      size.width * 0.35,
      const Color(0xFF00E5FF).withOpacity(0.07 * (0.5 + 0.5 * t)),
    );

    final grid = Paint()
      ..color = Colors.white.withOpacity(0.02)
      ..strokeWidth = 0.5;
    for (double x = 0; x < size.width; x += 36) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y < size.height; y += 36) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
  }

  void _orb(Canvas canvas, Offset center, double r, Color color) {
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..shader = RadialGradient(
          colors: [color, Colors.transparent],
        ).createShader(Rect.fromCircle(center: center, radius: r)),
    );
  }

  @override
  bool shouldRepaint(_ProfileBgPainter old) => old.t != t;
}
