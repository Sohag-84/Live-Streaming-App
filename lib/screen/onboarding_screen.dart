import 'package:flutter/material.dart';

class OnBoardingScreen extends StatelessWidget {
  static const String routeName = "/onboarding";
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello world"),
      ),
    );
  }
}
