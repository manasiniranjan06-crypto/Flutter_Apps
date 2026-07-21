import 'package:expensemanager_apps/screens/login/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUP extends StatefulWidget {
  const SignUP({super.key});

  @override
  State createState() => _signupState();
}

class _signupState extends State {
  //controller
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController conformPasswrodcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 100, left: 20, right: 20),

          child: Column(
            children: [
              Center(child: Image.asset("assets/Images/splash.png")),
              SizedBox(height: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Create new Account",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 10),
                  //name
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 5,
                          spreadRadius: 3,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: nameController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Name",
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  //username
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          offset: Offset(0, 3),
                          blurRadius: 5,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: usernameController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Username",
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  //password
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 3),
                          blurRadius: 5,
                          spreadRadius: 3,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        hintText: "Password",
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // conform password
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          offset: Offset(0, 3),
                          blurRadius: 5,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: conformPasswrodcontroller,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Conform Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 53,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(14, 161, 125, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        "Sign Up",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an Account? ",
                    style: GoogleFonts.poppins(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return LoginScreen();
                          },
                        ),
                      );
                    },
                    child: Text(
                      "Sign up",
                      style: GoogleFonts.poppins(
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromRGBO(14, 161, 125, 1),
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
