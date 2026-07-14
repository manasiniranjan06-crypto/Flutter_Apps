import 'dart:developer';
import 'dart:ui';

import 'package:ai_interview_app/Screens/startScreens/view/loginScreen.dart';
import 'package:ai_interview_app/Screens/startScreens/widget/customSnackBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class Signupscreen extends StatefulWidget {
  const Signupscreen({super.key});

  @override
  State<Signupscreen> createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen>
    with SingleTickerProviderStateMixin {
  //CONTROLLER
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();

  //FIREBASE AUTH
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //password
  bool ispasswordVisible = false;
  bool isrepasswordvisible = false;

  // ANIMATIONS
  late AnimationController _controller;
  late Animation<Offset> _logoAnim;
  late Animation<Offset> _lottieAnim;
  late Animation<Offset> _cardAnim;
  late Animation<Offset> _emailAnim;
  late Animation<Offset> _nameAnim;
  late Animation<Offset> _passwordAnim;
  late Animation<Offset> _confirmAnim;
  late Animation<Offset> _buttonAnim;

  //inist state
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _logoAnim = _slideAnim(0.0, 0.15);
    _lottieAnim = _slideAnim(0.15, 0.30);
    _cardAnim = _slideAnim(0.30, 0.60);
    _emailAnim = _slideAnim(0.45, 0.55);
    _nameAnim = _slideAnim(0.55, 0.65);
    _passwordAnim = _slideAnim(0.65, 0.75);
    _confirmAnim = _slideAnim(0.75, 0.85);
    _buttonAnim = _slideAnim(0.85, 1.0);

    _controller.forward();
  }

  //slide animation
  Animation<Offset> _slideAnim(double start, double end) {
    return Tween<Offset>(begin: const Offset(0, 0.6), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(start, end, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
          //  colors: [Colors.black, Color.fromARGB(255, 3, 58, 107)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.all(20)),
              SlideTransition(
                position: _logoAnim,
                child: Row(
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
                    // Lottie.asset(
                    //   "assets/lottie_ani/login.json",
                    //   height: 150,
                    //   width: 150,
                    // ),
                  ],
                ),
              ),

              SlideTransition(
                position: _lottieAnim,
                child: Lottie.asset(
                  "assets/lottie_ani/login.json",
                  height: 150,
                  width: 150,
                ),
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
                            height: 550,
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
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Create Account",
                                    style: GoogleFonts.poppins(
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Create a new account to get Started and enjoy",
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
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  // email controller
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
                                          // prefixIcon: Icon(
                                          //   Icons.mail,
                                          //   color: Colors.grey,
                                          // ),
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
                                          hintText: "enter email",
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  //name controller
                                  Row(
                                    children: [
                                      Text(
                                        " Name",
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  // email controller
                                  SlideTransition(
                                    position: _nameAnim,
                                    child: Container(
                                      height: 50,
                                      width: 320,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),

                                      child: TextField(
                                        controller: nameController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          // prefixIcon: Icon(
                                          //   Icons.mail,
                                          //   color: Colors.grey,
                                          // ),
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
                                          hintText: "enter Name",
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
                                          fontWeight: FontWeight.w600,
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
                                        controller: passController,
                                        obscureText: !isrepasswordvisible,
                                        //  keyboardType: TextInputType.visiblePassword,
                                        decoration: InputDecoration(
                                          // prefixIcon: Icon(
                                          //   Icons.lock,
                                          //   color: Colors.grey,
                                          // ),
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
                                          hintText: "enter Password",
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                isrepasswordvisible =
                                                    !isrepasswordvisible;
                                              });
                                            },
                                            icon: Icon(
                                              isrepasswordvisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //conform password
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(
                                        " Confirm Password",
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  SlideTransition(
                                    position: _confirmAnim,
                                    child: SizedBox(
                                      height: 50,
                                      width: 320,

                                      child: TextField(
                                        controller: rePasswordController,
                                        obscureText: !ispasswordVisible,
                                        //  keyboardType: TextInputType.visiblePassword,
                                        decoration: InputDecoration(
                                          // prefixIcon: Icon(
                                          //   Icons.lock,
                                          //   color: Colors.grey,
                                          // ),
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
                                          hintText: " Confirm Password",
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                ispasswordVisible =
                                                    !ispasswordVisible;
                                              });
                                            },
                                            icon: Icon(
                                              ispasswordVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  SlideTransition(
                                    position: _buttonAnim,
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (emailController.text
                                                .trim()
                                                .isNotEmpty &&
                                            nameController.text
                                                .trim()
                                                .isNotEmpty &&
                                            passController.text
                                                .trim()
                                                .isNotEmpty &&
                                            rePasswordController.text
                                                .trim()
                                                .isNotEmpty) {
                                          try {
                                            //create user new
                                            UserCredential
                                            userCredentialobj = await firebaseAuth
                                                .createUserWithEmailAndPassword(
                                                  email: emailController.text,
                                                  password: passController.text,
                                                );
                                            log(
                                              "user credential $userCredentialobj",
                                            );
                                            Customsnackbar().showCustomSnackbar(
                                              context,
                                              "Registered Successfully",
                                              bgColor: Colors.green,
                                            );

                                            Navigator.pop(context);
                                          } on FirebaseAuthException catch (
                                            error
                                          ) {
                                            log("erroe code : ${error.code}");
                                            log(
                                              "error message : ${error.message}",
                                            );

                                            if (error.code.toString() ==
                                                "Invalid-email") {
                                              Customsnackbar()
                                                  .showCustomSnackbar(
                                                    context,
                                                    "Enter valid email id",
                                                    bgColor: Colors.red,
                                                  );
                                            } else {
                                              Customsnackbar()
                                                  .showCustomSnackbar(
                                                    context,
                                                    error.message!,
                                                    bgColor: Colors.red,
                                                  );
                                            }
                                          }
                                        } else {
                                          Customsnackbar().showCustomSnackbar(
                                            context,
                                            "Enter valid data",
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
                                          "Create Account",
                                          style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Already have an account?",
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
                                                return Loginscreen();
                                              },
                                            ),
                                          );
                                        },
                                        child: Text(
                                          " Sign In here",
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
