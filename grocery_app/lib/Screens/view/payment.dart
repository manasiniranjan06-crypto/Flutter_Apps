import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/Screens/view/homeScreen.dart';
import 'package:grocery_app/Screens/widget/bottom_navbar.dart';

class paymentScreen extends StatefulWidget {
  const paymentScreen({super.key});

  @override
  State<paymentScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<paymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: Image.asset("assets/detailpage/payment.png")),
            SizedBox(height: 20),
            Center(
              child: Text(
                "Your Order has been ",
                style: GoogleFonts.dmSans(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Text(
                "Accepted",
                style: GoogleFonts.dmSans(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                "Your items has been placcd and is on",
                style: GoogleFonts.dmSans(
                  fontSize: 17,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Text(
                " it’s way to being processed",
                style: GoogleFonts.dmSans(
                  fontSize: 17,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 40),
            Container(
              height: 60,
              width: 290,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.green,
              ),
              alignment: Alignment.center,
              child: Text(
                "Track Order",
                style: GoogleFonts.dmSans(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return BottomNavbar();
                    },
                  ),
                );
              },
              child: Text(
                "Go Back To Home",
                style: GoogleFonts.dmSans(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
