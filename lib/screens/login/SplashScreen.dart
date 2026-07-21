import 'package:expensemanager_apps/screens/login/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State createState() => _SplashScreenState();
}

class _SplashScreenState extends State {

  void initState(){
    super.initState();
    checkUser();
  }

  void checkUser() async{
    await Future.delayed(Duration(seconds: 3));

    Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => const LoginScreen(),
    ),
  );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Lottie.asset(
                  "assets/lotties/splash.json",
                  width: 300,
                  height: 300,
                ),
                Image.asset(
                  "assets/Images/splash.png",
                  height: 150,
                  width: 150,
                ),
              ],
            ),
          ),
          SizedBox(height: 100),

          Text(
            "Expense Manager",
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
