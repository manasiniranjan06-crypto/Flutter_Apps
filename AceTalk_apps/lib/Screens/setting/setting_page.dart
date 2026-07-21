// import 'dart:math';
// import 'dart:ui';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';

// // ─────────────────────────────────────────────────────────────────────────────
// // PALETTE
// // ─────────────────────────────────────────────────────────────────────────────
// class _C {
//   static const bg = Color(0xFF030A14);
//   static const s1 = Color(0xFF081525);
//   static const s2 = Color(0xFF0D2040);
//   static const cyan = Color(0xFF00E5FF);
//   static const blue = Color(0xFF2979FF);
//   static const gold = Color(0xFFFFD740);
//   static const green = Color(0xFF00E676);
//   static const red = Color(0xFFFF3D57);
//   static const purple = Color(0xFFAA00FF);
//   static const tp = Color(0xFFE8F4FD);
//   static const ts = Color(0xFF5B8FA8);
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // MODELS
// // ─────────────────────────────────────────────────────────────────────────────
// class _TogglePref {
//   final String key;
//   final String subtitle;
//   bool value;
//   _TogglePref(this.key, this.subtitle, this.value);
// }

// class _InfoItem {
//   final IconData icon;
//   final String title;
//   final String subtitle;
//   const _InfoItem(this.icon, this.title, this.subtitle);
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SHARED BACKGROUND PAINTER
// // ─────────────────────────────────────────────────────────────────────────────
// class _BgPainter extends CustomPainter {
//   final double t;
//   final Color orbA;
//   final Color orbB;
//   _BgPainter(
//     this.t, {
//     this.orbA = const Color(0xFF2979FF),
//     this.orbB = const Color(0xFF00E5FF),
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     canvas.drawRect(
//       Rect.fromLTWH(0, 0, size.width, size.height),
//       Paint()
//         ..shader = const LinearGradient(
//           colors: [Color(0xFF030A14), Color(0xFF05101E), Color(0xFF030A14)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
//     );

//     for (var i = 0; i < 2; i++) {
//       final cx =
//           size.width * (i == 0 ? 0.15 : 0.85) +
//           cos(t + i * pi) * size.width * 0.1;
//       final cy =
//           size.height * (i == 0 ? 0.18 : 0.78) +
//           sin(t * 0.7 + i * pi) * size.height * 0.04;
//       final col = i == 0 ? orbA : orbB;
//       canvas.drawCircle(
//         Offset(cx, cy),
//         size.width * 0.48,
//         Paint()
//           ..shader =
//               RadialGradient(
//                 colors: [col.withOpacity(0.13), Colors.transparent],
//               ).createShader(
//                 Rect.fromCircle(
//                   center: Offset(cx, cy),
//                   radius: size.width * 0.48,
//                 ),
//               ),
//       );
//     }

//     final grid = Paint()
//       ..color = Colors.white.withOpacity(0.016)
//       ..strokeWidth = 0.5;
//     for (double x = 0; x < size.width; x += 44) {
//       canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
//     }
//     for (double y = 0; y < size.height; y += 44) {
//       canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
//     }
//   }

//   @override
//   bool shouldRepaint(_BgPainter o) => o.t != t;
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SHARED WIDGETS
// // ─────────────────────────────────────────────────────────────────────────────

// class _GlassCard extends StatelessWidget {
//   final Widget child;
//   final EdgeInsets? padding;
//   final Color? borderColor;
//   final Color? bgColor;
//   final double radius;
//   const _GlassCard({
//     required this.child,
//     this.padding,
//     this.borderColor,
//     this.bgColor,
//     this.radius = 20,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(radius),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
//         child: Container(
//           padding: padding ?? const EdgeInsets.all(18),
//           decoration: BoxDecoration(
//             color: bgColor ?? _C.s1.withOpacity(0.9),
//             borderRadius: BorderRadius.circular(radius),
//             border: Border.all(
//               color: borderColor ?? Colors.white10,
//               width: 1.2,
//             ),
//           ),
//           child: child,
//         ),
//       ),
//     );
//   }
// }

// Widget _sectionLabel(String label) {
//   return Row(
//     children: [
//       Container(
//         width: 3,
//         height: 14,
//         decoration: BoxDecoration(
//           color: _C.cyan,
//           borderRadius: BorderRadius.circular(2),
//           boxShadow: [
//             BoxShadow(color: _C.cyan.withOpacity(0.5), blurRadius: 8),
//           ],
//         ),
//       ),
//       const SizedBox(width: 8),
//       Text(
//         label.toUpperCase(),
//         style: GoogleFonts.spaceMono(
//           fontSize: 10,
//           color: _C.ts,
//           fontWeight: FontWeight.w700,
//           letterSpacing: 2.5,
//         ),
//       ),
//     ],
//   );
// }

// Widget _buildTag(String text, Color color) {
//   return Container(
//     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//     decoration: BoxDecoration(
//       color: color.withOpacity(0.1),
//       borderRadius: BorderRadius.circular(6),
//       border: Border.all(color: color.withOpacity(0.35)),
//     ),
//     child: Text(
//       text,
//       style: GoogleFonts.spaceMono(
//         color: color,
//         fontSize: 9,
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//   );
// }

// class _ChipSelector extends StatelessWidget {
//   final List<String> options;
//   final String selected;
//   final Color color;
//   final ValueChanged<String> onSelect;
//   const _ChipSelector({
//     required this.options,
//     required this.selected,
//     required this.color,
//     required this.onSelect,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Wrap(
//       spacing: 8,
//       runSpacing: 8,
//       children: options.map((o) {
//         final active = o == selected;
//         return GestureDetector(
//           onTap: () {
//             HapticFeedback.selectionClick();
//             onSelect(o);
//           },
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//             decoration: BoxDecoration(
//               color: active ? color.withOpacity(0.18) : _C.s2,
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(
//                 color: active ? color.withOpacity(0.65) : Colors.white12,
//               ),
//               boxShadow: active
//                   ? [BoxShadow(color: color.withOpacity(0.22), blurRadius: 12)]
//                   : [],
//             ),
//             child: Text(
//               o,
//               style: GoogleFonts.dmSans(
//                 color: active ? color : _C.ts,
//                 fontSize: 12.5,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }
// }

// class _AnimToggle extends StatelessWidget {
//   final bool value;
//   final VoidCallback onTap;
//   const _AnimToggle({required this.value, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         HapticFeedback.selectionClick();
//         onTap();
//       },
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 250),
//         width: 52,
//         height: 28,
//         decoration: BoxDecoration(
//           color: value ? _C.cyan.withOpacity(0.22) : _C.s2,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(
//             color: value ? _C.cyan.withOpacity(0.6) : Colors.white12,
//           ),
//         ),
//         child: AnimatedAlign(
//           duration: const Duration(milliseconds: 250),
//           alignment: value ? Alignment.centerRight : Alignment.centerLeft,
//           child: Container(
//             margin: const EdgeInsets.all(3),
//             width: 22,
//             height: 22,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: value ? _C.cyan : _C.ts,
//               boxShadow: value
//                   ? [
//                       BoxShadow(
//                         color: _C.cyan.withOpacity(0.55),
//                         blurRadius: 10,
//                       ),
//                     ]
//                   : [],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SETTING PAGE (main hub)
// // ─────────────────────────────────────────────────────────────────────────────
// class SettingPage extends StatefulWidget {
//   const SettingPage({super.key});
//   @override
//   State<SettingPage> createState() => _SettingPageState();
// }

// class _SettingPageState extends State<SettingPage>
//     with SingleTickerProviderStateMixin {
//   User? get _user => FirebaseAuth.instance.currentUser;
//   late AnimationController _bgCtrl;
//   late Animation<double> _bgAnim;

//   final _toggles = [
//     _TogglePref('Push Notifications', 'Interview reminders & updates', true),
//     _TogglePref('Email Digest', 'Weekly progress summary', false),
//     _TogglePref('Sound Effects', 'UI audio feedback', true),
//     _TogglePref('Haptic Feedback', 'Vibration on interactions', true),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _bgCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 12),
//     )..repeat();
//     _bgAnim = Tween<double>(
//       begin: 0,
//       end: 2 * pi,
//     ).animate(CurvedAnimation(parent: _bgCtrl, curve: Curves.linear));
//   }

//   @override
//   void dispose() {
//     _bgCtrl.dispose();
//     super.dispose();
//   }

//   void _push(Widget page) {
//     Navigator.push(
//       context,
//       PageRouteBuilder(
//         pageBuilder: (_, a, b) => page,
//         transitionsBuilder: (_, a, b, child) => SlideTransition(
//           position: Tween<Offset>(
//             begin: const Offset(1, 0),
//             end: Offset.zero,
//           ).animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic)),
//           child: child,
//         ),
//         transitionDuration: const Duration(milliseconds: 350),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final email = _user?.email ?? 'guest@acetalk.com';
//     final name = _user?.displayName ?? 'Interview Candidate';
//     final initials = name
//         .split(' ')
//         .map((e) => e.isNotEmpty ? e[0] : '')
//         .take(2)
//         .join()
//         .toUpperCase();

//     return Scaffold(
//       backgroundColor: _C.bg,
//       extendBodyBehindAppBar: true,
//       body: Stack(
//         children: [
//           AnimatedBuilder(
//             animation: _bgAnim,
//             builder: (_, __) => CustomPaint(
//               painter: _BgPainter(_bgAnim.value),
//               child: const SizedBox.expand(),
//             ),
//           ),
//           SafeArea(
//             child: Column(
//               children: [
//                 // ── App Bar ──
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
//                   child: Row(
//                     children: [
//                       IconButton(
//                         onPressed: () {
//                           HapticFeedback.lightImpact();
//                           Navigator.pop(context);
//                         },
//                         icon: const Icon(
//                           Icons.arrow_back_ios_new_rounded,
//                           color: _C.ts,
//                           size: 20,
//                         ),
//                       ),
//                       Text(
//                         'Settings',
//                         style: GoogleFonts.spaceMono(
//                           fontSize: 18,
//                           color: _C.tp,
//                           fontWeight: FontWeight.w700,
//                           letterSpacing: 0.5,
//                         ),
//                       ),
//                       const Spacer(),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 10,
//                           vertical: 5,
//                         ),
//                         decoration: BoxDecoration(
//                           color: _C.cyan.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(10),
//                           border: Border.all(color: _C.cyan.withOpacity(0.3)),
//                         ),
//                         child: Text(
//                           'v1.0',
//                           style: GoogleFonts.spaceMono(
//                             color: _C.cyan,
//                             fontSize: 11,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     physics: const BouncingScrollPhysics(),
//                     padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // ── Profile Card ──
//                         _buildProfileCard(name, email, initials),
//                         const SizedBox(height: 28),

//                         // ── General ──
//                         _sectionLabel('General'),
//                         const SizedBox(height: 12),
//                         _NavTile(
//                           icon: Icons.person_rounded,
//                           color: _C.cyan,
//                           title: 'Account',
//                           subtitle: 'Profile, resume, password',
//                           onTap: () => _push(const AccountScreen()),
//                         ),
//                         const SizedBox(height: 10),
//                         _NavTile(
//                           icon: Icons.tune_rounded,
//                           color: _C.blue,
//                           title: 'Interview Preferences',
//                           subtitle: 'Type, difficulty, time limit',
//                           onTap: () => _push(const InterviewPrefScreen()),
//                         ),
//                         const SizedBox(height: 10),
//                         _NavTile(
//                           icon: Icons.psychology_alt_rounded,
//                           color: _C.purple,
//                           title: 'AI Settings',
//                           subtitle: 'Voice, feedback style, scoring',
//                           onTap: () => _push(const AiSettingsScreen()),
//                         ),
//                         const SizedBox(height: 28),

//                         // ── App Preferences (toggles) ──
//                         _sectionLabel('App Preferences'),
//                         const SizedBox(height: 12),
//                         _buildTogglesCard(),
//                         const SizedBox(height: 28),

//                         // ── Support ──
//                         _sectionLabel('Support'),
//                         const SizedBox(height: 12),
//                         _NavTile(
//                           icon: Icons.help_outline_rounded,
//                           color: _C.cyan,
//                           title: 'Help & Support',
//                           subtitle: 'FAQs, email, bug reports',
//                           onTap: () => _showBottomSheet(
//                             title: 'Help & Support',
//                             icon: Icons.help_outline_rounded,
//                             color: _C.cyan,
//                             items: [
//                               const _InfoItem(
//                                 Icons.quiz_rounded,
//                                 'FAQs & Guides',
//                                 'Browse common questions and tutorials',
//                               ),
//                               const _InfoItem(
//                                 Icons.mail_rounded,
//                                 'Email Support',
//                                 'support@acetalk.com · replies within 24h',
//                               ),
//                               const _InfoItem(
//                                 Icons.bug_report_rounded,
//                                 'Report a Bug',
//                                 'Help us squash issues faster',
//                               ),
//                               const _InfoItem(
//                                 Icons.lightbulb_rounded,
//                                 'Feature Requests',
//                                 'Suggest what to build next',
//                               ),
//                               const _InfoItem(
//                                 Icons.manage_accounts_rounded,
//                                 'Account Recovery',
//                                 'Lost access? We can help',
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         _NavTile(
//                           icon: Icons.info_outline_rounded,
//                           color: _C.blue,
//                           title: 'About AceTalk',
//                           subtitle: 'Version, licenses, credits',
//                           onTap: () => _showBottomSheet(
//                             title: 'About AceTalk',
//                             icon: Icons.info_outline_rounded,
//                             color: _C.blue,
//                             items: [
//                               const _InfoItem(
//                                 Icons.rocket_launch_rounded,
//                                 'AceTalk v1.0',
//                                 'AI-powered interview coaching platform',
//                               ),
//                               const _InfoItem(
//                                 Icons.psychology_rounded,
//                                 'Personalized Mocks',
//                                 'Tailored to your experience & role',
//                               ),
//                               const _InfoItem(
//                                 Icons.speed_rounded,
//                                 'Real-time Scoring',
//                                 'Instant AI-based keyword analysis',
//                               ),
//                               const _InfoItem(
//                                 Icons.description_rounded,
//                                 'Resume Intelligence',
//                                 'Questions from your own resume',
//                               ),
//                               const _InfoItem(
//                                 Icons.copyright_rounded,
//                                 '© 2026 AceTalk',
//                                 'All rights reserved',
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         _NavTile(
//                           icon: Icons.privacy_tip_outlined,
//                           color: _C.gold,
//                           title: 'Privacy Policy',
//                           subtitle: 'How we handle your data',
//                           onTap: () => _showInfoDialog(
//                             'Privacy Policy',
//                             'We do not sell your data. Your interview sessions are encrypted and stored securely. '
//                                 'They are used only to personalise your results. You can request full data deletion at any time by contacting support.',
//                             _C.gold,
//                           ),
//                         ),
//                         const SizedBox(height: 28),
//                         _buildLogoutButton(),
//                         const SizedBox(height: 14),
//                         _buildDeleteAccount(),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ── Profile Card ──────────────────────────────────────────────────────────
//   Widget _buildProfileCard(String name, String email, String initials) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(24),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [_C.blue.withOpacity(0.2), _C.cyan.withOpacity(0.08)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(24),
//             border: Border.all(color: _C.cyan.withOpacity(0.25), width: 1.5),
//             boxShadow: [
//               BoxShadow(
//                 color: _C.blue.withOpacity(0.14),
//                 blurRadius: 30,
//                 spreadRadius: 2,
//               ),
//             ],
//           ),
//           child: Row(
//             children: [
//               Container(
//                 width: 62,
//                 height: 62,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: const LinearGradient(
//                     colors: [_C.blue, _C.cyan],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: _C.cyan.withOpacity(0.4),
//                       blurRadius: 18,
//                       spreadRadius: 2,
//                     ),
//                   ],
//                 ),
//                 child: Center(
//                   child: Text(
//                     initials.isEmpty ? 'AC' : initials,
//                     style: GoogleFonts.spaceMono(
//                       color: Colors.white,
//                       fontSize: 20,
//                       fontWeight: FontWeight.w900,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       name,
//                       style: GoogleFonts.dmSans(
//                         color: _C.tp,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w800,
//                       ),
//                     ),
//                     const SizedBox(height: 3),
//                     Text(
//                       email,
//                       style: GoogleFonts.dmSans(color: _C.ts, fontSize: 12),
//                     ),
//                     const SizedBox(height: 9),
//                     Row(
//                       children: [
//                         _buildTag('Pro Plan', _C.gold),
//                         const SizedBox(width: 6),
//                         _buildTag('14 Sessions', _C.cyan),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   HapticFeedback.selectionClick();
//                   _push(const AccountScreen());
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: _C.s2,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: Colors.white12),
//                   ),
//                   child: const Icon(Icons.edit_rounded, color: _C.ts, size: 18),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ── Toggles Card ──────────────────────────────────────────────────────────
//   Widget _buildTogglesCard() {
//     return _GlassCard(
//       child: Column(
//         children: List.generate(_toggles.length, (i) {
//           final t = _toggles[i];
//           final isLast = i == _toggles.length - 1;
//           return Column(
//             children: [
//               Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           t.key,
//                           style: GoogleFonts.dmSans(
//                             color: _C.tp,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                         const SizedBox(height: 2),
//                         Text(
//                           t.subtitle,
//                           style: GoogleFonts.dmSans(
//                             color: _C.ts,
//                             fontSize: 11.5,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   _AnimToggle(
//                     value: t.value,
//                     onTap: () => setState(() => t.value = !t.value),
//                   ),
//                 ],
//               ),
//               if (!isLast) ...[
//                 const SizedBox(height: 14),
//                 Divider(color: Colors.white.withOpacity(0.06), height: 1),
//                 const SizedBox(height: 14),
//               ],
//             ],
//           );
//         }),
//       ),
//     );
//   }

//   // ── Logout ────────────────────────────────────────────────────────────────
//   Widget _buildLogoutButton() {
//     return GestureDetector(
//       onTap: () {
//         HapticFeedback.mediumImpact();
//         _showLogoutConfirm();
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 16),
//         decoration: BoxDecoration(
//           color: _C.red.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(18),
//           border: Border.all(color: _C.red.withOpacity(0.4)),
//           boxShadow: [
//             BoxShadow(
//               color: _C.red.withOpacity(0.1),
//               blurRadius: 18,
//               spreadRadius: 1,
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.logout_rounded, color: _C.red, size: 20),
//             const SizedBox(width: 10),
//             Text(
//               'Log Out',
//               style: GoogleFonts.dmSans(
//                 color: _C.red,
//                 fontSize: 15,
//                 fontWeight: FontWeight.w800,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDeleteAccount() {
//     return Center(
//       child: GestureDetector(
//         onTap: () {
//           HapticFeedback.heavyImpact();
//           _showInfoDialog(
//             'Delete Account',
//             'This will permanently delete all your data, sessions, and progress. This action cannot be undone. '
//                 'Contact support@acetalk.com to proceed with account deletion.',
//             _C.red,
//             isDanger: true,
//           );
//         },
//         child: Text(
//           'Delete Account',
//           style: GoogleFonts.dmSans(
//             color: _C.red.withOpacity(0.5),
//             fontSize: 12,
//             decoration: TextDecoration.underline,
//             decorationColor: _C.red.withOpacity(0.4),
//           ),
//         ),
//       ),
//     );
//   }

//   // ── Dialogs ───────────────────────────────────────────────────────────────
//   void _showLogoutConfirm() {
//     showDialog(
//       context: context,
//       builder: (_) => Dialog(
//         backgroundColor: Colors.transparent,
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(26),
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
//             child: Container(
//               padding: const EdgeInsets.all(26),
//               decoration: BoxDecoration(
//                 color: _C.s1,
//                 borderRadius: BorderRadius.circular(26),
//                 border: Border.all(color: _C.red.withOpacity(0.35)),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(18),
//                     decoration: BoxDecoration(
//                       color: _C.red.withOpacity(0.1),
//                       shape: BoxShape.circle,
//                       border: Border.all(color: _C.red.withOpacity(0.35)),
//                     ),
//                     child: const Icon(
//                       Icons.logout_rounded,
//                       color: _C.red,
//                       size: 34,
//                     ),
//                   ),
//                   const SizedBox(height: 18),
//                   Text(
//                     'Log Out?',
//                     style: GoogleFonts.dmSans(
//                       color: _C.tp,
//                       fontSize: 22,
//                       fontWeight: FontWeight.w800,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     "You'll need to sign in again to access your sessions and progress.",
//                     textAlign: TextAlign.center,
//                     style: GoogleFonts.dmSans(
//                       color: _C.ts,
//                       fontSize: 13,
//                       height: 1.6,
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: OutlinedButton(
//                           onPressed: () => Navigator.pop(context),
//                           style: OutlinedButton.styleFrom(
//                             foregroundColor: _C.ts,
//                             side: const BorderSide(color: Colors.white12),
//                             padding: const EdgeInsets.symmetric(vertical: 14),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(13),
//                             ),
//                           ),
//                           child: Text(
//                             'Cancel',
//                             style: GoogleFonts.dmSans(
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: () async {
//                             Navigator.pop(context);
//                             await FirebaseAuth.instance.signOut();
//                             if (!mounted) return;
//                             Navigator.pushAndRemoveUntil(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => const _LoginPlaceholder(),
//                               ),
//                               (r) => false,
//                             );
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: _C.red,
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(vertical: 14),
//                             elevation: 0,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(13),
//                             ),
//                           ),
//                           child: Text(
//                             'Log Out',
//                             style: GoogleFonts.dmSans(
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _showInfoDialog(
//     String title,
//     String body,
//     Color color, {
//     bool isDanger = false,
//   }) {
//     showDialog(
//       context: context,
//       builder: (_) => Dialog(
//         backgroundColor: Colors.transparent,
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(24),
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
//             child: Container(
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 color: _C.s1,
//                 borderRadius: BorderRadius.circular(24),
//                 border: Border.all(color: color.withOpacity(0.32)),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: color.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Icon(
//                           isDanger ? Icons.warning_rounded : Icons.info_rounded,
//                           color: color,
//                           size: 18,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Text(
//                           title,
//                           style: GoogleFonts.dmSans(
//                             color: _C.tp,
//                             fontSize: 18,
//                             fontWeight: FontWeight.w800,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   Divider(color: Colors.white.withOpacity(0.07)),
//                   const SizedBox(height: 12),
//                   Text(
//                     body,
//                     style: GoogleFonts.dmSans(
//                       color: _C.ts,
//                       fontSize: 13.5,
//                       height: 1.7,
//                     ),
//                   ),
//                   const SizedBox(height: 22),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () => Navigator.pop(context),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: color.withOpacity(0.16),
//                         foregroundColor: color,
//                         elevation: 0,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(13),
//                           side: BorderSide(color: color.withOpacity(0.4)),
//                         ),
//                       ),
//                       child: Text(
//                         'Got it',
//                         style: GoogleFonts.dmSans(fontWeight: FontWeight.w700),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _showBottomSheet({
//     required String title,
//     required IconData icon,
//     required Color color,
//     required List<_InfoItem> items,
//   }) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => ClipRRect(
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
//           child: Container(
//             padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
//             decoration: const BoxDecoration(
//               color: _C.s1,
//               borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(
//                   child: Container(
//                     width: 36,
//                     height: 4,
//                     decoration: BoxDecoration(
//                       color: Colors.white24,
//                       borderRadius: BorderRadius.circular(2),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         color: color.withOpacity(0.12),
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: color.withOpacity(0.35)),
//                       ),
//                       child: Icon(icon, color: color, size: 20),
//                     ),
//                     const SizedBox(width: 12),
//                     Text(
//                       title,
//                       style: GoogleFonts.dmSans(
//                         color: _C.tp,
//                         fontSize: 18,
//                         fontWeight: FontWeight.w800,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 Divider(color: Colors.white.withOpacity(0.07)),
//                 const SizedBox(height: 14),
//                 ...items.map(
//                   (item) => Padding(
//                     padding: const EdgeInsets.only(bottom: 16),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(9),
//                           decoration: BoxDecoration(
//                             color: color.withOpacity(0.09),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Icon(item.icon, color: color, size: 16),
//                         ),
//                         const SizedBox(width: 14),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 item.title,
//                                 style: GoogleFonts.dmSans(
//                                   color: _C.tp,
//                                   fontSize: 13.5,
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                               ),
//                               if (item.subtitle.isNotEmpty) ...[
//                                 const SizedBox(height: 3),
//                                 Text(
//                                   item.subtitle,
//                                   style: GoogleFonts.dmSans(
//                                     color: _C.ts,
//                                     fontSize: 12,
//                                     height: 1.5,
//                                   ),
//                                 ),
//                               ],
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // NAV TILE (used in main settings list)
// // ─────────────────────────────────────────────────────────────────────────────
// class _NavTile extends StatelessWidget {
//   final IconData icon;
//   final Color color;
//   final String title;
//   final String subtitle;
//   final VoidCallback onTap;
//   const _NavTile({
//     required this.icon,
//     required this.color,
//     required this.title,
//     required this.subtitle,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         HapticFeedback.selectionClick();
//         onTap();
//       },
//       child: _GlassCard(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//         child: Row(
//           children: [
//             Container(
//               width: 42,
//               height: 42,
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.12),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: color.withOpacity(0.3)),
//               ),
//               child: Icon(icon, color: color, size: 20),
//             ),
//             const SizedBox(width: 14),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: GoogleFonts.dmSans(
//                       color: _C.tp,
//                       fontSize: 14.5,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   const SizedBox(height: 2),
//                   Text(
//                     subtitle,
//                     style: GoogleFonts.dmSans(color: _C.ts, fontSize: 11.5),
//                   ),
//                 ],
//               ),
//             ),
//             const Icon(Icons.chevron_right_rounded, color: _C.ts, size: 22),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // ACCOUNT SCREEN
// // ─────────────────────────────────────────────────────────────────────────────
// class AccountScreen extends StatefulWidget {
//   const AccountScreen({super.key});
//   @override
//   State<AccountScreen> createState() => _AccountScreenState();
// }

// class _AccountScreenState extends State<AccountScreen>
//     with SingleTickerProviderStateMixin {
//   User? get _user => FirebaseAuth.instance.currentUser;
//   late AnimationController _bgCtrl;
//   late Animation<double> _bgAnim;

//   final _nameCtrl = TextEditingController();
//   final _emailCtrl = TextEditingController();
//   final _phoneCtrl = TextEditingController();
//   final _locationCtrl = TextEditingController();
//   bool _editMode = false;
//   bool _saving = false;

//   // Password fields
//   final _curPassCtrl = TextEditingController();
//   final _newPassCtrl = TextEditingController();
//   final _confPassCtrl = TextEditingController();
//   bool _showCurPass = false;
//   bool _showNewPass = false;
//   bool _showConfPass = false;
//   bool _passExpanded = false;
//   bool _linkedExpanded = false;
//   bool _resumeExpanded = false;

//   // Social connections
//   bool _linkedinConnected = false;
//   bool _githubConnected = false;
//   bool _googleConnected = false;

//   @override
//   void initState() {
//     super.initState();
//     _bgCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 12),
//     )..repeat();
//     _bgAnim = Tween<double>(
//       begin: 0,
//       end: 2 * pi,
//     ).animate(CurvedAnimation(parent: _bgCtrl, curve: Curves.linear));
//     _nameCtrl.text = _user?.displayName ?? '';
//     _emailCtrl.text = _user?.email ?? '';
//     _phoneCtrl.text = '';
//     _locationCtrl.text = '';
//   }

//   @override
//   void dispose() {
//     _bgCtrl.dispose();
//     _nameCtrl.dispose();
//     _emailCtrl.dispose();
//     _phoneCtrl.dispose();
//     _locationCtrl.dispose();
//     _curPassCtrl.dispose();
//     _newPassCtrl.dispose();
//     _confPassCtrl.dispose();
//     super.dispose();
//   }

//   Future<void> _saveProfile() async {
//     setState(() => _saving = true);
//     await Future.delayed(const Duration(milliseconds: 900));
//     if (!mounted) return;
//     setState(() {
//       _saving = false;
//       _editMode = false;
//     });
//     _snack(
//       'Profile updated successfully!',
//       _C.green,
//       Icons.check_circle_rounded,
//     );
//   }

//   Future<void> _changePassword() async {
//     if (_newPassCtrl.text != _confPassCtrl.text) {
//       _snack('Passwords do not match.', _C.red, Icons.error_rounded);
//       return;
//     }
//     if (_newPassCtrl.text.length < 6) {
//       _snack(
//         'Password must be at least 6 characters.',
//         _C.gold,
//         Icons.warning_rounded,
//       );
//       return;
//     }
//     setState(() => _saving = true);
//     await Future.delayed(const Duration(milliseconds: 800));
//     if (!mounted) return;
//     setState(() {
//       _saving = false;
//       _passExpanded = false;
//     });
//     _curPassCtrl.clear();
//     _newPassCtrl.clear();
//     _confPassCtrl.clear();
//     _snack('Password changed successfully!', _C.green, Icons.lock_rounded);
//   }

//   void _snack(String msg, Color color, IconData icon) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).clearSnackBars();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         duration: const Duration(seconds: 3),
//         content: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//           decoration: BoxDecoration(
//             color: _C.s1,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: color.withOpacity(0.4), width: 1.5),
//             boxShadow: [
//               BoxShadow(
//                 color: color.withOpacity(0.15),
//                 blurRadius: 20,
//                 spreadRadius: 2,
//               ),
//             ],
//           ),
//           child: Row(
//             children: [
//               Icon(icon, color: color, size: 20),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Text(
//                   msg,
//                   style: GoogleFonts.dmSans(
//                     color: _C.tp,
//                     fontSize: 13,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _C.bg,
//       body: Stack(
//         children: [
//           AnimatedBuilder(
//             animation: _bgAnim,
//             builder: (_, __) => CustomPaint(
//               painter: _BgPainter(_bgAnim.value, orbA: _C.cyan, orbB: _C.blue),
//               child: const SizedBox.expand(),
//             ),
//           ),
//           SafeArea(
//             child: Column(
//               children: [
//                 _buildAppBar(),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     physics: const BouncingScrollPhysics(),
//                     padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // ── Avatar ──
//                         _buildAvatarCard(),
//                         const SizedBox(height: 22),

//                         // ── Profile Info ──
//                         _sectionLabel('Profile Information'),
//                         const SizedBox(height: 12),
//                         _buildProfileInfoCard(),
//                         const SizedBox(height: 22),

//                         // ── Connected Accounts ──
//                         _sectionLabel('Connected Accounts'),
//                         const SizedBox(height: 12),
//                         _buildSocialConnections(),
//                         const SizedBox(height: 22),

//                         // ── Resume ──
//                         _sectionLabel('Resume'),
//                         const SizedBox(height: 12),
//                         _buildResumeSection(),
//                         const SizedBox(height: 22),

//                         // ── Change Password ──
//                         _sectionLabel('Security'),
//                         const SizedBox(height: 12),
//                         _buildPasswordSection(),
//                         const SizedBox(height: 30),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAppBar() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
//       child: Row(
//         children: [
//           IconButton(
//             onPressed: () {
//               HapticFeedback.lightImpact();
//               Navigator.pop(context);
//             },
//             icon: const Icon(
//               Icons.arrow_back_ios_new_rounded,
//               color: _C.ts,
//               size: 20,
//             ),
//           ),
//           Text(
//             'Account',
//             style: GoogleFonts.spaceMono(
//               fontSize: 18,
//               color: _C.tp,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           const Spacer(),
//           if (!_editMode)
//             GestureDetector(
//               onTap: () {
//                 HapticFeedback.selectionClick();
//                 setState(() => _editMode = true);
//               },
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 14,
//                   vertical: 8,
//                 ),
//                 decoration: BoxDecoration(
//                   color: _C.cyan.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: _C.cyan.withOpacity(0.35)),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Icon(Icons.edit_rounded, color: _C.cyan, size: 14),
//                     const SizedBox(width: 6),
//                     Text(
//                       'Edit',
//                       style: GoogleFonts.dmSans(
//                         color: _C.cyan,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           else
//             Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 GestureDetector(
//                   onTap: () => setState(() => _editMode = false),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 8,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.05),
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(color: Colors.white12),
//                     ),
//                     child: Text(
//                       'Cancel',
//                       style: GoogleFonts.dmSans(
//                         color: _C.ts,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 GestureDetector(
//                   onTap: _saving ? null : _saveProfile,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 14,
//                       vertical: 8,
//                     ),
//                     decoration: BoxDecoration(
//                       color: _C.green.withOpacity(0.15),
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(color: _C.green.withOpacity(0.4)),
//                     ),
//                     child: _saving
//                         ? const SizedBox(
//                             width: 14,
//                             height: 14,
//                             child: CircularProgressIndicator(
//                               color: _C.green,
//                               strokeWidth: 2,
//                             ),
//                           )
//                         : Text(
//                             'Save',
//                             style: GoogleFonts.dmSans(
//                               color: _C.green,
//                               fontSize: 12,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                   ),
//                 ),
//               ],
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAvatarCard() {
//     final name = _nameCtrl.text.isEmpty
//         ? (_user?.displayName ?? 'User')
//         : _nameCtrl.text;
//     final initials = name
//         .split(' ')
//         .map((e) => e.isNotEmpty ? e[0] : '')
//         .take(2)
//         .join()
//         .toUpperCase();
//     return _GlassCard(
//       child: Row(
//         children: [
//           Stack(
//             alignment: Alignment.bottomRight,
//             children: [
//               Container(
//                 width: 70,
//                 height: 70,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: const LinearGradient(
//                     colors: [_C.blue, _C.cyan],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   boxShadow: [
//                     BoxShadow(color: _C.cyan.withOpacity(0.4), blurRadius: 18),
//                   ],
//                 ),
//                 child: Center(
//                   child: Text(
//                     initials.isEmpty ? 'U' : initials,
//                     style: GoogleFonts.spaceMono(
//                       color: Colors.white,
//                       fontSize: 22,
//                       fontWeight: FontWeight.w900,
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 width: 24,
//                 height: 24,
//                 decoration: BoxDecoration(
//                   color: _C.blue,
//                   shape: BoxShape.circle,
//                   border: Border.all(color: _C.bg, width: 2),
//                 ),
//                 child: const Icon(
//                   Icons.camera_alt_rounded,
//                   color: Colors.white,
//                   size: 12,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(width: 18),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   _editMode ? 'Editing Profile' : name,
//                   style: GoogleFonts.dmSans(
//                     color: _C.tp,
//                     fontSize: 17,
//                     fontWeight: FontWeight.w800,
//                   ),
//                 ),
//                 const SizedBox(height: 3),
//                 Text(
//                   _user?.email ?? '',
//                   style: GoogleFonts.dmSans(color: _C.ts, fontSize: 12),
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     _buildTag('Verified', _C.green),
//                     const SizedBox(width: 6),
//                     _buildTag('Pro', _C.gold),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProfileInfoCard() {
//     return _GlassCard(
//       child: Column(
//         children: [
//           _buildField(
//             'Full Name',
//             _nameCtrl,
//             Icons.badge_rounded,
//             _C.cyan,
//             enabled: _editMode,
//           ),
//           _buildField(
//             'Email Address',
//             _emailCtrl,
//             Icons.email_rounded,
//             _C.blue,
//             enabled: false,
//             keyboardType: TextInputType.emailAddress,
//           ),
//           _buildField(
//             'Phone Number',
//             _phoneCtrl,
//             Icons.phone_rounded,
//             _C.green,
//             enabled: _editMode,
//             keyboardType: TextInputType.phone,
//             hint: '+91 9876543210',
//           ),
//           _buildField(
//             'Location',
//             _locationCtrl,
//             Icons.location_on_rounded,
//             _C.gold,
//             enabled: _editMode,
//             hint: 'Mumbai, India',
//             isLast: true,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildField(
//     String label,
//     TextEditingController ctrl,
//     IconData icon,
//     Color color, {
//     bool enabled = true,
//     TextInputType? keyboardType,
//     String? hint,
//     bool isLast = false,
//   }) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: GoogleFonts.dmSans(
//               color: _C.ts,
//               fontSize: 11,
//               fontWeight: FontWeight.w600,
//               letterSpacing: 0.4,
//             ),
//           ),
//           const SizedBox(height: 6),
//           TextField(
//             controller: ctrl,
//             enabled: enabled,
//             keyboardType: keyboardType,
//             style: GoogleFonts.dmSans(
//               color: enabled ? _C.tp : _C.ts,
//               fontSize: 14.5,
//             ),
//             decoration: InputDecoration(
//               hintText: hint,
//               hintStyle: GoogleFonts.dmSans(
//                 color: Colors.white24,
//                 fontSize: 13,
//               ),
//               prefixIcon: Icon(
//                 icon,
//                 color: enabled ? color : _C.ts.withOpacity(0.5),
//                 size: 18,
//               ),
//               filled: true,
//               fillColor: enabled ? color.withOpacity(0.05) : Colors.transparent,
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 14,
//                 vertical: 14,
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(13),
//                 borderSide: BorderSide.none,
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(13),
//                 borderSide: BorderSide(
//                   color: enabled
//                       ? color.withOpacity(0.3)
//                       : Colors.white.withOpacity(0.06),
//                   width: 1.2,
//                 ),
//               ),
//               disabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(13),
//                 borderSide: BorderSide(
//                   color: Colors.white.withOpacity(0.06),
//                   width: 1,
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(13),
//                 borderSide: BorderSide(
//                   color: color.withOpacity(0.6),
//                   width: 1.5,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSocialConnections() {
//     return _GlassCard(
//       child: Column(
//         children: [
//           _socialRow(
//             'LinkedIn',
//             Icons.link_rounded,
//             _C.blue,
//             _linkedinConnected,
//             (v) {
//               setState(() => _linkedinConnected = v);
//               _snack(
//                 v ? 'LinkedIn connected!' : 'LinkedIn disconnected.',
//                 v ? _C.green : _C.ts,
//                 v ? Icons.check_circle_rounded : Icons.link_off_rounded,
//               );
//             },
//           ),
//           Divider(color: Colors.white.withOpacity(0.06), height: 20),
//           _socialRow(
//             'GitHub',
//             Icons.code_rounded,
//             _C.purple,
//             _githubConnected,
//             (v) {
//               setState(() => _githubConnected = v);
//               _snack(
//                 v ? 'GitHub connected!' : 'GitHub disconnected.',
//                 v ? _C.green : _C.ts,
//                 v ? Icons.check_circle_rounded : Icons.link_off_rounded,
//               );
//             },
//           ),
//           Divider(color: Colors.white.withOpacity(0.06), height: 20),
//           _socialRow(
//             'Google',
//             Icons.g_mobiledata_rounded,
//             _C.gold,
//             _googleConnected,
//             (v) {
//               setState(() => _googleConnected = v);
//               _snack(
//                 v ? 'Google connected!' : 'Google disconnected.',
//                 v ? _C.green : _C.ts,
//                 v ? Icons.check_circle_rounded : Icons.link_off_rounded,
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _socialRow(
//     String name,
//     IconData icon,
//     Color color,
//     bool connected,
//     ValueChanged<bool> onChanged,
//   ) {
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(9),
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(color: color.withOpacity(0.25)),
//           ),
//           child: Icon(icon, color: color, size: 18),
//         ),
//         const SizedBox(width: 14),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 name,
//                 style: GoogleFonts.dmSans(
//                   color: _C.tp,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 connected ? 'Connected' : 'Not connected',
//                 style: GoogleFonts.dmSans(
//                   color: connected ? _C.green : _C.ts,
//                   fontSize: 11.5,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         _AnimToggle(value: connected, onTap: () => onChanged(!connected)),
//       ],
//     );
//   }

//   Widget _buildResumeSection() {
//     return _GlassCard(
//       child: Column(
//         children: [
//           GestureDetector(
//             onTap: () {
//               HapticFeedback.selectionClick();
//               setState(() => _resumeExpanded = !_resumeExpanded);
//             },
//             behavior: HitTestBehavior.opaque,
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(9),
//                   decoration: BoxDecoration(
//                     color: _C.gold.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(color: _C.gold.withOpacity(0.25)),
//                   ),
//                   child: const Icon(
//                     Icons.description_rounded,
//                     color: _C.gold,
//                     size: 18,
//                   ),
//                 ),
//                 const SizedBox(width: 14),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Resume / CV',
//                         style: GoogleFonts.dmSans(
//                           color: _C.tp,
//                           fontSize: 14.5,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       const SizedBox(height: 2),
//                       Text(
//                         'No resume uploaded',
//                         style: GoogleFonts.dmSans(color: _C.ts, fontSize: 11.5),
//                       ),
//                     ],
//                   ),
//                 ),
//                 AnimatedRotation(
//                   turns: _resumeExpanded ? 0.5 : 0,
//                   duration: const Duration(milliseconds: 250),
//                   child: const Icon(
//                     Icons.keyboard_arrow_down_rounded,
//                     color: _C.ts,
//                     size: 22,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           AnimatedCrossFade(
//             firstChild: const SizedBox.shrink(),
//             secondChild: Column(
//               children: [
//                 const SizedBox(height: 16),
//                 Divider(color: Colors.white.withOpacity(0.07)),
//                 const SizedBox(height: 14),
//                 _uploadOption(
//                   Icons.upload_file_rounded,
//                   'Upload from Storage',
//                   'PDF, DOCX up to 5MB',
//                   _C.gold,
//                 ),
//                 const SizedBox(height: 10),
//                 _uploadOption(
//                   Icons.cloud_upload_rounded,
//                   'Import from Google Drive',
//                   'Connect and pick a file',
//                   _C.blue,
//                 ),
//                 const SizedBox(height: 10),
//                 _uploadOption(
//                   Icons.link_rounded,
//                   'Paste LinkedIn URL',
//                   'Auto-import from profile',
//                   _C.cyan,
//                 ),
//               ],
//             ),
//             crossFadeState: _resumeExpanded
//                 ? CrossFadeState.showSecond
//                 : CrossFadeState.showFirst,
//             duration: const Duration(milliseconds: 300),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _uploadOption(IconData icon, String title, String sub, Color color) {
//     return GestureDetector(
//       onTap: () {
//         HapticFeedback.selectionClick();
//         _snack('$title — coming soon!', color, icon);
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.06),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: color.withOpacity(0.2)),
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: color, size: 18),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: GoogleFonts.dmSans(
//                       color: _C.tp,
//                       fontSize: 13,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   Text(
//                     sub,
//                     style: GoogleFonts.dmSans(color: _C.ts, fontSize: 11),
//                   ),
//                 ],
//               ),
//             ),
//             const Icon(Icons.arrow_forward_ios_rounded, color: _C.ts, size: 13),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPasswordSection() {
//     return _GlassCard(
//       borderColor: _passExpanded ? _C.red.withOpacity(0.3) : null,
//       child: Column(
//         children: [
//           GestureDetector(
//             onTap: () {
//               HapticFeedback.selectionClick();
//               setState(() => _passExpanded = !_passExpanded);
//             },
//             behavior: HitTestBehavior.opaque,
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(9),
//                   decoration: BoxDecoration(
//                     color: _C.red.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(color: _C.red.withOpacity(0.25)),
//                   ),
//                   child: const Icon(
//                     Icons.lock_rounded,
//                     color: _C.red,
//                     size: 18,
//                   ),
//                 ),
//                 const SizedBox(width: 14),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Change Password',
//                         style: GoogleFonts.dmSans(
//                           color: _C.tp,
//                           fontSize: 14.5,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       Text(
//                         'Last changed: Never',
//                         style: GoogleFonts.dmSans(color: _C.ts, fontSize: 11.5),
//                       ),
//                     ],
//                   ),
//                 ),
//                 AnimatedRotation(
//                   turns: _passExpanded ? 0.5 : 0,
//                   duration: const Duration(milliseconds: 250),
//                   child: const Icon(
//                     Icons.keyboard_arrow_down_rounded,
//                     color: _C.ts,
//                     size: 22,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           AnimatedCrossFade(
//             firstChild: const SizedBox.shrink(),
//             secondChild: Column(
//               children: [
//                 const SizedBox(height: 16),
//                 Divider(color: Colors.white.withOpacity(0.07)),
//                 const SizedBox(height: 16),
//                 _passField(
//                   'Current Password',
//                   _curPassCtrl,
//                   _showCurPass,
//                   () => setState(() => _showCurPass = !_showCurPass),
//                 ),
//                 const SizedBox(height: 12),
//                 _passField(
//                   'New Password',
//                   _newPassCtrl,
//                   _showNewPass,
//                   () => setState(() => _showNewPass = !_showNewPass),
//                 ),
//                 const SizedBox(height: 12),
//                 _passField(
//                   'Confirm New Password',
//                   _confPassCtrl,
//                   _showConfPass,
//                   () => setState(() => _showConfPass = !_showConfPass),
//                 ),
//                 const SizedBox(height: 18),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: _saving ? null : _changePassword,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: _C.red.withOpacity(0.15),
//                       foregroundColor: _C.red,
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       elevation: 0,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(13),
//                         side: BorderSide(color: _C.red.withOpacity(0.4)),
//                       ),
//                     ),
//                     child: _saving
//                         ? const SizedBox(
//                             width: 18,
//                             height: 18,
//                             child: CircularProgressIndicator(
//                               color: _C.red,
//                               strokeWidth: 2,
//                             ),
//                           )
//                         : Text(
//                             'Update Password',
//                             style: GoogleFonts.dmSans(
//                               fontWeight: FontWeight.w700,
//                               fontSize: 14,
//                             ),
//                           ),
//                   ),
//                 ),
//               ],
//             ),
//             crossFadeState: _passExpanded
//                 ? CrossFadeState.showSecond
//                 : CrossFadeState.showFirst,
//             duration: const Duration(milliseconds: 300),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _passField(
//     String label,
//     TextEditingController ctrl,
//     bool show,
//     VoidCallback onToggle,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: GoogleFonts.dmSans(
//             color: _C.ts,
//             fontSize: 11,
//             fontWeight: FontWeight.w600,
//             letterSpacing: 0.4,
//           ),
//         ),
//         const SizedBox(height: 6),
//         TextField(
//           controller: ctrl,
//           obscureText: !show,
//           style: GoogleFonts.dmSans(color: _C.tp, fontSize: 14.5),
//           decoration: InputDecoration(
//             prefixIcon: const Icon(
//               Icons.lock_outline_rounded,
//               color: _C.ts,
//               size: 18,
//             ),
//             suffixIcon: GestureDetector(
//               onTap: onToggle,
//               child: Icon(
//                 show ? Icons.visibility_off_rounded : Icons.visibility_rounded,
//                 color: _C.ts,
//                 size: 18,
//               ),
//             ),
//             filled: true,
//             fillColor: _C.red.withOpacity(0.04),
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 14,
//               vertical: 14,
//             ),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(13),
//               borderSide: BorderSide.none,
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(13),
//               borderSide: BorderSide(
//                 color: _C.red.withOpacity(0.2),
//                 width: 1.2,
//               ),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(13),
//               borderSide: BorderSide(
//                 color: _C.red.withOpacity(0.5),
//                 width: 1.5,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // INTERVIEW PREFERENCES SCREEN
// // ─────────────────────────────────────────────────────────────────────────────
// class InterviewPrefScreen extends StatefulWidget {
//   const InterviewPrefScreen({super.key});
//   @override
//   State<InterviewPrefScreen> createState() => _InterviewPrefScreenState();
// }

// class _InterviewPrefScreenState extends State<InterviewPrefScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _bgCtrl;
//   late Animation<double> _bgAnim;
//   bool _saving = false;

//   String _type = 'Technical';
//   String _difficulty = 'Intermediate';
//   String _format = 'Descriptive';
//   String _duration = '30 min';
//   int _questionTime = 60;
//   bool _realFeedback = true;
//   bool _mockMode = false;
//   bool _companyMode = false;
//   String _companyName = '';
//   final _companyCtrl = TextEditingController();
//   final List<String> _selectedCompanies = [];
//   final _companies = [
//     'Google',
//     'Amazon',
//     'Microsoft',
//     'Flipkart',
//     'Infosys',
//     'TCS',
//     'Wipro',
//     'Meta',
//     'Apple',
//     'Uber',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _bgCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 12),
//     )..repeat();
//     _bgAnim = Tween<double>(
//       begin: 0,
//       end: 2 * pi,
//     ).animate(CurvedAnimation(parent: _bgCtrl, curve: Curves.linear));
//   }

//   @override
//   void dispose() {
//     _bgCtrl.dispose();
//     _companyCtrl.dispose();
//     super.dispose();
//   }

//   Future<void> _save() async {
//     setState(() => _saving = true);
//     await Future.delayed(const Duration(milliseconds: 800));
//     if (!mounted) return;
//     setState(() => _saving = false);
//     _snack(
//       'Interview preferences saved!',
//       _C.green,
//       Icons.check_circle_rounded,
//     );
//   }

//   void _snack(String msg, Color color, IconData icon) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).clearSnackBars();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         duration: const Duration(seconds: 2),
//         content: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//           decoration: BoxDecoration(
//             color: _C.s1,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: color.withOpacity(0.4), width: 1.5),
//           ),
//           child: Row(
//             children: [
//               Icon(icon, color: color, size: 20),
//               const SizedBox(width: 10),
//               Text(
//                 msg,
//                 style: GoogleFonts.dmSans(
//                   color: _C.tp,
//                   fontSize: 13,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _C.bg,
//       body: Stack(
//         children: [
//           AnimatedBuilder(
//             animation: _bgAnim,
//             builder: (_, __) => CustomPaint(
//               painter: _BgPainter(
//                 _bgAnim.value,
//                 orbA: _C.blue,
//                 orbB: _C.purple,
//               ),
//               child: const SizedBox.expand(),
//             ),
//           ),
//           SafeArea(
//             child: Column(
//               children: [
//                 // AppBar
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
//                   child: Row(
//                     children: [
//                       IconButton(
//                         onPressed: () {
//                           HapticFeedback.lightImpact();
//                           Navigator.pop(context);
//                         },
//                         icon: const Icon(
//                           Icons.arrow_back_ios_new_rounded,
//                           color: _C.ts,
//                           size: 20,
//                         ),
//                       ),
//                       Text(
//                         'Interview Preferences',
//                         style: GoogleFonts.spaceMono(
//                           fontSize: 16,
//                           color: _C.tp,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       const Spacer(),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     physics: const BouncingScrollPhysics(),
//                     padding: const EdgeInsets.fromLTRB(20, 14, 20, 40),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Summary card
//                         _buildSummaryCard(),
//                         const SizedBox(height: 22),

//                         _sectionLabel('Interview Type'),
//                         const SizedBox(height: 12),
//                         _GlassCard(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               _prefRow(
//                                 'Type',
//                                 Icons.category_rounded,
//                                 _C.blue,
//                                 _ChipSelector(
//                                   options: const [
//                                     'HR',
//                                     'Technical',
//                                     'Behavioral',
//                                     'Mixed',
//                                   ],
//                                   selected: _type,
//                                   color: _C.blue,
//                                   onSelect: (v) => setState(() => _type = v),
//                                 ),
//                               ),
//                               const SizedBox(height: 16),
//                               Divider(color: Colors.white.withOpacity(0.06)),
//                               const SizedBox(height: 16),
//                               _prefRow(
//                                 'Format',
//                                 Icons.question_answer_rounded,
//                                 _C.cyan,
//                                 _ChipSelector(
//                                   options: const [
//                                     'MCQ',
//                                     'Descriptive',
//                                     'Voice',
//                                     'Mixed',
//                                   ],
//                                   selected: _format,
//                                   color: _C.cyan,
//                                   onSelect: (v) => setState(() => _format = v),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 16),

//                         _sectionLabel('Difficulty & Duration'),
//                         const SizedBox(height: 12),
//                         _GlassCard(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               _prefRow(
//                                 'Difficulty Level',
//                                 Icons.bar_chart_rounded,
//                                 _C.gold,
//                                 _ChipSelector(
//                                   options: const [
//                                     'Beginner',
//                                     'Intermediate',
//                                     'Advanced',
//                                     'Expert',
//                                   ],
//                                   selected: _difficulty,
//                                   color: _C.gold,
//                                   onSelect: (v) =>
//                                       setState(() => _difficulty = v),
//                                 ),
//                               ),
//                               const SizedBox(height: 16),
//                               Divider(color: Colors.white.withOpacity(0.06)),
//                               const SizedBox(height: 16),
//                               _prefRow(
//                                 'Session Duration',
//                                 Icons.schedule_rounded,
//                                 _C.green,
//                                 _ChipSelector(
//                                   options: const [
//                                     '15 min',
//                                     '30 min',
//                                     '45 min',
//                                     '60 min',
//                                   ],
//                                   selected: _duration,
//                                   color: _C.green,
//                                   onSelect: (v) =>
//                                       setState(() => _duration = v),
//                                 ),
//                               ),
//                               const SizedBox(height: 16),
//                               Divider(color: Colors.white.withOpacity(0.06)),
//                               const SizedBox(height: 16),
//                               _prefRow(
//                                 'Time / Question: ${_questionTime}s',
//                                 Icons.timer_rounded,
//                                 _C.cyan,
//                                 SliderTheme(
//                                   data: SliderThemeData(
//                                     activeTrackColor: _C.cyan,
//                                     inactiveTrackColor: _C.s2,
//                                     thumbColor: _C.cyan,
//                                     overlayColor: _C.cyan.withOpacity(0.15),
//                                     thumbShape: const RoundSliderThumbShape(
//                                       enabledThumbRadius: 9,
//                                     ),
//                                     trackHeight: 5,
//                                   ),
//                                   child: Slider(
//                                     min: 30,
//                                     max: 180,
//                                     divisions: 10,
//                                     value: _questionTime.toDouble(),
//                                     onChanged: (v) => setState(
//                                       () => _questionTime = v.toInt(),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 16),

//                         _sectionLabel('Options'),
//                         const SizedBox(height: 12),
//                         _GlassCard(
//                           child: Column(
//                             children: [
//                               _toggleRow(
//                                 'Real-time Feedback',
//                                 'Instant AI hints after each answer',
//                                 Icons.bolt_rounded,
//                                 _C.cyan,
//                                 _realFeedback,
//                                 () => setState(
//                                   () => _realFeedback = !_realFeedback,
//                                 ),
//                               ),
//                               Divider(
//                                 color: Colors.white.withOpacity(0.06),
//                                 height: 24,
//                               ),
//                               _toggleRow(
//                                 'Mock Interview Mode',
//                                 'Simulates a real interview experience',
//                                 Icons.videocam_rounded,
//                                 _C.blue,
//                                 _mockMode,
//                                 () => setState(() => _mockMode = !_mockMode),
//                               ),
//                               Divider(
//                                 color: Colors.white.withOpacity(0.06),
//                                 height: 24,
//                               ),
//                               _toggleRow(
//                                 'Company-Specific Mode',
//                                 'Questions from top companies',
//                                 Icons.business_rounded,
//                                 _C.gold,
//                                 _companyMode,
//                                 () => setState(
//                                   () => _companyMode = !_companyMode,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         if (_companyMode) ...[
//                           const SizedBox(height: 12),
//                           _GlassCard(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Select Companies',
//                                   style: GoogleFonts.dmSans(
//                                     color: _C.ts,
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w600,
//                                     letterSpacing: 0.4,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 12),
//                                 Wrap(
//                                   spacing: 8,
//                                   runSpacing: 8,
//                                   children: _companies.map((c) {
//                                     final sel = _selectedCompanies.contains(c);
//                                     return GestureDetector(
//                                       onTap: () {
//                                         HapticFeedback.selectionClick();
//                                         setState(() {
//                                           if (sel)
//                                             _selectedCompanies.remove(c);
//                                           else
//                                             _selectedCompanies.add(c);
//                                         });
//                                       },
//                                       child: AnimatedContainer(
//                                         duration: const Duration(
//                                           milliseconds: 200,
//                                         ),
//                                         padding: const EdgeInsets.symmetric(
//                                           horizontal: 12,
//                                           vertical: 7,
//                                         ),
//                                         decoration: BoxDecoration(
//                                           color: sel
//                                               ? _C.gold.withOpacity(0.15)
//                                               : _C.s2,
//                                           borderRadius: BorderRadius.circular(
//                                             10,
//                                           ),
//                                           border: Border.all(
//                                             color: sel
//                                                 ? _C.gold.withOpacity(0.5)
//                                                 : Colors.white12,
//                                           ),
//                                         ),
//                                         child: Text(
//                                           c,
//                                           style: GoogleFonts.dmSans(
//                                             color: sel ? _C.gold : _C.ts,
//                                             fontSize: 12.5,
//                                             fontWeight: FontWeight.w700,
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   }).toList(),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                         const SizedBox(height: 28),
//                         _buildSaveButton(_save, _saving),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSummaryCard() {
//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [_C.blue.withOpacity(0.2), _C.purple.withOpacity(0.1)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(color: _C.blue.withOpacity(0.3)),
//       ),
//       child: Row(
//         children: [
//           Expanded(child: _summaryChip('Type', _type, _C.cyan)),
//           Expanded(child: _summaryChip('Level', _difficulty, _C.gold)),
//           Expanded(child: _summaryChip('Duration', _duration, _C.green)),
//         ],
//       ),
//     );
//   }

//   Widget _summaryChip(String label, String value, Color color) {
//     return Column(
//       children: [
//         Text(
//           label,
//           style: GoogleFonts.dmSans(
//             color: _C.ts,
//             fontSize: 10,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: GoogleFonts.spaceMono(
//             color: color,
//             fontSize: 12,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _prefRow(String label, IconData icon, Color color, Widget child) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(icon, color: color, size: 14),
//             const SizedBox(width: 6),
//             Text(
//               label,
//               style: GoogleFonts.dmSans(
//                 color: _C.ts,
//                 fontSize: 12,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 10),
//         child,
//       ],
//     );
//   }

//   Widget _toggleRow(
//     String title,
//     String sub,
//     IconData icon,
//     Color color,
//     bool val,
//     VoidCallback onTap,
//   ) {
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(9),
//             border: Border.all(color: color.withOpacity(0.25)),
//           ),
//           child: Icon(icon, color: color, size: 16),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: GoogleFonts.dmSans(
//                   color: _C.tp,
//                   fontSize: 13.5,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               Text(
//                 sub,
//                 style: GoogleFonts.dmSans(color: _C.ts, fontSize: 11.5),
//               ),
//             ],
//           ),
//         ),
//         _AnimToggle(value: val, onTap: onTap),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // AI SETTINGS SCREEN
// // ─────────────────────────────────────────────────────────────────────────────
// class AiSettingsScreen extends StatefulWidget {
//   const AiSettingsScreen({super.key});
//   @override
//   State<AiSettingsScreen> createState() => _AiSettingsScreenState();
// }

// class _AiSettingsScreenState extends State<AiSettingsScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _bgCtrl;
//   late Animation<double> _bgAnim;
//   bool _saving = false;

//   String _voice = 'Female';
//   String _feedbackStyle = 'Detailed';
//   String _evalLevel = 'Standard';
//   String _language = 'English';
//   double _confidenceThreshold = 70;
//   bool _smartFollowups = true;
//   bool _emotionAnalysis = true;
//   bool _confidenceScore = true;
//   bool _ttsCoach = false;
//   bool _keywordTracking = true;
//   bool _pauseDetection = false;
//   bool _facialAnalysis = false;

//   @override
//   void initState() {
//     super.initState();
//     _bgCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 12),
//     )..repeat();
//     _bgAnim = Tween<double>(
//       begin: 0,
//       end: 2 * pi,
//     ).animate(CurvedAnimation(parent: _bgCtrl, curve: Curves.linear));
//   }

//   @override
//   void dispose() {
//     _bgCtrl.dispose();
//     super.dispose();
//   }

//   Future<void> _save() async {
//     setState(() => _saving = true);
//     await Future.delayed(const Duration(milliseconds: 800));
//     if (!mounted) return;
//     setState(() => _saving = false);
//     _snack('AI settings saved!', _C.green, Icons.check_circle_rounded);
//   }

//   void _snack(String msg, Color color, IconData icon) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).clearSnackBars();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         duration: const Duration(seconds: 2),
//         content: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//           decoration: BoxDecoration(
//             color: _C.s1,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: color.withOpacity(0.4), width: 1.5),
//           ),
//           child: Row(
//             children: [
//               Icon(icon, color: color, size: 20),
//               const SizedBox(width: 10),
//               Text(
//                 msg,
//                 style: GoogleFonts.dmSans(
//                   color: _C.tp,
//                   fontSize: 13,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _C.bg,
//       body: Stack(
//         children: [
//           AnimatedBuilder(
//             animation: _bgAnim,
//             builder: (_, __) => CustomPaint(
//               painter: _BgPainter(
//                 _bgAnim.value,
//                 orbA: _C.purple,
//                 orbB: _C.blue,
//               ),
//               child: const SizedBox.expand(),
//             ),
//           ),
//           SafeArea(
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
//                   child: Row(
//                     children: [
//                       IconButton(
//                         onPressed: () {
//                           HapticFeedback.lightImpact();
//                           Navigator.pop(context);
//                         },
//                         icon: const Icon(
//                           Icons.arrow_back_ios_new_rounded,
//                           color: _C.ts,
//                           size: 20,
//                         ),
//                       ),
//                       Text(
//                         'AI Settings',
//                         style: GoogleFonts.spaceMono(
//                           fontSize: 18,
//                           color: _C.tp,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       const Spacer(),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 10,
//                           vertical: 5,
//                         ),
//                         decoration: BoxDecoration(
//                           color: _C.purple.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(10),
//                           border: Border.all(
//                             color: _C.purple.withOpacity(0.35),
//                           ),
//                         ),
//                         child: Text(
//                           'AI Engine v2',
//                           style: GoogleFonts.spaceMono(
//                             color: _C.purple,
//                             fontSize: 10,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     physics: const BouncingScrollPhysics(),
//                     padding: const EdgeInsets.fromLTRB(20, 14, 20, 40),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // AI Status card
//                         _buildAiStatusCard(),
//                         const SizedBox(height: 22),

//                         _sectionLabel('Voice & Language'),
//                         const SizedBox(height: 12),
//                         _GlassCard(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               _aiPrefRow(
//                                 'AI Voice',
//                                 Icons.record_voice_over_rounded,
//                                 _C.purple,
//                                 _ChipSelector(
//                                   options: const ['Male', 'Female', 'Neutral'],
//                                   selected: _voice,
//                                   color: _C.purple,
//                                   onSelect: (v) => setState(() => _voice = v),
//                                 ),
//                               ),
//                               const SizedBox(height: 16),
//                               Divider(color: Colors.white.withOpacity(0.06)),
//                               const SizedBox(height: 16),
//                               _aiPrefRow(
//                                 'Language',
//                                 Icons.language_rounded,
//                                 _C.blue,
//                                 _ChipSelector(
//                                   options: const ['English', 'Hindi', 'Mixed'],
//                                   selected: _language,
//                                   color: _C.blue,
//                                   onSelect: (v) =>
//                                       setState(() => _language = v),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 16),

//                         _sectionLabel('Feedback & Evaluation'),
//                         const SizedBox(height: 12),
//                         _GlassCard(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               _aiPrefRow(
//                                 'Feedback Style',
//                                 Icons.rate_review_rounded,
//                                 _C.cyan,
//                                 _ChipSelector(
//                                   options: const [
//                                     'Brief',
//                                     'Detailed',
//                                     'Coach Mode',
//                                   ],
//                                   selected: _feedbackStyle,
//                                   color: _C.cyan,
//                                   onSelect: (v) =>
//                                       setState(() => _feedbackStyle = v),
//                                 ),
//                               ),
//                               const SizedBox(height: 16),
//                               Divider(color: Colors.white.withOpacity(0.06)),
//                               const SizedBox(height: 16),
//                               _aiPrefRow(
//                                 'Evaluation Level',
//                                 Icons.assessment_rounded,
//                                 _C.gold,
//                                 _ChipSelector(
//                                   options: const [
//                                     'Lenient',
//                                     'Standard',
//                                     'Strict',
//                                   ],
//                                   selected: _evalLevel,
//                                   color: _C.gold,
//                                   onSelect: (v) =>
//                                       setState(() => _evalLevel = v),
//                                 ),
//                               ),
//                               const SizedBox(height: 16),
//                               Divider(color: Colors.white.withOpacity(0.06)),
//                               const SizedBox(height: 16),
//                               _aiPrefRow(
//                                 'Confidence Threshold: ${_confidenceThreshold.toInt()}%',
//                                 Icons.speed_rounded,
//                                 _C.green,
//                                 SliderTheme(
//                                   data: SliderThemeData(
//                                     activeTrackColor: _C.green,
//                                     inactiveTrackColor: _C.s2,
//                                     thumbColor: _C.green,
//                                     overlayColor: _C.green.withOpacity(0.15),
//                                     thumbShape: const RoundSliderThumbShape(
//                                       enabledThumbRadius: 9,
//                                     ),
//                                     trackHeight: 5,
//                                   ),
//                                   child: Slider(
//                                     min: 30,
//                                     max: 100,
//                                     divisions: 14,
//                                     value: _confidenceThreshold,
//                                     onChanged: (v) => setState(
//                                       () => _confidenceThreshold = v,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 16),

//                         _sectionLabel('Advanced AI Features'),
//                         const SizedBox(height: 12),
//                         _GlassCard(
//                           child: Column(
//                             children: [
//                               _aiToggleRow(
//                                 'Smart Follow-up Questions',
//                                 'AI digs deeper on weak answers',
//                                 Icons.psychology_rounded,
//                                 _C.purple,
//                                 _smartFollowups,
//                                 () => setState(
//                                   () => _smartFollowups = !_smartFollowups,
//                                 ),
//                               ),
//                               Divider(
//                                 color: Colors.white.withOpacity(0.06),
//                                 height: 24,
//                               ),
//                               _aiToggleRow(
//                                 'Emotion & Tone Analysis',
//                                 'Detects confidence in your voice',
//                                 Icons.sentiment_satisfied_alt_rounded,
//                                 _C.cyan,
//                                 _emotionAnalysis,
//                                 () => setState(
//                                   () => _emotionAnalysis = !_emotionAnalysis,
//                                 ),
//                               ),
//                               Divider(
//                                 color: Colors.white.withOpacity(0.06),
//                                 height: 24,
//                               ),
//                               _aiToggleRow(
//                                 'Confidence Scoring',
//                                 'Real-time body language feedback',
//                                 Icons.show_chart_rounded,
//                                 _C.gold,
//                                 _confidenceScore,
//                                 () => setState(
//                                   () => _confidenceScore = !_confidenceScore,
//                                 ),
//                               ),
//                               Divider(
//                                 color: Colors.white.withOpacity(0.06),
//                                 height: 24,
//                               ),
//                               _aiToggleRow(
//                                 'Keyword Tracking',
//                                 'Highlights important answer keywords',
//                                 Icons.text_fields_rounded,
//                                 _C.green,
//                                 _keywordTracking,
//                                 () => setState(
//                                   () => _keywordTracking = !_keywordTracking,
//                                 ),
//                               ),
//                               Divider(
//                                 color: Colors.white.withOpacity(0.06),
//                                 height: 24,
//                               ),
//                               _aiToggleRow(
//                                 'Pause & Filler Detection',
//                                 'Tracks umm, uh, like in speech',
//                                 Icons.mic_none_rounded,
//                                 _C.blue,
//                                 _pauseDetection,
//                                 () => setState(
//                                   () => _pauseDetection = !_pauseDetection,
//                                 ),
//                               ),
//                               Divider(
//                                 color: Colors.white.withOpacity(0.06),
//                                 height: 24,
//                               ),
//                               _aiToggleRow(
//                                 'Facial Expression Analysis',
//                                 'Camera-based confidence check',
//                                 Icons.face_rounded,
//                                 _C.red,
//                                 _facialAnalysis,
//                                 () => setState(
//                                   () => _facialAnalysis = !_facialAnalysis,
//                                 ),
//                               ),
//                               Divider(
//                                 color: Colors.white.withOpacity(0.06),
//                                 height: 24,
//                               ),
//                               _aiToggleRow(
//                                 'TTS Voice Coach',
//                                 'AI speaks questions aloud',
//                                 Icons.volume_up_rounded,
//                                 _C.purple,
//                                 _ttsCoach,
//                                 () => setState(() => _ttsCoach = !_ttsCoach),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 16),

//                         // Reset to defaults
//                         GestureDetector(
//                           onTap: () {
//                             HapticFeedback.mediumImpact();
//                             setState(() {
//                               _voice = 'Female';
//                               _feedbackStyle = 'Detailed';
//                               _evalLevel = 'Standard';
//                               _language = 'English';
//                               _confidenceThreshold = 70;
//                               _smartFollowups = true;
//                               _emotionAnalysis = true;
//                               _confidenceScore = true;
//                               _ttsCoach = false;
//                               _keywordTracking = true;
//                               _pauseDetection = false;
//                               _facialAnalysis = false;
//                             });
//                             _snack(
//                               'Settings reset to defaults.',
//                               _C.ts,
//                               Icons.refresh_rounded,
//                             );
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(vertical: 14),
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.03),
//                               borderRadius: BorderRadius.circular(14),
//                               border: Border.all(color: Colors.white12),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 const Icon(
//                                   Icons.refresh_rounded,
//                                   color: _C.ts,
//                                   size: 18,
//                                 ),
//                                 const SizedBox(width: 8),
//                                 Text(
//                                   'Reset to Defaults',
//                                   style: GoogleFonts.dmSans(
//                                     color: _C.ts,
//                                     fontSize: 13.5,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 24),
//                         _buildSaveButton(_save, _saving),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAiStatusCard() {
//     final activeFeatures = [
//       _smartFollowups,
//       _emotionAnalysis,
//       _confidenceScore,
//       _keywordTracking,
//       _pauseDetection,
//       _facialAnalysis,
//       _ttsCoach,
//     ].where((b) => b).length;
//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [_C.purple.withOpacity(0.2), _C.blue.withOpacity(0.1)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(color: _C.purple.withOpacity(0.3)),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 50,
//             height: 50,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: const LinearGradient(colors: [_C.purple, _C.blue]),
//               boxShadow: [
//                 BoxShadow(color: _C.purple.withOpacity(0.4), blurRadius: 16),
//               ],
//             ),
//             child: const Icon(
//               Icons.psychology_rounded,
//               color: Colors.white,
//               size: 26,
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'AI Engine Active',
//                   style: GoogleFonts.dmSans(
//                     color: _C.tp,
//                     fontSize: 15,
//                     fontWeight: FontWeight.w800,
//                   ),
//                 ),
//                 const SizedBox(height: 3),
//                 Text(
//                   '$activeFeatures of 7 features enabled',
//                   style: GoogleFonts.dmSans(color: _C.ts, fontSize: 12),
//                 ),
//                 const SizedBox(height: 8),
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(4),
//                   child: LinearProgressIndicator(
//                     value: activeFeatures / 7,
//                     backgroundColor: Colors.white10,
//                     valueColor: AlwaysStoppedAnimation<Color>(
//                       activeFeatures >= 5
//                           ? _C.green
//                           : activeFeatures >= 3
//                           ? _C.gold
//                           : _C.red,
//                     ),
//                     minHeight: 6,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(width: 12),
//           Column(
//             children: [
//               Text(
//                 '$_voice',
//                 style: GoogleFonts.spaceMono(
//                   color: _C.purple,
//                   fontSize: 11,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Text(
//                 'voice',
//                 style: GoogleFonts.dmSans(color: _C.ts, fontSize: 10),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _aiPrefRow(String label, IconData icon, Color color, Widget child) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(icon, color: color, size: 14),
//             const SizedBox(width: 6),
//             Text(
//               label,
//               style: GoogleFonts.dmSans(
//                 color: _C.ts,
//                 fontSize: 12,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 10),
//         child,
//       ],
//     );
//   }

//   Widget _aiToggleRow(
//     String title,
//     String sub,
//     IconData icon,
//     Color color,
//     bool val,
//     VoidCallback onTap,
//   ) {
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(9),
//             border: Border.all(color: color.withOpacity(0.25)),
//           ),
//           child: Icon(icon, color: color, size: 16),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: GoogleFonts.dmSans(
//                   color: _C.tp,
//                   fontSize: 13.5,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               Text(
//                 sub,
//                 style: GoogleFonts.dmSans(color: _C.ts, fontSize: 11.5),
//               ),
//             ],
//           ),
//         ),
//         _AnimToggle(value: val, onTap: onTap),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SHARED SAVE BUTTON
// // ─────────────────────────────────────────────────────────────────────────────
// Widget _buildSaveButton(Future<void> Function() onSave, bool saving) {
//   return GestureDetector(
//     onTap: saving ? null : onSave,
//     child: Container(
//       height: 58,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(18),
//         gradient: saving
//             ? LinearGradient(
//                 colors: [_C.green.withOpacity(0.6), _C.green.withOpacity(0.8)],
//               )
//             : const LinearGradient(
//                 colors: [
//                   Color(0xFF1565C0),
//                   Color(0xFF2979FF),
//                   Color(0xFF00B0FF),
//                 ],
//                 begin: Alignment.centerLeft,
//                 end: Alignment.centerRight,
//               ),
//         boxShadow: [
//           BoxShadow(
//             color: _C.blue.withOpacity(0.3),
//             blurRadius: 20,
//             spreadRadius: 1,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Center(
//         child: saving
//             ? const SizedBox(
//                 width: 22,
//                 height: 22,
//                 child: CircularProgressIndicator(
//                   color: Colors.white,
//                   strokeWidth: 2.5,
//                 ),
//               )
//             : Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Icon(Icons.save_rounded, color: Colors.white, size: 20),
//                   const SizedBox(width: 10),
//                   Text(
//                     'Save Changes',
//                     style: GoogleFonts.dmSans(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w800,
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//     ),
//   );
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // LOGIN PLACEHOLDER (replace with your actual login screen)
// // ─────────────────────────────────────────────────────────────────────────────
// class _LoginPlaceholder extends StatelessWidget {
//   const _LoginPlaceholder();
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       backgroundColor: _C.bg,
//       body: Center(
//         child: Text('Login Screen', style: TextStyle(color: _C.tp)),
//       ),
//     );
//   }
// }
import 'dart:math';
import 'dart:ui';

import 'package:ai_interview_app/Screens/setting/AI_setting.dart';
import 'package:ai_interview_app/Screens/setting/account_screen.dart';
import 'package:ai_interview_app/Screens/setting/animate_backgrd.dart';
import 'package:ai_interview_app/Screens/setting/color_palet.dart';
import 'package:ai_interview_app/Screens/setting/inforItem.dart';
import 'package:ai_interview_app/Screens/setting/interview_pref.dart';
import 'package:ai_interview_app/Screens/setting/navigator_helper.dart';
import 'package:ai_interview_app/Screens/setting/resuable_widget.dart';
import 'package:ai_interview_app/Screens/setting/toggle_pref.dart';
import 'package:ai_interview_app/payment/subscription_history.dart';
import 'package:ai_interview_app/payment/subscription_plan.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage>
    with SingleTickerProviderStateMixin {
  User? get _user => FirebaseAuth.instance.currentUser;
  late AnimationController _bgCtrl;
  late Animation<double> _bgAnim;

  SubscriptionPlan _plan = SubscriptionPlan.free;
  bool _loadingPlan = true;

  final _toggles = [
    TogglePref(
      'Push Notifications',
      'pref_push_notif',
      'Interview reminders & updates',
      true,
    ),
    TogglePref(
      'Email Digest',
      'pref_email_digest',
      'Weekly progress summary',
      false,
    ),
    TogglePref('Sound Effects', 'pref_sound_fx', 'UI audio feedback', true),
    TogglePref(
      'Haptic Feedback',
      'pref_haptic',
      'Vibration on interactions',
      true,
    ),
  ];

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
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final plan = await SubscriptionManager.getCurrentPlan();
    if (!mounted) return;
    setState(() {
      _plan = plan;
      _loadingPlan = false;
      for (final t in _toggles) t.value = prefs.getBool(t.prefKey) ?? t.value;
    });
  }

  Future<void> _saveToggle(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    super.dispose();
  }

  // ── Plan badge ─────────────────────────────────────────────────────────────
  Widget _planBadge() {
    Color c;
    String label;
    switch (_plan) {
      case SubscriptionPlan.pro:
        c = AppColors2.gold;
        label = 'PRO';
        break;
      case SubscriptionPlan.elite:
        c = AppColors2.cyan;
        label = 'ELITE';
        break;
      case SubscriptionPlan.free:
        c = AppColors2.ts;
        label = 'FREE';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: c.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: c.withOpacity(0.35)),
      ),
      child: Text(
        label,
        style: GoogleFonts.spaceMono(
          color: c,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ── Profile card ────────────────────────────────────────────────────────────
  Widget _profileCard(String name, String email, String initials) {
    Color planColor;
    String planLabel;
    switch (_plan) {
      case SubscriptionPlan.pro:
        planColor = AppColors2.gold;
        planLabel = 'Pro Plan';
        break;
      case SubscriptionPlan.elite:
        planColor = AppColors2.cyan;
        planLabel = 'Elite Plan';
        break;
      case SubscriptionPlan.free:
        planColor = AppColors2.ts;
        planLabel = 'Free Plan';
        break;
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors2.blue.withOpacity(0.2),
                AppColors2.cyan.withOpacity(0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors2.cyan.withOpacity(0.25),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors2.blue.withOpacity(0.14),
                blurRadius: 30,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 62,
                height: 62,
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
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    initials.isEmpty ? 'AC' : initials,
                    style: GoogleFonts.spaceMono(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.dmSans(
                        color: AppColors2.tp,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      email,
                      style: GoogleFonts.dmSans(
                        color: AppColors2.ts,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Row(
                      children: [
                        AppTag(planLabel, planColor),
                        const SizedBox(width: 6),
                        const AppTag('14 Sessions', AppColors2.cyan),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => AppNav.push(context, const AccountScreen()),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors2.s2,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: const Icon(
                    Icons.edit_rounded,
                    color: AppColors2.ts,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Subscription banner ─────────────────────────────────────────────────────
  Widget _subscriptionBanner() {
    if (_loadingPlan || _plan == SubscriptionPlan.elite)
      return const SizedBox.shrink();
    final color = _plan == SubscriptionPlan.pro
        ? AppColors2.gold
        : AppColors2.cyan;
    final title = _plan == SubscriptionPlan.pro
        ? 'Upgrade to Elite'
        : 'Upgrade to Pro';
    final sub = _plan == SubscriptionPlan.pro
        ? 'Get 20 questions & company-specific banks'
        : 'Unlock all difficulty levels & more questions';

    return GestureDetector(
      onTap: () => AppNav.push(context, SubscriptionHistoryScreen(plan: _plan)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withOpacity(0.35)),
        ),
        child: Row(
          children: [
            Icon(
              _plan == SubscriptionPlan.pro
                  ? Icons.diamond_rounded
                  : Icons.workspace_premium_rounded,
              color: color,
              size: 24,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.dmSans(
                      color: AppColors2.tp,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    sub,
                    style: GoogleFonts.dmSans(
                      color: AppColors2.ts,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded, color: color, size: 22),
          ],
        ),
      ),
    );
  }

  // ── Toggles card ────────────────────────────────────────────────────────────
  Widget _togglesCard() {
    return GlassCard(
      child: Column(
        children: List.generate(_toggles.length, (i) {
          final t = _toggles[i];
          final isLast = i == _toggles.length - 1;
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.label,
                          style: GoogleFonts.dmSans(
                            color: AppColors2.tp,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          t.subtitle,
                          style: GoogleFonts.dmSans(
                            color: AppColors2.ts,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  AnimToggle(
                    value: t.value,
                    onTap: () {
                      setState(() => t.value = !t.value);
                      _saveToggle(t.prefKey, t.value);
                    },
                  ),
                ],
              ),
              if (!isLast) ...[
                const SizedBox(height: 14),
                Divider(color: Colors.white.withOpacity(0.06), height: 1),
                const SizedBox(height: 14),
              ],
            ],
          );
        }),
      ),
    );
  }

  // ── Logout ──────────────────────────────────────────────────────────────────
  Widget _logoutButton() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        _showLogoutConfirm();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors2.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors2.red.withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: AppColors2.red.withOpacity(0.1),
              blurRadius: 18,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded, color: AppColors2.red, size: 20),
            const SizedBox(width: 10),
            Text(
              'Log Out',
              style: GoogleFonts.dmSans(
                color: AppColors2.red,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _deleteAccount() {
    return Center(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.heavyImpact();
          _showInfoDialog(
            'Delete Account',
            'This will permanently delete all your data, sessions, and progress. This action cannot be undone. '
                'Contact support@acetalk.com to proceed with account deletion.',
            AppColors2.red,
            isDanger: true,
          );
        },
        child: Text(
          'Delete Account',
          style: GoogleFonts.dmSans(
            color: AppColors2.red.withOpacity(0.5),
            fontSize: 12,
            decoration: TextDecoration.underline,
            decorationColor: AppColors2.red.withOpacity(0.4),
          ),
        ),
      ),
    );
  }

  // ── Dialogs ─────────────────────────────────────────────────────────────────
  void _showLogoutConfirm() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(
                color: AppColors2.s1,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: AppColors2.red.withOpacity(0.35)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors2.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors2.red.withOpacity(0.35),
                      ),
                    ),
                    child: const Icon(
                      Icons.logout_rounded,
                      color: AppColors2.red,
                      size: 34,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Log Out?',
                    style: GoogleFonts.dmSans(
                      color: AppColors2.tp,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "You'll need to sign in again to access your sessions and progress.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSans(
                      color: AppColors2.ts,
                      fontSize: 13,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors2.ts,
                            side: const BorderSide(color: Colors.white12),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            await FirebaseAuth.instance.signOut();
                            if (!mounted) return;
                            AppNav.pushAndRemoveUntil(
                              context,
                              const _LoginPlaceholder(),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors2.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                          child: Text(
                            'Log Out',
                            style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showInfoDialog(
    String title,
    String body,
    Color color, {
    bool isDanger = false,
  }) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors2.s1,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: color.withOpacity(0.32)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          isDanger ? Icons.warning_rounded : Icons.info_rounded,
                          color: color,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          title,
                          style: GoogleFonts.dmSans(
                            color: AppColors2.tp,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(color: Colors.white.withOpacity(0.07)),
                  const SizedBox(height: 12),
                  Text(
                    body,
                    style: GoogleFonts.dmSans(
                      color: AppColors2.ts,
                      fontSize: 13.5,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color.withOpacity(0.16),
                        foregroundColor: color,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                          side: BorderSide(color: color.withOpacity(0.4)),
                        ),
                      ),
                      child: Text(
                        'Got it',
                        style: GoogleFonts.dmSans(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet({
    required String title,
    required IconData icon,
    required Color color,
    required List<InfoItem> items,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
            decoration: const BoxDecoration(
              color: AppColors2.s1,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: color.withOpacity(0.35)),
                      ),
                      child: Icon(icon, color: color, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      title,
                      style: GoogleFonts.dmSans(
                        color: AppColors2.tp,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Divider(color: Colors.white.withOpacity(0.07)),
                const SizedBox(height: 14),
                ...items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.09),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(item.icon, color: color, size: 16),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: GoogleFonts.dmSans(
                                  color: AppColors2.tp,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              if (item.subtitle.isNotEmpty) ...[
                                const SizedBox(height: 3),
                                Text(
                                  item.subtitle,
                                  style: GoogleFonts.dmSans(
                                    color: AppColors2.ts,
                                    fontSize: 12,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Build ───────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final email = _user?.email ?? 'guest@acetalk.com';
    final name = _user?.displayName ?? 'Interview Candidate';
    final initials = name
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .take(2)
        .join()
        .toUpperCase();

    return Scaffold(
      backgroundColor: AppColors2.bg,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _bgAnim,
            builder: (_, __) => CustomPaint(
              painter: BgPainter(_bgAnim.value),
              child: const SizedBox.expand(),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // App bar
                Padding(
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
                        'Settings',
                        style: GoogleFonts.spaceMono(
                          fontSize: 18,
                          color: AppColors2.tp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors2.cyan.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors2.cyan.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          'v1.0',
                          style: GoogleFonts.spaceMono(
                            color: AppColors2.cyan,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _profileCard(name, email, initials),
                        const SizedBox(height: 16),
                        _subscriptionBanner(),
                        const SizedBox(height: 28),
                        const SectionLabel('General'),
                        const SizedBox(height: 12),
                        NavTile(
                          icon: Icons.person_rounded,
                          color: AppColors2.cyan,
                          title: 'Account',
                          subtitle: 'Profile, resume, password',
                          onTap: () =>
                              AppNav.push(context, const AccountScreen()),
                        ),
                        const SizedBox(height: 10),
                        NavTile(
                          icon: Icons.tune_rounded,
                          color: AppColors2.blue,
                          title: 'Interview Preferences',
                          subtitle: 'Type, difficulty, time limit',
                          onTap: () =>
                              AppNav.push(context, const InterviewPrefScreen()),
                        ),
                        const SizedBox(height: 10),
                        NavTile(
                          icon: Icons.psychology_alt_rounded,
                          color: AppColors2.purple,
                          title: 'AI Settings',
                          subtitle: 'Voice, feedback style, scoring',
                          onTap: () =>
                              AppNav.push(context, const AiSettingsScreen()),
                        ),
                        const SizedBox(height: 10),
                        NavTile(
                          icon: Icons.receipt_long_rounded,
                          color: AppColors2.gold,
                          title: 'Subscription & Billing',
                          subtitle: 'Plan, payment history, upgrade',
                          trailing: _planBadge(),
                          onTap: () => AppNav.push(
                            context,
                            SubscriptionHistoryScreen(plan: _plan),
                          ),
                        ),
                        const SizedBox(height: 28),
                        const SectionLabel('App Preferences'),
                        const SizedBox(height: 12),
                        _togglesCard(),
                        const SizedBox(height: 28),
                        const SectionLabel('Support'),
                        const SizedBox(height: 12),
                        NavTile(
                          icon: Icons.help_outline_rounded,
                          color: AppColors2.cyan,
                          title: 'Help & Support',
                          subtitle: 'FAQs, email, bug reports',
                          onTap: () => _showBottomSheet(
                            title: 'Help & Support',
                            icon: Icons.help_outline_rounded,
                            color: AppColors2.cyan,
                            items: const [
                              InfoItem(
                                Icons.quiz_rounded,
                                'FAQs & Guides',
                                'Browse common questions and tutorials',
                              ),
                              InfoItem(
                                Icons.mail_rounded,
                                'Email Support',
                                'support@acetalk.com · replies within 24h',
                              ),
                              InfoItem(
                                Icons.bug_report_rounded,
                                'Report a Bug',
                                'Help us squash issues faster',
                              ),
                              InfoItem(
                                Icons.lightbulb_rounded,
                                'Feature Requests',
                                'Suggest what to build next',
                              ),
                              InfoItem(
                                Icons.manage_accounts_rounded,
                                'Account Recovery',
                                'Lost access? We can help',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        NavTile(
                          icon: Icons.info_outline_rounded,
                          color: AppColors2.blue,
                          title: 'About AceTalk',
                          subtitle: 'Version, licenses, credits',
                          onTap: () => _showBottomSheet(
                            title: 'About AceTalk',
                            icon: Icons.info_outline_rounded,
                            color: AppColors2.blue,
                            items: const [
                              InfoItem(
                                Icons.rocket_launch_rounded,
                                'AceTalk v1.0',
                                'AI-powered interview coaching platform',
                              ),
                              InfoItem(
                                Icons.psychology_rounded,
                                'Personalized Mocks',
                                'Tailored to your experience & role',
                              ),
                              InfoItem(
                                Icons.speed_rounded,
                                'Real-time Scoring',
                                'Instant AI-based keyword analysis',
                              ),
                              InfoItem(
                                Icons.description_rounded,
                                'Resume Intelligence',
                                'Questions from your own resume',
                              ),
                              InfoItem(
                                Icons.copyright_rounded,
                                '© 2026 AceTalk',
                                'All rights reserved',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        NavTile(
                          icon: Icons.privacy_tip_outlined,
                          color: AppColors2.gold,
                          title: 'Privacy Policy',
                          subtitle: 'How we handle your data',
                          onTap: () => _showInfoDialog(
                            'Privacy Policy',
                            'We do not sell your data. Your interview sessions are encrypted and stored securely. '
                                'They are used only to personalise your results. You can request full data deletion at any time by contacting support.',
                            AppColors2.gold,
                          ),
                        ),
                        const SizedBox(height: 28),
                        _logoutButton(),
                        const SizedBox(height: 14),
                        _deleteAccount(),
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
}

// ── Login placeholder (post-logout destination) ──────────────────────────────
class _LoginPlaceholder extends StatelessWidget {
  const _LoginPlaceholder();
  @override
  Widget build(BuildContext context) => const Scaffold(
    backgroundColor: AppColors2.bg,
    body: Center(
      child: Text('Login Screen', style: TextStyle(color: AppColors2.tp)),
    ),
  );
}
