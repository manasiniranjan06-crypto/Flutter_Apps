import 'dart:developer';
import 'dart:ui';

import 'package:ai_interview_app/Screens/mainScreen/view/homeScreen.dart';
import 'package:ai_interview_app/Screens/startScreens/service/Authgate.dart';
import 'package:ai_interview_app/Screens/startScreens/view/SignupScreen.dart';
import 'package:ai_interview_app/Screens/startScreens/widget/customSnackBar.dart';
import 'package:ai_interview_app/Widget/Bottom_navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen>
    with SingleTickerProviderStateMixin {
  //CONTROLLER
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  //PASSWORD
  bool _ispasswordVisible = false;
  bool _isCheck = false;

  //FIREBASE AUTH
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // ANIMATIONS
  late AnimationController _controller;
  late Animation<Offset> _logoAnim;
  late Animation<Offset> _cardAnim;
  late Animation<Offset> _emailAnim;
  late Animation<Offset> _passwordAnim;
  late Animation<Offset> _buttonAnim;
  late Animation<Offset> _socialAnim;

  //INITSTATE
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1600),
    );

    //animations
    _logoAnim = _slideAnim(0.0, 0.15);
    _cardAnim = _slideAnim(0.3, 0.90);
    _emailAnim = _slideAnim(0.45, 0.6);
    _passwordAnim = _slideAnim(0.6, 0.75);
    _buttonAnim = _slideAnim(0.75, 0.9);
    _socialAnim = _slideAnim(0.85, 1.0);

    _controller.forward();
  }

  //ANIMATION SLIDE
  Animation<Offset> _slideAnim(double start, double end) {
    return Tween<Offset>(begin: Offset(0, 0.6), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(start, end, curve: Curves.easeOut),
      ),
    );
  }

  //dispose
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Social Login Methods
  void _loginWithGoogle() {}

  void _loginWithFacebook() {}

  void _loginWithApple() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 3, 10, 20), Color.fromARGB(255, 8, 21, 37),Color.fromARGB(255, 13, 32, 64)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SlideTransition(
            position: _logoAnim,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.all(20)),
                Row(
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      height: 80,
                      width: 80,
                    ),
                    Text(
                      "AceTalk",
                      style: GoogleFonts.poppins(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),

                Lottie.asset(
                  "assets/lottie_ani/login.json",
                  height: 150,
                  width: 150,
                ),
                SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: SlideTransition(
                        position: _cardAnim,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                            child: Container(
                              padding: EdgeInsets.all(18),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.4),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 16,
                                    spreadRadius: 3,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Login",
                                    style: GoogleFonts.poppins(
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Enter your email and password to securely access ",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(
                                        " Email",
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  SlideTransition(
                                    position: _emailAnim,
                                    child: Container(
                                      height: 50,
                                      width: 320,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: TextField(
                                        controller: emailController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                            

                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.mail,
                                            color: Colors.grey,
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                          fillColor:  Colors.blueGrey,
                                          filled: true,
                                          hintText: "enter email",
                                          
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(
                                        "Password",
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  SlideTransition(
                                    position: _passwordAnim,
                                    child: SizedBox(
                                      height: 50,
                                      width: 320,
                                      child: TextField(
                                        controller: passwordController,
                                        obscureText: !_ispasswordVisible,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.lock,
                                            color: Colors.grey,
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                          fillColor: Colors.blueGrey,
                                          filled: true,
                                          hintText: "enter password",
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _ispasswordVisible =
                                                    !_ispasswordVisible;
                                              });
                                            },
                                            icon: Icon(
                                              _ispasswordVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _isCheck = !_isCheck;
                                          });
                                        },

                                        child: AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 200,
                                          ),
                                          height: 18,
                                          width: 18,
                                          decoration: BoxDecoration(
                                            color: _isCheck
                                                ? Colors.blueAccent
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                          ),
                                          child: _isCheck
                                              ? const Icon(
                                                  Icons.check,
                                                  size: 14,
                                                  color: Colors.white,
                                                )
                                              : null,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        "Remember me",
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Spacer(),
                                      TextButton(
                                        onPressed: () {},
                                        child: Text(
                                          "Forget Password?",
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 10),

                                  SlideTransition(
                                    position: _buttonAnim,
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (emailController.text
                                                .trim()
                                                .isNotEmpty &&
                                            passwordController.text
                                                .trim()
                                                .isNotEmpty) {
                                          try {
                                            UserCredential userCredentialobj =
                                                await firebaseAuth
                                                    .signInWithEmailAndPassword(
                                                      email:
                                                          emailController.text,
                                                      password:
                                                          passwordController
                                                              .text,
                                                    );

                                            // await LoginSharedpref.saveLogin(
                                            //   true,
                                            //);

                                            log(
                                              "User credential: $userCredentialobj",
                                            );
                                            log(
                                              "User ${userCredentialobj.user}",
                                            );

                                            log(
                                              "User Id ${userCredentialobj.user!.uid}",
                                            );

                                            Customsnackbar().showCustomSnackbar(
                                              context,
                                              "Login Successfully",
                                              bgColor: Colors.green,
                                            );

                                            //clear controller
                                            emailController.clear();
                                            passwordController.clear();

                                            Navigator.of(
                                              context,
                                            ).pushReplacement(
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return BottomNavbar();
                                                },
                                              ),
                                            );
                                          } on FirebaseAuthException catch (
                                            error
                                          ) {
                                            Customsnackbar().showCustomSnackbar(
                                              context,
                                              error.message!,
                                              bgColor: Colors.red,
                                            );
                                          }
                                        } else {
                                          Customsnackbar().showCustomSnackbar(
                                            context,
                                            "Enter Valid Data",
                                            bgColor: Colors.red,
                                          );
                                        }
                                      },
                                      child: Container(
                                        height: 60,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          color: Colors.blueAccent,
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color.fromARGB(
                                                255,
                                                96,
                                                96,
                                                96,
                                              ),
                                              offset: Offset(3, 3),
                                              blurRadius: 3,
                                            ),
                                          ],
                                          border: Border.all(
                                            color: const Color.fromARGB(
                                              255,
                                              90,
                                              89,
                                              89,
                                            ).withBlue(0),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Login",
                                          style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 20),

                                  // Divider with "OR"
                                  SlideTransition(
                                    position: _socialAnim,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Divider(
                                            color: Colors.white.withOpacity(
                                              0.5,
                                            ),
                                            thickness: 1,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          child: Text(
                                            "OR",
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: Colors.white70,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Divider(
                                            color: Colors.white.withOpacity(
                                              0.5,
                                            ),
                                            thickness: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 15),

                                  // Social Login Buttons
                                  SlideTransition(
                                    position: _socialAnim,
                                    child: Column(
                                      children: [
                                        Text(
                                          "Continue with",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.white70,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(height: 15),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            // Google Login Button
                                            _SocialLoginButton(
                                              onTap: _loginWithGoogle,
                                              iconPath:
                                                  'assets/images/google.png',
                                              label: 'Google',
                                            ),
                                            SizedBox(width: 15),

                                            // Facebook/Instagram Login Button
                                            _SocialLoginButton(
                                              onTap: _loginWithFacebook,
                                              iconPath:
                                                  'assets/images/facebook.png',
                                              label: 'Facebook',
                                            ),
                                            SizedBox(width: 15),

                                            // Apple Login Button
                                            _SocialLoginButton(
                                              onTap: _loginWithApple,
                                              iconPath:
                                                  'assets/images/apple.png',
                                              label: 'Apple',
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 20),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Don't have an account? ",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return Signupscreen();
                                              },
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "Sign Up here",
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
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
                    ),
                  ],
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Social Login Button Widget
class _SocialLoginButton extends StatelessWidget {
  final VoidCallback onTap;
  final String iconPath;
  final String label;

  const _SocialLoginButton({
    required this.onTap,
    required this.iconPath,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        width: 90,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              height: 28,
              width: 28,
              errorBuilder: (context, error, stackTrace) {
                // Fallback to icon if image not found
                IconData icon = Icons.account_circle;
                if (label == 'Google') icon = Icons.g_mobiledata;
                if (label == 'Facebook') icon = Icons.facebook;
                if (label == 'Apple') icon = Icons.apple;

                return Icon(icon, size: 28, color: Colors.white);
              },
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
