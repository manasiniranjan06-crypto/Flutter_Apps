import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/Screens/view/loginScreen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Color containerColor = Colors.green.shade500;
  bool ispressed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            child: Image.asset("assets/welPg.png", fit: BoxFit.fill),
          ),
          Positioned(
            top: 500,
            right: 50,
            left: 50,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/carrotwh.png"),
                  SizedBox(height: 20),
                  Text(
                    "Welcome",
                    style: GoogleFonts.dmSans(
                      fontSize: 43,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "to our store",
                    style: GoogleFonts.dmSans(
                      fontSize: 43,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Ger your groceries in as fast as one hour",
                    style: GoogleFonts.dmSans(
                      fontSize: 17,
                      color: const Color.fromARGB(255, 207, 207, 207),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      splashColor: Colors.white.withOpacity(0.3), //light white
                      highlightColor: Colors.white.withOpacity(
                        0.15,
                      ), //pressed effect
                      onTapDown: (details) {
                        setState(() {
                          ispressed = true;
                        });
                      },
                      onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                        return Loginscreen();
                      }));
                      },
                      child: AnimatedScale(
                        scale: ispressed ? 0.96 : 1.0,
                        duration: Duration(milliseconds: 120),
                        curve: Curves.easeInOut,
                          child: Container(
                        height: 60,
                        width: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: containerColor,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Get Started",
                          style: GoogleFonts.dmSans(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ),
                    
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
