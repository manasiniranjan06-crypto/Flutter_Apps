// import 'package:flutter/material.dart';
// import 'dart:async';

// class TailorSplashScreen extends StatefulWidget {
//   const TailorSplashScreen({super.key});

//   @override
//   State<TailorSplashScreen> createState() => _TailorSplashScreenState();
// }

// class _TailorSplashScreenState extends State<TailorSplashScreen>
//     with TickerProviderStateMixin {
//   late PageController _pageController;
//   int _currentPage = 0;
//   late AnimationController _fadeController;
//   late AnimationController _scaleController;
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _scaleAnimation;

//   final List<SlideData> slides = [
//     SlideData(
//       title: "Welcome to Tailor",
//       subtitle: "Your perfect fit awaits",
//       description: "Custom tailoring made easy",
//       icon: Icons.checkroom,
//       color: Colors.deepOrange,
//       imagePath: "assets/img1.jpg",
//     ),
//     SlideData(
//       title: "Expert Craftsmanship",
//       subtitle: "Precision in every stitch",
//       description: "Professional tailors at your service",
//       icon: Icons.cut,
//       color: Colors.blue,
//       imagePath: "assets/img1.jpg",
//     ),
//     SlideData(
//       title: "Quick & Reliable",
//       subtitle: "Fast turnaround time",
//       description: "Get your perfect outfit in days",
//       icon: Icons.schedule,
//       color: Colors.green,
//       imagePath: "assets/img1.jpg",
//     ),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();

//     _fadeController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );

//     _scaleController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );

//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
//     );

//     _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
//       CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
//     );

//     _fadeController.forward();
//     _scaleController.forward();

//     // Auto-advance slides
//     Timer.periodic(const Duration(seconds: 4), (timer) {
//       if (_currentPage < slides.length - 1) {
//         _currentPage++;
//         _pageController.animateToPage(
//           _currentPage,
//           duration: const Duration(milliseconds: 800),
//           curve: Curves.easeInOut,
//         );
//       } else {
//         timer.cancel();
//         // Navigate to home after last slide
//         Future.delayed(const Duration(seconds: 2), () {
//           // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     _fadeController.dispose();
//     _scaleController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background gradient
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   const Color.fromARGB(255, 255, 255, 255),
//                   const Color.fromARGB(255, 250, 229, 223),
//                 ],
//               ),
//             ),
//           ),

//           // Page view with slides
//           PageView.builder(
//             controller: _pageController,
//             onPageChanged: (index) {
//               setState(() {
//                 _currentPage = index;
//               });
//               _fadeController.reset();
//               _scaleController.reset();
//               _fadeController.forward();
//               _scaleController.forward();
//             },
//             itemCount: slides.length,
//             itemBuilder: (context, index) {
//               return _buildSlide(slides[index]);
//             },
//           ),

//           // Page indicators
//           Positioned(
//             bottom: 80,
//             left: 0,
//             right: 0,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(
//                 slides.length,
//                 (index) => _buildPageIndicator(index),
//               ),
//             ),
//           ),

//           // Skip button
//           Positioned(
//             top: 50,
//             right: 20,
//             child: TextButton(
//               onPressed: () {
//                 // Navigate to home
//               },
//               child: const Text(
//                 'Skip',
//                 style: TextStyle(
//                   color: Color.fromARGB(255, 0, 0, 0),
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSlide(SlideData slide) {
//     return AnimatedBuilder(
//       animation: _fadeController,
//       builder: (context, child) {
//         return FadeTransition(
//           opacity: _fadeAnimation,
//           child: ScaleTransition(
//             scale: _scaleAnimation,
//             child: Padding(
//               padding: const EdgeInsets.all(40.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Animated icon or image
//                   Hero(
//                     tag: 'slide_${slide.title}',
//                     child: Container(
//                       width: 280,
//                       height: 280,
//                       decoration: BoxDecoration(
//                         color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.2),
//                             blurRadius: 30,
//                             spreadRadius: 5,
//                           ),
//                         ],
//                       ),
//                       child: ClipOval(
//                         child: Image.asset(
//                           slide.imagePath,
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) {
//                             return Icon(
//                               slide.icon,
//                               size: 140,
//                               color: Colors.white,
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 60),

//                   // Title
//                   Text(
//                     slide.title,
//                     style: const TextStyle(
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                       letterSpacing: 1.2,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 16),

//                   // Subtitle
//                   Text(
//                     slide.subtitle,
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.white.withOpacity(0.9),
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 12),

//                   // Description
//                   Text(
//                     slide.description,
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.white.withOpacity(0.8),
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildPageIndicator(int index) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       margin: const EdgeInsets.symmetric(horizontal: 6),
//       height: 8,
//       width: _currentPage == index ? 24 : 8,
//       decoration: BoxDecoration(
//         color: _currentPage == index
//             ? Colors.white
//             : Colors.white.withOpacity(0.4),
//         borderRadius: BorderRadius.circular(4),
//       ),
//     );
//   }
// }

// class SlideData {
//   final String title;
//   final String subtitle;
//   final String description;
//   final IconData icon;
//   final Color color;
//   final String imagePath;

//   SlideData({
//     required this.title,
//     required this.subtitle,
//     required this.description,
//     required this.icon,
//     required this.color,
//     required this.imagePath,
//   });
// }