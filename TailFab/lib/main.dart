import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseauth/API_Binding/bindingScreen.dart';
import 'package:firebaseauth/TailorSide/view/landing.dart';
import 'package:firebaseauth/TailorSide/view/tailorAlternation.dart';
import 'package:firebaseauth/TailorSide/view/tailorhomepage.dart';
import 'package:firebaseauth/customerside/screens/chackoutbottomsheet.dart';
import 'package:firebaseauth/customerside/screens/home_screen.dart';
import 'package:firebaseauth/message/Tailor_List_screen_custSide.dart';

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:FirebaseOptions(
      apiKey:"AIzaSyDNVLQsAe6ANEEm5oCh3WnwQMYev9w7G5E",
       appId:"1:87909089095:android:985d9714e2b4437b435662", 
       messagingSenderId:"87909089095", 
       projectId:"flutter-superx-3c3e1")
  );
  runApp( MainApp());
}

class MainApp extends StatelessWidget {
   MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home:OnboardingScreen(),

    );
  }
}
