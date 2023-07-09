// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:twitch_clone/screen/auth_screen/login_screen.dart';
import 'package:twitch_clone/screen/auth_screen/signup_screen.dart';
import 'package:twitch_clone/widgets/custom_button.dart';

class OnBoardingScreen extends StatelessWidget {
  static const String routeName = "/onboarding";
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome to \nTwitch",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            CustomButton(
              text: "Log In",
              onTap: () {
                Navigator.pushNamed(context, LogInScreen.routeName);
              },
            ),
            SizedBox(
              height: 15,
            ),
            CustomButton(
              text: "Sign Up",
              onTap: () {
                Navigator.pushNamed(context, SignUpScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
