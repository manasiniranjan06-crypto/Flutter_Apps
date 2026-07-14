import 'dart:math';
import 'dart:ui';

import 'package:ai_interview_app/Screens/setting/animate_backgrd.dart';
import 'package:ai_interview_app/Screens/setting/color_palet.dart';
import 'package:ai_interview_app/Screens/setting/resuable_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with SingleTickerProviderStateMixin {
  User? get _user => FirebaseAuth.instance.currentUser;
  late AnimationController _bgCtrl;
  late Animation<double> _bgAnim;

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();

  bool _editMode = false;
  bool _saving = false;

  final _curPassCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  final _confPassCtrl = TextEditingController();
  bool _showCurPass = false;
  bool _showNewPass = false;
  bool _showConfPass = false;
  bool _passExpanded = false;
  bool _resumeExpanded = false;

  bool _linkedinConnected = false;
  bool _githubConnected = false;
  bool _googleConnected = false;

  static const _prefPhone = 'acc_phone';
  static const _prefLocation = 'acc_location';

  @override
  void initState() {
    super.initState();
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
    _bgAnim = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(CurvedAnimation(parent: _bgCtrl, curve: Curves.linear));
    _nameCtrl.text = _user?.displayName ?? '';
    _emailCtrl.text = _user?.email ?? '';
    _loadSavedFields();
  }

  Future<void> _loadSavedFields() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _phoneCtrl.text = prefs.getString(_prefPhone) ?? '';
      _locationCtrl.text = prefs.getString(_prefLocation) ?? '';
    });
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _locationCtrl.dispose();
    _curPassCtrl.dispose();
    _newPassCtrl.dispose();
    _confPassCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() => _saving = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefPhone, _phoneCtrl.text.trim());
    await prefs.setString(_prefLocation, _locationCtrl.text.trim());
    try {
      await _user?.updateDisplayName(_nameCtrl.text.trim());
    } catch (_) {}
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() {
      _saving = false;
      _editMode = false;
    });
    showAppSnack(
      context,
      'Profile updated successfully!',
      AppColors2.green,
      Icons.check_circle_rounded,
    );
  }

  Future<void> _changePassword() async {
    if (_newPassCtrl.text != _confPassCtrl.text) {
      showAppSnack(
        context,
        'Passwords do not match.',
        AppColors2.red,
        Icons.error_rounded,
      );
      return;
    }
    if (_newPassCtrl.text.length < 6) {
      showAppSnack(
        context,
        'Password must be at least 6 characters.',
        AppColors2.gold,
        Icons.warning_rounded,
      );
      return;
    }
    setState(() => _saving = true);
    try {
      await _user?.updatePassword(_newPassCtrl.text);
      if (!mounted) return;
      setState(() {
        _saving = false;
        _passExpanded = false;
      });
      _curPassCtrl.clear();
      _newPassCtrl.clear();
      _confPassCtrl.clear();
      showAppSnack(
        context,
        'Password changed successfully!',
        AppColors2.green,
        Icons.lock_rounded,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      showAppSnack(
        context,
        'Error: ${e.toString()}',
        AppColors2.red,
        Icons.error_rounded,
      );
    }
  }

  // ── Build ───────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors2.bg,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _bgAnim,
            builder: (_, __) => CustomPaint(
              painter: BgPainter(
                _bgAnim.value,
                orbA: AppColors2.cyan,
                orbB: AppColors2.blue,
              ),
              child: const SizedBox.expand(),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAvatarCard(),
                        const SizedBox(height: 22),
                        const SectionLabel('Profile Information'),
                        const SizedBox(height: 12),
                        _buildProfileInfoCard(),
                        const SizedBox(height: 22),
                        const SectionLabel('Connected Accounts'),
                        const SizedBox(height: 12),
                        _buildSocialConnections(),
                        const SizedBox(height: 22),
                        const SectionLabel('Resume'),
                        const SizedBox(height: 12),
                        _buildResumeSection(),
                        const SizedBox(height: 22),
                        const SectionLabel('Security'),
                        const SizedBox(height: 12),
                        _buildPasswordSection(),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── App bar ─────────────────────────────────────────────────────────────────
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors2.ts,
              size: 20,
            ),
          ),
          Text(
            'Account',
            style: GoogleFonts.spaceMono(
              fontSize: 18,
              color: AppColors2.tp,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          if (!_editMode)
            GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _editMode = true);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors2.cyan.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors2.cyan.withOpacity(0.35)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.edit_rounded,
                      color: AppColors2.cyan,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Edit',
                      style: GoogleFonts.dmSans(
                        color: AppColors2.cyan,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => setState(() => _editMode = false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.dmSans(
                        color: AppColors2.ts,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _saving ? null : _saveProfile,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors2.green.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors2.green.withOpacity(0.4),
                      ),
                    ),
                    child: _saving
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              color: AppColors2.green,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Save',
                            style: GoogleFonts.dmSans(
                              color: AppColors2.green,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  // ── Avatar card ─────────────────────────────────────────────────────────────
  Widget _buildAvatarCard() {
    final name = _nameCtrl.text.isEmpty
        ? (_user?.displayName ?? 'User')
        : _nameCtrl.text;
    final initials = name
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .take(2)
        .join()
        .toUpperCase();
    return GlassCard(
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppColors2.blue, AppColors2.cyan],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors2.cyan.withOpacity(0.4),
                      blurRadius: 18,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    initials.isEmpty ? 'U' : initials,
                    style: GoogleFonts.spaceMono(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors2.blue,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors2.bg, width: 2),
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ],
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _editMode ? 'Editing Profile' : name,
                  style: GoogleFonts.dmSans(
                    color: AppColors2.tp,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _user?.email ?? '',
                  style: GoogleFonts.dmSans(color: AppColors2.ts, fontSize: 12),
                ),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    AppTag('Verified', AppColors2.green),
                    SizedBox(width: 6),
                    AppTag('Pro', AppColors2.gold),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Profile info card ───────────────────────────────────────────────────────
  Widget _buildProfileInfoCard() {
    return GlassCard(
      child: Column(
        children: [
          _buildField(
            'Full Name',
            _nameCtrl,
            Icons.badge_rounded,
            AppColors2.cyan,
            enabled: _editMode,
          ),
          _buildField(
            'Email Address',
            _emailCtrl,
            Icons.email_rounded,
            AppColors2.blue,
            enabled: false,
            keyboardType: TextInputType.emailAddress,
          ),
          _buildField(
            'Phone Number',
            _phoneCtrl,
            Icons.phone_rounded,
            AppColors2.green,
            enabled: _editMode,
            keyboardType: TextInputType.phone,
            hint: '+91 9876543210',
          ),
          _buildField(
            'Location',
            _locationCtrl,
            Icons.location_on_rounded,
            AppColors2.gold,
            enabled: _editMode,
            hint: 'Mumbai, India',
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController ctrl,
    IconData icon,
    Color color, {
    bool enabled = true,
    TextInputType? keyboardType,
    String? hint,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.dmSans(
              color: AppColors2.ts,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: ctrl,
            enabled: enabled,
            keyboardType: keyboardType,
            style: GoogleFonts.dmSans(
              color: enabled ? AppColors2.tp : AppColors2.ts,
              fontSize: 14.5,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.dmSans(
                color: Colors.white24,
                fontSize: 13,
              ),
              prefixIcon: Icon(
                icon,
                color: enabled ? color : AppColors2.ts.withOpacity(0.5),
                size: 18,
              ),
              filled: true,
              fillColor: enabled ? color.withOpacity(0.05) : Colors.transparent,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: BorderSide(
                  color: enabled
                      ? color.withOpacity(0.3)
                      : Colors.white.withOpacity(0.06),
                  width: 1.2,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(0.06),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: BorderSide(
                  color: color.withOpacity(0.6),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Social connections ──────────────────────────────────────────────────────
  Widget _buildSocialConnections() {
    return GlassCard(
      child: Column(
        children: [
          _socialRow(
            'LinkedIn',
            Icons.link_rounded,
            AppColors2.blue,
            _linkedinConnected,
            (v) {
              setState(() => _linkedinConnected = v);
              showAppSnack(
                context,
                v ? 'LinkedIn connected!' : 'LinkedIn disconnected.',
                v ? AppColors2.green : AppColors2.ts,
                v ? Icons.check_circle_rounded : Icons.link_off_rounded,
              );
            },
          ),
          Divider(color: Colors.white.withOpacity(0.06), height: 20),
          _socialRow(
            'GitHub',
            Icons.code_rounded,
            AppColors2.purple,
            _githubConnected,
            (v) {
              setState(() => _githubConnected = v);
              showAppSnack(
                context,
                v ? 'GitHub connected!' : 'GitHub disconnected.',
                v ? AppColors2.green : AppColors2.ts,
                v ? Icons.check_circle_rounded : Icons.link_off_rounded,
              );
            },
          ),
          Divider(color: Colors.white.withOpacity(0.06), height: 20),
          _socialRow(
            'Google',
            Icons.g_mobiledata_rounded,
            AppColors2.gold,
            _googleConnected,
            (v) {
              setState(() => _googleConnected = v);
              showAppSnack(
                context,
                v ? 'Google connected!' : 'Google disconnected.',
                v ? AppColors2.green : AppColors2.ts,
                v ? Icons.check_circle_rounded : Icons.link_off_rounded,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _socialRow(
    String name,
    IconData icon,
    Color color,
    bool connected,
    ValueChanged<bool> onChanged,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withOpacity(0.25)),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: GoogleFonts.dmSans(
                  color: AppColors2.tp,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                connected ? 'Connected' : 'Not connected',
                style: GoogleFonts.dmSans(
                  color: connected ? AppColors2.green : AppColors2.ts,
                  fontSize: 11.5,
                ),
              ),
            ],
          ),
        ),
        AnimToggle(value: connected, onTap: () => onChanged(!connected)),
      ],
    );
  }

  // ── Resume section ──────────────────────────────────────────────────────────
  Widget _buildResumeSection() {
    return GlassCard(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() => _resumeExpanded = !_resumeExpanded);
            },
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: AppColors2.gold.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors2.gold.withOpacity(0.25),
                    ),
                  ),
                  child: const Icon(
                    Icons.description_rounded,
                    color: AppColors2.gold,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Resume / CV',
                        style: GoogleFonts.dmSans(
                          color: AppColors2.tp,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'No resume uploaded',
                        style: GoogleFonts.dmSans(
                          color: AppColors2.ts,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: _resumeExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors2.ts,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: [
                const SizedBox(height: 16),
                Divider(color: Colors.white.withOpacity(0.07)),
                const SizedBox(height: 14),
                _uploadOption(
                  Icons.upload_file_rounded,
                  'Upload from Storage',
                  'PDF, DOCX up to 5MB',
                  AppColors2.gold,
                ),
                const SizedBox(height: 10),
                _uploadOption(
                  Icons.cloud_upload_rounded,
                  'Import from Google Drive',
                  'Connect and pick a file',
                  AppColors2.blue,
                ),
                const SizedBox(height: 10),
                _uploadOption(
                  Icons.link_rounded,
                  'Paste LinkedIn URL',
                  'Auto-import from profile',
                  AppColors2.cyan,
                ),
              ],
            ),
            crossFadeState: _resumeExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _uploadOption(IconData icon, String title, String sub, Color color) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        showAppSnack(context, '$title — coming soon!', color, icon);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.dmSans(
                      color: AppColors2.tp,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    sub,
                    style: GoogleFonts.dmSans(
                      color: AppColors2.ts,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors2.ts,
              size: 13,
            ),
          ],
        ),
      ),
    );
  }

  // ── Password section ────────────────────────────────────────────────────────
  Widget _buildPasswordSection() {
    return GlassCard(
      borderColor: _passExpanded ? AppColors2.red.withOpacity(0.3) : null,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() => _passExpanded = !_passExpanded);
            },
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: AppColors2.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors2.red.withOpacity(0.25)),
                  ),
                  child: const Icon(
                    Icons.lock_rounded,
                    color: AppColors2.red,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Change Password',
                        style: GoogleFonts.dmSans(
                          color: AppColors2.tp,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Last changed: Never',
                        style: GoogleFonts.dmSans(
                          color: AppColors2.ts,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: _passExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors2.ts,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: [
                const SizedBox(height: 16),
                Divider(color: Colors.white.withOpacity(0.07)),
                const SizedBox(height: 16),
                _passField(
                  'Current Password',
                  _curPassCtrl,
                  _showCurPass,
                  () => setState(() => _showCurPass = !_showCurPass),
                ),
                const SizedBox(height: 12),
                _passField(
                  'New Password',
                  _newPassCtrl,
                  _showNewPass,
                  () => setState(() => _showNewPass = !_showNewPass),
                ),
                const SizedBox(height: 12),
                _passField(
                  'Confirm New Password',
                  _confPassCtrl,
                  _showConfPass,
                  () => setState(() => _showConfPass = !_showConfPass),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _changePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors2.red.withOpacity(0.15),
                      foregroundColor: AppColors2.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                        side: BorderSide(
                          color: AppColors2.red.withOpacity(0.4),
                        ),
                      ),
                    ),
                    child: _saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              color: AppColors2.red,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Update Password',
                            style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                  ),
                ),
              ],
            ),
            crossFadeState: _passExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _passField(
    String label,
    TextEditingController ctrl,
    bool show,
    VoidCallback onToggle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.dmSans(
            color: AppColors2.ts,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          obscureText: !show,
          style: GoogleFonts.dmSans(color: AppColors2.tp, fontSize: 14.5),
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.lock_outline_rounded,
              color: AppColors2.ts,
              size: 18,
            ),
            suffixIcon: GestureDetector(
              onTap: onToggle,
              child: Icon(
                show ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                color: AppColors2.ts,
                size: 18,
              ),
            ),
            filled: true,
            fillColor: AppColors2.red.withOpacity(0.04),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide(
                color: AppColors2.red.withOpacity(0.2),
                width: 1.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide(
                color: AppColors2.red.withOpacity(0.5),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
