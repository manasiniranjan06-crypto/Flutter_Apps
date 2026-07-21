// lib/app.dart
import 'package:ai_interview_app/Screens/block/historybloc.dart';
import 'package:ai_interview_app/Screens/block/langselectblock.dart';
import 'package:ai_interview_app/Widget/Bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AIInterviewApp extends StatelessWidget {
  const AIInterviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LanguageBloc>(
          create: (_) => LanguageBloc(),
        ),
        BlocProvider<HistoryBloc>(
          create: (_) => HistoryBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'AI Interview Coach',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF040C18),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF2979FF),
            secondary: Color(0xFF00E5FF),
          ),
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            },
          ),
        ),
        home: const BottomNavbar(),
      ),
    );
  }
}