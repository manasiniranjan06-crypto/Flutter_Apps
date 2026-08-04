import 'dart:async';
import 'dart:ui';
import 'package:ai_interview_app/Screens/startScreens/view/loginScreen.dart';
import 'package:ai_interview_app/Screens/startScreens/view/typingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  final FlutterTts flutterTts = FlutterTts();

  int currentPage = 0;
  String displayedText = "";
  int currentIndex = 0;
  Timer? typingTimer;
  bool isTyping = false;

  final List<IntroData> introPages = [
    IntroData(
      title: "Welcome to AceTalk",
      description:
          "Hello! I'm your AI Interview Coach. I will guide you through your interview preparation journey with personalized practice sessions.",
      lottieAsset: "assets/lottie_ani/robo1.json",
      gradientColors: [Colors.black, Color.fromARGB(255, 3, 58, 107)],
    ),
    IntroData(
      title: "Practice & Improve",
      description:
          "Practice various interview rounds including technical, HR, and behavioral interviews. Get instant feedback and improve your skills.",
      lottieAsset: "assets/lottie_ani/prctice_code.json",
      gradientColors: [Colors.black, Color.fromARGB(255, 58, 3, 107)],
    ),
    IntroData(
      title: "Ace Your Interview",
      description:
          "Track your progress, analyze your performance, and build confidence. Get ready to succeed in your dream job interview!",
      lottieAsset: "assets/lottie_ani/interview_intro.json",
      gradientColors: [Colors.black, Color.fromARGB(255, 3, 58, 107)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    initTtsAndStart();
  }

  Future<void> initTtsAndStart() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.45);
    await flutterTts.setPitch(1.0);
    await flutterTts.setVolume(1.0);

    flutterTts.setCompletionHandler(() {
      // Speech completed
    });

    startTypingAndSpeaking(0);
  }

  void startTypingAndSpeaking(int pageIndex) {
    // Cancel previous timer
    typingTimer?.cancel();
    flutterTts.stop();

    setState(() {
      displayedText = "";
      currentIndex = 0;
      isTyping = true;
    });

    final text = introPages[pageIndex].description;
    flutterTts.speak(text);

    typingTimer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      if (currentIndex < text.length) {
        setState(() {
          displayedText += text[currentIndex];
          currentIndex++;
        });
      } else {
        timer.cancel();
        setState(() {
          isTyping = false;
        });
      }
    });
  }

  void onPageChanged(int index) {
    setState(() {
      currentPage = index;
    });
    startTypingAndSpeaking(index);
  }

  void nextPage() {
    if (currentPage < introPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Loginscreen()),
      );
    }
  }

  void skipIntro() {
    typingTimer?.cancel();
    flutterTts.stop();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Loginscreen()),
    );
  }

  @override
  void dispose() {
    typingTimer?.cancel();
    flutterTts.stop();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          if (currentPage < introPages.length - 1)
            TextButton(
              onPressed: skipIntro,
              child: Text(
                "Skip",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: onPageChanged,
            itemCount: introPages.length,
            itemBuilder: (context, index) {
              return IntroPage(
                data: introPages[index],
                displayedText: currentPage == index ? displayedText : "",
                isTyping: currentPage == index ? isTyping : false,
              );
            },
          ),

          // Bottom Navigation Area
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Page Indicator
                SmoothPageIndicator(
                  controller: _pageController,
                  count: introPages.length,
                  effect: ExpandingDotsEffect(
                    activeDotColor: Colors.blueAccent,
                    dotColor: Colors.white.withOpacity(0.3),
                    dotHeight: 10,
                    dotWidth: 10,
                    expansionFactor: 4,
                    spacing: 8,
                  ),
                ),

                const SizedBox(height: 30),

                // Next/Get Started Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 55,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 3, 46, 84),
                          Colors.blueAccent,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 2,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: nextPage,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            currentPage == introPages.length - 1
                                ? "Get Started"
                                : "Next",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            currentPage == introPages.length - 1
                                ? Icons.check_circle_outline
                                : Icons.arrow_forward_rounded,
                            color: Colors.white,
                          ),
                        ],
                      ),
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

// Intro Page Widget
class IntroPage extends StatelessWidget {
  final IntroData data;
  final String displayedText;
  final bool isTyping;

  const IntroPage({
    super.key,
    required this.data,
    required this.displayedText,
    required this.isTyping,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: data.gradientColors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                data.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Robot Animation with Glow Effect
            Hero(
              tag: 'robot_animation',
              child: Container(
                height: 280,
                width: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.3),
                      blurRadius: 60,
                      spreadRadius: 20,
                    ),
                  ],
                ),
                child: Lottie.asset(data.lottieAsset, fit: BoxFit.contain),
              ),
            ),

            const SizedBox(height: 40),

            // Glassmorphism Text Box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    constraints: BoxConstraints(minHeight: 160, maxHeight: 200),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.4),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          displayedText,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white,
                            height: 1.5,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        if (isTyping)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: TypingIndicator(),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}

// Data Model
class IntroData {
  final String title;
  final String description;
  final String lottieAsset;
  final List<Color> gradientColors;

  IntroData({
    required this.title,
    required this.description,
    required this.lottieAsset,
    required this.gradientColors,
  });
}
