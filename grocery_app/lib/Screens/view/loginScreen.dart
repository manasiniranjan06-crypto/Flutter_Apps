import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/Screens/widget/bottom_navbar.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  bool _ispassword = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 150,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Image.asset("assets/loginpg.png")],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Login",
                style: GoogleFonts.dmSans(
                  fontSize: 27,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Enter your emails and password",
                style: GoogleFonts.dmSans(
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Email",
                style: GoogleFonts.dmSans(
                  fontSize: 18,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: emailcontroller,
                decoration: InputDecoration(
                  hintText: "Enter email",
                  hintStyle: GoogleFonts.dmSans(),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Psssword",
                style: GoogleFonts.dmSans(
                  fontSize: 18,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 7),
              TextField(
                controller: passwordcontroller,
                obscureText: !_ispassword,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  suffixIcon: IconButton(onPressed: (){
                    setState(() {
                      _ispassword =!_ispassword;
                    });
                  }, icon:  Icon(
                          _ispassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Color.fromRGBO(159, 159, 159, 1),
                        ),),
                  hintText: "Enter Valid Password",
                  hintStyle: GoogleFonts.dmSans(),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Forget Password ?",
                    style: GoogleFonts.dmSans(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
            GestureDetector(
  onTap: () {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) {
          return const BottomNavbar(); // <-- navigate to your bottom nav page
        },
      ),
    );
  },
  child: Center(
    child: Container(
      height: 60,
      width: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.green.shade500,
      ),
      alignment: Alignment.center,
      child: Text(
        "Log in",
        style: GoogleFonts.dmSans(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
),

            ],
          ),
        ),
      ),
    );
  }
}
