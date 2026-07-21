import 'package:expensemanager_apps/screens/HomeScreen.dart';
import 'package:expensemanager_apps/screens/login/signup.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //controller
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
        child: Column(
          children: [
            Center(child: Image.asset("assets/Images/splash.png")),
            SizedBox(height: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Login to your Account",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10),

                //username
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),

                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: Offset(0, 3),
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
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                //password
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        offset: Offset(0, 3),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      hintText: "Password",
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
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
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                        return Homescreen();
                      }));
                      
                    },
                    child: Text("Sign in", style:GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                    )
                  ),)
                ),
              ],
            ),
            Spacer(),
           Row(
            mainAxisAlignment: MainAxisAlignment.center,
             children: [
                Text("Don't have an account?", style: GoogleFonts.poppins(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: Colors.black
                ),),

               TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (Context){
                  return SignUP();
                }));
               
               }, child: Text("Sign up", style: GoogleFonts.poppins(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromRGBO(14, 161, 125, 1)
                ),))
             ],
           )
          ],
        ),
      ),
    );
  }
}
