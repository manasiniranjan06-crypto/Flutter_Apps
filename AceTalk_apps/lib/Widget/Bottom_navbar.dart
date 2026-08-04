import 'dart:ui';
import 'package:ai_interview_app/Screens/block/historybloc.dart';
import 'package:ai_interview_app/Screens/block/langselectblock.dart';
import 'package:ai_interview_app/Screens/mainScreen/view/History_screen.dart';
import 'package:ai_interview_app/Screens/mainScreen/view/homeScreen.dart';
import 'package:ai_interview_app/Screens/mainScreen/view/language_screen.dart';
import 'package:ai_interview_app/Screens/mainScreen/view/profileScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int currentIndex = 0;

  final List<Widget> pages = [
    HomeScreen (),
    LanguageScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(90),topRight: Radius.circular(90)),
        gradient: LinearGradient(
          colors: [
            Color(0xff061A35),
            Color(0xff0A2A52),
            Color(0xff0E3E78),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),

      child: Scaffold(
  extendBody: true,
  backgroundColor: Colors.transparent,

  body: MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => LanguageBloc(),
      ),

      BlocProvider(
        create: (_) => HistoryBloc(),
      ),
    ],

    child: pages[currentIndex],
  ),

  bottomNavigationBar: glassNavbar(),
),
    );
  }

  //  Glass Navbar
  Widget glassNavbar() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 28,
            sigmaY: 28,
          ),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),

              // Glass color
              color: Colors.white.withOpacity(0.08),

              // Soft border like iOS dock
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
                width: 1,
              ),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.35),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: navItems(),
            ),
          ),
        ),
      ),
    );
  }

  // Icons
  List<Widget> navItems() {
    return [
      navIcon(Icons.home_rounded, 0),
      navIcon(Icons.code_rounded, 1),
      navIcon(Icons.school_rounded, 2),
      navIcon(Icons.person_rounded, 3),
    ];
  }

  //  Animated Icon Button
  Widget navIcon(IconData icon, int index) {
    bool isActive = currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(14),

        decoration: BoxDecoration(
          shape: BoxShape.circle,

          // Active glow
          color: isActive
              ? Colors.blue.withOpacity(0.25)
              : Colors.transparent,
        ),

        child: AnimatedScale(
          duration: const Duration(milliseconds: 250),
          scale: isActive ? 1.15 : 1,
          child: Icon(
            icon,
            size: 24,
            color: isActive ? Colors.white : Colors.white54,
          ),
        ),
      ),
    );
  }
}
