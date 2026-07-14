import 'package:flutter/material.dart';
import 'package:grocery_app/Screens/controller/product_provider_controller.dart';
import 'package:grocery_app/Screens/view/splashScreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return ProductProvider();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Splashscreen(),
      ),
    );
  }
}
