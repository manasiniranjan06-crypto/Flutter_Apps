import 'package:expensemanager_apps/screens/login/sideDrwer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Transactions",
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      drawer: menuDrawer(),
    );
  }
}
