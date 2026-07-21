// Animated Splash Screen with Tailor Cutting Cloth
import 'package:firebaseauth/customerside/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class customersplashscreen extends StatefulWidget {
  const customersplashscreen({super.key});

  @override
  State createState() => _TailorSplashScreenState();
}

class _TailorSplashScreenState extends State with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scissorsController;
  late AnimationController _clothController;
  late AnimationController _handController;
  late AnimationController _progressController;
  
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _scissorsSlide;
  late Animation<double> _clothCut;
  late Animation<double> _handMove;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scissorsController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _clothController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _handController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _scissorsSlide = Tween<Offset>(
      begin: const Offset(-0.5, 0),
      end: const Offset(0.5, 0),
    ).animate(CurvedAnimation(
      parent: _scissorsController,
      curve: Curves.easeInOut,
    ));

    _clothCut = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _clothController, curve: Curves.easeInOut),
    );

    _handMove = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _handController, curve: Curves.easeInOut),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    _startAnimations();

    // Navigate to home screen after animation
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        // Replace with your home screen
       Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (_) => CustomerHomeScreen()),
  (route) => false, // This removes all previous routes
);
      }
    });
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    _handController.repeat(reverse: true);
    _scissorsController.forward();
    _clothController.forward();
    _progressController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scissorsController.dispose();
    _clothController.dispose();
    _handController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Decorative circles background
            Positioned(
              right: -80,
              top: -80,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFF5F7),
                ),
              ),
            ),
            Positioned(
              left: -60,
              bottom: -60,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFF8E1),
                ),
              ),
            ),

            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),

                      // Main Tailor Illustration Scene
                      SizedBox(
                        height: 320,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Background decorative elements
                            Positioned(
                              left: 30,
                              top: 20,
                              child: AnimatedBuilder(
                                animation: _progressController,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(0, -_progressAnimation.value * 10),
                                    child: _buildDecorativeIcon(
                                      Icons.straighten,
                                      const Color(0xFFE8B89A),
                                      35,
                                      -0.3,
                                    ),
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              right: 40,
                              top: 30,
                              child: AnimatedBuilder(
                                animation: _progressController,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(0, _progressAnimation.value * 8),
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xFFE8CBA7),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            // Sewing machine illustration
                            Positioned(
                              bottom: 100,
                              child: AnimatedBuilder(
                                animation: _progressController,
                                builder: (context, child) {
                                  return Opacity(
                                    opacity: _progressAnimation.value,
                                    child: _buildSewingMachine(),
                                  );
                                },
                              ),
                            ),

                            // Dress form/mannequin
                            Positioned(
                              right: 60,
                              bottom: 110,
                              child: AnimatedBuilder(
                                animation: _fadeController,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _fadeAnimation.value,
                                    child: _buildDressForm(),
                                  );
                                },
                              ),
                            ),

                            // Thread spool
                            Positioned(
                              left: 50,
                              top: 100,
                              child: AnimatedBuilder(
                                animation: _scissorsController,
                                builder: (context, child) {
                                  return Transform.rotate(
                                    angle: _scissorsSlide.value.dx * 0.2,
                                    child: _buildThreadSpool(),
                                  );
                                },
                              ),
                            ),

                            // Animated Scissors cutting
                            AnimatedBuilder(
                              animation: _scissorsController,
                              builder: (context, child) {
                                return Positioned(
                                  top: 120 + (_scissorsController.value * 60),
                                  left: 120 + (_scissorsController.value * 40),
                                  child: Transform.rotate(
                                    angle: -0.4 + (_scissorsController.value * 0.2),
                                    child: Icon(
                                      Icons.content_cut,
                                      size: 55,
                                      color: const Color(0xFFB01048),
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.15),
                                          blurRadius: 8,
                                          offset: const Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),

                            // Buttons floating
                            Positioned(
                              right: 30,
                              top: 80,
                              child: AnimatedBuilder(
                                animation: _handController,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(_handMove.value * 5, _handMove.value * -5),
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xFFE8CBA7),
                                        border: Border.all(
                                          color: const Color(0xFF8B6F47),
                                          width: 2,
                                        ),
                                      ),
                                      child: Center(
                                        child: Container(
                                          width: 3,
                                          height: 3,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFF8B6F47),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            // Fabric piece
                            Positioned(
                              bottom: 140,
                              left: 80,
                              child: AnimatedBuilder(
                                animation: _clothController,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(-_clothCut.value * 20, 0),
                                    child: Container(
                                      width: 90,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFD4145A),
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.08),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // App Name
                      Text(
                        'StitchCraft',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFD4145A),
                          letterSpacing: 1.5,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Tagline
                      Text(
                        'Your Perfect Fit Awaits',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: const Color(0xFF6B7280),
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5,
                        ),
                      ),

                      const SizedBox(height: 60),

                      // Progress Indicator
                      AnimatedBuilder(
                        animation: _progressController,
                        builder: (context, child) {
                          return Column(
                            children: [
                              Container(
                                width: 240,
                                height: 3,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: _progressAnimation.value,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFD4145A),
                                          Color(0xFFB01048),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFD4145A).withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Crafting your experience...',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: const Color(0xFF9CA3AF),
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 40),
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

  // Helper widget builders
  Widget _buildSewingMachine() {
    return SizedBox(
      width: 100,
      height: 80,
      child: Stack(
        children: [
          // Machine body
          Positioned(
            bottom: 0,
            left: 10,
            child: Container(
              width: 70,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFB01048),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
          // Machine top
          Positioned(
            top: 0,
            left: 30,
            child: Container(
              width: 40,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFFD4145A),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          // Needle
          Positioned(
            bottom: 45,
            left: 45,
            child: Container(
              width: 2,
              height: 15,
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDressForm() {
    return SizedBox(
      width: 60,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Stand
          Positioned(
            bottom: 0,
            child: Container(
              width: 40,
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFF8B6F47),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          // Pole
          Positioned(
            bottom: 8,
            child: Container(
              width: 3,
              height: 30,
              color: const Color(0xFF8B6F47),
            ),
          ),
          // Dress form body
          Positioned(
            top: 0,
            child: Container(
              width: 50,
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFF5D4E37),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(25),
                  bottom: Radius.circular(15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThreadSpool() {
    return Container(
      width: 40,
      height: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Spool body
          Container(
            width: 35,
            height: 45,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  const Color(0xFFB01048),
                  const Color(0xFFD4145A),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
          // Top cap
          Positioned(
            top: 0,
            child: Container(
              width: 38,
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xFF8B6F47),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          // Bottom cap
          Positioned(
            bottom: 0,
            child: Container(
              width: 38,
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xFF8B6F47),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecorativeIcon(IconData icon, Color color, double size, double rotation) {
    return Transform.rotate(
      angle: rotation,
      child: Icon(
        icon,
        size: size,
        color: color.withOpacity(0.4),
      ),
    );
  }
}