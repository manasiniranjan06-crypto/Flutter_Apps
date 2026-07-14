import 'package:firebaseauth/message/chat_screen.dart';
import 'package:flutter/material.dart';

class ReceiverScreen extends StatelessWidget {
  const ReceiverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChatScreen(currentUser: "Receiver");
  }
}