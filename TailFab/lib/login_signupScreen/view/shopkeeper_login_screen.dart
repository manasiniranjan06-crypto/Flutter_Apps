// view/tailor/tailor_login_screen.dart
import 'dart:io';
import 'package:firebaseauth/login_signupScreen/view/shopkeeperSignup.dart';
import 'package:firebaseauth/splashscreen/splashscreen1.dart';
import 'package:firebaseauth/splashscreen/tailorsplashscreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math' as math;

class ShopkeeperLoginScreen extends StatefulWidget {
  const ShopkeeperLoginScreen({Key? key}) : super(key: key);

  @override
  State<ShopkeeperLoginScreen> createState() => _TailorLoginScreenState();
}

class _TailorLoginScreenState extends State<ShopkeeperLoginScreen>
    with TickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();

  // Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _shopAddressController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  File? _shopImage;

  // Animation controllers
  late AnimationController _animationController;
  late AnimationController _scissorsAnimationController;
  late AnimationController _floatingController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scissorsRotation;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _scissorsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _scissorsRotation = Tween<double>(
      begin: -0.1,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _scissorsAnimationController,
      curve: Curves.easeInOut,
    ));

    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(
      begin: -10.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scissorsAnimationController.dispose();
    _floatingController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _shopNameController.dispose();
    _shopAddressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await showModalBottomSheet<XFile?>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => _buildImageSourceDialog(),
      );

      if (pickedFile != null) {
        setState(() {
          _shopImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      _showMessage('Failed to pick image', false);
    }
  }

  Widget _buildImageSourceDialog() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Choose Shop Image',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildImageOption(
                icon: Icons.camera_alt,
                label: 'Camera',
                onTap: () async {
                  final XFile? photo = await _picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 80,
                  );
                  if (context.mounted) Navigator.pop(context, photo);
                },
              ),
              _buildImageOption(
                icon: Icons.photo_library,
                label: 'Gallery',
                onTap: () async {
                  final XFile? photo = await _picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                  );
                  if (context.mounted) Navigator.pop(context, photo);
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildImageOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF0891B2).withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF0891B2).withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: const Color(0xFF0891B2)),
            const SizedBox(height: 10),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0891B2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogin() async {
    // Validation
    if (_emailController.text.isEmpty) {
      _showMessage('Please enter your email', false);
      return;
    }

    if (!_emailController.text.contains('@')) {
      _showMessage('Please enter a valid email', false);
      return;
    }

    if (_passwordController.text.isEmpty) {
      _showMessage('Please enter your password', false);
      return;
    }

    if (_passwordController.text.length < 6) {
      _showMessage('Password must be at least 6 characters', false);
      return;
    }

    if (_shopNameController.text.isEmpty) {
      _showMessage('Please enter your shop name', false);
      return;
    }

    if (_shopAddressController.text.isEmpty) {
      _showMessage('Please enter your shop address', false);
      return;
    }

    if (_shopImage == null) {
      _showMessage('Please select a shop image', false);
      return;
    }

    setState(() => _isLoading = true);

    // Simulate API call - Replace with your actual Firebase logic
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    _showMessage('Login successful! Shop profile created.', true);

    // TODO: Navigate to Tailor Home Screen
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (_) => TailorHomeScreen()),
    // );
  }

  void _showMessage(String message, bool isSuccess) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: isSuccess 
            ? const Color(0xFF4CAF50) 
            : const Color(0xFFE53935),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0891B2), Color(0xFF06B6D4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _buildLoginCard(),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Stack(
        children: [
          // Animated background patterns
          ...List.generate(5, (index) {
            return Positioned(
              left: (index * 80.0) - 40,
              top: 20 + (index * 15.0),
              child: AnimatedBuilder(
                animation: _floatingAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                      math.sin(index * 0.5) * _floatingAnimation.value,
                      _floatingAnimation.value * (index % 2 == 0 ? 1 : -1),
                    ),
                    child: Opacity(
                      opacity: 0.1,
                      child: Icon(
                        index % 3 == 0
                            ? Icons.content_cut
                            : index % 3 == 1
                                ? Icons.straighten
                                : Icons.store,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  );
                },
              ),
            );
          }),

          // Animated scissors
          Positioned(
            right: 50,
            top: 50,
            child: AnimatedBuilder(
              animation: _scissorsRotation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _scissorsRotation.value,
                  child: AnimatedBuilder(
                    animation: _floatingAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _floatingAnimation.value * 0.3),
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.content_cut,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),

          // Back Button
          Positioned(
            top: 20,
            left: 20,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
            ),
          ),

          // Welcome Text
          Positioned(
            left: 30,
            bottom: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tailor Login',
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Login & Setup Your Shop',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            children: [
              const Icon(Icons.store, color: Color(0xFF0891B2), size: 28),
              const SizedBox(width: 10),
              Text(
                'Complete Profile',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0891B2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            'Fill in your details to get started',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 25),

          // Shop Image Picker
          Center(
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF0891B2).withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: _shopImage != null
                    ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(
                              _shopImage!,
                              fit: BoxFit.cover,
                              width: 140,
                              height: 140,
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Color(0xFF0891B2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate,
                            size: 45,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Shop Image',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Tap to upload',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),

          const SizedBox(height: 25),

          // Divider
          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey[300])),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'Login Credentials',
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(child: Divider(color: Colors.grey[300])),
            ],
          ),

          const SizedBox(height: 20),

          // Email Field
          _buildTextField(
            controller: _emailController,
            label: 'Email Address',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 15),

          // Password Field
          _buildTextField(
            controller: _passwordController,
            label: 'Password',
            icon: Icons.lock_outline,
            isPassword: true,
            obscureText: !_isPasswordVisible,
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() => _isPasswordVisible = !_isPasswordVisible);
              },
            ),
          ),

          const SizedBox(height: 20),

          // Divider
          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey[300])),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'Shop Information',
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(child: Divider(color: Colors.grey[300])),
            ],
          ),

          const SizedBox(height: 20),

          // Shop Name Field
          _buildTextField(
            controller: _shopNameController,
            label: 'Shop Name',
            icon: Icons.store_outlined,
          ),
          const SizedBox(height: 15),

          // Shop Address Field
          _buildTextField(
            controller: _shopAddressController,
            label: 'Shop Address',
            icon: Icons.location_on_outlined,
            maxLines: 2,
          ),

          const SizedBox(height: 25),

          // Login Button
         // Login Button
SizedBox(
  width: double.infinity,
  height: 55,
  child: ElevatedButton(
    onPressed: () {
      // Navigate to SplashScreen when button is clicked
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TailorSplashScreen2()),
      );
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF0891B2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Login & Continue',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.arrow_forward, size: 20),
      ],
    ),
  ),
),

          const SizedBox(height: 15),

          // Sign Up Link
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Don't have an account? ",
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to tailor registration
                  },
                  child: TextButton(
  onPressed: () {
    // TODO: Add your navigation or sign-up action here
    // Example:
    Navigator.push(context, MaterialPageRoute(builder: (_) => const TailorSignUpScreen()));
  },
  style: TextButton.styleFrom(
    padding: EdgeInsets.zero, // removes extra padding for a cleaner look
    minimumSize: const Size(0, 0), // optional: to tightly fit the text
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  ),
  child: Text(
    'Sign Up',
    style: GoogleFonts.poppins(
      color: const Color(0xFF0891B2),
      fontSize: 12,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.underline,
    ),
  ),
)

                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: GoogleFonts.poppins(fontSize: 14),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF0891B2), size: 22),
          suffixIcon: suffixIcon,
          hintText: label,
          hintStyle: GoogleFonts.poppins(color: Colors.grey[500], fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}