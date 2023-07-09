// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:twitch_clone/screen/auth_screen/login_screen.dart';
import 'package:twitch_clone/screen/onboarding_screen.dart';
import 'package:twitch_clone/screen/auth_screen/signup_screen.dart';
import 'package:twitch_clone/utils/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twitch Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: AppBarTheme().copyWith(
          centerTitle: true,
          backgroundColor: backgroundColor,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: primaryColor,
          ),
          iconTheme: IconThemeData(color: primaryColor),
        ),
      ),
      routes: {
        OnBoardingScreen.routeName: (context) => OnBoardingScreen(),
        LogInScreen.routeName: (context) => LogInScreen(),
        SignUpScreen.routeName: (context) => SignUpScreen(),
      },
      home: const OnBoardingScreen(),
    );
  }
}
