import 'package:flutter/material.dart';

class GradientScaffold extends StatelessWidget {
  final Widget child;
  final AppBar? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;

  const GradientScaffold({
    Key? key,
    required this.child,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar != null 
          ? AppBar(
              backgroundColor: const Color(0xFF8075FF), // Use your purple color
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
              // Copy all properties from the provided appBar
              title: appBar!.title,
              actions: appBar!.actions,
              leading: appBar!.leading,
              bottom: appBar!.bottom,
              flexibleSpace: appBar!.flexibleSpace,
            )
          : null,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      backgroundColor: backgroundColor ?? Colors.transparent,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF8075FF), Colors.white],
            stops: [0.0, 0.6],
          ),
        ),
        child: child,
      ),
    );
  }
}