

import 'package:ai_interview_app/Screens/startScreens/view/IntroScreen.dart';

import 'package:ai_interview_app/Widget/aiinterview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {

        // 🔵 Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 🟢 User Logged In
        if (snapshot.hasData) {
          return AIInterviewApp();
        }

        // 🔴 Not Logged In
        return IntroScreen();
      },
    );
  }
}
