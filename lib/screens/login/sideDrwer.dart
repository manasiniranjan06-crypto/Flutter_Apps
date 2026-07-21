import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class menuDrawer extends StatelessWidget {
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 50, right: 70),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Expense Manager",
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Saves all your Transactions",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 40),

                    Padding(
                       padding: const EdgeInsets.only(right: 10),
                      child: Row(
                        children: [
                          Image.asset("assets/Images/Subtract.png", height: 20,),
                          SizedBox(width: 5),
                          Text(
                            "Transaction",
                            style: GoogleFonts.poppins(
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    
                    Padding(
                       padding: const EdgeInsets.only(right: 10),
                      child: Row(
                        children: [
                          Image.asset("assets/Images/graph.png", height: 20,),
                          SizedBox(width: 5),
                          Text(
                            "Graph",
                            style: GoogleFonts.poppins(
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Row(
                        children: [
                          Image.asset("assets/Images/category.png", height: 20,),
                          SizedBox(width: 5),
                          Text(
                            "Category",
                            style: GoogleFonts.poppins(
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Row(
                        children: [
                          Image.asset("assets/Images/trash.png", height: 20,),
                          SizedBox(width: 5),
                          Text(
                            "Trash",
                            style: GoogleFonts.poppins(
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Row(
                        children: [
                          Image.asset("assets/Images/about.png", height: 20,),
                          SizedBox(width: 5),
                          Text(
                            "About us",
                            style: GoogleFonts.poppins(
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
