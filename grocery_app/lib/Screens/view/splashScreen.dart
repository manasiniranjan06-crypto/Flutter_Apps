
import 'package:flutter/material.dart';
import 'package:grocery_app/Screens/view/welcome_Screen.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {

  void initState(){
    super.initState();
    navigateTOScreen();
  }

  void navigateTOScreen(){
    Future.delayed(Duration(seconds: 4),(){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
        return WelcomeScreen();
      }));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //rgba(83, 177, 117, 1)
      backgroundColor: Colors.green,
      body: Center(
            child: Image.asset("assets/splashimg.png"),
      ),
    );
  }
}