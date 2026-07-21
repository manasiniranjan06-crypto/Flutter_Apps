import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseauth/customerside/screens/home_screen.dart';
import 'package:firebaseauth/login_signupScreen/view/signupscreen.dart';
import 'package:firebaseauth/splashscreen/splashscreen1.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

// Import your controller
// import 'package:firebaseauth/login_signupScreen/controller/login_controller.dart';
// import 'package:firebaseauth/login_signupScreen/view/signupscreen.dart';

class Login2 extends StatefulWidget {
  const Login2({super.key});

  @override
  State createState() => _LoginScreenState();
}

class _LoginScreenState extends State with TickerProviderStateMixin {
  // Uncomment when you add the controller file
  // final LoginController _controller = LoginController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  // Animation controllers
  late AnimationController _animationController;
  late AnimationController _tailorAnimationController;
  late AnimationController _scissorsAnimationController;
  late AnimationController _needleAnimationController;
  late AnimationController _floatingController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _tailorScaleAnimation;
  late Animation<double> _scissorsRotation;
  late Animation<double> _needleAnimation;
  late Animation<double> _floatingAnimation;

  // Temporary error states (replace with controller errors)
  String? _emailError;
  String? _passwordError;

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
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _tailorAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _tailorScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _tailorAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _scissorsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _scissorsRotation = Tween<double>(begin: -0.1, end: 0.1).animate(
      CurvedAnimation(
        parent: _scissorsAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _needleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _needleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_needleAnimationController);

    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    _tailorAnimationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tailorAnimationController.dispose();
    _scissorsAnimationController.dispose();
    _needleAnimationController.dispose();
    _floatingController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    // Clear previous errors
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    // Basic validation
    if (_emailController.text.isEmpty) {
      setState(() => _emailError = 'Email is required');
      return;
    }

    if (_passwordController.text.isEmpty) {
      setState(() => _passwordError = 'Password is required');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Uncomment and use your LoginController
      // _controller.userModel.email = _emailController.text;
      // _controller.userModel.password = _passwordController.text;

      // if (_controller.validateInputs()) {
      //   bool success = await _controller.login();
      //
      //   setState(() => _isLoading = false);
      //
      //   if (success) {
      //     _showMessage('Login successful!', true);
      //     // Navigate to home screen
      //     // Navigator.pushReplacement(
      //     //   context,
      //     //   MaterialPageRoute(builder: (_) => const HomeScreen()),
      //     // );
      //   } else {
      //     setState(() {
      //       _emailError = _controller.emailError;
      //       _passwordError = _controller.passwordError;
      //     });
      //     _showMessage('Login failed. Please try again.', false);
      //   }
      // } else {
      //   setState(() {
      //     _emailError = _controller.emailError;
      //     _passwordError = _controller.passwordError;
      //     _isLoading = false;
      //   });
      // }

      // Temporary simulation
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _isLoading = false);
      _showMessage('Login successful!', true);
    } catch (e) {
      setState(() => _isLoading = false);
      _showMessage('An error occurred. Please try again.', false);
    }
  }

  void _handleSocialLogin(String provider) async {
    setState(() => _isLoading = true);

    try {
      // Uncomment to use your LoginController
      // bool success = await _controller.socialLogin(provider);
      // setState(() => _isLoading = false);
      //
      // if (success) {
      //   _showMessage('$provider login successful!', true);
      //   // Navigate to home screen
      // } else {
      //   _showMessage('$provider login failed', false);
      // }

      // Temporary simulation
      await Future.delayed(const Duration(seconds: 1));
      setState(() => _isLoading = false);
      _showMessage('$provider login successful!', true);
    } catch (e) {
      setState(() => _isLoading = false);
      _showMessage('$provider login failed', false);
    }
  }

  void _handleForgotPassword() async {
    if (_emailController.text.isEmpty) {
      _showMessage('Please enter your email address', false);
      return;
    }

    try {
      // Uncomment to use your LoginController
      // bool success = await _controller.resetPassword(_emailController.text);
      // if (success) {
      //   _showMessage('Password reset email sent!', true);
      // } else {
      //   _showMessage('Failed to send reset email', false);
      // }

      _showMessage('Password reset email sent!', true);
    } catch (e) {
      _showMessage('Failed to send reset email', false);
    }
  }

  void _showMessage(String message, bool isSuccess) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor:
            isSuccess ? const Color(0xFF4CAF50) : const Color(0xFFE53935),
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
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 30),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _buildLoginCard(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 320,
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
                            : Icons.push_pin,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  );
                },
              ),
            );
          }),

          // Animated Tailor Character
          Positioned(
            right: 30,
            top: 80,
            child: ScaleTransition(
              scale: _tailorScaleAnimation,
              child: _buildTailorCharacter(),
            ),
          ),

          // Animated scissors
          Positioned(
            right: 150,
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
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.content_cut,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),

          // Animated needle with thread
          Positioned(
            left: 50,
            top: 200,
            child: AnimatedBuilder(
              animation: _needleAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_needleAnimation.value * 20 - 10, 0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.straighten,
                        color: Colors.white,
                        size: 25,
                      ),
                      CustomPaint(
                        size: const Size(30, 2),
                        painter: ThreadPainter(_needleAnimation.value),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Welcome Text
          Positioned(
            left: 30,
            top: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 800),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(-20 * (1 - value), 0),
                        child: Text(
                          'Hello!',
                          style: GoogleFonts.poppins(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1000),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(-20 * (1 - value), 0),
                        child: Text(
                          'Welcome to StitchCraft',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTailorCharacter() {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatingAnimation.value * 0.5),
          child: SizedBox(
            width: 120,
            height: 140,
            child: Stack(
              children: [
                // Shadow
                Positioned(
                  bottom: 0,
                  left: 20,
                  right: 20,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),

                // Body
                Positioned(
                  left: 30,
                  top: 30,
                  child: Container(
                    width: 60,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),

                // Head
                Positioned(
                  left: 35,
                  top: 10,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Container(
                            width: 15,
                            height: 3,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Tape measure
                Positioned(
                  left: 25,
                  top: 55,
                  child: Container(
                    width: 70,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Scissors in hand
                Positioned(
                  right: 10,
                  top: 70,
                  child: AnimatedBuilder(
                    animation: _scissorsRotation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _scissorsRotation.value * 2,
                        child: const Icon(
                          Icons.content_cut,
                          color: Colors.white70,
                          size: 20,
                        ),
                      );
                    },
                  ),
                ),

                // Buttons
                ...List.generate(3, (index) {
                  return Positioned(
                    left: 54,
                    top: 70.0 + (index * 12),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 5, 86, 208),
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.only(top: 20, right: 30, left: 30, bottom: 60),
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
          Row(
            children: [
              Text(
                'Login',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 5, 86, 208),
                ),
              ),
              const SizedBox(width: 10),
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 2000),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.rotate(
                    angle: value * 2 * math.pi,
                    child: const Icon(
                      Icons.content_cut,
                      color: Color.fromARGB(255, 5, 86, 208),
                      size: 24,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 30),

          _buildTextField(
            controller: _emailController,
            label: 'Email',
            icon: Icons.email_outlined,
            errorText: _emailError,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),

          _buildTextField(
            controller: _passwordController,
            label: 'Password',
            icon: Icons.lock_outline,
            errorText: _passwordError,
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

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _handleForgotPassword,
              child: Text(
                'Forgot Password?',
                style: GoogleFonts.poppins(
                  color: const Color.fromARGB(255, 5, 86, 208),
                  fontSize: 12,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
          //login button
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () async{
                FirebaseAuth firebaseAuth = FirebaseAuth.instance;
              await  firebaseAuth.signInWithEmailAndPassword(
                  email: _emailController.text,
                  password: _passwordController.text,
                );
                // Navigate to HomeScreen when button is clicked
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => customersplashscreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4145A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
              ),
              child: Text(
                'Login',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 25),

          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey[300])),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'Or login with',
                  style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
                ),
              ),
              Expanded(child: Divider(color: Colors.grey[300])),
            ],
          ),

          const SizedBox(height: 25),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialButton(Icons.facebook, Colors.blue, 'Facebook'),
              const SizedBox(width: 20),
              _buildSocialButton(Icons.mail, Colors.red, 'Google'),
              const SizedBox(width: 20),
              _buildSocialButton(Icons.apple, Colors.black, 'Apple'),
            ],
          ),

          const SizedBox(height: 25),

          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Don't have account? ",
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Uncomment to navigate to SignUpScreen
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 800),
                        pageBuilder:
                            (context, animation, secondaryAnimation) =>
                                const SignUpScreen2(),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          final slideTween = Tween(
                            begin: begin,
                            end: end,
                          ).chain(CurveTween(curve: Curves.easeOutCubic));
                          final fadeTween = Tween(begin: 0.0, end: 1.0);

                          return SlideTransition(
                            position: animation.drive(slideTween),
                            child: FadeTransition(
                              opacity: animation.drive(fadeTween),
                              child: child,
                            ),
                          );
                        },
                      ),
                    );
                    _showMessage('Login Succesfully', true);
                  },
                  child: Text(
                    'Sign Up',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFD4145A),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? errorText,
    bool isPassword = false,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: errorText != null ? Colors.red : Colors.transparent,
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: GoogleFonts.poppins(),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.grey),
              suffixIcon: suffixIcon,
              hintText: label,
              hintStyle: GoogleFonts.poppins(color: Colors.grey),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 5),
            child: Text(
              errorText,
              style: GoogleFonts.poppins(color: Colors.red, fontSize: 11),
            ),
          ),
      ],
    );
  }

  Widget _buildSocialButton(IconData icon, Color color, String provider) {
    return GestureDetector(
      onTap: _isLoading ? null : () => _handleSocialLogin(provider),
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }
}

// Custom painter for animated thread
class ThreadPainter extends CustomPainter {
  final double progress;

  ThreadPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.8)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height / 2);

    for (double i = 0; i < size.width; i++) {
      final y =
          size.height / 2 +
          math.sin((i / size.width * 2 * math.pi) + (progress * 2 * math.pi)) *
              3;
      path.lineTo(i, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(ThreadPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
