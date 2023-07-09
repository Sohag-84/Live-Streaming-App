// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitch_clone/models/user.dart' as model;
import 'package:twitch_clone/provider/user_provider.dart';
import 'package:twitch_clone/resources/auth_methods.dart';
import 'package:twitch_clone/screen/auth_screen/login_screen.dart';
import 'package:twitch_clone/screen/home/home_screen.dart';
import 'package:twitch_clone/screen/onboarding_screen.dart';
import 'package:twitch_clone/screen/auth_screen/signup_screen.dart';
import 'package:twitch_clone/utils/colors.dart';
import 'package:twitch_clone/widgets/loading_indicator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
        HomeScreen.routeName: (context) => HomeScreen(),
      },
      home: FutureBuilder(
        future: AuthMethods()
            .getCurrentUser(
                uid: FirebaseAuth.instance.currentUser != null
                    ? FirebaseAuth.instance.currentUser!.uid
                    : null)
            .then((value) {
          if (value != null) {
            Provider.of<UserProvider>(context, listen: false)
                .setUser(user: model.User.fromMap(value));
          }
          return value;
        }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingIndicator();
          }
          if (snapshot.hasData) {
            return HomeScreen();
          }
          return OnBoardingScreen();
        },
      ),
    );
  }
}
