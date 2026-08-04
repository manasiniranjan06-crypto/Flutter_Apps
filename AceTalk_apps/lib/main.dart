import 'package:ai_interview_app/Screens/block/historybloc.dart';
import 'package:ai_interview_app/Screens/startScreens/view/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await  Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDD76ex-U3L3sIfmxfqYz4RpV7bvqYGAs4",
      appId: "1:247454986358:android:aa102b7daed89721012f57",
      messagingSenderId: "247454986358",
      projectId: "aiinterview-a94bd",
    ),
  );

   runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<HistoryBloc>(
          create: (_) => HistoryBloc(),                              
        ),
      ],
      child: const MainApp(),
    ),
  );//sendgrid thirt psrty email provide
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen());
  }
}
