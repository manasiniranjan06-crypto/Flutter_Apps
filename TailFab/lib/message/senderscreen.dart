import 'package:firebaseauth/message/chat_screen.dart';
import 'package:flutter/material.dart';

class SenderScreen extends StatelessWidget {
  const SenderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChatScreen(currentUser: "Sender");
  }
}