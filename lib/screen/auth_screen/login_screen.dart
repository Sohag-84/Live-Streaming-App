// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:twitch_clone/resources/auth_methods.dart';
import 'package:twitch_clone/screen/home/home_screen.dart';
import 'package:twitch_clone/widgets/custom_button.dart';
import 'package:twitch_clone/widgets/custom_textfield.dart';

class LogInScreen extends StatefulWidget {
  static const String routeName = "/login";
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  AuthMethods authMethods = AuthMethods();

  void signInUser() async {
    bool res = await authMethods.signInUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (res) {
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Log In"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.1),
              Text(
                "Email",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              CustomTextField(controller: _emailController),
              SizedBox(height: 20),
              Text(
                "Password",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              CustomTextField(controller: _passwordController),
              SizedBox(height: 20),
              CustomButton(text: "Log In", onTap: signInUser),
            ],
          ),
        ),
      ),
    );
  }
}
